//
//  CustomInputDialog.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// 输入类型
enum InputType {
    case text
    case password
    case email
    case number
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .text, .password:
            return .default
        case .email:
            return .emailAddress
        case .number:
            return .numberPad
        }
    }
    
    var isSecureText: Bool {
        return self == .password
    }
}

/// 自定义输入弹窗
class CustomInputDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let textField = UITextField()
    private let textFieldContainer = UIView()
    private let buttonsStackView = UIStackView()
    
    private var confirmAction: ((String) -> Void)?
    private var cancelAction: (() -> Void)?
    
    /// 初始化输入弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息内容
    ///   - placeholder: 输入框占位符
    ///   - inputType: 输入类型
    ///   - confirmAction: 确认回调
    ///   - cancelAction: 取消回调
    init(title: String, message: String, placeholder: String, inputType: InputType, confirmAction: @escaping (String) -> Void, cancelAction: @escaping () -> Void) {
        super.init(frame: .zero)
        
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
        
        setupUI()
        configure(title: title, message: message, placeholder: placeholder, inputType: inputType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupLabels()
        setupTextField()
        setupButtons()
        setupConstraints()
        setupKeyboardObservers()
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
        
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
    }
    
    /// 设置输入框
    private func setupTextField() {
        // 容器
        textFieldContainer.backgroundColor = UIColor.systemGray6
        textFieldContainer.layer.cornerRadius = 8
        textFieldContainer.layer.borderWidth = 1
        textFieldContainer.layer.borderColor = UIColor.systemGray4.cgColor
        
        // 输入框
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .label
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        
        textFieldContainer.addSubview(textField)
        containerView.addSubview(textFieldContainer)
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
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
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        textFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 设置键盘监听
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    /// 配置弹窗内容
    private func configure(title: String, message: String, placeholder: String, inputType: InputType) {
        titleLabel.text = title
        messageLabel.text = message
        textField.placeholder = placeholder
        textField.keyboardType = inputType.keyboardType
        textField.isSecureTextEntry = inputType.isSecureText
        
        // 取消按钮
        let cancelButton = createButton(title: "取消", style: .cancel) { [weak self] in
            self?.cancelAction?()
            self?.dismiss()
        }
        
        // 确认按钮
        let confirmButton = createButton(title: "确定", style: .confirm) { [weak self] in
            let text = self?.textField.text ?? ""
            self?.confirmAction?(text)
            self?.dismiss()
        }
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(confirmButton)
    }
    
    /// 按钮样式
    enum ButtonStyle {
        case cancel
        case confirm
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
        case .confirm:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
        }
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        return button
    }
    
    /// 键盘显示
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let screenHeight = UIScreen.main.bounds.height
        let containerBottom = frame.height / 2 + containerView.frame.height / 2
        
        if containerBottom + keyboardHeight > screenHeight {
            let offset = containerBottom + keyboardHeight - screenHeight + 20
            
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -offset)
            }
        }
    }
    
    /// 键盘隐藏
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
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
        } completion: { _ in
            self.textField.becomeFirstResponder()
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        textField.resignFirstResponder()
        
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
        textField.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate

extension CustomInputDialog: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        confirmAction?(text)
        dismiss()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldContainer.layer.borderColor = UIColor.themeColor.cgColor
        textFieldContainer.layer.borderWidth = 1.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldContainer.layer.borderColor = UIColor.systemGray4.cgColor
        textFieldContainer.layer.borderWidth = 1
    }
}