//
//  SystemBarViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/20.
//

import UIKit
import SnapKit

/// 系统栏管理页面
/// 演示状态栏、导航栏、安全区域、全屏模式等相关操作
class SystemBarViewController: BaseViewController {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navigationBar = CustomNavigationBar()

    // 状态栏相关
    private let statusBarSectionLabel = UILabel()
    private let lightContentButton = UIButton(type: .system)
    private let darkContentButton = UIButton(type: .system)
    private let defaultButton = UIButton(type: .system)
    private let statusBarHiddenSwitch = UISwitch()
    private let statusBarHiddenLabel = UILabel()

    // 底部安全区域相关
    private let bottomSafeAreaSectionLabel = UILabel()
    private let showBottomIndicatorSwitch = UISwitch()
    private let showBottomIndicatorLabel = UILabel()
    private let safeAreaColorButton = UIButton(type: .system)
    private let bottomSafeAreaView = UIView()

    // 安全区域相关
    private let safeAreaSectionLabel = UILabel()
    private let safeAreaInfoLabel = UILabel()

    // 当前底部安全区域颜色
    private var currentSafeAreaColor: UIColor = .clear
    private let safeAreaColors: [UIColor] = [.clear, .red, .blue, .green, .orange, .purple]
    private var colorIndex = 0

    // 状态记录
    private var isFullScreenMode = false
    private var isStatusBarHidden = false
    private var currentStatusBarStyle: UIStatusBarStyle = .default

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateSafeAreaInfo()
        updateButtonText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusBarAppearance()
    }

    // MARK: - Setup Methods

    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        setupNavigationBar()
        setupScrollView()
        setupContentView()
        setupStatusBarSection()
        setupBottomSafeAreaSection()
        setupSafeAreaSection()
        setupBottomSafeAreaView()
        setupConstraints()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "系统栏管理") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
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

    /// 设置内容视图
    private func setupContentView() {
        contentView.backgroundColor = .clear
    }

    /// 设置状态栏控制区域
    private func setupStatusBarSection() {
        // 标题
        statusBarSectionLabel.text = "状态栏控制"
        statusBarSectionLabel.font = .boldSystemFont(ofSize: 20)
        statusBarSectionLabel.textColor = .mainTextColor

        // 状态栏样式按钮
        configureButton(lightContentButton, title: "浅色内容", backgroundColor: .themeColor)
        configureButton(darkContentButton, title: "深色内容", backgroundColor: .secondaryThemeColor)
        configureButton(defaultButton, title: "默认样式", backgroundColor: .systemGray)

        // 隐藏状态栏开关
        statusBarHiddenLabel.text = "隐藏状态栏"
        statusBarHiddenLabel.font = .systemFont(ofSize: 16)
        statusBarHiddenLabel.textColor = .mainTextColor

        statusBarHiddenSwitch.isOn = false
        statusBarHiddenSwitch.onTintColor = .themeColor

        // 添加到内容视图
        [statusBarSectionLabel, lightContentButton, darkContentButton, defaultButton,
         statusBarHiddenLabel, statusBarHiddenSwitch].forEach { contentView.addSubview($0) }
    }

    /// 设置底部安全区域控制区域
    private func setupBottomSafeAreaSection() {
        // 标题
        bottomSafeAreaSectionLabel.text = "底部安全区域控制"
        bottomSafeAreaSectionLabel.font = .boldSystemFont(ofSize: 20)
        bottomSafeAreaSectionLabel.textColor = .mainTextColor

        // 显示底部指示器开关
        showBottomIndicatorLabel.text = "显示底部安全区域"
        showBottomIndicatorLabel.font = .systemFont(ofSize: 16)
        showBottomIndicatorLabel.textColor = .mainTextColor

        showBottomIndicatorSwitch.isOn = false
        showBottomIndicatorSwitch.onTintColor = .themeColor

        // 安全区域颜色按钮
        configureButton(safeAreaColorButton, title: "切换安全区域颜色", backgroundColor: .systemBlue)

        // 添加到内容视图
        [bottomSafeAreaSectionLabel, showBottomIndicatorLabel, showBottomIndicatorSwitch,
         safeAreaColorButton].forEach { contentView.addSubview($0) }
    }

    /// 设置底部安全区域视图
    private func setupBottomSafeAreaView() {
        bottomSafeAreaView.backgroundColor = currentSafeAreaColor
        bottomSafeAreaView.isHidden = true
        bottomSafeAreaView.alpha = 0.8
        view.addSubview(bottomSafeAreaView)

        // 初始设置约束，在 viewDidLayoutSubviews 中会根据实际安全区域调整
        bottomSafeAreaView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50) // 默认高度，后续会调整
        }
    }

    /// 设置安全区域信息区域
    private func setupSafeAreaSection() {
        // 标题
        safeAreaSectionLabel.text = "设备安全区域信息"
        safeAreaSectionLabel.font = .boldSystemFont(ofSize: 20)
        safeAreaSectionLabel.textColor = .mainTextColor

        // 安全区域信息标签
        safeAreaInfoLabel.font = .systemFont(ofSize: 14)
        safeAreaInfoLabel.textColor = .secondaryTextColor
        safeAreaInfoLabel.numberOfLines = 0

        // 添加到内容视图
        [safeAreaSectionLabel, safeAreaInfoLabel].forEach { contentView.addSubview($0) }
    }

    /// 配置按钮样式
    /// - Parameters:
    ///   - button: 按钮对象
    ///   - title: 按钮标题
    ///   - backgroundColor: 背景颜色
    private func configureButton(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
    }

    /// 设置约束
    private func setupConstraints() {
        var previousView: UIView = contentView
        let margin: CGFloat = 16
        let sectionSpacing: CGFloat = 30

        // 状态栏控制区域
        statusBarSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(margin)
        }
        previousView = statusBarSectionLabel

        let buttonStackView = UIStackView(arrangedSubviews: [lightContentButton, darkContentButton, defaultButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        contentView.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        previousView = buttonStackView

        statusBarHiddenLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(margin)
            make.centerY.equalTo(statusBarHiddenSwitch)
        }

        statusBarHiddenSwitch.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(margin)
        }
        previousView = statusBarHiddenSwitch

        // 底部安全区域控制区域
        bottomSafeAreaSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        previousView = bottomSafeAreaSectionLabel

        showBottomIndicatorLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(margin)
            make.centerY.equalTo(showBottomIndicatorSwitch)
        }

        showBottomIndicatorSwitch.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(margin)
        }
        previousView = showBottomIndicatorSwitch

        safeAreaColorButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }
        previousView = safeAreaColorButton

        // 设备安全区域信息区域
        safeAreaSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        previousView = safeAreaSectionLabel

        safeAreaInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(margin)
            make.bottom.equalToSuperview().inset(margin)
        }
    }

    // MARK: - Actions Setup

    /// 设置事件监听
    private func setupActions() {
        lightContentButton.addTarget(self, action: #selector(lightContentButtonTapped), for: .touchUpInside)
        darkContentButton.addTarget(self, action: #selector(darkContentButtonTapped), for: .touchUpInside)
        defaultButton.addTarget(self, action: #selector(defaultButtonTapped), for: .touchUpInside)
        safeAreaColorButton.addTarget(self, action: #selector(safeAreaColorButtonTapped), for: .touchUpInside)

        statusBarHiddenSwitch.addTarget(self, action: #selector(statusBarHiddenSwitchChanged), for: .valueChanged)
        showBottomIndicatorSwitch.addTarget(self, action: #selector(showBottomIndicatorSwitchChanged), for: .valueChanged)
    }

    // MARK: - Action Methods

    /// 浅色内容按钮点击事件
    @objc private func lightContentButtonTapped() {
        currentStatusBarStyle = .lightContent
        updateStatusBarAppearance()
        updateButtonStates()
    }

    /// 深色内容按钮点击事件
    @objc private func darkContentButtonTapped() {
        if #available(iOS 13.0, *) {
            currentStatusBarStyle = .darkContent
        } else {
            currentStatusBarStyle = .default
        }
        updateStatusBarAppearance()
        updateButtonStates()
    }

    /// 默认样式按钮点击事件
    @objc private func defaultButtonTapped() {
        currentStatusBarStyle = .default
        updateStatusBarAppearance()
        updateButtonStates()
    }

    /// 状态栏隐藏开关改变事件
    @objc private func statusBarHiddenSwitchChanged() {
        isStatusBarHidden = statusBarHiddenSwitch.isOn
        updateStatusBarAppearance()
    }

    /// 显示底部指示器开关改变事件
    @objc private func showBottomIndicatorSwitchChanged() {
        bottomSafeAreaView.isHidden = !showBottomIndicatorSwitch.isOn

        // 如果开关打开但颜色是透明的，设置一个默认颜色
        if showBottomIndicatorSwitch.isOn && currentSafeAreaColor == .clear {
            colorIndex = 1 // 设置为红色
            currentSafeAreaColor = safeAreaColors[colorIndex]
            bottomSafeAreaView.backgroundColor = currentSafeAreaColor
            updateButtonText()
        }

        // 强制布局更新
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    /// 安全区域颜色按钮点击事件
    @objc private func safeAreaColorButtonTapped() {
        colorIndex = (colorIndex + 1) % safeAreaColors.count
        currentSafeAreaColor = safeAreaColors[colorIndex]
        bottomSafeAreaView.backgroundColor = currentSafeAreaColor
        updateButtonText()
    }


    // MARK: - Helper Methods

    /// 更新状态栏外观
    private func updateStatusBarAppearance() {
        setNeedsStatusBarAppearanceUpdate()
    }

    /// 更新按钮状态
    private func updateButtonStates() {
        // 重置所有按钮状态
        [lightContentButton, darkContentButton, defaultButton].forEach { button in
            button.alpha = 0.6
            button.transform = .identity
        }

        // 高亮当前选中的按钮
        let selectedButton: UIButton
        switch currentStatusBarStyle {
        case .lightContent:
            selectedButton = lightContentButton
        case .darkContent:
            selectedButton = darkContentButton
        default:
            selectedButton = defaultButton
        }

        selectedButton.alpha = 1.0
        UIView.animate(withDuration: 0.2) {
            selectedButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }

    /// 更新安全区域信息
    private func updateSafeAreaInfo() {
        let safeAreaInsets = view.safeAreaInsets
        let infoText = """
        安全区域信息：
        顶部: \(safeAreaInsets.top)pt
        底部: \(safeAreaInsets.bottom)pt
        左侧: \(safeAreaInsets.left)pt
        右侧: \(safeAreaInsets.right)pt

        屏幕尺寸: \(UIScreen.main.bounds.width) × \(UIScreen.main.bounds.height)
        """
        safeAreaInfoLabel.text = infoText
    }

    // MARK: - Status Bar

    /// 重写状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentStatusBarStyle
    }

    /// 重写状态栏隐藏状态
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    /// 重写状态栏更新动画
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    // MARK: - View Lifecycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSafeAreaInfo()
        updateBottomSafeAreaView()
    }

    /// 更新底部安全区域视图的约束
    private func updateBottomSafeAreaView() {
        let bottomInset = view.safeAreaInsets.bottom

        bottomSafeAreaView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if bottomInset > 0 {
                // 有底部安全区域的设备（如 iPhone X 系列）
                make.height.equalTo(bottomInset)
            } else {
                // 没有底部安全区域的设备，设置固定高度以便演示
                make.height.equalTo(30)
            }
        }
    }

    /// 更新按钮文本
    private func updateButtonText() {
        let colorNames = ["透明", "红色", "蓝色", "绿色", "橙色", "紫色"]
        safeAreaColorButton.setTitle("当前颜色：\(colorNames[colorIndex])", for: .normal)
    }
}
