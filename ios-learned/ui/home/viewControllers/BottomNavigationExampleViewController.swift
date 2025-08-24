//
//  BottomNavigationExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class BottomNavigationExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 样式展示区域
    private var style1Container = UIView()
    private var style2Container = UIView()
    private var style3Container = UIView()
    private var style4Container = UIView()
    
    // 当前选中的标签索引
    private var selectedTabIndex1 = 0
    private var selectedTabIndex2 = 0
    private var selectedTabIndex3 = 0
    private var selectedTabIndex4 = 0
    
    // 标签按钮数组
    private var style1Tabs: [UIView] = []
    private var style2Tabs: [UIView] = []
    private var style3Tabs: [UIView] = []
    private var style4Tabs: [UIView] = []
    
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
        customNavigationBar.configure(title: "底部导航栏") { [weak self] in
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
        setupStyle1()
        setupStyle2()
        setupStyle3()
        setupStyle4()
    }
    
    /// 设置样式1 - 简单3标签导航
    private func setupStyle1() {
        let titleLabel = createTitleLabel(text: "导航样式1")
        let subtitleLabel = createSubtitleLabel(text: "简单3标签导航，经典布局")
        
        style1Container = createStyleContainer()
        
        // 创建导航栏
        let navbar1 = createSimpleNavBar()
        style1Container.addSubview(navbar1)
        
        navbar1.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(style1Container)
        
        // 约束设置
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        style1Container.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
    }
    
    /// 设置样式2 - 5标签带悬浮按钮
    private func setupStyle2() {
        let titleLabel = createTitleLabel(text: "导航样式2")
        let subtitleLabel = createSubtitleLabel(text: "5标签布局，中央悬浮按钮")
        
        style2Container = createStyleContainer()
        
        // 创建导航栏
        let navbar2 = createFloatingNavBar()
        style2Container.addSubview(navbar2)
        
        navbar2.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(style2Container)
        
        // 约束设置
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(style1Container.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        style2Container.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
    }
    
    /// 设置样式3 - 圆形悬浮按钮变体
    private func setupStyle3() {
        let titleLabel = createTitleLabel(text: "导航样式3")
        let subtitleLabel = createSubtitleLabel(text: "圆形悬浮按钮，更突出的中心操作")
        
        style3Container = createStyleContainer()
        
        // 创建导航栏
        let navbar3 = createCircularFloatingNavBar()
        style3Container.addSubview(navbar3)
        
        navbar3.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(style3Container)
        
        // 约束设置
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(style2Container.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        style3Container.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
    }
    
    /// 设置样式4 - 增强悬浮按钮
    private func setupStyle4() {
        let titleLabel = createTitleLabel(text: "导航样式4")
        let subtitleLabel = createSubtitleLabel(text: "增强悬浮按钮，带阴影效果")
        
        style4Container = createStyleContainer()
        
        // 创建导航栏
        let navbar4 = createEnhancedFloatingNavBar()
        style4Container.addSubview(navbar4)
        
        navbar4.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(style4Container)
        
        // 约束设置
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(style3Container.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        style4Container.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 设置约束
    private func setupConstraints() {
        // 约束已在各个setup方法中设置
    }
    
    // MARK: - Helper Methods
    
    /// 创建标题标签
    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        return label
    }
    
    /// 创建副标题标签
    private func createSubtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }
    
    /// 创建样式容器
    private func createStyleContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        return container
    }
    
    /// 创建简单导航栏（样式1）
    private func createSimpleNavBar() -> UIView {
        let navBar = UIView()
        navBar.backgroundColor = .systemBackground
        navBar.layer.cornerRadius = 8
        navBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // 分割线
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        navBar.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        // 创建3个标签
        let homeTab = createTabButton(icon: "🏠", title: "控件", isSelected: true, style: 1, index: 0)
        let advancedTab = createTabButton(icon: "🛠", title: "进阶", isSelected: false, style: 1, index: 1)
        let libraryTab = createTabButton(icon: "👤", title: "案例库", isSelected: false, style: 1, index: 2)
        
        style1Tabs = [homeTab, advancedTab, libraryTab]
        
        navBar.addSubview(homeTab)
        navBar.addSubview(advancedTab)
        navBar.addSubview(libraryTab)
        
        homeTab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        
        advancedTab.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(60)
        }
        
        libraryTab.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        
        return navBar
    }
    
    /// 创建悬浮导航栏（样式2）
    private func createFloatingNavBar() -> UIView {
        let navBar = UIView()
        navBar.backgroundColor = .systemBackground
        navBar.layer.cornerRadius = 8
        navBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // 分割线
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        navBar.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        // 创建4个标签
        let homeTab = createTabButton(icon: "🏠", title: "控件", isSelected: true, style: 2, index: 0)
        let fileTab = createTabButton(icon: "📄", title: "文件", isSelected: false, style: 2, index: 1)
        let shareTab = createTabButton(icon: "✈️", title: "共享", isSelected: false, style: 2, index: 2)
        let libraryTab = createTabButton(icon: "👤", title: "案例库", isSelected: false, style: 2, index: 3)
        
        style2Tabs = [homeTab, fileTab, shareTab, libraryTab]
        
        // 悬浮按钮
        let floatingButton = UIButton()
        floatingButton.backgroundColor = UIColor.systemPink
        floatingButton.setTitle("+", for: .normal)
        floatingButton.setTitleColor(.white, for: .normal)
        floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        floatingButton.layer.cornerRadius = 25
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        navBar.addSubview(homeTab)
        navBar.addSubview(fileTab)
        navBar.addSubview(floatingButton)
        navBar.addSubview(shareTab)
        navBar.addSubview(libraryTab)
        
        homeTab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        fileTab.snp.makeConstraints { make in
            make.left.equalTo(homeTab.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        shareTab.snp.makeConstraints { make in
            make.right.equalTo(libraryTab.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        libraryTab.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        return navBar
    }
    
    /// 创建圆形悬浮导航栏（样式3）
    private func createCircularFloatingNavBar() -> UIView {
        let navBar = UIView()
        navBar.backgroundColor = .systemBackground
        navBar.layer.cornerRadius = 8
        navBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // 分割线
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        navBar.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        // 创建4个标签
        let homeTab = createTabButton(icon: "🏠", title: "控件", isSelected: true, style: 3, index: 0)
        let fileTab = createTabButton(icon: "📄", title: "文件", isSelected: false, style: 3, index: 1)
        let shareTab = createTabButton(icon: "✈️", title: "共享", isSelected: false, style: 3, index: 2)
        let libraryTab = createTabButton(icon: "👤", title: "案例库", isSelected: false, style: 3, index: 3)
        
        style3Tabs = [homeTab, fileTab, shareTab, libraryTab]
        
        // 大圆形悬浮按钮
        let floatingButton = UIButton()
        floatingButton.backgroundColor = UIColor.systemPink
        floatingButton.setTitle("+", for: .normal)
        floatingButton.setTitleColor(.white, for: .normal)
        floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        floatingButton.layer.cornerRadius = 30
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        navBar.addSubview(homeTab)
        navBar.addSubview(fileTab)
        navBar.addSubview(floatingButton)
        navBar.addSubview(shareTab)
        navBar.addSubview(libraryTab)
        
        homeTab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        fileTab.snp.makeConstraints { make in
            make.left.equalTo(homeTab.snp.right).offset(25)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        shareTab.snp.makeConstraints { make in
            make.right.equalTo(libraryTab.snp.left).offset(-25)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        libraryTab.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        return navBar
    }
    
    /// 创建增强悬浮导航栏（样式4）
    private func createEnhancedFloatingNavBar() -> UIView {
        let navBar = UIView()
        navBar.backgroundColor = .systemBackground
        navBar.layer.cornerRadius = 8
        navBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // 分割线
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        navBar.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        // 创建4个标签
        let homeTab = createTabButton(icon: "🏠", title: "控件", isSelected: true, style: 4, index: 0)
        let fileTab = createTabButton(icon: "📄", title: "文件", isSelected: false, style: 4, index: 1)
        let shareTab = createTabButton(icon: "✈️", title: "共享", isSelected: false, style: 4, index: 2)
        let libraryTab = createTabButton(icon: "👤", title: "案例库", isSelected: false, style: 4, index: 3)
        
        style4Tabs = [homeTab, fileTab, shareTab, libraryTab]
        
        // 增强悬浮按钮（带阴影）
        let floatingButton = UIButton()
        floatingButton.backgroundColor = UIColor.systemPink
        floatingButton.setTitle("+", for: .normal)
        floatingButton.setTitleColor(.white, for: .normal)
        floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        floatingButton.layer.cornerRadius = 30
        
        // 添加阴影效果
        floatingButton.layer.shadowColor = UIColor.systemPink.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingButton.layer.shadowRadius = 8
        floatingButton.layer.shadowOpacity = 0.3
        
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        navBar.addSubview(homeTab)
        navBar.addSubview(fileTab)
        navBar.addSubview(floatingButton)
        navBar.addSubview(shareTab)
        navBar.addSubview(libraryTab)
        
        homeTab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        fileTab.snp.makeConstraints { make in
            make.left.equalTo(homeTab.snp.right).offset(25)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        shareTab.snp.makeConstraints { make in
            make.right.equalTo(libraryTab.snp.left).offset(-25)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        libraryTab.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        return navBar
    }
    
    /// 创建标签按钮
    private func createTabButton(icon: String, title: String, isSelected: Bool, style: Int, index: Int) -> UIView {
        let container = UIView()
        container.tag = index
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 18)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textAlignment = .center
        titleLabel.textColor = isSelected ? UIColor.themeColor : .secondaryLabel
        titleLabel.tag = 100 // 用于更新颜色
        
        container.addSubview(iconLabel)
        container.addSubview(titleLabel)
        
        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        // 存储样式信息
        container.accessibilityIdentifier = "\(style)"
        
        return container
    }
    
    // MARK: - Actions
    
    /// 标签点击
    @objc private func tabTapped(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view,
              let styleString = container.accessibilityIdentifier,
              let style = Int(styleString) else { return }
        
        let tappedIndex = container.tag
        
        switch style {
        case 1:
            if selectedTabIndex1 != tappedIndex {
                updateTabSelection(for: style1Tabs, selectedIndex: tappedIndex)
                selectedTabIndex1 = tappedIndex
                showTabChangeMessage(style: 1, index: tappedIndex)
            }
        case 2:
            if selectedTabIndex2 != tappedIndex {
                updateTabSelection(for: style2Tabs, selectedIndex: tappedIndex)
                selectedTabIndex2 = tappedIndex
                showTabChangeMessage(style: 2, index: tappedIndex)
            }
        case 3:
            if selectedTabIndex3 != tappedIndex {
                updateTabSelection(for: style3Tabs, selectedIndex: tappedIndex)
                selectedTabIndex3 = tappedIndex
                showTabChangeMessage(style: 3, index: tappedIndex)
            }
        case 4:
            if selectedTabIndex4 != tappedIndex {
                updateTabSelection(for: style4Tabs, selectedIndex: tappedIndex)
                selectedTabIndex4 = tappedIndex
                showTabChangeMessage(style: 4, index: tappedIndex)
            }
        default:
            break
        }
    }
    
    /// 更新标签选中状态
    private func updateTabSelection(for tabs: [UIView], selectedIndex: Int) {
        for (index, tab) in tabs.enumerated() {
            if let titleLabel = tab.subviews.first(where: { $0.tag == 100 }) as? UILabel {
                titleLabel.textColor = index == selectedIndex ? UIColor.themeColor : .secondaryLabel
            }
        }
    }
    
    /// 显示标签切换消息
    private func showTabChangeMessage(style: Int, index: Int) {
        let tabNames = [
            ["控件", "进阶", "案例库"], // Style 1
            ["控件", "文件", "共享", "案例库"], // Style 2
            ["控件", "文件", "共享", "案例库"], // Style 3
            ["控件", "文件", "共享", "案例库"]  // Style 4
        ]
        
        if style <= tabNames.count && index < tabNames[style - 1].count {
            let tabName = tabNames[style - 1][index]
            let message = "样式\(style) - 切换到：\(tabName)"
            
            // 创建简单的提示视图
            let alertView = UIView()
            alertView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            alertView.layer.cornerRadius = 8
            
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .white
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabel.textAlignment = .center
            
            alertView.addSubview(messageLabel)
            view.addSubview(alertView)
            
            messageLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(12)
            }
            
            alertView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(40)
                make.width.greaterThanOrEqualTo(120)
            }
            
            // 动画显示和隐藏
            alertView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                alertView.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.3) {
                    alertView.alpha = 0
                } completion: { _ in
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    
    /// 悬浮按钮点击
    @objc private func floatingButtonTapped() {
        let alert = UIAlertController(title: "悬浮按钮", message: "您点击了中央悬浮按钮！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}