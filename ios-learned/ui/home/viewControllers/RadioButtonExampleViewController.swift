//
//  RadioButtonExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class RadioButtonExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 单选按钮组件
    private let userAgreementRadioButton = CustomRadioButton()
    private let privacyPolicyRadioButton = CustomRadioButton()
    private let allAgreementRadioButton = CustomRadioButton()
    
    // 标签和文本
    private let titleLabel = UILabel()
    private let userAgreementLabel = UILabel()
    private let privacyPolicyLabel = UILabel()
    private let allAgreementLabel = UILabel()
    private let confirmButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        setupNavigationBar()
        setupScrollView()
        setupContent()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "单选按钮") { [weak self] in
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
    
    /// 设置内容
    private func setupContent() {
        setupTitleLabel()
        setupUserAgreementSection()
        setupPrivacyPolicySection()
        setupAllAgreementSection()
        setupConfirmButton()
    }
    
    /// 设置标题
    private func setupTitleLabel() {
        titleLabel.text = "服务协议确认"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
    }
    
    /// 设置用户协议部分
    private func setupUserAgreementSection() {
        // 用户协议标签
        userAgreementLabel.text = "我已阅读并同意《用户服务协议》"
        userAgreementLabel.font = UIFont.systemFont(ofSize: 16)
        userAgreementLabel.textColor = .label
        userAgreementLabel.numberOfLines = 0
        
        // 设置可点击的协议文本
        let attributedText = NSMutableAttributedString(string: userAgreementLabel.text!)
        let range = (userAgreementLabel.text! as NSString).range(of: "《用户服务协议》")
        attributedText.addAttribute(.foregroundColor, value: UIColor.themeColor, range: range)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        userAgreementLabel.attributedText = attributedText
        
        // 添加点击手势
        userAgreementLabel.isUserInteractionEnabled = true
        let userAgreementTap = UITapGestureRecognizer(target: self, action: #selector(showUserAgreement))
        userAgreementLabel.addGestureRecognizer(userAgreementTap)
        
        // 配置单选按钮
        userAgreementRadioButton.addTarget(self, action: #selector(userAgreementRadioButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(userAgreementRadioButton)
        contentView.addSubview(userAgreementLabel)
    }
    
    /// 设置隐私政策部分
    private func setupPrivacyPolicySection() {
        // 隐私政策标签
        privacyPolicyLabel.text = "我已阅读并同意《隐私政策》"
        privacyPolicyLabel.font = UIFont.systemFont(ofSize: 16)
        privacyPolicyLabel.textColor = .label
        privacyPolicyLabel.numberOfLines = 0
        
        // 设置可点击的协议文本
        let attributedText = NSMutableAttributedString(string: privacyPolicyLabel.text!)
        let range = (privacyPolicyLabel.text! as NSString).range(of: "《隐私政策》")
        attributedText.addAttribute(.foregroundColor, value: UIColor.themeColor, range: range)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        privacyPolicyLabel.attributedText = attributedText
        
        // 添加点击手势
        privacyPolicyLabel.isUserInteractionEnabled = true
        let privacyPolicyTap = UITapGestureRecognizer(target: self, action: #selector(showPrivacyPolicy))
        privacyPolicyLabel.addGestureRecognizer(privacyPolicyTap)
        
        // 配置单选按钮
        privacyPolicyRadioButton.addTarget(self, action: #selector(privacyPolicyRadioButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(privacyPolicyRadioButton)
        contentView.addSubview(privacyPolicyLabel)
    }
    
    /// 设置全部同意部分
    private func setupAllAgreementSection() {
        allAgreementLabel.text = "我同意以上所有条款"
        allAgreementLabel.font = UIFont.boldSystemFont(ofSize: 16)
        allAgreementLabel.textColor = .label
        
        // 配置单选按钮
        allAgreementRadioButton.addTarget(self, action: #selector(allAgreementRadioButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(allAgreementRadioButton)
        contentView.addSubview(allAgreementLabel)
    }
    
    /// 设置确认按钮
    private func setupConfirmButton() {
        confirmButton.setTitle("确认并继续", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitleColor(.lightGray, for: .disabled)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        confirmButton.backgroundColor = UIColor.systemGray4
        confirmButton.layer.cornerRadius = 8
        confirmButton.isEnabled = false
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(confirmButton)
    }
    
    /// 设置约束
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 20
        let radioButtonSize: CGFloat = 24
        
        // 标题
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        // 用户协议部分
        userAgreementRadioButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(margin)
            make.width.height.equalTo(radioButtonSize)
        }
        
        userAgreementLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userAgreementRadioButton)
            make.left.equalTo(userAgreementRadioButton.snp.right).offset(12)
            make.right.equalToSuperview().inset(margin)
        }
        
        // 隐私政策部分
        privacyPolicyRadioButton.snp.makeConstraints { make in
            make.top.equalTo(userAgreementRadioButton.snp.bottom).offset(spacing)
            make.left.equalToSuperview().offset(margin)
            make.width.height.equalTo(radioButtonSize)
        }
        
        privacyPolicyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyPolicyRadioButton)
            make.left.equalTo(privacyPolicyRadioButton.snp.right).offset(12)
            make.right.equalToSuperview().inset(margin)
        }
        
        // 全部同意部分
        allAgreementRadioButton.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyRadioButton.snp.bottom).offset(spacing)
            make.left.equalToSuperview().offset(margin)
            make.width.height.equalTo(radioButtonSize)
        }
        
        allAgreementLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allAgreementRadioButton)
            make.left.equalTo(allAgreementRadioButton.snp.right).offset(12)
            make.right.equalToSuperview().inset(margin)
        }
        
        // 确认按钮
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(allAgreementRadioButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    /// 更新按钮状态
    private func updateConfirmButtonState() {
        let allSelected = userAgreementRadioButton.isSelected && 
                         privacyPolicyRadioButton.isSelected &&
                         allAgreementRadioButton.isSelected
        
        confirmButton.isEnabled = allSelected
        confirmButton.backgroundColor = allSelected ? UIColor.themeColor : UIColor.systemGray4
    }
    
    // MARK: - Actions
    
    /// 用户协议单选按钮点击
    @objc private func userAgreementRadioButtonTapped() {
        userAgreementRadioButton.isSelected.toggle()
        updateAllAgreementState()
        updateConfirmButtonState()
    }
    
    /// 隐私政策单选按钮点击
    @objc private func privacyPolicyRadioButtonTapped() {
        privacyPolicyRadioButton.isSelected.toggle()
        updateAllAgreementState()
        updateConfirmButtonState()
    }
    
    /// 全部同意单选按钮点击
    @objc private func allAgreementRadioButtonTapped() {
        allAgreementRadioButton.isSelected.toggle()
        
        // 如果点击全部同意，则同步其他选项
        if allAgreementRadioButton.isSelected {
            userAgreementRadioButton.isSelected = true
            privacyPolicyRadioButton.isSelected = true
        } else {
            userAgreementRadioButton.isSelected = false
            privacyPolicyRadioButton.isSelected = false
        }
        
        updateConfirmButtonState()
    }
    
    /// 更新全部同意状态
    private func updateAllAgreementState() {
        let allIndividualSelected = userAgreementRadioButton.isSelected && 
                                   privacyPolicyRadioButton.isSelected
        allAgreementRadioButton.isSelected = allIndividualSelected
    }
    
    /// 显示用户协议
    @objc private func showUserAgreement() {
        let alert = UIAlertController(title: "用户服务协议", 
                                     message: "这里是用户服务协议的具体内容...\n\n1. 服务条款\n2. 用户权责\n3. 免责声明\n4. 其他条款", 
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    /// 显示隐私政策
    @objc private func showPrivacyPolicy() {
        let alert = UIAlertController(title: "隐私政策", 
                                     message: "这里是隐私政策的具体内容...\n\n1. 信息收集\n2. 信息使用\n3. 信息保护\n4. 用户权利", 
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    /// 确认按钮点击
    @objc private func confirmButtonTapped() {
        let alert = UIAlertController(title: "确认成功", 
                                     message: "感谢您同意我们的服务条款！", 
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - CustomRadioButton

class CustomRadioButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    /// 设置UI
    private func setupUI() {
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .systemBackground
        updateAppearance()
    }
    
    /// 更新外观
    private func updateAppearance() {
        if isSelected {
            backgroundColor = UIColor.themeColor
            layer.borderColor = UIColor.themeColor.cgColor
            
            // 添加对勾图标
            let checkmarkImage = createCheckmarkImage()
            setImage(checkmarkImage, for: .normal)
        } else {
            backgroundColor = .systemBackground
            layer.borderColor = UIColor.systemGray4.cgColor
            setImage(nil, for: .normal)
        }
    }
    
    /// 创建对勾图标
    private func createCheckmarkImage() -> UIImage? {
        let size = CGSize(width: 16, height: 16)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 设置画笔
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        // 绘制对勾
        context.move(to: CGPoint(x: 3, y: 8))
        context.addLine(to: CGPoint(x: 7, y: 12))
        context.addLine(to: CGPoint(x: 13, y: 4))
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}