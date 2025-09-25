//
//  WindowManagerViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/9/21.
//

import UIKit
import SnapKit

/// 窗口管理页面
/// 用于控制应用级别悬浮球的显示、隐藏和各种设置
class WindowManagerViewController: BaseViewController {

    // MARK: - Properties

    /// 滚动视图容器
    private let scrollView = UIScrollView()
    /// 内容容器视图
    private let contentView = UIView()
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()

    /// 状态信息标签引用
    private var statusInfoLabel: UILabel?
    /// 自动刷新定时器
    private var refreshTimer: Timer?

    /// 悬浮球管理器
    private let floatingBallManager = FloatingBallManager.shared

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFloatingBallCallbacks()
        startAutoRefresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoRefresh()
    }

    deinit {
        stopAutoRefresh()
    }

    // MARK: - UI Setup Methods

    /// 初始化UI界面
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        setupNavigationBar()
        setupScrollView()
        setupFloatingBallSections()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "窗口管理") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置滚动视图
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    /// 设置悬浮球功能区域
    private func setupFloatingBallSections() {
        var previousView: UIView = contentView

        // 1. 基础控制区域
        let basicControlSection = createBasicControlSection()
        contentView.addSubview(basicControlSection)
        basicControlSection.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = basicControlSection

        // 2. 外观设置区域
        let appearanceSection = createAppearanceControlSection()
        contentView.addSubview(appearanceSection)
        appearanceSection.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = appearanceSection

        // 3. 行为设置区域
        let behaviorSection = createBehaviorControlSection()
        contentView.addSubview(behaviorSection)
        behaviorSection.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = behaviorSection

        // 4. 状态信息显示区域
        let statusSection = createStatusInfoSection()
        contentView.addSubview(statusSection)
        statusSection.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Section Creation Methods

    /// 创建基础控制区域
    /// - Returns: 包含基础控制按钮的容器视图
    private func createBasicControlSection() -> UIView {
        let containerView = createSectionContainer()

        let titleLabel = createSectionTitle("基础控制")
        let descLabel = createSectionDescription("控制悬浮球的显示和隐藏")

        let showButton = createStyledButton(title: "显示悬浮球", style: .primary) { [weak self] in
            self?.showFloatingBall()
        }

        let hideButton = createStyledButton(title: "隐藏悬浮球", style: .danger) { [weak self] in
            self?.hideFloatingBall()
        }

        let resetPositionButton = createStyledButton(title: "重置位置", style: .secondary) { [weak self] in
            self?.resetFloatingBallPosition()
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(showButton)
        containerView.addSubview(hideButton)
        containerView.addSubview(resetPositionButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }

        showButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }

        hideButton.snp.makeConstraints { make in
            make.top.equalTo(showButton)
            make.left.equalTo(showButton.snp.right).offset(12)
            make.width.height.equalTo(showButton)
        }

        resetPositionButton.snp.makeConstraints { make in
            make.top.equalTo(showButton.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(showButton)
            make.bottom.equalToSuperview().offset(-16)
        }

        return containerView
    }

    /// 创建外观设置区域
    /// - Returns: 包含外观设置按钮的容器视图
    private func createAppearanceControlSection() -> UIView {
        let containerView = createSectionContainer()

        let titleLabel = createSectionTitle("外观设置")
        let descLabel = createSectionDescription("自定义悬浮球的外观样式")

        // 颜色选择按钮
        let colorButtons = FloatingBallConfiguration.PredefinedColor.allCases.map { color in
            return createStyledButton(title: color.title, style: .secondary) { [weak self] in
                self?.changeFloatingBallColor(color.color)
            }
        }

        // 大小选择按钮
        let sizeButtons = FloatingBallConfiguration.PredefinedSize.allCases.map { size in
            return createStyledButton(title: size.title, style: .tertiary) { [weak self] in
                self?.changeFloatingBallSize(size.size)
            }
        }

        // 透明度按钮
        let alphaButtons = [
            ("50%", 0.5),
            ("80%", 0.8),
            ("100%", 1.0)
        ].map { title, alpha in
            return createStyledButton(title: title, style: .primary) { [weak self] in
                self?.changeFloatingBallAlpha(CGFloat(alpha))
            }
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)

        var allButtons: [UIButton] = []
        allButtons.append(contentsOf: colorButtons)
        allButtons.append(contentsOf: sizeButtons)
        allButtons.append(contentsOf: alphaButtons)

        allButtons.forEach { containerView.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }

        // 布局按钮 (3列布局)
        let buttonWidth: CGFloat = 80
        let buttonHeight: CGFloat = 36
        let spacing: CGFloat = 10

        for (index, button) in allButtons.enumerated() {
            let row = index / 3
            let col = index % 3

            button.snp.makeConstraints { make in
                make.top.equalTo(descLabel.snp.bottom).offset(16 + CGFloat(row) * (buttonHeight + spacing))
                make.left.equalToSuperview().offset(16 + CGFloat(col) * (buttonWidth + spacing))
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)

                if index == allButtons.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview().offset(-16)
                }
            }
        }

        return containerView
    }

    /// 创建行为设置区域
    /// - Returns: 包含行为设置开关的容器视图
    private func createBehaviorControlSection() -> UIView {
        let containerView = createSectionContainer()

        let titleLabel = createSectionTitle("行为设置")
        let descLabel = createSectionDescription("配置悬浮球的交互行为")

        let dragToggleButton = createStyledButton(title: "拖拽功能", style: .primary) { [weak self] in
            self?.toggleDragEnabled()
        }

        let snapToggleButton = createStyledButton(title: "边缘吸附", style: .secondary) { [weak self] in
            self?.toggleEdgeSnapEnabled()
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(dragToggleButton)
        containerView.addSubview(snapToggleButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }

        dragToggleButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }

        snapToggleButton.snp.makeConstraints { make in
            make.top.equalTo(dragToggleButton)
            make.left.equalTo(dragToggleButton.snp.right).offset(12)
            make.width.height.equalTo(dragToggleButton)
            make.bottom.equalToSuperview().offset(-16)
        }

        return containerView
    }

    /// 创建状态信息显示区域
    /// - Returns: 包含当前状态信息的容器视图
    private func createStatusInfoSection() -> UIView {
        let containerView = createSectionContainer()

        let titleLabel = createSectionTitle("悬浮球状态")
        let descLabel = createSectionDescription("显示当前悬浮球的状态信息")

        let infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = .darkGray
        infoLabel.numberOfLines = 0
        infoLabel.text = getFloatingBallInfo()

        // 保存引用以便自动更新
        statusInfoLabel = infoLabel

        let refreshButton = createStyledButton(title: "刷新信息", style: .primary) { [weak self] in
            self?.refreshFloatingBallInfo()
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(refreshButton)

        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }

        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.left.right.equalTo(titleLabel)
        }

        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-16)
        }

        return containerView
    }

    // MARK: - Helper Methods

    /// 创建通用区域容器
    /// - Returns: 带有卡片样式的容器视图
    private func createSectionContainer() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 3
        return containerView
    }

    /// 创建区域标题标签
    /// - Parameter title: 标题文本
    /// - Returns: 配置好的标题标签
    private func createSectionTitle(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }

    /// 创建区域描述标签
    /// - Parameter description: 描述文本
    /// - Returns: 配置好的描述标签
    private func createSectionDescription(_ description: String) -> UILabel {
        let label = UILabel()
        label.text = description
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }

    /// 创建样式化按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - style: 按钮样式
    ///   - action: 点击事件回调
    /// - Returns: 配置好的按钮
    private func createStyledButton(title: String, style: ButtonDisplayStyle, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8

        // 保存点击事件
        button.tag = Int.random(in: 1000...9999)
        objc_setAssociatedObject(button, &AssociatedKeys.actionKey, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        switch style {
        case .primary:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor

        case .secondary:
            button.setTitleColor(UIColor.themeColor, for: .normal)
            button.backgroundColor = .clear
            button.layer.borderColor = UIColor.themeColor.cgColor
            button.layer.borderWidth = 1

        case .tertiary:
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)

        case .danger:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemRed
        }

        return button
    }

    // MARK: - Floating Ball Control Methods

    /// 显示悬浮球
    private func showFloatingBall() {
        floatingBallManager.show()
        showAlert(title: "悬浮球控制", message: "悬浮球已显示")
    }

    /// 隐藏悬浮球
    private func hideFloatingBall() {
        floatingBallManager.hide()
        showAlert(title: "悬浮球控制", message: "悬浮球已隐藏")
    }

    /// 重置悬浮球位置
    private func resetFloatingBallPosition() {
        floatingBallManager.resetPosition()
        showAlert(title: "悬浮球控制", message: "悬浮球位置已重置")
    }

    /// 改变悬浮球颜色
    /// - Parameter color: 新颜色
    private func changeFloatingBallColor(_ color: UIColor) {
        var config = floatingBallManager.getCurrentConfiguration()
        config.color = color
        floatingBallManager.updateConfiguration(config)
        showAlert(title: "外观设置", message: "悬浮球颜色已更改")
    }

    /// 改变悬浮球大小
    /// - Parameter size: 新大小
    private func changeFloatingBallSize(_ size: CGFloat) {
        var config = floatingBallManager.getCurrentConfiguration()
        config.size = size
        floatingBallManager.updateConfiguration(config)
        showAlert(title: "外观设置", message: "悬浮球大小已更改")
    }

    /// 改变悬浮球透明度
    /// - Parameter alpha: 新透明度
    private func changeFloatingBallAlpha(_ alpha: CGFloat) {
        var config = floatingBallManager.getCurrentConfiguration()
        config.alpha = alpha
        floatingBallManager.updateConfiguration(config)
        showAlert(title: "外观设置", message: "悬浮球透明度已更改")
    }

    /// 切换拖拽功能
    private func toggleDragEnabled() {
        var config = floatingBallManager.getCurrentConfiguration()
        config.isDragEnabled.toggle()
        floatingBallManager.updateConfiguration(config)

        let status = config.isDragEnabled ? "已启用" : "已禁用"
        showAlert(title: "行为设置", message: "拖拽功能\(status)")
    }

    /// 切换边缘吸附功能
    private func toggleEdgeSnapEnabled() {
        var config = floatingBallManager.getCurrentConfiguration()
        config.isEdgeSnapEnabled.toggle()
        floatingBallManager.updateConfiguration(config)

        let status = config.isEdgeSnapEnabled ? "已启用" : "已禁用"
        showAlert(title: "行为设置", message: "边缘吸附功能\(status)")
    }

    // MARK: - Information Methods

    /// 获取当前悬浮球信息
    /// - Returns: 格式化的悬浮球信息字符串
    private func getFloatingBallInfo() -> String {
        let isShowing = floatingBallManager.isShowing
        let config = floatingBallManager.getCurrentConfiguration()
        let position = floatingBallManager.getCurrentPosition()

        // 设置时间格式
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let timeString = timeFormatter.string(from: Date())

        let positionText = if let pos = position {
            "(\(Int(pos.x)), \(Int(pos.y)))"
        } else {
            "未设置"
        }

        return """
        🎯 悬浮球状态信息

        📱 显示状态：\(isShowing ? "显示中" : "已隐藏")
        📐 当前大小：\(Int(config.size))pt
        🎨 当前颜色：自定义色
        👁 透明度：\(Int(config.alpha * 100))%
        📍 当前位置：\(positionText)

        ⚙️ 行为设置
        🖱 拖拽功能：\(config.isDragEnabled ? "启用" : "禁用")
        🧲 边缘吸附：\(config.isEdgeSnapEnabled ? "启用" : "禁用")

        🔄 更新时间：\(timeString)
        """
    }

    /// 刷新悬浮球信息显示
    private func refreshFloatingBallInfo() {
        statusInfoLabel?.text = getFloatingBallInfo()
        showAlert(title: "信息已刷新", message: "悬浮球状态信息已更新")
    }

    /// 自动刷新悬浮球信息（无弹窗提示）
    private func autoRefreshFloatingBallInfo() {
        statusInfoLabel?.text = getFloatingBallInfo()
    }

    // MARK: - Timer Management Methods

    /// 开始自动刷新
    private func startAutoRefresh() {
        stopAutoRefresh() // 防止重复创建定时器

        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.autoRefreshFloatingBallInfo()
        }
    }

    /// 停止自动刷新
    private func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    /// 设置悬浮球回调
    private func setupFloatingBallCallbacks() {
        floatingBallManager.onStatusChanged = { [weak self] isShowing in
            self?.autoRefreshFloatingBallInfo()
        }

        floatingBallManager.onPositionChanged = { [weak self] position in
            self?.autoRefreshFloatingBallInfo()
        }
    }

    // MARK: - Action Methods

    /// 按钮点击事件处理
    /// - Parameter sender: 点击的按钮
    @objc private func buttonTapped(_ sender: UIButton) {
        if let action = objc_getAssociatedObject(sender, &AssociatedKeys.actionKey) as? () -> Void {
            action()
        }
    }
}

// MARK: - Supporting Types

/// 按钮显示样式枚举
private enum ButtonDisplayStyle {
    case primary    // 主要按钮
    case secondary  // 次要按钮
    case tertiary   // 第三级按钮
    case danger     // 危险操作按钮
}

/// 关联对象键值
private enum AssociatedKeys {
    static var actionKey = "actionKey"
}