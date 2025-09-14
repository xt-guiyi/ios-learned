//
//  BottomSheetExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class BottomSheetExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 滚动容器
    private let scrollView = UIScrollView()
    
    /// 内容容器
    private let contentView = UIView()
    
    /// 按钮组
    private let basicBottomSheetButton = UIButton(type: .system)
    private let menuBottomSheetButton = UIButton(type: .system)
    private let formBottomSheetButton = UIButton(type: .system)
    private let imagePickerButton = UIButton(type: .system)
    private let shareBottomSheetButton = UIButton(type: .system)
    private let customHeightButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
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
        navigationBar.configure(title: "底部弹窗") {
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
        let buttons = [basicBottomSheetButton, menuBottomSheetButton, formBottomSheetButton, imagePickerButton, shareBottomSheetButton, customHeightButton]
        let titles = ["基础底部弹窗", "菜单选择弹窗", "表单输入弹窗", "图片选择弹窗", "分享操作弹窗", "自定义高度弹窗"]
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemTeal, .systemIndigo]
        
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
        
        let buttons = [basicBottomSheetButton, menuBottomSheetButton, formBottomSheetButton, imagePickerButton, shareBottomSheetButton, customHeightButton]
        
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
        basicBottomSheetButton.addTarget(self, action: #selector(showBasicBottomSheet), for: .touchUpInside)
        menuBottomSheetButton.addTarget(self, action: #selector(showMenuBottomSheet), for: .touchUpInside)
        formBottomSheetButton.addTarget(self, action: #selector(showFormBottomSheet), for: .touchUpInside)
        imagePickerButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        shareBottomSheetButton.addTarget(self, action: #selector(showShareBottomSheet), for: .touchUpInside)
        customHeightButton.addTarget(self, action: #selector(showCustomHeightBottomSheet), for: .touchUpInside)
    }
    
    /// 显示基础底部弹窗
    @objc private func showBasicBottomSheet() {
        let bottomSheet = BasicBottomSheetView()
        bottomSheet.show(
            title: "基础底部弹窗",
            message: "这是一个基础的底部弹窗，展示简单的信息内容。可以通过下拉手势或点击背景来关闭。",
            buttonTitle: "知道了"
        ) {
            print("用户点击了确认按钮")
        }
    }
    
    /// 显示菜单选择弹窗
    @objc private func showMenuBottomSheet() {
        let bottomSheet = MenuBottomSheetView()
        let menuItems = [
            BottomSheetMenuItem(icon: "pencil", title: "编辑", action: {
                self.showResultMessage("选择了编辑")
            }),
            BottomSheetMenuItem(icon: "square.and.arrow.up", title: "分享", action: {
                self.showResultMessage("选择了分享")
            }),
            BottomSheetMenuItem(icon: "heart", title: "收藏", action: {
                self.showResultMessage("选择了收藏")
            }),
            BottomSheetMenuItem(icon: "trash", title: "删除", isDestructive: true, action: {
                self.showResultMessage("选择了删除")
            })
        ]
        bottomSheet.show(title: "选择操作", items: menuItems)
    }
    
    /// 显示表单输入弹窗
    @objc private func showFormBottomSheet() {
        let bottomSheet = FormBottomSheetView()
        bottomSheet.show(
            title: "创建新项目",
            fields: [
                FormField(placeholder: "项目名称", type: .text),
                FormField(placeholder: "项目描述", type: .text),
                FormField(placeholder: "截止日期", type: .date)
            ]
        ) { results in
            print("表单结果：", results)
            self.showResultMessage("项目创建成功")
        }
    }
    
    /// 显示图片选择弹窗
    @objc private func showImagePicker() {
        let bottomSheet = ImagePickerBottomSheetView()
        bottomSheet.show { source in
            switch source {
            case .camera:
                self.showResultMessage("选择了拍照")
            case .photoLibrary:
                self.showResultMessage("选择了相册")
            case .files:
                self.showResultMessage("选择了文件")
            }
        }
    }
    
    /// 显示分享操作弹窗
    @objc private func showShareBottomSheet() {
        let bottomSheet = ShareBottomSheetView()
        bottomSheet.show(content: "分享这个精彩的内容给朋友们吧！")
    }
    
    /// 显示自定义高度弹窗
    @objc private func showCustomHeightBottomSheet() {
        let bottomSheet = CustomHeightBottomSheetView()
        bottomSheet.show(height: 500) {
            print("自定义弹窗关闭")
        }
    }
    
    /// 显示结果消息
    private func showResultMessage(_ message: String) {
        SimpleAlertDialog.show(title: "操作结果", message: message)
    }
}

// MARK: - 底部弹窗基础类
class BaseBottomSheetView: UIView {
    
    internal let backgroundView = UIView()
    internal let containerView = UIView()
    internal let handleView = UIView()
    
    private var containerBottomConstraint: Constraint?
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialContainerFrame: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置基础UI
    private func setupBaseUI() {
        // 背景视图
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        addSubview(backgroundView)
        
        // 容器视图
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(containerView)
        
        // 拖拽指示器
        handleView.backgroundColor = UIColor.systemGray3
        handleView.layer.cornerRadius = 2.5
        containerView.addSubview(handleView)
        
        // 设置约束
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            self.containerBottomConstraint = make.bottom.equalToSuperview().offset(500).constraint
        }
        
        handleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(5)
        }
    }
    
    /// 设置手势
    private func setupGestures() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    /// 显示弹窗
    func showBottomSheet() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        // 强制布局，确保初始位置正确
        layoutIfNeeded()
        
        // 更新约束到最终位置
        containerBottomConstraint?.update(offset: 0)
        
        // 动画显示
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    /// 关闭弹窗
    @objc func dismiss() {
        containerBottomConstraint?.update(offset: containerView.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 0
            self.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 背景点击
    @objc private func backgroundTapped() {
        dismiss()
    }
    
    /// 拖拽手势处理
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            initialContainerFrame = containerView.frame
            
        case .changed:
            let newOffset = max(0, translation.y)
            containerBottomConstraint?.update(offset: newOffset)
            
            // 更新背景透明度
            let progress = newOffset / containerView.frame.height
            backgroundView.alpha = max(0.1, 1 - progress)
            
        case .ended, .cancelled:
            let shouldDismiss = translation.y > containerView.frame.height * 0.3 || velocity.y > 1000
            
            if shouldDismiss {
                dismiss()
            } else {
                // 回弹到原位
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                    self.containerBottomConstraint?.update(offset: 0)
                    self.backgroundView.alpha = 1
                    self.layoutIfNeeded()
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - 基础底部弹窗
class BasicBottomSheetView: BaseBottomSheetView {
    
    /// 显示基础弹窗
    func show(title: String, message: String, buttonTitle: String = "确定", action: (() -> Void)? = nil) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        
        let button = UIButton()
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        containerView.addSubview(button)
        
        button.addAction(UIAction { _ in
            action?()
            self.dismiss()
        }, for: .touchUpInside)
        
        // 约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        showBottomSheet()
    }
}

// MARK: - 菜单项模型
struct BottomSheetMenuItem {
    let icon: String
    let title: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(icon: String, title: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
}

// MARK: - 菜单底部弹窗
class MenuBottomSheetView: BaseBottomSheetView {
    
    /// 显示菜单弹窗
    func show(title: String, items: [BottomSheetMenuItem]) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        containerView.addSubview(stackView)
        
        for (index, item) in items.enumerated() {
            let itemButton = createMenuItemButton(item: item)
            stackView.addArrangedSubview(itemButton)
            
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.separator
                stackView.addArrangedSubview(separator)
                separator.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
            }
        }
        
        // 约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        showBottomSheet()
    }
    
    /// 创建菜单项按钮
    private func createMenuItemButton(item: BottomSheetMenuItem) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .left
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: item.icon)
        iconImageView.tintColor = item.isDestructive ? .systemRed : .label
        iconImageView.contentMode = .scaleAspectFit
        button.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = item.isDestructive ? .systemRed : .label
        button.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        button.addAction(UIAction { _ in
            item.action()
            self.dismiss()
        }, for: .touchUpInside)
        
        return button
    }
}

// MARK: - 表单字段模型
struct FormField {
    let placeholder: String
    let type: FormFieldType
    
    enum FormFieldType {
        case text
        case email
        case password
        case date
    }
}

// MARK: - 表单底部弹窗
class FormBottomSheetView: BaseBottomSheetView {
    
    private var textFields: [UITextField] = []
    
    /// 显示表单弹窗
    func show(title: String, fields: [FormField], onSubmit: @escaping ([String]) -> Void) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        containerView.addSubview(stackView)
        
        // 创建输入字段
        for field in fields {
            let textField = createTextField(for: field)
            textFields.append(textField)
            stackView.addArrangedSubview(textField)
        }
        
        // 按钮容器
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.backgroundColor = UIColor.systemGray5
        cancelButton.layer.cornerRadius = 8
        
        let submitButton = UIButton()
        submitButton.setTitle("确定", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor.themeColor
        submitButton.layer.cornerRadius = 8
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(submitButton)
        
        stackView.addArrangedSubview(buttonStackView)
        
        // 按钮事件
        cancelButton.addAction(UIAction { _ in
            self.dismiss()
        }, for: .touchUpInside)
        
        submitButton.addAction(UIAction { _ in
            let results = self.textFields.map { $0.text ?? "" }
            onSubmit(results)
            self.dismiss()
        }, for: .touchUpInside)
        
        // 约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        showBottomSheet()
    }
    
    /// 创建文本输入框
    private func createTextField(for field: FormField) -> UITextField {
        let textField = UITextField()
        textField.placeholder = field.placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 16)
        
        switch field.type {
        case .text:
            textField.keyboardType = .default
        case .email:
            textField.keyboardType = .emailAddress
        case .password:
            textField.isSecureTextEntry = true
        case .date:
            textField.keyboardType = .default
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        return textField
    }
}

// MARK: - 图片选择来源
enum ImagePickerSource {
    case camera
    case photoLibrary
    case files
}

// MARK: - 图片选择底部弹窗
class ImagePickerBottomSheetView: BaseBottomSheetView {
    
    /// 显示图片选择弹窗
    func show(onSelect: @escaping (ImagePickerSource) -> Void) {
        let titleLabel = UILabel()
        titleLabel.text = "选择图片"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        containerView.addSubview(stackView)
        
        let options = [
            ("camera.fill", "拍照", ImagePickerSource.camera),
            ("photo.on.rectangle", "相册", ImagePickerSource.photoLibrary),
            ("folder.fill", "文件", ImagePickerSource.files)
        ]
        
        for (index, option) in options.enumerated() {
            let button = createOptionButton(icon: option.0, title: option.1) {
                onSelect(option.2)
                self.dismiss()
            }
            stackView.addArrangedSubview(button)
            
            if index < options.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.separator
                stackView.addArrangedSubview(separator)
                separator.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
            }
        }
        
        // 约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        showBottomSheet()
    }
    
    /// 创建选项按钮
    private func createOptionButton(icon: String, title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = UIColor.themeColor
        iconImageView.contentMode = .scaleAspectFit
        button.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        button.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        return button
    }
}

// MARK: - 分享底部弹窗
class ShareBottomSheetView: BaseBottomSheetView {
    
    /// 显示分享弹窗
    func show(content: String) {
        let titleLabel = UILabel()
        titleLabel.text = "分享到"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // 分享选项网格
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 20
        containerView.addSubview(gridStackView)
        
        let shareOptions = [
            [("message.fill", "信息"), ("square.and.arrow.up", "系统分享"), ("link", "复制链接")],
            [("envelope.fill", "邮件"), ("safari.fill", "浏览器"), ("ellipsis", "更多")]
        ]
        
        for row in shareOptions {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 20
            
            for option in row {
                let button = createShareOptionButton(icon: option.0, title: option.1) {
                    print("分享到：\(option.1)")
                    self.dismiss()
                }
                rowStackView.addArrangedSubview(button)
            }
            
            gridStackView.addArrangedSubview(rowStackView)
        }
        
        // 约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        gridStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(40)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(30)
        }
        
        showBottomSheet()
    }
    
    /// 创建分享选项按钮
    private func createShareOptionButton(icon: String, title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        
        let iconView = UIView()
        iconView.backgroundColor = UIColor.systemGray6
        iconView.layer.cornerRadius = 25
        button.addSubview(iconView)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = UIColor.themeColor
        iconImageView.contentMode = .scaleAspectFit
        iconView.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        button.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        return button
    }
}

// MARK: - 自定义高度底部弹窗
class CustomHeightBottomSheetView: BaseBottomSheetView {
    
    /// 显示自定义高度弹窗
    func show(height: CGFloat, onDismiss: (() -> Void)? = nil) {
        let titleLabel = UILabel()
        titleLabel.text = "自定义高度弹窗"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = "这是一个自定义高度的底部弹窗，高度为 \(Int(height)) 点。你可以通过下拉手势关闭它，或者点击下面的按钮。\n\n这个弹窗演示了如何创建固定高度的底部弹窗，适合展示更多内容或复杂的交互界面。"
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .secondaryLabel
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        containerView.addSubview(contentLabel)
        
        let closeButton = UIButton()
        closeButton.setTitle("关闭", for: .normal)
        closeButton.backgroundColor = UIColor.systemGray5
        closeButton.setTitleColor(.label, for: .normal)
        closeButton.layer.cornerRadius = 8
        containerView.addSubview(closeButton)
        
        closeButton.addAction(UIAction { _ in
            onDismiss?()
            self.dismiss()
        }, for: .touchUpInside)
        
        // 约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(20)
        }
        
        // 设置固定高度
        containerView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        showBottomSheet()
    }
}
