//
//  CheckboxExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class CheckboxExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 兴趣爱好多选
    private let interestsLabel = UILabel()
    private let sportsCheckbox = CustomCheckbox()
    private let musicCheckbox = CustomCheckbox()
    private let readingCheckbox = CustomCheckbox()
    private let travelCheckbox = CustomCheckbox()
    
    // 权限设置多选
    private let permissionsLabel = UILabel()
    private let cameraCheckbox = CustomCheckbox()
    private let locationCheckbox = CustomCheckbox()
    private let notificationCheckbox = CustomCheckbox()
    private let contactsCheckbox = CustomCheckbox()
    
    // 应用设置多选
    private let settingsLabel = UILabel()
    private let autoSaveCheckbox = CustomCheckbox()
    private let offlineModeCheckbox = CustomCheckbox()
    private let dataCompressionCheckbox = CustomCheckbox()
    
    // 全选控制
    private let selectAllCheckbox = CustomCheckbox()
    private let selectAllLabel = UILabel()
    
    // 结果显示
    private let resultButton = UIButton()
    
    private var allCheckboxes: [CustomCheckbox] = []
    
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
        setupCheckboxes()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "多选按钮") { [weak self] in
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
        setupInterestsSection()
        setupPermissionsSection()
        setupSettingsSection()
        setupSelectAllSection()
        setupResultButton()
    }
    
    /// 设置兴趣爱好部分
    private func setupInterestsSection() {
        interestsLabel.text = "选择您的兴趣爱好"
        interestsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        interestsLabel.textColor = .label
        
        setupCheckboxWithLabel(checkbox: sportsCheckbox, text: "运动健身")
        setupCheckboxWithLabel(checkbox: musicCheckbox, text: "音乐欣赏")
        setupCheckboxWithLabel(checkbox: readingCheckbox, text: "读书学习")
        setupCheckboxWithLabel(checkbox: travelCheckbox, text: "旅行探索")
        
        contentView.addSubview(interestsLabel)
    }
    
    /// 设置权限部分
    private func setupPermissionsSection() {
        permissionsLabel.text = "应用权限设置"
        permissionsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        permissionsLabel.textColor = .label
        
        setupCheckboxWithLabel(checkbox: cameraCheckbox, text: "允许使用相机")
        setupCheckboxWithLabel(checkbox: locationCheckbox, text: "允许获取位置信息")
        setupCheckboxWithLabel(checkbox: notificationCheckbox, text: "允许推送通知")
        setupCheckboxWithLabel(checkbox: contactsCheckbox, text: "允许访问通讯录")
        
        contentView.addSubview(permissionsLabel)
    }
    
    /// 设置应用设置部分
    private func setupSettingsSection() {
        settingsLabel.text = "应用功能设置"
        settingsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        settingsLabel.textColor = .label
        
        setupCheckboxWithLabel(checkbox: autoSaveCheckbox, text: "自动保存数据")
        setupCheckboxWithLabel(checkbox: offlineModeCheckbox, text: "离线模式")
        setupCheckboxWithLabel(checkbox: dataCompressionCheckbox, text: "数据压缩传输")
        
        contentView.addSubview(settingsLabel)
    }
    
    /// 设置全选部分
    private func setupSelectAllSection() {
        selectAllLabel.text = "全选所有选项"
        selectAllLabel.font = UIFont.boldSystemFont(ofSize: 16)
        selectAllLabel.textColor = UIColor.themeColor
        
        selectAllCheckbox.addTarget(self, action: #selector(selectAllTapped), for: .touchUpInside)
        
        contentView.addSubview(selectAllCheckbox)
        contentView.addSubview(selectAllLabel)
    }
    
    /// 设置结果按钮
    private func setupResultButton() {
        resultButton.setTitle("查看选择结果", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        resultButton.backgroundColor = UIColor.themeColor
        resultButton.layer.cornerRadius = 8
        
        resultButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        
        contentView.addSubview(resultButton)
    }
    
    /// 设置复选框和标签
    private func setupCheckboxWithLabel(checkbox: CustomCheckbox, text: String) {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        
        checkbox.tag = allCheckboxes.count
        checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        contentView.addSubview(checkbox)
        contentView.addSubview(label)
        
        allCheckboxes.append(checkbox)
    }
    
    /// 设置复选框数组
    private func setupCheckboxes() {
        // 重新整理所有复选框
        allCheckboxes = [
            sportsCheckbox, musicCheckbox, readingCheckbox, travelCheckbox,
            cameraCheckbox, locationCheckbox, notificationCheckbox, contactsCheckbox,
            autoSaveCheckbox, offlineModeCheckbox, dataCompressionCheckbox
        ]
        
        // 为每个复选框重新设置tag和事件
        for (index, checkbox) in allCheckboxes.enumerated() {
            checkbox.tag = index
            checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        }
    }
    
    /// 设置约束
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 15
        let sectionSpacing: CGFloat = 30
        let checkboxSize: CGFloat = 24
        
        // 兴趣爱好部分
        interestsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        let interestCheckboxes = [sportsCheckbox, musicCheckbox, readingCheckbox, travelCheckbox]
        let interestLabels = ["运动健身", "音乐欣赏", "读书学习", "旅行探索"]
        
        for (index, checkbox) in interestCheckboxes.enumerated() {
            let previousView = index == 0 ? interestsLabel : interestCheckboxes[index - 1]
            
            checkbox.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(spacing)
                make.left.equalToSuperview().offset(margin)
                make.width.height.equalTo(checkboxSize)
            }
            
            // 找到对应的标签
            if let label = contentView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == interestLabels[index] }) {
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(checkbox)
                    make.left.equalTo(checkbox.snp.right).offset(12)
                    make.right.equalToSuperview().inset(margin)
                }
            }
        }
        
        // 权限设置部分
        permissionsLabel.snp.makeConstraints { make in
            make.top.equalTo(travelCheckbox.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        let permissionCheckboxes = [cameraCheckbox, locationCheckbox, notificationCheckbox, contactsCheckbox]
        let permissionLabels = ["允许使用相机", "允许获取位置信息", "允许推送通知", "允许访问通讯录"]
        
        for (index, checkbox) in permissionCheckboxes.enumerated() {
            let previousView = index == 0 ? permissionsLabel : permissionCheckboxes[index - 1]
            
            checkbox.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(spacing)
                make.left.equalToSuperview().offset(margin)
                make.width.height.equalTo(checkboxSize)
            }
            
            if let label = contentView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == permissionLabels[index] }) {
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(checkbox)
                    make.left.equalTo(checkbox.snp.right).offset(12)
                    make.right.equalToSuperview().inset(margin)
                }
            }
        }
        
        // 应用设置部分
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(contactsCheckbox.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        let settingCheckboxes = [autoSaveCheckbox, offlineModeCheckbox, dataCompressionCheckbox]
        let settingLabels = ["自动保存数据", "离线模式", "数据压缩传输"]
        
        for (index, checkbox) in settingCheckboxes.enumerated() {
            let previousView = index == 0 ? settingsLabel : settingCheckboxes[index - 1]
            
            checkbox.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(spacing)
                make.left.equalToSuperview().offset(margin)
                make.width.height.equalTo(checkboxSize)
            }
            
            if let label = contentView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == settingLabels[index] }) {
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(checkbox)
                    make.left.equalTo(checkbox.snp.right).offset(12)
                    make.right.equalToSuperview().inset(margin)
                }
            }
        }
        
        // 全选部分
        selectAllCheckbox.snp.makeConstraints { make in
            make.top.equalTo(dataCompressionCheckbox.snp.bottom).offset(sectionSpacing)
            make.left.equalToSuperview().offset(margin)
            make.width.height.equalTo(checkboxSize)
        }
        
        selectAllLabel.snp.makeConstraints { make in
            make.centerY.equalTo(selectAllCheckbox)
            make.left.equalTo(selectAllCheckbox.snp.right).offset(12)
            make.right.equalToSuperview().inset(margin)
        }
        
        // 结果按钮
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(selectAllCheckbox.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    /// 更新全选状态
    private func updateSelectAllState() {
        let allSelected = allCheckboxes.allSatisfy { $0.isSelected }
        selectAllCheckbox.isSelected = allSelected
    }
    
    // MARK: - Actions
    
    /// 复选框点击
    @objc private func checkboxTapped(_ sender: CustomCheckbox) {
        sender.isSelected.toggle()
        updateSelectAllState()
    }
    
    /// 全选点击
    @objc private func selectAllTapped() {
        selectAllCheckbox.isSelected.toggle()
        
        // 同步所有复选框状态
        for checkbox in allCheckboxes {
            checkbox.isSelected = selectAllCheckbox.isSelected
        }
    }
    
    /// 显示结果
    @objc private func showResults() {
        var selectedItems: [String] = []
        let labels = ["运动健身", "音乐欣赏", "读书学习", "旅行探索",
                     "允许使用相机", "允许获取位置信息", "允许推送通知", "允许访问通讯录",
                     "自动保存数据", "离线模式", "数据压缩传输"]
        
        for (index, checkbox) in allCheckboxes.enumerated() {
            if checkbox.isSelected {
                selectedItems.append(labels[index])
            }
        }
        
        let message = selectedItems.isEmpty ? "您没有选择任何选项" : "您选择了：\n• " + selectedItems.joined(separator: "\n• ")
        
        let alert = UIAlertController(title: "选择结果", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CustomCheckbox

class CustomCheckbox: UIButton {
    
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
        layer.cornerRadius = 4
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