//
//  CustomCameraViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import AVFoundation
import SnapKit

/**
 * 自定义相机视图控制器
 * 实现相机预览、拍照、前后摄像头切换等功能
 */
class CustomCameraViewController: BaseViewController {

    // MARK: - UI Components
    /// 自定义导航栏
    private let customNavigationBar = CustomNavigationBar()

    /// 相机预览层
    private var previewLayer: AVCaptureVideoPreviewLayer?

    /// 预览容器视图
    private let previewContainer = UIView()

    /// 底部控制栏
    private let controlContainer = UIView()

    /// 拍照按钮
    private let captureButton = UIButton(type: .custom)

    /// 切换摄像头按钮
    private let switchCameraButton = UIButton(type: .custom)

    /// 相册按钮
    private let albumButton = UIButton(type: .custom)

    /// 放大按钮
    private let zoomButton = UIButton(type: .custom)

    /// 闪光灯按钮
    private let flashButton = UIButton(type: .custom)

    // MARK: - Camera Components
    /// 相机会话
    private let captureSession = AVCaptureSession()

    /// 当前输入设备
    private var currentInput: AVCaptureDeviceInput?

    /// 照片输出
    private let photoOutput = AVCapturePhotoOutput()

    /// 视频输出
    private let videoOutput = AVCaptureVideoDataOutput()

    /// 当前相机位置
    private var currentCameraPosition: AVCaptureDevice.Position = .back

    /// 闪光灯模式
    private var flashMode: AVCaptureDevice.FlashMode = .auto

    /// 当前焦距
    private var currentZoom: CGFloat = 1.0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestCameraPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning == true {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
    }

    // MARK: - UI Setup
    /**
     * 设置用户界面
     */
    private func setupUI() {
        view.backgroundColor = .black

        setupNavigationBar()
        setupPreviewContainer()
        setupControlContainer()
        setupCaptureButton()
        setupSwitchCameraButton()
        setupAlbumButton()
        setupZoomButton()
        setupFlashButton()

        setupConstraints()
    }

    /**
     * 设置自定义导航栏
     */
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "相机") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        customNavigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        view.addSubview(customNavigationBar)
    }

    /**
     * 设置预览容器
     */
    private func setupPreviewContainer() {
        previewContainer.backgroundColor = .clear  // 改为透明，避免遮挡预览层
        previewContainer.layer.masksToBounds = true

        view.addSubview(previewContainer)
        print("✅ 预览容器设置完成")
    }

    /**
     * 设置控制容器
     */
    private func setupControlContainer() {
        controlContainer.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        view.addSubview(controlContainer)
    }

    /**
     * 设置拍照按钮
     */
    private func setupCaptureButton() {
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        captureButton.layer.borderWidth = 3
        captureButton.layer.borderColor = UIColor.white.cgColor

        // 添加内部圆圈效果
        let innerCircle = UIView()
        innerCircle.backgroundColor = .white
        innerCircle.layer.cornerRadius = 30
        innerCircle.isUserInteractionEnabled = false

        captureButton.addSubview(innerCircle)
        innerCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }

        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)

        controlContainer.addSubview(captureButton)
    }

    /**
     * 设置切换摄像头按钮
     */
    private func setupSwitchCameraButton() {
        switchCameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        switchCameraButton.tintColor = .white
        switchCameraButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        switchCameraButton.layer.cornerRadius = 25

        switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)

        controlContainer.addSubview(switchCameraButton)
    }

    /**
     * 设置相册按钮
     */
    private func setupAlbumButton() {
        albumButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        albumButton.tintColor = .white
        albumButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        albumButton.layer.cornerRadius = 25

        albumButton.addTarget(self, action: #selector(openAlbum), for: .touchUpInside)

        controlContainer.addSubview(albumButton)
    }

    /**
     * 设置放大按钮
     */
    private func setupZoomButton() {
        zoomButton.setTitle("1.0x", for: .normal)
        zoomButton.setTitleColor(.white, for: .normal)
        zoomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        zoomButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        zoomButton.layer.cornerRadius = 20
        zoomButton.layer.borderWidth = 1
        zoomButton.layer.borderColor = UIColor.white.cgColor

        zoomButton.addTarget(self, action: #selector(zoomButtonTapped), for: .touchUpInside)

        view.addSubview(zoomButton)
    }

    /**
     * 设置闪光灯按钮
     */
    private func setupFlashButton() {
        updateFlashButtonIcon()
        flashButton.tintColor = .white
        flashButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        flashButton.layer.cornerRadius = 20

        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)

        view.addSubview(flashButton)
    }

    /**
     * 设置约束布局
     */
    private func setupConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(88)
        }

        previewContainer.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(controlContainer.snp.top)
        }

        controlContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(150)
        }

        captureButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(70)
        }

        switchCameraButton.snp.makeConstraints { make in
            make.centerY.equalTo(captureButton)
            make.right.equalToSuperview().inset(30)
            make.width.height.equalTo(50)
        }

        albumButton.snp.makeConstraints { make in
            make.centerY.equalTo(captureButton)
            make.left.equalToSuperview().inset(30)
            make.width.height.equalTo(50)
        }

        zoomButton.snp.makeConstraints { make in
            make.top.equalTo(previewContainer).inset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }

        flashButton.snp.makeConstraints { make in
            make.top.equalTo(previewContainer).inset(20)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(40)
        }
    }

    // MARK: - Camera Setup
    /**
     * 请求相机权限
     */
    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupCamera()
                    } else {
                        self.showPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showPermissionAlert()
        @unknown default:
            showPermissionAlert()
        }
    }

    /**
     * 设置相机
     */
    private func setupCamera() {
        print("开始设置相机")
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition) else {
            print("❌ 无法获取相机设备")
            captureSession.commitConfiguration()
            return
        }
        print("✅ 获取到相机设备: \(camera.localizedName)")

        do {
            let input = try AVCaptureDeviceInput(device: camera)

            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                currentInput = input
                print("✅ 成功添加输入设备")
            } else {
                print("❌ 无法添加输入设备")
            }

            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
                print("✅ 成功添加照片输出")

                // 确保照片输出有视频连接
                if let connection = photoOutput.connection(with: .video) {
                    print("✅ 找到视频连接")
                    if connection.isVideoStabilizationSupported {
                        connection.preferredVideoStabilizationMode = .auto
                    }
                } else {
                    print("❌ 没有找到视频连接")
                }

                // 设置初始闪光灯模式为支持的模式
                let supportedModes = photoOutput.supportedFlashModes
                if supportedModes.contains(.auto) {
                    flashMode = .auto
                } else if supportedModes.contains(.off) {
                    flashMode = .off
                } else {
                    flashMode = supportedModes.first ?? .off
                }
                print("✅ 设置闪光灯模式: \(flashMode.rawValue), 支持的模式: \(supportedModes.map { $0.rawValue })")

                DispatchQueue.main.async {
                    self.updateFlashButtonIcon()
                }
            } else {
                print("❌ 无法添加照片输出")
            }

            captureSession.commitConfiguration()
            print("✅ 相机配置完成")

            DispatchQueue.main.async {
                self.setupPreviewLayer()
                print("✅ 预览层设置完成")
            }

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
                print("✅ 相机会话开始运行")
            }

        } catch {
            print("❌ 相机设置失败: \(error)")
            captureSession.commitConfiguration()
        }
    }

    /**
     * 设置预览层
     */
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill

        if let previewLayer = previewLayer {
            previewContainer.layer.addSublayer(previewLayer)
        }

        // 延迟设置frame，确保容器已经布局完成
        DispatchQueue.main.async {
            self.previewLayer?.frame = self.previewContainer.bounds
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = previewContainer.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 确保在视图完全显示后设置预览层frame
        previewLayer?.frame = previewContainer.bounds
    }

    // MARK: - Actions
    /**
     * 拍照功能
     */
    @objc private func capturePhoto() {
        // 检查相机会话是否运行
        guard captureSession.isRunning else {
            print("相机会话未运行")
            return
        }

        // 检查照片输出是否有有效的视频连接
        guard let videoConnection = photoOutput.connection(with: .video),
              videoConnection.isEnabled else {
            print("没有有效的视频连接")
            return
        }

        let settings = AVCapturePhotoSettings()

        // 检查并设置支持的闪光灯模式
        if photoOutput.supportedFlashModes.contains(flashMode) {
            settings.flashMode = flashMode
        } else {
            // 如果当前模式不支持，使用自动模式或关闭
            if photoOutput.supportedFlashModes.contains(.auto) {
                settings.flashMode = .auto
            } else {
                settings.flashMode = .off
            }
            print("⚠️ 当前闪光灯模式不支持，使用: \(settings.flashMode.rawValue)")
        }

        // 添加拍照动画
        UIView.animate(withDuration: 0.1, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.captureButton.transform = .identity
            }
        }

        // 屏幕闪光效果
        let flashView = UIView(frame: view.bounds)
        flashView.backgroundColor = .white
        view.addSubview(flashView)
        UIView.animate(withDuration: 0.3, animations: {
            flashView.alpha = 0
        }) { _ in
            flashView.removeFromSuperview()
        }

        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    /**
     * 切换前后摄像头
     */
    @objc private func switchCamera() {
        guard let currentInput = currentInput else { return }

        captureSession.beginConfiguration()
        captureSession.removeInput(currentInput)

        currentCameraPosition = currentCameraPosition == .back ? .front : .back

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition) else {
            print("无法获取相机设备")
            return
        }

        do {
            let newInput = try AVCaptureDeviceInput(device: camera)

            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
                self.currentInput = newInput
            }
        } catch {
            print("切换相机失败: \(error)")
        }

        captureSession.commitConfiguration()

        // 添加切换动画
        UIView.transition(with: previewContainer, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
    }

    /**
     * 打开相册
     */
    @objc private func openAlbum() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    /**
     * 放大按钮点击
     */
    @objc private func zoomButtonTapped() {
        guard let device = currentInput?.device else { return }

        // 循环切换放大倍数：1.0x -> 2.0x -> 3.0x -> 1.0x
        if currentZoom == 1.0 {
            currentZoom = 2.0
        } else if currentZoom == 2.0 {
            currentZoom = 3.0
        } else {
            currentZoom = 1.0
        }

        setZoom(currentZoom, for: device)
    }

    /**
     * 设置相机焦距
     */
    private func setZoom(_ zoom: CGFloat, for device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()

            let maxZoom = device.activeFormat.videoMaxZoomFactor
            let clampedZoom = min(max(zoom, 1.0), maxZoom)

            device.videoZoomFactor = clampedZoom
            currentZoom = clampedZoom

            device.unlockForConfiguration()

            // 更新按钮文字
            DispatchQueue.main.async {
                self.zoomButton.setTitle(String(format: "%.1fx", self.currentZoom), for: .normal)
            }

            print("设置焦距: \(clampedZoom)x")

        } catch {
            print("设置焦距失败: \(error)")
        }
    }

    /**
     * 切换闪光灯模式
     */
    @objc private func toggleFlash() {
        let supportedModes = photoOutput.supportedFlashModes

        switch flashMode {
        case .auto:
            if supportedModes.contains(.on) {
                flashMode = .on
            } else if supportedModes.contains(.off) {
                flashMode = .off
            } else {
                flashMode = .auto
            }
        case .on:
            if supportedModes.contains(.off) {
                flashMode = .off
            } else if supportedModes.contains(.auto) {
                flashMode = .auto
            } else {
                flashMode = .on
            }
        case .off:
            if supportedModes.contains(.auto) {
                flashMode = .auto
            } else if supportedModes.contains(.on) {
                flashMode = .on
            } else {
                flashMode = .off
            }
        @unknown default:
            flashMode = supportedModes.first ?? .off
        }

        updateFlashButtonIcon()
        print("闪光灯模式切换到: \(flashMode.rawValue), 支持的模式: \(supportedModes.map { $0.rawValue })")
    }

    /**
     * 更新闪光灯按钮图标
     */
    private func updateFlashButtonIcon() {
        let iconName: String
        switch flashMode {
        case .auto:
            iconName = "bolt.badge.a"
        case .on:
            iconName = "bolt.fill"
        case .off:
            iconName = "bolt.slash"
        @unknown default:
            iconName = "bolt.badge.a"
        }

        flashButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    // MARK: - Helper Methods
    /**
     * 显示权限提示
     */
    private func showPermissionAlert() {
        let alert = UIAlertController(title: "需要相机权限", message: "请在设置中允许访问相机", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        })

        alert.addAction(UIAlertAction(title: "设置", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })

        present(alert, animated: true)
    }

    /**
     * 保存图片到相册
     */
    private func saveImageToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    /**
     * 图片保存结果回调
     */
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                self.showAlert(title: "保存失败", message: error.localizedDescription)
            } else {
                self.showAlert(title: "保存成功", message: "照片已保存到相册")
            }
        }
    }

    /**
     * 显示提示框
     */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    /**
     * 照片拍摄完成回调
     */
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("拍照失败: \(error!)")
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("无法生成图片")
            return
        }

        // 保存到相册
        saveImageToAlbum(image)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CustomCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     * 图片选择完成回调
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            // 这里可以处理选中的图片
            showAlert(title: "选择成功", message: "已选择照片")
        }
    }

    /**
     * 取消选择回调
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}