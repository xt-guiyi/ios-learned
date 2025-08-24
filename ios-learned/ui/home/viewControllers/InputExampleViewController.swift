//
//  InputExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class InputExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 输入框组件
    private let basicTextField = UITextField()
    private let passwordTextField = UITextField()
    private let numericTextField = UITextField()
    private let emailTextField = UITextField()
    private let phoneTextField = UITextField()
    private let textView = UITextView()
    
    // 标签
    private let basicLabel = UILabel()
    private let passwordLabel = UILabel()
    private let numericLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()
    private let textViewLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardHandling()
    }
    
    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        setupNavigationBar()
        setupScrollView()
        setupInputControls()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "输入控件") { [weak self] in
          self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(customNavigationBar)
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    /// 设置输入控件
    private func setupInputControls() {
        // 基础文本输入框
        setupBasicTextField()
        
        // 密码输入框
        setupPasswordTextField()
        
        // 数字输入框
        setupNumericTextField()
        
        // 邮箱输入框
        setupEmailTextField()
        
        // 手机号输入框
        setupPhoneTextField()
        
        // 多行文本输入框
        setupTextView()
    }
    
    /// 设置基础文本输入框
    private func setupBasicTextField() {
        basicLabel.text = "基础文本输入框"
        basicLabel.font = UIFont.boldSystemFont(ofSize: 16)
        basicLabel.textColor = .label
        
        basicTextField.placeholder = "请输入文本"
        basicTextField.borderStyle = .roundedRect
        basicTextField.backgroundColor = .systemBackground
        basicTextField.layer.borderWidth = 1
        basicTextField.layer.borderColor = UIColor.systemGray4.cgColor
        basicTextField.layer.cornerRadius = 8
        basicTextField.font = UIFont.systemFont(ofSize: 16)
        basicTextField.clearButtonMode = .whileEditing
        
        contentView.addSubview(basicLabel)
        contentView.addSubview(basicTextField)
    }
    
    /// 设置密码输入框
    private func setupPasswordTextField() {
        passwordLabel.text = "密码输入框"
        passwordLabel.font = UIFont.boldSystemFont(ofSize: 16)
        passwordLabel.textColor = .label
        
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .systemBackground
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGray4.cgColor
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .whileEditing
        
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
    }
    
    /// 设置数字输入框
    private func setupNumericTextField() {
        numericLabel.text = "数字输入框"
        numericLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numericLabel.textColor = .label
        
        numericTextField.placeholder = "请输入数字"
        numericTextField.borderStyle = .roundedRect
        numericTextField.backgroundColor = .systemBackground
        numericTextField.layer.borderWidth = 1
        numericTextField.layer.borderColor = UIColor.systemGray4.cgColor
        numericTextField.layer.cornerRadius = 8
        numericTextField.font = UIFont.systemFont(ofSize: 16)
        numericTextField.keyboardType = .numberPad
        numericTextField.clearButtonMode = .whileEditing
        
        contentView.addSubview(numericLabel)
        contentView.addSubview(numericTextField)
    }
    
    /// 设置邮箱输入框
    private func setupEmailTextField() {
        emailLabel.text = "邮箱输入框"
        emailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.textColor = .label
        
        emailTextField.placeholder = "请输入邮箱地址"
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .systemBackground
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemGray4.cgColor
        emailTextField.layer.cornerRadius = 8
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.clearButtonMode = .whileEditing
        
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
    }
    
    /// 设置手机号输入框
    private func setupPhoneTextField() {
        phoneLabel.text = "手机号输入框"
        phoneLabel.font = UIFont.boldSystemFont(ofSize: 16)
        phoneLabel.textColor = .label
        
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.borderStyle = .none
        phoneTextField.backgroundColor = UIColor.systemGray6
        phoneTextField.layer.cornerRadius = 8
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        phoneTextField.keyboardType = .phonePad
        phoneTextField.clearButtonMode = .whileEditing
        
        // 添加内边距
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: phoneTextField.frame.height))
        phoneTextField.leftView = paddingView
        phoneTextField.leftViewMode = .always
        
        contentView.addSubview(phoneLabel)
        contentView.addSubview(phoneTextField)
    }
    
    /// 设置多行文本输入框
    private func setupTextView() {
        textViewLabel.text = "多行文本输入框"
        textViewLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textViewLabel.textColor = .label
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .systemBackground
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.text = "请输入多行文本内容..."
        textView.textColor = .placeholderText
        textView.delegate = self
        
        contentView.addSubview(textViewLabel)
        contentView.addSubview(textView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 15
        
        // 基础文本输入框
        basicLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        basicTextField.snp.makeConstraints { make in
            make.top.equalTo(basicLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        
        // 密码输入框
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(basicTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        
        // 数字输入框
        numericLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        numericTextField.snp.makeConstraints { make in
            make.top.equalTo(numericLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        
        // 邮箱输入框
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(numericTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        
        // 手机号输入框
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        
        // 多行文本输入框
        textViewLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(textViewLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    /// 设置键盘处理
    private func setupKeyboardHandling() {
        // 点击空白区域收起键盘
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // 监听键盘显示/隐藏
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
    
    /// 收起键盘
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// 键盘将要显示
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    /// 键盘将要隐藏
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextViewDelegate
extension InputExampleViewController: UITextViewDelegate {
    
    /// 开始编辑时清除占位文本
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    /// 结束编辑时恢复占位文本
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "请输入多行文本内容..."
            textView.textColor = .placeholderText
        }
    }
}
