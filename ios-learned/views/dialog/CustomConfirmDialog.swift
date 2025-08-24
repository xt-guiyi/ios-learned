//
//  CustomConfirmDialog.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// 自定义确认弹窗
class CustomConfirmDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonsStackView = UIStackView()
    
    private var confirmAction: (() -> Void)?
    private var cancelAction: (() -> Void)?
    
    /// 初始化确认弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息内容
    ///   - confirmAction: 确认操作按钮和回调
    ///   - cancelAction: 取消操作按钮和回调
    init(title: String, message: String, confirmAction: (String, () -> Void), cancelAction: (String, () -> Void)) {
        super.init(frame: .zero)
        
        self.confirmAction = confirmAction.1
        self.cancelAction = cancelAction.1
        
        setupUI()
        configure(title: title, message: message, confirmActionTitle: confirmAction.0, cancelActionTitle: cancelAction.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
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
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        containerView.alpha = 0
        
        addSubview(containerView)
    }
    
    /// 设置标签
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = UIFont.systemFont(ofSize: 15)
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
            make.width.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
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
    private func configure(title: String, message: String, confirmActionTitle: String, cancelActionTitle: String) {
        titleLabel.text = title
        messageLabel.text = message
        
        // 取消按钮
        let cancelButton = createButton(title: cancelActionTitle, style: .cancel) { [weak self] in
            self?.cancelAction?()
            self?.dismiss()
        }
        
        // 确认按钮
        let confirmButton = createButton(title: confirmActionTitle, style: .destructive) { [weak self] in
            self?.confirmAction?()
            self?.dismiss()
        }
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)
    }
    
    /// 按钮样式
    enum ButtonStyle {
        case cancel
        case destructive
        case `default`
    }
    
    /// 创建按钮
    private func createButton(title: String, style: ButtonStyle, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        
        switch style {
        case .cancel:
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = UIColor.systemGray5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
        case .destructive:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemRed
        case .default:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
        }
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        // 添加点击效果
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    /// 按钮按下效果
    @objc private func buttonTouchDown(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            button.alpha = 0.8
        }
    }
    
    /// 按钮抬起效果
    @objc private func buttonTouchUp(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = .identity
            button.alpha = 1.0
        }
    }
    
    /// 显示弹窗
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 背景点击事件
    @objc private func backgroundTapped() {
        dismiss()
    }
}