//
//  ToastExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit
import Toast_Swift

class ToastExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 滚动容器
    private let scrollView = UIScrollView()
    
    /// 内容容器
    private let contentView = UIView()
    
    /// 按钮组
    private let basicToastButton = UIButton(type: .system)
    private let successToastButton = UIButton(type: .system)
    private let warningToastButton = UIButton(type: .system)
    private let errorToastButton = UIButton(type: .system)
    private let customPositionButton = UIButton(type: .system)
    private let longTextToastButton = UIButton(type: .system)
    private let imageToastButton = UIButton(type: .system)
    private let customStyleButton = UIButton(type: .system)
    private let loadingToastButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        configureToastStyle()
    }
    
    /// 设置用户界面
    private func setupUI() {
        setupNavigationBar()
        setupScrollView()
        setupButtons()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "Toast 提示") {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
    }
    
    /// 设置按钮
    private func setupButtons() {
        let buttons = [basicToastButton, successToastButton, warningToastButton, errorToastButton, customPositionButton, longTextToastButton, imageToastButton, customStyleButton, loadingToastButton]
        let titles = ["基础 Toast", "成功提示", "警告提示", "错误提示", "自定义位置", "长文本 Toast", "带图标 Toast", "自定义样式", "加载 Toast"]
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemPurple, .systemTeal, .systemIndigo, .systemPink, .systemYellow]
        
        for (index, button) in buttons.enumerated() {
            setupButtonStyle(button, title: titles[index], backgroundColor: colors[index])
            contentView.addSubview(button)
        }
    }
    
    /// 设置单个按钮样式
    private func setupButtonStyle(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
    }
    
    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let buttons = [basicToastButton, successToastButton, warningToastButton, errorToastButton, customPositionButton, longTextToastButton, imageToastButton, customStyleButton, loadingToastButton]
        
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(50)
                
                if index == 0 {
                    make.top.equalToSuperview().offset(20)
                } else {
                    make.top.equalTo(buttons[index - 1].snp.bottom).offset(15)
                }
                
                if index == buttons.count - 1 {
                    make.bottom.equalToSuperview().offset(-30)
                }
            }
        }
    }
    
    /// 设置按钮点击事件
    private func setupActions() {
        basicToastButton.addTarget(self, action: #selector(showBasicToast), for: .touchUpInside)
        successToastButton.addTarget(self, action: #selector(showSuccessToast), for: .touchUpInside)
        warningToastButton.addTarget(self, action: #selector(showWarningToast), for: .touchUpInside)
        errorToastButton.addTarget(self, action: #selector(showErrorToast), for: .touchUpInside)
        customPositionButton.addTarget(self, action: #selector(showCustomPositionToast), for: .touchUpInside)
        longTextToastButton.addTarget(self, action: #selector(showLongTextToast), for: .touchUpInside)
        imageToastButton.addTarget(self, action: #selector(showImageToast), for: .touchUpInside)
        customStyleButton.addTarget(self, action: #selector(showCustomStyleToast), for: .touchUpInside)
        loadingToastButton.addTarget(self, action: #selector(showLoadingToast), for: .touchUpInside)
    }
    
    /// 配置 Toast 全局样式
    private func configureToastStyle() {
        // 设置全局默认样式
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = .black.withAlphaComponent(0.8)
        style.cornerRadius = 10
        style.messageFont = UIFont.systemFont(ofSize: 16)
        style.maxWidthPercentage = 0.8
        style.horizontalPadding = 16
        style.verticalPadding = 12
        style.fadeDuration = 0.3
        style.displayShadow = true
        style.shadowColor = .black
        style.shadowOpacity = 0.3
        style.shadowRadius = 6
        style.shadowOffset = CGSize(width: 0, height: 3)
        
        // 应用为默认样式
        ToastManager.shared.style = style
        ToastManager.shared.position = .center
        ToastManager.shared.duration = 2.0
    }
    
    /// 显示基础 Toast
    @objc private func showBasicToast() {
        view.makeToast("这是一个基础的 Toast 提示")
    }
    
    /// 显示成功提示
    @objc private func showSuccessToast() {
        var style = ToastStyle()
        style.backgroundColor = UIColor.systemGreen
        style.messageColor = .white
        style.cornerRadius = 10
        style.messageFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        view.makeToast("操作成功完成！", duration: 2.0, position: .center, style: style)
    }
    
    /// 显示警告提示
    @objc private func showWarningToast() {
        var style = ToastStyle()
        style.backgroundColor = UIColor.systemOrange
        style.messageColor = .white
        style.cornerRadius = 10
        style.messageFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        view.makeToast("⚠️ 请注意相关操作", duration: 2.5, position: .center, style: style)
    }
    
    /// 显示错误提示
    @objc private func showErrorToast() {
        var style = ToastStyle()
        style.backgroundColor = UIColor.systemRed
        style.messageColor = .white
        style.cornerRadius = 10
        style.messageFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        view.makeToast("❌ 操作失败，请重试", duration: 3.0, position: .center, style: style)
    }
    
    /// 显示自定义位置 Toast
    @objc private func showCustomPositionToast() {
        // 顶部
        view.makeToast("顶部位置的 Toast", duration: 1.5, position: .top)
        
        // 延迟显示底部
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.makeToast("底部位置的 Toast", duration: 1.5, position: .bottom)
        }
        
        // 延迟显示中心
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.view.makeToast("中心位置的 Toast", duration: 1.5, position: .center)
        }
    }
    
    /// 显示长文本 Toast
    @objc private func showLongTextToast() {
        let longMessage = "这是一个很长的 Toast 消息，用来演示 Toast 如何处理多行文本内容。Toast 会自动调整高度来适应文本内容，并且保持良好的可读性和视觉效果。"
        
        var style = ToastStyle()
        style.backgroundColor = UIColor.systemIndigo
        style.messageColor = .white
        style.cornerRadius = 12
        style.messageFont = UIFont.systemFont(ofSize: 15)
        style.maxWidthPercentage = 0.85
        style.horizontalPadding = 20
        style.verticalPadding = 16
        
        view.makeToast(longMessage, duration: 4.0, position: .center, style: style)
    }
    
    /// 显示带图标的 Toast
    @objc private func showImageToast() {
        let message = "文件上传成功"
        let image = UIImage(systemName: "checkmark.circle.fill")
        
        var style = ToastStyle()
        style.backgroundColor = UIColor.themeColor
        style.messageColor = .white
        style.imageSize = CGSize(width: 24, height: 24)
        style.cornerRadius = 12
        style.messageFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        view.makeToast(message, duration: 2.5, position: .center, image: image, style: style)
    }
    
    /// 显示自定义样式 Toast
    @objc private func showCustomStyleToast() {
        var style = ToastStyle()
        
        // 创建渐变背景
        style.backgroundColor = UIColor.systemPurple
        style.messageColor = .white
        style.titleColor = .white
        
        // 自定义圆角和边框
        style.cornerRadius = 20
        
        // 自定义字体
        style.titleFont = UIFont.boldSystemFont(ofSize: 18)
        style.messageFont = UIFont.systemFont(ofSize: 14)
        
        // 自定义内边距
        style.horizontalPadding = 24
        style.verticalPadding = 16
        style.titleAlignment = .center
        style.messageAlignment = .center
        
        // 自定义阴影
        style.displayShadow = true
        style.shadowColor = UIColor.systemPurple
        style.shadowOpacity = 0.5
        style.shadowRadius = 10
        style.shadowOffset = CGSize(width: 0, height: 5)
        
        view.makeToast("自定义样式 Toast", 
                      duration: 3.0, 
                      position: .center, 
                      title: "样式演示", 
                      image: UIImage(systemName: "star.fill"), 
                      style: style)
    }
    
    /// 显示加载 Toast
    @objc private func showLoadingToast() {
        // 显示加载 Toast
        view.makeToastActivity(.center)
        
        // 3秒后隐藏并显示完成提示
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.view.hideToastActivity()
            
            // 显示完成提示
            var style = ToastStyle()
            style.backgroundColor = UIColor.systemGreen
            style.messageColor = .white
            style.cornerRadius = 10
            
            self.view.makeToast("加载完成！", duration: 2.0, position: .center, style: style)
        }
    }
}

// MARK: - 扩展方法
extension ToastExampleViewController {
    
    /// 创建自定义 Toast 视图
    private func createCustomToastView(message: String, icon: UIImage?) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 15
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        containerView.addSubview(stackView)
        
        if let icon = icon {
            let imageView = UIImageView(image: icon)
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(24)
            }
        }
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        return containerView
    }
    
    /// 显示自定义 Toast 动画
    private func showCustomAnimatedToast() {
        let customView = createCustomToastView(message: "自定义动画 Toast", icon: UIImage(systemName: "sparkles"))
        
        view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        // 初始状态
        customView.alpha = 0
        customView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // 弹入动画
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            customView.alpha = 1
            customView.transform = .identity
        } completion: { _ in
            // 保持显示
            UIView.animate(withDuration: 0.3, delay: 2.0) {
                customView.alpha = 0
                customView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { _ in
                customView.removeFromSuperview()
            }
        }
    }
}
