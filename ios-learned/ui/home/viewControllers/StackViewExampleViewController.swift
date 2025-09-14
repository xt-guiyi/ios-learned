//
//  StackViewExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class StackViewExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 动态StackView相关
    private var dynamicStackView: UIStackView!
    private var itemCount = 3
    
    // Tab切换控件相关
    private var customTabView: CustomTabView!
    private var currentTabIndex = 0
    private var tabContentViews: [UIView] = []
    
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
        customNavigationBar.configure(title: "UIStackView") { [weak self] in
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
        var currentY: CGFloat = 20
        
        // 水平StackView示例
        currentY = setupHorizontalStackViewSection(startY: currentY)
        
        // 垂直StackView示例
        currentY = setupVerticalStackViewSection(startY: currentY)
        
        // 嵌套StackView示例
        currentY = setupNestedStackViewSection(startY: currentY)
        
        // 动态StackView示例
        currentY = setupDynamicStackViewSection(startY: currentY)
        
        // Tab切换控件示例
        currentY = setupTabSwitchSection(startY: currentY)
        
        // 设置内容高度
        contentView.snp.makeConstraints { make in
            make.height.equalTo(currentY + 20)
        }
    }
    
    /// 设置水平StackView部分
    private func setupHorizontalStackViewSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("水平布局 (Horizontal)")
        let subtitleLabel = createSectionSubtitle("展示不同分布方式的水平排列")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        var currentY = startY + 60
        
        // 1. Fill Distribution https://blog.csdn.net/u010259906/article/details/120553159
        // 根据compression resistance和hugging两个 priority 布局
        let fillContainer = createExampleContainer(title: "Fill - 填充分布")
        let fillStackView = createHorizontalStackView(distribution: .fill)
        fillStackView.addArrangedSubview(createColorButton(title: "按钮1", color: .systemBlue, width: 60))
        fillStackView.addArrangedSubview(createColorButton(title: "按钮2", color: .systemGreen, width: 60))
        fillStackView.addArrangedSubview(createColorButton(title: "按钮3", color: .systemOrange, width: 60))
        
        fillContainer.addSubview(fillStackView)
        contentView.addSubview(fillContainer)
        
        fillContainer.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        fillStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        currentY += 95
        
        // 2. Fill Equally Distribution
        let fillEquallyContainer = createExampleContainer(title: "Fill Equally - 等比填充")
        let fillEquallyStackView = createHorizontalStackView(distribution: .fillEqually)
        fillEquallyStackView.addArrangedSubview(createColorButton(title: "A", color: .systemRed))
        fillEquallyStackView.addArrangedSubview(createColorButton(title: "B", color: .systemPurple))
        fillEquallyStackView.addArrangedSubview(createColorButton(title: "C", color: .systemTeal))
        
        fillEquallyContainer.addSubview(fillEquallyStackView)
        contentView.addSubview(fillEquallyContainer)
        
        fillEquallyContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(currentY)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        fillEquallyStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        currentY += 95
        
        // 3. Equal Spacing Distribution
        let equalSpacingContainer = createExampleContainer(title: "Equal Spacing - 等间距")
        let equalSpacingStackView = createHorizontalStackView(distribution: .equalSpacing)
        equalSpacingStackView.addArrangedSubview(createColorButton(title: "左", color: .systemIndigo, width: 60))
        equalSpacingStackView.addArrangedSubview(createColorButton(title: "中", color: .systemPink, width: 60))
        equalSpacingStackView.addArrangedSubview(createColorButton(title: "右", color: .systemYellow, width: 60))
        
        equalSpacingContainer.addSubview(equalSpacingStackView)
        contentView.addSubview(equalSpacingContainer)
        
        equalSpacingContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(currentY)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        equalSpacingStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        return currentY + 95
    }
    
    /// 设置垂直StackView部分
    private func setupVerticalStackViewSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("垂直布局 (Vertical)")
        let subtitleLabel = createSectionSubtitle("展示垂直方向的不同对齐方式")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        var currentY = startY + 80
        
        // 垂直StackView容器
        let verticalContainer = createExampleContainer(title: "垂直排列 - 不同对齐方式")
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 10
        
        // Leading对齐
        let leadingStackView = createVerticalStackView(alignment: .leading)
        leadingStackView.addArrangedSubview(createColorLabel(title: "Left", color: .systemBlue, width: 60))
        leadingStackView.addArrangedSubview(createColorLabel(title: "Leading", color: .systemGreen, width: 80))
        leadingStackView.addArrangedSubview(createColorLabel(title: "L", color: .systemRed, width: 40))
        
        // Center对齐
        let centerStackView = createVerticalStackView(alignment: .center)
        centerStackView.addArrangedSubview(createColorLabel(title: "Center", color: .systemOrange, width: 70))
        centerStackView.addArrangedSubview(createColorLabel(title: "中心", color: .systemPurple, width: 50))
        centerStackView.addArrangedSubview(createColorLabel(title: "C", color: .systemTeal, width: 30))
        
        // Trailing对齐
        let trailingStackView = createVerticalStackView(alignment: .trailing)
        trailingStackView.addArrangedSubview(createColorLabel(title: "Right", color: .systemPink, width: 60))
        trailingStackView.addArrangedSubview(createColorLabel(title: "Trailing", color: .systemIndigo, width: 80))
        trailingStackView.addArrangedSubview(createColorLabel(title: "R", color: .systemYellow, width: 40))
        
        mainStackView.addArrangedSubview(leadingStackView)
        mainStackView.addArrangedSubview(centerStackView)
        mainStackView.addArrangedSubview(trailingStackView)
        
        verticalContainer.addSubview(mainStackView)
        contentView.addSubview(verticalContainer)
        
        verticalContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(currentY)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(140)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(100)
        }
        
        return currentY + 155
    }
    
    /// 设置嵌套StackView部分
    private func setupNestedStackViewSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("嵌套布局 (Nested)")
        let subtitleLabel = createSectionSubtitle("组合使用水平和垂直StackView")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let nestedContainer = createExampleContainer(title: "卡片式布局")
        
        // 主垂直StackView
        let mainVerticalStackView = UIStackView()
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.spacing = 10
        mainVerticalStackView.alignment = .fill
        
        // 顶部水平区域
        let topHorizontalStackView = UIStackView()
        topHorizontalStackView.axis = .horizontal
        topHorizontalStackView.spacing = 8
        topHorizontalStackView.alignment = .center
        
        let avatarView = UIView()
        avatarView.backgroundColor = UIColor.systemBlue
        avatarView.layer.cornerRadius = 20
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "用户名"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        
        let timeLabel = UILabel()
        timeLabel.text = "刚刚"
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .secondaryLabel
        
        topHorizontalStackView.addArrangedSubview(avatarView)
        topHorizontalStackView.addArrangedSubview(nameLabel)
        topHorizontalStackView.addArrangedSubview(UIView()) // 占位符
        topHorizontalStackView.addArrangedSubview(timeLabel)
        
        // 内容区域
        let contentLabel = UILabel()
        contentLabel.text = "这是一个使用嵌套StackView创建的卡片布局示例，展示了如何组合不同方向的StackView来创建复杂的界面。"
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0
        
        // 底部操作区域
        let bottomHorizontalStackView = UIStackView()
        bottomHorizontalStackView.axis = .horizontal
        bottomHorizontalStackView.distribution = .fillEqually
        bottomHorizontalStackView.spacing = 10
        
        let likeButton = createActionButton(title: "👍 点赞", color: .systemBlue)
        let commentButton = createActionButton(title: "💬 评论", color: .systemGreen)
        let shareButton = createActionButton(title: "🔗 分享", color: .systemOrange)
        
        bottomHorizontalStackView.addArrangedSubview(likeButton)
        bottomHorizontalStackView.addArrangedSubview(commentButton)
        bottomHorizontalStackView.addArrangedSubview(shareButton)
        
        mainVerticalStackView.addArrangedSubview(topHorizontalStackView)
        mainVerticalStackView.addArrangedSubview(contentLabel)
        mainVerticalStackView.addArrangedSubview(bottomHorizontalStackView)
        
        nestedContainer.addSubview(mainVerticalStackView)
        contentView.addSubview(nestedContainer)
        
        nestedContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 80)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }
        
        mainVerticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        return startY + 260
    }
    
    /// 设置动态StackView部分
    private func setupDynamicStackViewSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("动态操作 (Dynamic)")
        let subtitleLabel = createSectionSubtitle("运行时添加、删除StackView子视图")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let dynamicContainer = createExampleContainer(title: "动态添加/删除")
        
        // 控制按钮区域
        let controlStackView = UIStackView()
        controlStackView.axis = .horizontal
        controlStackView.distribution = .fillEqually
        controlStackView.spacing = 10
        
        let addButton = UIButton()
        addButton.setTitle("+ 添加", for: .normal)
        addButton.backgroundColor = UIColor.systemGreen
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        let removeButton = UIButton()
        removeButton.setTitle("- 删除", for: .normal)
        removeButton.backgroundColor = UIColor.systemRed
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.layer.cornerRadius = 8
        removeButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        
        controlStackView.addArrangedSubview(addButton)
        controlStackView.addArrangedSubview(removeButton)
        
        // 动态内容StackView
        dynamicStackView = UIStackView()
        dynamicStackView.axis = .horizontal
        dynamicStackView.distribution = .fillEqually
        dynamicStackView.spacing = 8
        
        // 添加初始项目
        for i in 1...itemCount {
            let item = createDynamicItem(number: i)
            dynamicStackView.addArrangedSubview(item)
        }
        
        dynamicContainer.addSubview(controlStackView)
        dynamicContainer.addSubview(dynamicStackView)
        contentView.addSubview(dynamicContainer)
        
        dynamicContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 80)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        controlStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(35)
        }
        
        dynamicStackView.snp.makeConstraints { make in
            make.top.equalTo(controlStackView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        return startY + 220
    }
    
    /// 设置Tab切换控件部分
    private func setupTabSwitchSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("Tab切换控件 (Custom Tabs)")
        let subtitleLabel = createSectionSubtitle("使用StackView创建自定义Tab切换控件")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        let tabContainer = createExampleContainer(title: "自定义Tab切换 - 文字+指示器")
        
        // 创建自定义Tab控件
        customTabView = CustomTabView(titles: ["首页", "分类", "我的"])
        customTabView.onTabChanged = { [weak self] index in
            self?.switchToTab(index: index)
        }
        
        // 创建内容视图容器
        let contentContainer = UIView()
        contentContainer.backgroundColor = UIColor.systemBackground
        contentContainer.layer.cornerRadius = 8
        
        // 创建三个内容视图
        let homeView = createTabContentView(title: "首页内容", subtitle: "这里是首页的内容区域", color: .systemBlue)
        let categoryView = createTabContentView(title: "分类内容", subtitle: "这里是分类的内容区域", color: .systemGreen)
        let profileView = createTabContentView(title: "我的内容", subtitle: "这里是个人中心的内容区域", color: .systemOrange)
        
        tabContentViews = [homeView, categoryView, profileView]
        
        // 添加所有内容视图到容器中，初始只显示第一个
        tabContentViews.forEach { contentView in
            contentContainer.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(15)
            }
            contentView.isHidden = true
        }
        tabContentViews[0].isHidden = false // 显示第一个
        
        tabContainer.addSubview(customTabView)
        tabContainer.addSubview(contentContainer)
        contentView.addSubview(tabContainer)
        
        tabContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(startY + 80)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        customTabView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(customTabView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(15)
        }
        
        return startY + 300
    }
    
    /// 切换Tab
    private func switchToTab(index: Int) {
        guard index != currentTabIndex && index < tabContentViews.count else { return }
        
        // 隐藏当前内容
        tabContentViews[currentTabIndex].isHidden = true
        
        // 显示新内容
        tabContentViews[index].isHidden = false
        
        currentTabIndex = index
    }
    
    /// 创建Tab内容视图
    private func createTabContentView(title: String, subtitle: String, color: UIColor) -> UIView {
        let container = UIView()
        
        let iconView = UIView()
        iconView.backgroundColor = color.withAlphaComponent(0.3)
        iconView.layer.cornerRadius = 25
        
        let iconLabel = UILabel()
        iconLabel.text = "📱"
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = color
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        iconView.addSubview(iconLabel)
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        return container
    }
    
    /// 设置约束
    private func setupConstraints() {
        // 约束已在各个setup方法中设置
    }
    
    // MARK: - Helper Methods
    
    /// 创建区域标题
    private func createSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        return label
    }
    
    /// 创建区域副标题
    private func createSectionSubtitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }
    
    /// 创建示例容器
    private func createExampleContainer(title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
        }
        
        return container
    }
    
    /// 创建水平StackView
    private func createHorizontalStackView(distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = distribution
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }
    
    /// 创建垂直StackView
    private func createVerticalStackView(alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = alignment
        stackView.spacing = 8
        return stackView
    }
    
    /// 创建彩色按钮
    private func createColorButton(title: String, color: UIColor, width: CGFloat = 0) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 6
        
        if width > 0 {
            button.snp.makeConstraints { make in
                make.width.equalTo(width)
            }
        }
        
        return button
    }
    
    /// 创建彩色标签
    private func createColorLabel(title: String, color: UIColor, width: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.backgroundColor = color
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        
        label.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        return label
    }
    
    /// 创建操作按钮
    private func createActionButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = color.withAlphaComponent(0.1)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        return button
    }
    
    /// 创建动态项目
    private func createDynamicItem(number: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.themeColor
        container.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = "\(number)"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return container
    }
    
    // MARK: - Actions
    
    /// 添加项目
    @objc private func addItem() {
        itemCount += 1
        let newItem = createDynamicItem(number: itemCount)
        
        UIView.animate(withDuration: 0.3) {
            self.dynamicStackView.addArrangedSubview(newItem)
            self.dynamicStackView.layoutIfNeeded()
        }
    }
    
    /// 删除项目
    @objc private func removeItem() {
        guard itemCount > 1, let lastItem = dynamicStackView.arrangedSubviews.last else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            lastItem.isHidden = true
        }) { _ in
            self.dynamicStackView.removeArrangedSubview(lastItem)
            lastItem.removeFromSuperview()
            self.itemCount -= 1
        }
    }
}

// MARK: - CustomTabView

class CustomTabView: UIView {
    
    private let stackView = UIStackView()
    private var tabButtons: [CustomTabButton] = []
    private var selectedIndex: Int = 0
    
    var onTabChanged: ((Int) -> Void)?
    
    init(titles: [String]) {
        super.init(frame: .zero)
        setupUI(with: titles)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI
    private func setupUI(with titles: [String]) {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 8
        
        // 配置StackView
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建Tab按钮
        for (index, title) in titles.enumerated() {
            let tabButton = CustomTabButton(title: title, isSelected: index == 0)
            tabButton.tag = index
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            tabButton.addGestureRecognizer(tapGesture)
            tabButton.isUserInteractionEnabled = true
            
            tabButtons.append(tabButton)
            stackView.addArrangedSubview(tabButton)
        }
    }
    
    /// Tab点击
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let tabButton = sender.view as? CustomTabButton else { return }
        let tappedIndex = tabButton.tag
        
        if tappedIndex != selectedIndex {
            // 更新选中状态
            tabButtons[selectedIndex].setSelected(false, animated: true)
            tabButtons[tappedIndex].setSelected(true, animated: true)
            
            selectedIndex = tappedIndex
            onTabChanged?(tappedIndex)
        }
    }
}

// MARK: - CustomTabButton

class CustomTabButton: UIView {
    
    private let titleLabel = UILabel()
    private let indicatorView = UIView()
    private let stackView = UIStackView()
    
    private var isSelected: Bool = false
    
    init(title: String, isSelected: Bool = false) {
        super.init(frame: .zero)
        self.isSelected = isSelected
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI
    private func setupUI(title: String) {
        // 配置标题
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = isSelected ? UIColor.themeColor : .secondaryLabel
        
        // 配置指示器
        indicatorView.backgroundColor = UIColor.themeColor
        indicatorView.layer.cornerRadius = 2
        indicatorView.alpha = isSelected ? 1.0 : 0.0
        
        // 配置StackView - 垂直结构：文字在上，指示器在下
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(indicatorView)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(4)
        }
    }
    
    /// 设置选中状态
    func setSelected(_ selected: Bool, animated: Bool = false) {
        isSelected = selected
        
        let updateUI = {
            self.titleLabel.textColor = selected ? UIColor.themeColor : .secondaryLabel
            self.indicatorView.alpha = selected ? 1.0 : 0.0
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: updateUI)
        } else {
            updateUI()
        }
    }
}
