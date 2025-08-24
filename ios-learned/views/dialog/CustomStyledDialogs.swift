//
//  CustomStyledDialogs.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// 动画类型
enum AnimationType {
    case bounce
    case slide
    case fade
    case rotate
}

/// 自定义动画弹窗
class CustomAnimatedDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let closeButton = UIButton()
    
    private let animationType: AnimationType
    
    /// 初始化动画弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - animation: 动画类型
    init(title: String, message: String, animation: AnimationType) {
        self.animationType = animation
        super.init(frame: .zero)
        setupUI()
        configure(title: title, message: message)
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
        setupCloseButton()
        setupConstraints()
    }
    
    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.alpha = 0
        addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 12
        
        // 渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.themeColor.withAlphaComponent(0.1).cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.cornerRadius = 20
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(containerView)
    }
    
    /// 设置图标视图
    private func setupIconView() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.themeColor
        containerView.addSubview(iconImageView)
    }
    
    /// 设置标签
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
    }
    
    /// 设置关闭按钮
    private func setupCloseButton() {
        closeButton.setTitle("确定", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.themeColor
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        closeButton.layer.cornerRadius = 12
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(closeButton)
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
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    /// 配置弹窗内容
    private func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
        iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
        
        // 根据动画类型设置初始状态
        switch animationType {
        case .bounce:
            containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        case .slide:
            containerView.transform = CGAffineTransform(translationX: 0, y: -400)
        case .fade:
            containerView.alpha = 0
        case .rotate:
            containerView.transform = CGAffineTransform(rotationAngle: .pi).scaledBy(x: 0.5, y: 0.5)
        }
    }
    
    /// 显示弹窗
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        // 渐变层适配容器大小
        if let gradientLayer = containerView.layer.sublayers?.first as? CAGradientLayer {
            DispatchQueue.main.async {
                gradientLayer.frame = self.containerView.bounds
            }
        }
        
        // 根据动画类型执行不同的动画
        switch animationType {
        case .bounce:
            showBounceAnimation()
        case .slide:
            showSlideAnimation()
        case .fade:
            showFadeAnimation()
        case .rotate:
            showRotateAnimation()
        }
    }
    
    /// 弹跳动画
    private func showBounceAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8) {
            self.containerView.transform = .identity
        }
    }
    
    /// 滑入动画
    private func showSlideAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.containerView.transform = .identity
        }
    }
    
    /// 淡入动画
    private func showFadeAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
        }
    }
    
    /// 旋转动画
    private func showRotateAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0) {
            self.containerView.transform = .identity
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 关闭按钮点击
    @objc private func closeButtonTapped() {
        dismiss()
    }
    
    /// 背景点击
    @objc private func backgroundTapped() {
        dismiss()
    }
}

/// 自定义卡片弹窗
class CustomCardDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let headerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionsStackView = UIStackView()
    
    /// 初始化卡片弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - imageName: 图标名称
    ///   - actions: 操作按钮列表
    init(title: String, subtitle: String, imageName: String, actions: [(String, () -> Void)]) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, subtitle: subtitle, imageName: imageName, actions: actions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupHeaderView()
        setupLabels()
        setupActionsStackView()
        setupConstraints()
    }
    
    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
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
    
    /// 设置头部视图
    private func setupHeaderView() {
        headerView.backgroundColor = UIColor.themeColor.withAlphaComponent(0.1)
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.themeColor
        
        headerView.addSubview(iconImageView)
        containerView.addSubview(headerView)
    }
    
    /// 设置标签
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
    }
    
    /// 设置操作按钮容器
    private func setupActionsStackView() {
        actionsStackView.axis = .vertical
        actionsStackView.spacing = 8
        actionsStackView.distribution = .fillEqually
        
        containerView.addSubview(actionsStackView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(320)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        actionsStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 配置弹窗内容
    private func configure(title: String, subtitle: String, imageName: String, actions: [(String, () -> Void)]) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = UIImage(systemName: imageName)
        
        // 添加操作按钮
        for (index, action) in actions.enumerated() {
            let button = createActionButton(title: action.0, isDestructive: index == actions.count - 2) {
                action.1()
                self.dismiss()
            }
            actionsStackView.addArrangedSubview(button)
        }
    }
    
    /// 创建操作按钮
    private func createActionButton(title: String, isDestructive: Bool, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        
        if isDestructive {
            button.setTitleColor(.systemRed, for: .normal)
            button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            button.layer.borderColor = UIColor.systemRed.cgColor
        } else if title == "取消" {
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = UIColor.systemGray5
            button.layer.borderColor = UIColor.systemGray4.cgColor
        } else {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
            button.layer.borderColor = UIColor.themeColor.cgColor
        }
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        return button
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
    
    /// 背景点击
    @objc private func backgroundTapped() {
        dismiss()
    }
}

/// 自定义底部弹窗
class CustomBottomSheetDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let handleView = UIView()
    private let titleLabel = UILabel()
    private let itemsStackView = UIStackView()
    
    /// 初始化底部弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - items: 选项列表 (标题, 图标, 回调)
    init(title: String, items: [(String, String, () -> Void)]) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupHandleView()
        setupTitleLabel()
        setupItemsStackView()
        setupConstraints()
    }
    
    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addSubview(containerView)
    }
    
    /// 设置拖拽条
    private func setupHandleView() {
        handleView.backgroundColor = UIColor.systemGray4
        handleView.layer.cornerRadius = 2
        containerView.addSubview(handleView)
    }
    
    /// 设置标题标签
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
    }
    
    /// 设置选项容器
    private func setupItemsStackView() {
        itemsStackView.axis = .vertical
        itemsStackView.spacing = 0
        containerView.addSubview(itemsStackView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        handleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    /// 配置弹窗内容
    private func configure(title: String, items: [(String, String, () -> Void)]) {
        titleLabel.text = title
        
        // 添加选项按钮
        for item in items {
            let itemView = createItemView(title: item.0, iconName: item.1, action: item.2)
            itemsStackView.addArrangedSubview(itemView)
        }
    }
    
    /// 创建选项视图
    private func createItemView(title: String, iconName: String, action: @escaping () -> Void) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = UIColor.themeColor
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        let button = UIButton()
        button.backgroundColor = .clear
        button.addAction(UIAction { _ in
            action()
            self.dismiss()
        }, for: .touchUpInside)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(button)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(56)
        }
        
        // 添加分割线
        if title != "更多" { // 假设最后一个是"更多"选项
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.separator
            containerView.addSubview(separatorView)
            
            separatorView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(60)
                make.right.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
        
        return containerView
    }
    
    /// 显示弹窗
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        // 先设置初始位置
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.containerView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            }
            self.containerView.transform = .identity
            self.layoutIfNeeded()
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 背景点击
    @objc private func backgroundTapped() {
        dismiss()
    }
}