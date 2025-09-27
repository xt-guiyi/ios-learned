//
//  PermissionManagerViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit
import Photos
import AVFoundation
import CoreLocation
import UserNotifications
import Contacts

class PermissionManagerViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var listViewController: CardListViewController?
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupNavigationBar()
        setupListViewController()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "权限管理") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置权限列表
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller

        // 配置权限列表数据
        let permissionData = [
            ListItemModel(title: "相机权限", subtitle: "申请相机使用权限") { [weak self] in
                self?.requestCameraPermission()
            },
            ListItemModel(title: "相册权限", subtitle: "申请相册访问权限") { [weak self] in
                self?.requestPhotoLibraryPermission()
            },
            ListItemModel(title: "麦克风权限", subtitle: "申请麦克风使用权限") { [weak self] in
                self?.requestMicrophonePermission()
            },
            ListItemModel(title: "定位权限", subtitle: "申请定位服务权限") { [weak self] in
                self?.requestLocationPermission()
            },
            ListItemModel(title: "通知权限", subtitle: "申请推送通知权限") { [weak self] in
                self?.requestNotificationPermission()
            },
            ListItemModel(title: "通讯录权限", subtitle: "申请通讯录访问权限") { [weak self] in
                self?.requestContactsPermission()
            },
            ListItemModel(title: "查看所有权限状态", subtitle: "检查各项权限的当前状态") { [weak self] in
                self?.checkAllPermissionStatus()
            }
        ]

        controller.updateData(permissionData)

        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - 权限申请方法

    /// 申请相机权限
    private func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.showPermissionResult(permissionName: "相机", granted: granted)
                }
            }
        case .authorized:
            showPermissionResult(permissionName: "相机", granted: true, alreadyGranted: true)
        case .denied, .restricted:
            showPermissionResult(permissionName: "相机", granted: false, denied: true)
        @unknown default:
            break
        }
    }

    /// 申请相册权限
    private func requestPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    let granted = newStatus == .authorized || newStatus == .limited
                    self?.showPermissionResult(permissionName: "相册", granted: granted)
                }
            }
        case .authorized, .limited:
            showPermissionResult(permissionName: "相册", granted: true, alreadyGranted: true)
        case .denied, .restricted:
            showPermissionResult(permissionName: "相册", granted: false, denied: true)
        @unknown default:
            break
        }
    }

    /// 申请麦克风权限
    private func requestMicrophonePermission() {
        let status = AVAudioSession.sharedInstance().recordPermission

        switch status {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    self?.showPermissionResult(permissionName: "麦克风", granted: granted)
                }
            }
        case .granted:
            showPermissionResult(permissionName: "麦克风", granted: true, alreadyGranted: true)
        case .denied:
            showPermissionResult(permissionName: "麦克风", granted: false, denied: true)
        @unknown default:
            break
        }
    }

    /// 申请定位权限
    private func requestLocationPermission() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            showPermissionResult(permissionName: "定位", granted: true, alreadyGranted: true)
        case .denied, .restricted:
            showPermissionResult(permissionName: "定位", granted: false, denied: true)
        @unknown default:
            break
        }
    }

    /// 申请通知权限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        DispatchQueue.main.async {
                            self?.showPermissionResult(permissionName: "通知", granted: granted)
                        }
                    }
                case .authorized, .provisional, .ephemeral:
                    self?.showPermissionResult(permissionName: "通知", granted: true, alreadyGranted: true)
                case .denied:
                    self?.showPermissionResult(permissionName: "通知", granted: false, denied: true)
                @unknown default:
                    break
                }
            }
        }
    }

    /// 申请通讯录权限
    private func requestContactsPermission() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        print("通讯录当前权限状态: \(status.rawValue)")

        switch status {
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { [weak self] granted, error in
                DispatchQueue.main.async {
                    print("通讯录权限申请结果: granted=\(granted)")
                    if let error = error {
                        print("通讯录权限请求错误: \(error.localizedDescription)")
                        // 在模拟器上，有时候即使有错误，granted 仍可能为 true
                        let finalGranted = granted && error == nil
                        self?.showPermissionResult(permissionName: "通讯录", granted: finalGranted)
                    } else {
                        self?.showPermissionResult(permissionName: "通讯录", granted: granted)
                    }
                }
            }
        case .authorized:
            showPermissionResult(permissionName: "通讯录", granted: true, alreadyGranted: true)
        case .denied, .restricted:
            showPermissionResult(permissionName: "通讯录", granted: false, denied: true)
        @unknown default:
            print("通讯录权限状态未知")
            showPermissionResult(permissionName: "通讯录", granted: false)
            break
        }
    }

    /// 检查所有权限状态
    private func checkAllPermissionStatus() {
        var statusMessage = "当前权限状态：\n\n"

        // 相机权限
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        statusMessage += "相机: \(getPermissionStatusText(cameraStatus))\n"

        // 相册权限
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        statusMessage += "相册: \(getPhotoPermissionStatusText(photoStatus))\n"

        // 麦克风权限
        let micStatus = AVAudioSession.sharedInstance().recordPermission
        statusMessage += "麦克风: \(getMicPermissionStatusText(micStatus))\n"

        // 定位权限
        let locationStatus = locationManager.authorizationStatus
        statusMessage += "定位: \(getLocationPermissionStatusText(locationStatus))\n"

        // 通讯录权限
        let contactsStatus = CNContactStore.authorizationStatus(for: .contacts)
        statusMessage += "通讯录: \(getContactsPermissionStatusText(contactsStatus))\n"

        // 通知权限（异步获取）
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let notificationStatusText = self.getNotificationPermissionStatusText(settings.authorizationStatus)
                let fullMessage = statusMessage + "通知: \(notificationStatusText)"

                let alert = UIAlertController(title: "权限状态", message: fullMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确定", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    // MARK: - 辅助方法

    /// 显示权限申请结果
    private func showPermissionResult(permissionName: String, granted: Bool, alreadyGranted: Bool = false, denied: Bool = false) {
        var message: String

        if alreadyGranted {
            message = "\(permissionName)权限已经授权"
        } else if denied {
            message = "\(permissionName)权限被拒绝，请前往设置中手动开启"
        } else {
            if permissionName == "通讯录" && !granted {
                // 特殊处理通讯录权限失败的情况
                message = "\(permissionName)权限申请失败\n\n可能原因：\n1. 模拟器限制\n2. 系统版本兼容性\n3. 请在真机上测试"
            } else {
                message = granted ? "\(permissionName)权限申请成功" : "\(permissionName)权限申请失败"
            }
        }

        let alert = UIAlertController(title: "权限结果", message: message, preferredStyle: .alert)

        if denied {
            alert.addAction(UIAlertAction(title: "前往设置", style: .default) { _ in
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        } else {
            alert.addAction(UIAlertAction(title: "确定", style: .default))
        }

        present(alert, animated: true)
    }

    /// 获取通用权限状态文本
    private func getPermissionStatusText(_ status: AVAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "未决定"
        case .authorized: return "已授权"
        case .denied: return "已拒绝"
        case .restricted: return "受限制"
        @unknown default: return "未知"
        }
    }

    /// 获取相册权限状态文本
    private func getPhotoPermissionStatusText(_ status: PHAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "未决定"
        case .authorized: return "已授权"
        case .denied: return "已拒绝"
        case .restricted: return "受限制"
        case .limited: return "部分授权"
        @unknown default: return "未知"
        }
    }

    /// 获取麦克风权限状态文本
    private func getMicPermissionStatusText(_ status: AVAudioSession.RecordPermission) -> String {
        switch status {
        case .undetermined: return "未决定"
        case .granted: return "已授权"
        case .denied: return "已拒绝"
        @unknown default: return "未知"
        }
    }

    /// 获取定位权限状态文本
    private func getLocationPermissionStatusText(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "未决定"
        case .authorizedWhenInUse: return "使用时授权"
        case .authorizedAlways: return "始终授权"
        case .denied: return "已拒绝"
        case .restricted: return "受限制"
        @unknown default: return "未知"
        }
    }

    /// 获取通知权限状态文本
    private func getNotificationPermissionStatusText(_ status: UNAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "未决定"
        case .authorized: return "已授权"
        case .denied: return "已拒绝"
        case .provisional: return "临时授权"
        case .ephemeral: return "短暂授权"
        @unknown default: return "未知"
        }
    }

    /// 获取通讯录权限状态文本
    private func getContactsPermissionStatusText(_ status: CNAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "未决定"
        case .authorized: return "已授权"
        case .denied: return "已拒绝"
        case .restricted: return "受限制"
        @unknown default: return "未知"
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension PermissionManagerViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            showPermissionResult(permissionName: "定位", granted: true)
        case .denied, .restricted:
            showPermissionResult(permissionName: "定位", granted: false)
        default:
            break
        }
    }
}