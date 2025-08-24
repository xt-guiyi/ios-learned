//
//  ContextMenuExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class ContextMenuExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 示例数据
    private var menuItems: [ContextMenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        setupNavigationBar()
        setupScrollView()
        setupContent()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "上下文菜单") { [weak self] in
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
        
        // 基础上下文菜单
        currentY = setupBasicContextMenuSection(startY: currentY)
        
        // 带图标的上下文菜单
        currentY = setupIconContextMenuSection(startY: currentY)
        
        // 带子菜单的上下文菜单
        currentY = setupNestedContextMenuSection(startY: currentY)
        
        // 带预览的上下文菜单
        currentY = setupPreviewContextMenuSection(startY: currentY)
        
        // 列表中的上下文菜单
        currentY = setupListContextMenuSection(startY: currentY)
        
        // 自定义弹窗菜单
        currentY = setupCustomPopoverSection(startY: currentY)
        
        // 设置内容高度
        contentView.snp.makeConstraints { make in
            make.height.equalTo(currentY + 20)
        }
    }
    
    /// 设置数据
    private func setupData() {
        menuItems = [
            ContextMenuItem(title: "收藏文章", subtitle: "添加到我的收藏", type: .favorite),
            ContextMenuItem(title: "分享链接", subtitle: "分享给朋友", type: .share),
            ContextMenuItem(title: "复制内容", subtitle: "复制到剪贴板", type: .copy),
            ContextMenuItem(title: "编辑信息", subtitle: "修改详细信息", type: .edit),
            ContextMenuItem(title: "删除项目", subtitle: "永久删除此项", type: .delete)
        ]
    }
    
    /// 设置基础上下文菜单部分
    private func setupBasicContextMenuSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("基础上下文菜单")
        let subtitleLabel = createSectionSubtitle("长按显示基础的上下文菜单选项")
        
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
        
        // 基础按钮
        let basicButton = createContextButton(
            title: "基础菜单",
            subtitle: "长按显示简单的上下文菜单",
            color: .systemBlue
        )
        
        // 添加上下文菜单
        let basicInteraction = UIContextMenuInteraction(delegate: self)
        basicButton.addInteraction(basicInteraction)
        basicButton.tag = 1
        
        contentView.addSubview(basicButton)
        
        basicButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        return startY + 140
    }
    
    /// 设置带图标的上下文菜单部分
    private func setupIconContextMenuSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("带图标的上下文菜单")
        let subtitleLabel = createSectionSubtitle("包含图标和状态的上下文菜单")
        
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
        
        let iconButton = createContextButton(
            title: "图标菜单",
            subtitle: "长按显示带图标的菜单选项",
            color: .systemGreen
        )
        
        let iconInteraction = UIContextMenuInteraction(delegate: self)
        iconButton.addInteraction(iconInteraction)
        iconButton.tag = 2
        
        contentView.addSubview(iconButton)
        
        iconButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        return startY + 140
    }
    
    /// 设置嵌套上下文菜单部分
    private func setupNestedContextMenuSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("嵌套子菜单")
        let subtitleLabel = createSectionSubtitle("包含子菜单的多层级上下文菜单")
        
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
        
        let nestedButton = createContextButton(
            title: "嵌套菜单",
            subtitle: "长按显示包含子菜单的选项",
            color: .systemOrange
        )
        
        let nestedInteraction = UIContextMenuInteraction(delegate: self)
        nestedButton.addInteraction(nestedInteraction)
        nestedButton.tag = 3
        
        contentView.addSubview(nestedButton)
        
        nestedButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        return startY + 140
    }
    
    /// 设置带预览的上下文菜单部分
    private func setupPreviewContextMenuSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("带预览的上下文菜单")
        let subtitleLabel = createSectionSubtitle("显示预览视图的上下文菜单")
        
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
        
        let previewButton = createContextButton(
            title: "预览菜单",
            subtitle: "长按显示预览视图和菜单",
            color: .systemPurple
        )
        
        let previewInteraction = UIContextMenuInteraction(delegate: self)
        previewButton.addInteraction(previewInteraction)
        previewButton.tag = 4
        
        contentView.addSubview(previewButton)
        
        previewButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        return startY + 140
    }
    
    /// 设置列表中的上下文菜单部分
    private func setupListContextMenuSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("列表项上下文菜单")
        let subtitleLabel = createSectionSubtitle("在列表项中使用上下文菜单")
        
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
        
        // 创建列表项
        for (index, item) in menuItems.enumerated() {
            let listItem = createListItem(item: item, index: index)
            contentView.addSubview(listItem)
            
            listItem.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(currentY)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(60)
            }
            
            currentY += 65
        }
        
        return currentY
    }
    
    /// 设置自定义弹窗菜单部分
    private func setupCustomPopoverSection(startY: CGFloat) -> CGFloat {
        let titleLabel = createSectionTitle("自定义弹窗菜单")
        let subtitleLabel = createSectionSubtitle("搜索建议弹窗和操作弹窗示例")
        
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
        
        // 搜索输入框 + 搜索建议弹窗
        let searchContainer = createExampleContainer(title: "搜索建议弹窗")
        let searchTextField = createSearchTextField()
        
        searchContainer.addSubview(searchTextField)
        contentView.addSubview(searchContainer)
        
        searchContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(currentY)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        currentY += 120
        
        // 更多操作按钮 + 操作弹窗
        let actionContainer = createExampleContainer(title: "操作项弹窗")
        let moreActionButton = createMoreActionButton()
        
        actionContainer.addSubview(moreActionButton)
        contentView.addSubview(actionContainer)
        
        actionContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(currentY)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        moreActionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        
        currentY += 120
        
        // 自定义样式弹窗按钮
        let customStyleContainer = createExampleContainer(title: "自定义样式弹窗")
        let customStyleButton = createCustomStyleButton()
        
        customStyleContainer.addSubview(customStyleButton)
        contentView.addSubview(customStyleContainer)
        
        customStyleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(currentY)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        customStyleButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        
        return currentY + 120
    }
    
    /// 创建搜索输入框
    private func createSearchTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "输入搜索内容..."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        
        // 添加搜索图标
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .systemGray
        searchIcon.contentMode = .scaleAspectFit
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        searchIcon.frame = CGRect(x: 10, y: 0, width: 15, height: 20)
        leftView.addSubview(searchIcon)
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(searchTextFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(searchTextFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        return textField
    }
    
    /// 创建更多操作按钮
    private func createMoreActionButton() -> UIButton {
        let button = UIButton()
        button.setTitle("更多操作", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(moreActionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    /// 创建自定义样式按钮
    private func createCustomStyleButton() -> UIButton {
        let button = UIButton()
        button.setTitle("自定义弹窗", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemPurple
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(customStyleButtonTapped(_:)), for: .touchUpInside)
        
        return button
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
    
    /// 创建上下文菜单按钮
    private func createContextButton(title: String, subtitle: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = color.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        container.layer.borderWidth = 1
        container.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        
        let iconView = UIView()
        iconView.backgroundColor = color
        iconView.layer.cornerRadius = 20
        
        let iconLabel = UILabel()
        iconLabel.text = "📱"
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = color
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        
        iconView.addSubview(iconLabel)
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(iconView.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(iconView.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualToSuperview().inset(15)
        }
        
        return container
    }
    
    /// 创建列表项
    private func createListItem(item: ContextMenuItem, index: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 8
        container.tag = 100 + index // 用于区分不同的列表项
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        
        let iconLabel = UILabel()
        iconLabel.text = item.type.icon
        iconLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 添加上下文菜单交互
        let interaction = UIContextMenuInteraction(delegate: self)
        container.addInteraction(interaction)
        
        container.addSubview(iconLabel)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        
        iconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(iconLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.equalTo(iconLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }
        
        return container
    }
    
    /// 显示操作结果
    private func showActionResult(action: String, item: String = "") {
        let message = item.isEmpty ? "执行了：\(action)" : "对「\(item)」执行了：\(action)"
        
        let alert = UIAlertController(title: "操作完成", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Custom Popover Actions
    
    /// 搜索文本改变
    @objc private func searchTextChanged(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            dismissSearchSuggestions()
            return
        }
        
        showSearchSuggestions(for: text, from: textField)
    }
    
    /// 搜索开始编辑
    @objc private func searchTextFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            showSearchSuggestions(for: text, from: textField)
        }
    }
    
    /// 搜索结束编辑
    @objc private func searchTextFieldDidEndEditing(_ textField: UITextField) {
        // 延迟关闭，允许用户点击建议项
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismissSearchSuggestions()
        }
    }
    
    /// 显示搜索建议
    private func showSearchSuggestions(for text: String, from textField: UITextField) {
        let suggestions = generateSearchSuggestions(for: text)
        
        let suggestionViewController = SearchSuggestionViewController(suggestions: suggestions) { [weak self] selectedSuggestion in
            textField.text = selectedSuggestion
            self?.dismissSearchSuggestions()
            self?.showActionResult(action: "选择搜索建议", item: selectedSuggestion)
        }
        
        suggestionViewController.modalPresentationStyle = .popover
        suggestionViewController.preferredContentSize = CGSize(width: textField.bounds.width, height: CGFloat(min(suggestions.count * 44, 200)))
        
        if let popover = suggestionViewController.popoverPresentationController {
            popover.sourceView = textField
            popover.sourceRect = CGRect(x: 0, y: textField.bounds.height, width: textField.bounds.width, height: 0)
            popover.permittedArrowDirections = .up
            popover.delegate = self
        }
        
        present(suggestionViewController, animated: true)
    }
    
    /// 关闭搜索建议
    private func dismissSearchSuggestions() {
        if let presentedVC = presentedViewController as? SearchSuggestionViewController {
            presentedVC.dismiss(animated: true)
        }
    }
    
    /// 生成搜索建议
    private func generateSearchSuggestions(for text: String) -> [String] {
        let allSuggestions = [
            "苹果", "苹果手机", "苹果电脑", "苹果平板",
            "安卓", "安卓系统", "安卓开发", "安卓应用",
            "iOS", "iOS开发", "iOS应用", "iOS系统",
            "Swift", "Swift语言", "SwiftUI", "Swift开发",
            "Xcode", "Xcode工具", "Xcode调试", "Xcode模拟器"
        ]
        
        return allSuggestions.filter { $0.localizedCaseInsensitiveContains(text) }
    }
    
    /// 更多操作按钮点击
    @objc private func moreActionButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "选择操作", message: "请选择要执行的操作", preferredStyle: .actionSheet)
        
        let copyAction = UIAlertAction(title: "📋 复制内容", style: .default) { _ in
            self.showActionResult(action: "复制内容")
        }
        
        let shareAction = UIAlertAction(title: "📤 分享内容", style: .default) { _ in
            self.showActionResult(action: "分享内容")
        }
        
        let editAction = UIAlertAction(title: "✏️ 编辑内容", style: .default) { _ in
            self.showActionResult(action: "编辑内容")
        }
        
        let favoriteAction = UIAlertAction(title: "❤️ 添加收藏", style: .default) { _ in
            self.showActionResult(action: "添加收藏")
        }
        
        let deleteAction = UIAlertAction(title: "🗑️ 删除内容", style: .destructive) { _ in
            self.showActionResult(action: "删除内容")
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        actionSheet.addAction(copyAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(favoriteAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        // iPad支持
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .any
        }
        
        present(actionSheet, animated: true)
    }
    
    /// 自定义样式按钮点击
    @objc private func customStyleButtonTapped(_ sender: UIButton) {
        let customPopoverVC = CustomPopoverViewController()
        customPopoverVC.onActionSelected = { [weak self] action in
            self?.showActionResult(action: action)
        }
        
        customPopoverVC.modalPresentationStyle = .popover
        customPopoverVC.preferredContentSize = CGSize(width: 250, height: 300)
        
        if let popover = customPopoverVC.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .up
            popover.delegate = self
            popover.backgroundColor = UIColor.systemBackground
        }
        
        present(customPopoverVC, animated: true)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension ContextMenuExampleViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 确保在iPhone上也显示为popover
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension ContextMenuExampleViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let view = interaction.view else { return nil }
        
        let tag = view.tag
        
        switch tag {
        case 1: // 基础菜单
            return createBasicMenuConfiguration()
        case 2: // 图标菜单
            return createIconMenuConfiguration()
        case 3: // 嵌套菜单
            return createNestedMenuConfiguration()
        case 4: // 预览菜单
            return createPreviewMenuConfiguration()
        case 100..<200: // 列表项菜单
            let itemIndex = tag - 100
            return createListItemMenuConfiguration(for: itemIndex)
        default:
            return nil
        }
    }
    
    /// 创建基础菜单配置
    private func createBasicMenuConfiguration() -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let copyAction = UIAction(title: "复制", image: UIImage(systemName: "doc.on.doc")) { _ in
                self.showActionResult(action: "复制")
            }
            
            let shareAction = UIAction(title: "分享", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.showActionResult(action: "分享")
            }
            
            let deleteAction = UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.showActionResult(action: "删除")
            }
            
            return UIMenu(title: "", children: [copyAction, shareAction, deleteAction])
        }
    }
    
    /// 创建图标菜单配置
    private func createIconMenuConfiguration() -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let favoriteAction = UIAction(title: "收藏", image: UIImage(systemName: "heart")) { _ in
                self.showActionResult(action: "收藏")
            }
            
            let editAction = UIAction(title: "编辑", image: UIImage(systemName: "pencil")) { _ in
                self.showActionResult(action: "编辑")
            }
            
            let infoAction = UIAction(title: "详情", image: UIImage(systemName: "info.circle")) { _ in
                self.showActionResult(action: "查看详情")
            }
            
            let archiveAction = UIAction(title: "归档", image: UIImage(systemName: "archivebox")) { _ in
                self.showActionResult(action: "归档")
            }
            
            return UIMenu(title: "选择操作", children: [favoriteAction, editAction, infoAction, archiveAction])
        }
    }
    
    /// 创建嵌套菜单配置
    private func createNestedMenuConfiguration() -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            // 分享子菜单
            let shareToFriends = UIAction(title: "分享给朋友", image: UIImage(systemName: "person.2")) { _ in
                self.showActionResult(action: "分享给朋友")
            }
            let shareToSocial = UIAction(title: "分享到社交媒体", image: UIImage(systemName: "network")) { _ in
                self.showActionResult(action: "分享到社交媒体")
            }
            let copyLink = UIAction(title: "复制链接", image: UIImage(systemName: "link")) { _ in
                self.showActionResult(action: "复制链接")
            }
            let shareMenu = UIMenu(title: "分享选项", image: UIImage(systemName: "square.and.arrow.up"), children: [shareToFriends, shareToSocial, copyLink])
            
            // 编辑子菜单
            let rename = UIAction(title: "重命名", image: UIImage(systemName: "character.cursor.ibeam")) { _ in
                self.showActionResult(action: "重命名")
            }
            let duplicate = UIAction(title: "复制副本", image: UIImage(systemName: "plus.square.on.square")) { _ in
                self.showActionResult(action: "复制副本")
            }
            let move = UIAction(title: "移动", image: UIImage(systemName: "folder")) { _ in
                self.showActionResult(action: "移动")
            }
            let editMenu = UIMenu(title: "编辑选项", image: UIImage(systemName: "pencil.circle"), children: [rename, duplicate, move])
            
            let deleteAction = UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.showActionResult(action: "删除")
            }
            
            return UIMenu(title: "操作菜单", children: [shareMenu, editMenu, deleteAction])
        }
    }
    
    /// 创建预览菜单配置
    private func createPreviewMenuConfiguration() -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                // 创建预览视图
                let previewVC = UIViewController()
                previewVC.view.backgroundColor = UIColor.systemBackground
                
                let containerView = UIView()
                containerView.backgroundColor = UIColor.systemGray6
                containerView.layer.cornerRadius = 12
                
                let titleLabel = UILabel()
                titleLabel.text = "预览内容"
                titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
                titleLabel.textAlignment = .center
                
                let contentLabel = UILabel()
                contentLabel.text = "这是一个预览视图的示例内容。\n您可以在这里显示详细信息，\n然后通过上下文菜单执行相关操作。"
                contentLabel.font = UIFont.systemFont(ofSize: 16)
                contentLabel.textAlignment = .center
                contentLabel.numberOfLines = 0
                contentLabel.textColor = .secondaryLabel
                
                let imageView = UIImageView()
                imageView.backgroundColor = UIColor.themeColor.withAlphaComponent(0.3)
                imageView.layer.cornerRadius = 8
                imageView.contentMode = .center
                
                let emojiLabel = UILabel()
                emojiLabel.text = "🔍"
                emojiLabel.font = UIFont.systemFont(ofSize: 40)
                emojiLabel.textAlignment = .center
                
                previewVC.view.addSubview(containerView)
                containerView.addSubview(imageView)
                imageView.addSubview(emojiLabel)
                containerView.addSubview(titleLabel)
                containerView.addSubview(contentLabel)
                
                containerView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.equalTo(280)
                    make.height.equalTo(200)
                }
                
                imageView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(20)
                    make.centerX.equalToSuperview()
                    make.width.height.equalTo(60)
                }
                
                emojiLabel.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                
                titleLabel.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom).offset(15)
                    make.left.right.equalToSuperview().inset(20)
                }
                
                contentLabel.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(10)
                    make.left.right.equalToSuperview().inset(20)
                    make.bottom.lessThanOrEqualToSuperview().inset(20)
                }
                
                previewVC.preferredContentSize = CGSize(width: 280, height: 200)
                return previewVC
            }
        ) { _ in
            let openAction = UIAction(title: "打开", image: UIImage(systemName: "doc.text.magnifyingglass")) { _ in
                self.showActionResult(action: "打开预览内容")
            }
            
            let quickLookAction = UIAction(title: "快速查看", image: UIImage(systemName: "eye")) { _ in
                self.showActionResult(action: "快速查看")
            }
            
            let saveAction = UIAction(title: "保存", image: UIImage(systemName: "square.and.arrow.down")) { _ in
                self.showActionResult(action: "保存")
            }
            
            return UIMenu(title: "", children: [openAction, quickLookAction, saveAction])
        }
    }
    
    /// 创建列表项菜单配置
    private func createListItemMenuConfiguration(for index: Int) -> UIContextMenuConfiguration {
        let item = menuItems[index]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let primaryAction = UIAction(title: item.type.actionTitle, image: UIImage(systemName: item.type.systemImage)) { _ in
                self.showActionResult(action: item.type.actionTitle, item: item.title)
            }
            
            let editAction = UIAction(title: "编辑", image: UIImage(systemName: "pencil")) { _ in
                self.showActionResult(action: "编辑", item: item.title)
            }
            
            let moreAction = UIAction(title: "更多信息", image: UIImage(systemName: "info.circle")) { _ in
                self.showActionResult(action: "查看更多信息", item: item.title)
            }
            
            let deleteAction = UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.showActionResult(action: "删除", item: item.title)
            }
            
            return UIMenu(title: item.title, children: [primaryAction, editAction, moreAction, deleteAction])
        }
    }
}

// MARK: - Data Models

struct ContextMenuItem {
    let title: String
    let subtitle: String
    let type: ContextMenuType
}

enum ContextMenuType {
    case favorite
    case share
    case copy
    case edit
    case delete
    
    var icon: String {
        switch self {
        case .favorite: return "❤️"
        case .share: return "📤"
        case .copy: return "📋"
        case .edit: return "✏️"
        case .delete: return "🗑️"
        }
    }
    
    var actionTitle: String {
        switch self {
        case .favorite: return "收藏"
        case .share: return "分享"
        case .copy: return "复制"
        case .edit: return "编辑"
        case .delete: return "删除"
        }
    }
    
    var systemImage: String {
        switch self {
        case .favorite: return "heart"
        case .share: return "square.and.arrow.up"
        case .copy: return "doc.on.doc"
        case .edit: return "pencil"
        case .delete: return "trash"
        }
    }
}

// MARK: - SearchSuggestionViewController

class SearchSuggestionViewController: UIViewController {
    
    private let tableView = UITableView()
    private let suggestions: [String]
    private let onSuggestionSelected: (String) -> Void
    
    init(suggestions: [String], onSuggestionSelected: @escaping (String) -> Void) {
        self.suggestions = suggestions
        self.onSuggestionSelected = onSuggestionSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchSuggestionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.accessoryType = .none
        cell.backgroundColor = .systemBackground
        
        // 添加搜索图标
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.tintColor = .systemGray
        iconImageView.contentMode = .scaleAspectFit
        cell.imageView?.image = iconImageView.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSuggestion = suggestions[indexPath.row]
        onSuggestionSelected(selectedSuggestion)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - CustomPopoverViewController

class CustomPopoverViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    var onActionSelected: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupContent()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupContent() {
        // 头部标题
        let titleLabel = UILabel()
        titleLabel.text = "快捷操作"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        // 分割线
        let separator = UIView()
        separator.backgroundColor = .separator
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        // 操作按钮
        let actions = [
            ("🔍", "搜索相关", "搜索相关内容"),
            ("📊", "数据统计", "查看数据统计"),
            ("⚙️", "设置选项", "打开设置选项"),
            ("🎨", "主题切换", "切换应用主题"),
            ("📱", "设备信息", "查看设备信息"),
            ("🔔", "通知设置", "配置通知设置")
        ]
        
        var currentY: CGFloat = 0
        
        for (index, action) in actions.enumerated() {
            let button = createActionButton(
                icon: action.0,
                title: action.1,
                subtitle: action.2,
                tag: index
            )
            
            contentView.addSubview(button)
            
            let topOffset = index == 0 ? 20 : 8
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(separator.snp.bottom).offset(topOffset)
                } else {
                    make.top.equalTo(contentView.subviews[contentView.subviews.count - 2].snp.bottom).offset(topOffset)
                }
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(50)
            }
            
            currentY += 58
        }
        
        // 设置内容高度
        contentView.snp.makeConstraints { make in
            make.height.equalTo(currentY + 80)
        }
    }
    
    private func createActionButton(icon: String, title: String, subtitle: String, tag: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 8
        container.tag = tag
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        
        let arrowLabel = UILabel()
        arrowLabel.text = "›"
        arrowLabel.font = UIFont.systemFont(ofSize: 20)
        arrowLabel.textColor = .systemGray2
        arrowLabel.textAlignment = .center
        
        container.addSubview(iconLabel)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(arrowLabel)
        
        iconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(iconLabel.snp.right).offset(12)
            make.right.equalTo(arrowLabel.snp.left).offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.left.equalTo(iconLabel.snp.right).offset(12)
            make.right.equalTo(arrowLabel.snp.left).offset(-8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        arrowLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionButtonTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    @objc private func actionButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view else { return }
        let tag = container.tag
        
        let actions = ["搜索相关内容", "查看数据统计", "打开设置选项", "切换应用主题", "查看设备信息", "配置通知设置"]
        
        if tag < actions.count {
            dismiss(animated: true) {
                self.onActionSelected?(actions[tag])
            }
        }
    }
}