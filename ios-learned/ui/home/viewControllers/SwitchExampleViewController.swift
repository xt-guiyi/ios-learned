//
//  SwitchExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

class SwitchExampleViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    
    // 通知设置开关
    private let notificationsLabel = UILabel()
    private let pushNotificationSwitch = UISwitch()
    private let emailNotificationSwitch = UISwitch()
    private let smsNotificationSwitch = UISwitch()
    private let soundNotificationSwitch = UISwitch()
    
    // 隐私设置开关
    private let privacyLabel = UILabel()
    private let locationTrackingSwitch = UISwitch()
    private let dataSharingSwitch = UISwitch()
    private let analyticsSwitch = UISwitch()
    private let crashReportingSwitch = UISwitch()
    
    // 功能设置开关
    private let featuresLabel = UILabel()
    private let darkModeSwitch = UISwitch()
    private let autoUpdateSwitch = UISwitch()
    private let wifiOnlySwitch = UISwitch()
    private let batteryOptimizationSwitch = UISwitch()
    
    // 开发者选项开关
    private let developerLabel = UILabel()
    private let debugModeSwitch = UISwitch()
    private let betaFeaturesSwitch = UISwitch()
    
    // 状态显示
    private let statusTextView = UITextView()
    
    private var allSwitches: [(UISwitch, String)] = []
    
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
        setupSwitches()
        updateStatusDisplay()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "切换按钮") { [weak self] in
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
        setupLabels()
        setupSwitchesContent()
        setupStatusDisplay()
    }
    
    /// 设置标签
    private func setupLabels() {
        // 通知设置标签
        notificationsLabel.text = "通知设置"
        notificationsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        notificationsLabel.textColor = .label
        contentView.addSubview(notificationsLabel)
        
        // 隐私设置标签
        privacyLabel.text = "隐私设置"
        privacyLabel.font = UIFont.boldSystemFont(ofSize: 18)
        privacyLabel.textColor = .label
        contentView.addSubview(privacyLabel)
        
        // 功能设置标签
        featuresLabel.text = "功能设置"
        featuresLabel.font = UIFont.boldSystemFont(ofSize: 18)
        featuresLabel.textColor = .label
        contentView.addSubview(featuresLabel)
        
        // 开发者选项标签
        developerLabel.text = "开发者选项"
        developerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        developerLabel.textColor = .label
        contentView.addSubview(developerLabel)
    }
    
    /// 设置开关内容
    private func setupSwitchesContent() {
        // 通知设置开关
        setupSwitch(pushNotificationSwitch, defaultOn: true)
        setupSwitch(emailNotificationSwitch, defaultOn: false)
        setupSwitch(smsNotificationSwitch, defaultOn: false)
        setupSwitch(soundNotificationSwitch, defaultOn: true)
        
        // 隐私设置开关
        setupSwitch(locationTrackingSwitch, defaultOn: false)
        setupSwitch(dataSharingSwitch, defaultOn: false)
        setupSwitch(analyticsSwitch, defaultOn: false)
        setupSwitch(crashReportingSwitch, defaultOn: true)
        
        // 功能设置开关
        setupSwitch(darkModeSwitch, defaultOn: false)
        setupSwitch(autoUpdateSwitch, defaultOn: false)
        setupSwitch(wifiOnlySwitch, defaultOn: false)
        setupSwitch(batteryOptimizationSwitch, defaultOn: true)
        
        // 开发者选项开关
        setupSwitch(debugModeSwitch, defaultOn: false)
        setupSwitch(betaFeaturesSwitch, defaultOn: false)
        
        // 添加所有开关到内容视图
        [pushNotificationSwitch, emailNotificationSwitch, smsNotificationSwitch, soundNotificationSwitch,
         locationTrackingSwitch, dataSharingSwitch, analyticsSwitch, crashReportingSwitch,
         darkModeSwitch, autoUpdateSwitch, wifiOnlySwitch, batteryOptimizationSwitch,
         debugModeSwitch, betaFeaturesSwitch].forEach { switchControl in
            contentView.addSubview(switchControl)
        }
    }
    
    /// 设置单个开关
    private func setupSwitch(_ switchControl: UISwitch, defaultOn: Bool) {
        switchControl.onTintColor = UIColor.themeColor
        switchControl.isOn = defaultOn
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    /// 设置状态显示
    private func setupStatusDisplay() {
        statusTextView.layer.borderWidth = 1
        statusTextView.layer.borderColor = UIColor.systemGray4.cgColor
        statusTextView.layer.cornerRadius = 8
        statusTextView.backgroundColor = .systemBackground
        statusTextView.font = UIFont.systemFont(ofSize: 14)
        statusTextView.textColor = .label
        statusTextView.isEditable = false
        statusTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        contentView.addSubview(statusTextView)
    }
    
    /// 设置开关数组
    private func setupSwitches() {
        allSwitches = [
            (pushNotificationSwitch, "推送通知"),
            (emailNotificationSwitch, "邮件通知"),
            (smsNotificationSwitch, "短信通知"),
            (soundNotificationSwitch, "声音提醒"),
            (locationTrackingSwitch, "位置跟踪"),
            (dataSharingSwitch, "数据共享"),
            (analyticsSwitch, "使用分析"),
            (crashReportingSwitch, "崩溃报告"),
            (darkModeSwitch, "深色模式"),
            (autoUpdateSwitch, "自动更新"),
            (wifiOnlySwitch, "仅WiFi下载"),
            (batteryOptimizationSwitch, "电池优化"),
            (debugModeSwitch, "调试模式"),
            (betaFeaturesSwitch, "Beta功能")
        ]
    }
    
    /// 设置约束
    private func setupConstraints() {
        let margin: CGFloat = 20
        let spacing: CGFloat = 12
        let sectionSpacing: CGFloat = 20
        let sectionTitleSpacing: CGFloat = 10
        
        // 通知设置部分
        notificationsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        // 推送通知
        pushNotificationSwitch.snp.makeConstraints { make in
            make.top.equalTo(notificationsLabel.snp.bottom).offset(sectionTitleSpacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let pushLabel = createSwitchLabel(title: "推送通知", subtitle: "接收应用推送消息")
        pushLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pushNotificationSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(pushNotificationSwitch.snp.left).offset(-15)
        }
        
        // 邮件通知
        emailNotificationSwitch.snp.makeConstraints { make in
            make.top.equalTo(pushNotificationSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let emailLabel = createSwitchLabel(title: "邮件通知", subtitle: "通过邮件接收通知")
        emailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(emailNotificationSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(emailNotificationSwitch.snp.left).offset(-15)
        }
        
        // 短信通知
        smsNotificationSwitch.snp.makeConstraints { make in
            make.top.equalTo(emailNotificationSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let smsLabel = createSwitchLabel(title: "短信通知", subtitle: "通过短信接收通知")
        smsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(smsNotificationSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(smsNotificationSwitch.snp.left).offset(-15)
        }
        
        // 声音提醒
        soundNotificationSwitch.snp.makeConstraints { make in
            make.top.equalTo(smsNotificationSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let soundLabel = createSwitchLabel(title: "声音提醒", subtitle: "通知时播放提示音")
        soundLabel.snp.makeConstraints { make in
            make.centerY.equalTo(soundNotificationSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(soundNotificationSwitch.snp.left).offset(-15)
        }
        
        // 隐私设置部分
        privacyLabel.snp.makeConstraints { make in
            make.top.equalTo(soundNotificationSwitch.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        // 位置跟踪
        locationTrackingSwitch.snp.makeConstraints { make in
            make.top.equalTo(privacyLabel.snp.bottom).offset(sectionTitleSpacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let locationLabel = createSwitchLabel(title: "位置跟踪", subtitle: "允许应用跟踪您的位置")
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationTrackingSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(locationTrackingSwitch.snp.left).offset(-15)
        }
        
        // 数据共享
        dataSharingSwitch.snp.makeConstraints { make in
            make.top.equalTo(locationTrackingSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let dataLabel = createSwitchLabel(title: "数据共享", subtitle: "与第三方服务共享数据")
        dataLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dataSharingSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(dataSharingSwitch.snp.left).offset(-15)
        }
        
        // 使用分析
        analyticsSwitch.snp.makeConstraints { make in
            make.top.equalTo(dataSharingSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let analyticsLabel = createSwitchLabel(title: "使用分析", subtitle: "收集使用数据用于改进服务")
        analyticsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(analyticsSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(analyticsSwitch.snp.left).offset(-15)
        }
        
        // 崩溃报告
        crashReportingSwitch.snp.makeConstraints { make in
            make.top.equalTo(analyticsSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let crashLabel = createSwitchLabel(title: "崩溃报告", subtitle: "自动发送崩溃报告")
        crashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(crashReportingSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(crashReportingSwitch.snp.left).offset(-15)
        }
        
        // 功能设置部分
        featuresLabel.snp.makeConstraints { make in
            make.top.equalTo(crashReportingSwitch.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        // 深色模式
        darkModeSwitch.snp.makeConstraints { make in
            make.top.equalTo(featuresLabel.snp.bottom).offset(sectionTitleSpacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let darkLabel = createSwitchLabel(title: "深色模式", subtitle: "使用深色主题界面")
        darkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(darkModeSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(darkModeSwitch.snp.left).offset(-15)
        }
        
        // 自动更新
        autoUpdateSwitch.snp.makeConstraints { make in
            make.top.equalTo(darkModeSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let autoLabel = createSwitchLabel(title: "自动更新", subtitle: "自动下载和安装更新")
        autoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(autoUpdateSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(autoUpdateSwitch.snp.left).offset(-15)
        }
        
        // 仅WiFi下载
        wifiOnlySwitch.snp.makeConstraints { make in
            make.top.equalTo(autoUpdateSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let wifiLabel = createSwitchLabel(title: "仅WiFi下载", subtitle: "仅在WiFi环境下载内容")
        wifiLabel.snp.makeConstraints { make in
            make.centerY.equalTo(wifiOnlySwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(wifiOnlySwitch.snp.left).offset(-15)
        }
        
        // 电池优化
        batteryOptimizationSwitch.snp.makeConstraints { make in
            make.top.equalTo(wifiOnlySwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let batteryLabel = createSwitchLabel(title: "电池优化", subtitle: "启用节电模式")
        batteryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(batteryOptimizationSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(batteryOptimizationSwitch.snp.left).offset(-15)
        }
        
        // 开发者选项部分
        developerLabel.snp.makeConstraints { make in
            make.top.equalTo(batteryOptimizationSwitch.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
        }
        
        // 调试模式
        debugModeSwitch.snp.makeConstraints { make in
            make.top.equalTo(developerLabel.snp.bottom).offset(sectionTitleSpacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let debugLabel = createSwitchLabel(title: "调试模式", subtitle: "启用调试功能")
        debugLabel.snp.makeConstraints { make in
            make.centerY.equalTo(debugModeSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(debugModeSwitch.snp.left).offset(-15)
        }
        
        // Beta功能
        betaFeaturesSwitch.snp.makeConstraints { make in
            make.top.equalTo(debugModeSwitch.snp.bottom).offset(spacing)
            make.right.equalToSuperview().inset(margin)
        }
        
        let betaLabel = createSwitchLabel(title: "Beta功能", subtitle: "体验测试中的新功能")
        betaLabel.snp.makeConstraints { make in
            make.centerY.equalTo(betaFeaturesSwitch)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(betaFeaturesSwitch.snp.left).offset(-15)
        }
        
        // 状态显示
        statusTextView.snp.makeConstraints { make in
            make.top.equalTo(betaFeaturesSwitch.snp.bottom).offset(sectionSpacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().inset(margin)
        }
    }
    
    /// 创建开关标签
    private func createSwitchLabel(title: String, subtitle: String) -> UIView {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        contentView.addSubview(containerView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.right.bottom.equalToSuperview()
        }
        
        return containerView
    }
    
    /// 更新状态显示
    private func updateStatusDisplay() {
        var enabledFeatures: [String] = []
        
        for (switchControl, title) in allSwitches {
            if switchControl.isOn {
                enabledFeatures.append(title)
            }
        }
        
        let statusText = "当前启用的功能：\n\n" + (enabledFeatures.isEmpty ? "无" : "• " + enabledFeatures.joined(separator: "\n• "))
        
        statusTextView.text = statusText
    }
    
    // MARK: - Actions
    
    /// 开关状态改变
    @objc private func switchValueChanged(_ sender: UISwitch) {
        updateStatusDisplay()
        
        // 找到对应的标题
        if let title = allSwitches.first(where: { $0.0 === sender })?.1 {
            let status = sender.isOn ? "开启" : "关闭"
            print("[\(title)] 已\(status)")
            
            // 特殊处理某些开关
            handleSpecialSwitches(title: title, isOn: sender.isOn)
        }
    }
    
    /// 处理特殊开关逻辑
    private func handleSpecialSwitches(title: String, isOn: Bool) {
        switch title {
        case "深色模式":
            // 这里可以实际切换深色模式（仅作演示）
            if #available(iOS 13.0, *) {
                view.window?.overrideUserInterfaceStyle = isOn ? .dark : .light
            }
            
        case "电池优化":
            if isOn {
                // 电池优化开启时，关闭一些耗电功能
                locationTrackingSwitch.setOn(false, animated: true)
                analyticsSwitch.setOn(false, animated: true)
                updateStatusDisplay()
            }
            
        case "调试模式":
            if isOn {
                // 调试模式开启时，自动开启崩溃报告
                crashReportingSwitch.setOn(true, animated: true)
                updateStatusDisplay()
            }
            
        default:
            break
        }
    }
}