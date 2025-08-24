//
//  CustomAlertDialog.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// 自定义警告弹窗类型
enum CustomAlertType {
    case info
    case warning
    case error
    
    var iconName: String {
        switch self {
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.circle.fill"
        }
    }
    
    var iconColor: UIColor {
        switch self {
        case .info:
            return .systemBlue
        case .warning:
            return .systemOrange
        case .error:
            return .systemRed
        }
    }
}

/// 自定义警告弹窗
class CustomAlertDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonsStackView = UIStackView()
    
    private var primaryAction: (() -> Void)?
    private var secondaryAction: (() -> Void)?
    
    /// 初始化自定义警告弹窗
    /// - Parameters:
    ///   - type: 弹窗类型
    ///   - title: 标题
    ///   - message: 消息内容
    ///   - primaryAction: 主要操作按钮和回调
    ///   - secondaryAction: 次要操作按钮和回调（可选）
    init(type: CustomAlertType, title: String, message: String, primaryAction: (String, () -> Void), secondaryAction: (String, () -> Void)?) {
        super.init(frame: .zero)
        
        self.primaryAction = primaryAction.1
        self.secondaryAction = secondaryAction?.1
        
        setupUI()
        configure(type: type, title: title, message: message, primaryActionTitle: primaryAction.0, secondaryActionTitle: secondaryAction?.0)
    }
    
    /// 便利构造器 - 用于简单的弹窗
    convenience init() {
        self.init(type: .info, title: "", message: "", primaryAction: ("确定", {}), secondaryAction: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupIconView()
        setupLabels()
        setupButtons()
        setupConstraints()
    }
    
    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        
        addSubview(backgroundView)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 8
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
        
        addSubview(containerView)
    }
    
    /// 设置图标视图
    private func setupIconView() {
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
    }
    
    /// 设置标签
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
    }
    
    /// 设置按钮
    private func setupButtons() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 12
        
        containerView.addSubview(buttonsStackView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(280)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 配置弹窗内容
    private func configure(type: CustomAlertType, title: String, message: String, primaryActionTitle: String, secondaryActionTitle: String?) {
        // 设置图标
        iconImageView.image = UIImage(systemName: type.iconName)
        iconImageView.tintColor = type.iconColor
        
        // 设置文本
        titleLabel.text = title
        messageLabel.text = message
        
        // 设置按钮
        let primaryButton = createButton(title: primaryActionTitle, isPrimary: true) { [weak self] in
            self?.primaryAction?()
            self?.dismiss()
        }
        
        if let secondaryTitle = secondaryActionTitle {
            let secondaryButton = createButton(title: secondaryTitle, isPrimary: false) { [weak self] in
                self?.secondaryAction?()
                self?.dismiss()
            }
            
            buttonsStackView.addArrangedSubview(secondaryButton)
            buttonsStackView.addArrangedSubview(primaryButton)
        } else {
            buttonsStackView.addArrangedSubview(primaryButton)
        }
    }
    
    /// 创建按钮
    private func createButton(title: String, isPrimary: Bool, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: isPrimary ? .medium : .regular)
        button.layer.cornerRadius = 8
        
        if isPrimary {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
        } else {
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = UIColor.systemGray5
        }
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        return button
    }
    
    /// 显示弹窗
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 背景点击事件
    @objc private func backgroundTapped() {
        dismiss()
    }
}

/// 简单基础弹窗
class SimpleAlertDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private var onDismiss: (() -> Void)?
    
    /// 显示简单弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - buttonTitle: 按钮标题
    ///   - action: 按钮点击回调
    static func show(title: String, message: String, buttonTitle: String = "确定", action: (() -> Void)? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let dialog = SimpleAlertDialog()
        dialog.setupUI(title: title, message: message, buttonTitle: buttonTitle, action: action)
        dialog.showOn(window: window)
    }
    
    /// 设置UI
    private func setupUI(title: String, message: String, buttonTitle: String, action: (() -> Void)?) {
        // 设置背景
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        addSubview(backgroundView)
        
        // 设置容器
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 8
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
        addSubview(containerView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        // 消息
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        
        // 按钮
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.themeColor
        containerView.addSubview(button)
        
        // 按钮点击
        self.onDismiss = action
        button.addAction(UIAction { _ in
            self.onDismiss?()
            self.dismiss()
        }, for: .touchUpInside)
        
        // 约束
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 显示弹窗
    private func showOn(window: UIWindow) {
        frame = window.bounds
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 关闭弹窗
    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 背景点击
    @objc private func backgroundTapped() {
        dismiss()
    }
}

/// CustomAlertDialog 扩展
extension CustomAlertDialog {
    /// 简单显示警告弹窗
    func show(title: String, message: String, buttonTitle: String = "确定", action: (() -> Void)? = nil) {
        SimpleAlertDialog.show(title: title, message: message, buttonTitle: buttonTitle, action: action)
    }
}

/// UIViewController 扩展
extension UIViewController {
    /// 获取最顶层的视图控制器
    func topMostViewController() -> UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostViewController()
        }
        
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? self
        }
        
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }
        
        return self
    }
}
