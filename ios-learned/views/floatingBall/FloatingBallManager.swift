//
//  FloatingBallManager.swift
//  ios-learned
//
//  Created by Claude on 2025/9/21.
//

import UIKit

/// 悬浮球管理器
/// 负责管理应用级别的悬浮球显示、隐藏和配置
class FloatingBallManager {

    // MARK: - Singleton

    /// 单例实例
    static let shared = FloatingBallManager()

    private init() {
        loadConfiguration()
    }

    // MARK: - Properties

    /// 悬浮球视图
    private var floatingBallView: FloatingBallView?
    /// 悬浮球是否显示中
    private(set) var isShowing: Bool = false

    /// 配置信息
    private var configuration = FloatingBallConfiguration()

    /// 状态改变回调
    var onStatusChanged: ((Bool) -> Void)?
    /// 位置改变回调
    var onPositionChanged: ((CGPoint) -> Void)?

    // MARK: - Public Methods

    /// 显示悬浮球
    func show() {
        guard !isShowing else { return }

        guard let keyWindow = getKeyWindow() else {
            print("❌ 无法获取主窗口")
            return
        }

        createFloatingBall()
        keyWindow.addSubview(floatingBallView!)
        keyWindow.bringSubviewToFront(floatingBallView!)

        isShowing = true
        onStatusChanged?(true)

        print("🎯 悬浮球已显示")
    }

    /// 隐藏悬浮球
    func hide() {
        guard isShowing else { return }

        floatingBallView?.removeFromSuperview()
        floatingBallView = nil

        isShowing = false
        onStatusChanged?(false)

        print("🎯 悬浮球已隐藏")
    }

    /// 切换悬浮球显示状态
    func toggle() {
        if isShowing {
            hide()
        } else {
            show()
        }
    }

    /// 更新悬浮球配置
    /// - Parameter config: 新的配置
    func updateConfiguration(_ config: FloatingBallConfiguration) {
        configuration = config
        saveConfiguration()

        // 如果悬浮球正在显示，更新其外观
        if isShowing {
            updateFloatingBallAppearance()
        }
    }

    /// 获取当前配置
    /// - Returns: 当前配置
    func getCurrentConfiguration() -> FloatingBallConfiguration {
        return configuration
    }

    /// 重置悬浮球位置
    func resetPosition() {
        floatingBallView?.resetToDefaultPosition(animated: true)
    }

    /// 获取当前悬浮球位置
    /// - Returns: 当前位置，如果悬浮球未显示则返回nil
    func getCurrentPosition() -> CGPoint? {
        return floatingBallView?.center
    }

    // MARK: - Private Methods

    /// 获取主窗口
    /// - Returns: 主应用窗口
    private func getKeyWindow() -> UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return nil
        }

        return windowScene.windows.first { $0.isKeyWindow }
    }

    /// 创建悬浮球视图
    private func createFloatingBall() {
        // 创建悬浮球视图
        floatingBallView = FloatingBallView(
            size: configuration.size,
            color: configuration.color
        )

        guard let ballView = floatingBallView else { return }

        // 配置悬浮球
        ballView.ballAlpha = configuration.alpha
        ballView.isDragEnabled = configuration.isDragEnabled
        ballView.isEdgeSnapEnabled = configuration.isEdgeSnapEnabled

        // 设置回调
        ballView.onTapped = { [weak self] in
            self?.handleFloatingBallTapped()
        }

        ballView.onPositionChanged = { [weak self] position in
            self?.handlePositionChanged(position)
        }

        // 设置初始位置
        let initialPosition = configuration.lastPosition ?? getDefaultPosition()
        ballView.moveTo(initialPosition, animated: false)
    }

    /// 更新悬浮球外观
    private func updateFloatingBallAppearance() {
        floatingBallView?.configure(
            size: configuration.size,
            color: configuration.color,
            alpha: configuration.alpha
        )

        floatingBallView?.isDragEnabled = configuration.isDragEnabled
        floatingBallView?.isEdgeSnapEnabled = configuration.isEdgeSnapEnabled
    }

    /// 获取默认位置
    /// - Returns: 默认位置
    private func getDefaultPosition() -> CGPoint {
        guard let window = getKeyWindow() else {
            return CGPoint(x: 300, y: 400)
        }

        let bounds = window.bounds
        let safeAreaInsets = window.safeAreaInsets
        let margin: CGFloat = 10

        return CGPoint(
            x: bounds.width - configuration.size / 2 - safeAreaInsets.right - margin,
            y: bounds.height / 2
        )
    }

    /// 处理悬浮球点击
    private func handleFloatingBallTapped() {
        print("🎯 悬浮球被点击")

        // 可以在这里添加悬浮球点击后的操作
        // 比如显示快捷菜单、回到首页等

        // 示例：震动反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    /// 处理位置改变
    /// - Parameter position: 新位置
    private func handlePositionChanged(_ position: CGPoint) {
        configuration.lastPosition = position
        saveConfiguration()
        onPositionChanged?(position)
    }

    // MARK: - Configuration Management

    /// 加载配置
    private func loadConfiguration() {
        let defaults = UserDefaults.standard

        configuration.size = CGFloat(defaults.double(forKey: "FloatingBall.size"))
        if configuration.size <= 0 {
            configuration.size = 60 // 默认大小
        }

        configuration.alpha = CGFloat(defaults.double(forKey: "FloatingBall.alpha"))
        if configuration.alpha <= 0 {
            configuration.alpha = 0.8 // 默认透明度
        }

        configuration.isDragEnabled = defaults.object(forKey: "FloatingBall.dragEnabled") as? Bool ?? true
        configuration.isEdgeSnapEnabled = defaults.object(forKey: "FloatingBall.edgeSnapEnabled") as? Bool ?? true

        // 加载颜色
        if let colorData = defaults.data(forKey: "FloatingBall.color"),
           let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            configuration.color = color
        } else {
            configuration.color = UIColor.themeColor
        }

        // 加载位置
        let x = defaults.double(forKey: "FloatingBall.position.x")
        let y = defaults.double(forKey: "FloatingBall.position.y")
        if x > 0 && y > 0 {
            configuration.lastPosition = CGPoint(x: x, y: y)
        }

        print("📱 悬浮球配置已加载")
    }

    /// 保存配置
    private func saveConfiguration() {
        let defaults = UserDefaults.standard

        defaults.set(Double(configuration.size), forKey: "FloatingBall.size")
        defaults.set(Double(configuration.alpha), forKey: "FloatingBall.alpha")
        defaults.set(configuration.isDragEnabled, forKey: "FloatingBall.dragEnabled")
        defaults.set(configuration.isEdgeSnapEnabled, forKey: "FloatingBall.edgeSnapEnabled")

        // 保存颜色
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: configuration.color, requiringSecureCoding: false) {
            defaults.set(colorData, forKey: "FloatingBall.color")
        }

        // 保存位置
        if let position = configuration.lastPosition {
            defaults.set(Double(position.x), forKey: "FloatingBall.position.x")
            defaults.set(Double(position.y), forKey: "FloatingBall.position.y")
        }

        defaults.synchronize()
        print("💾 悬浮球配置已保存")
    }
}

// MARK: - Configuration Model

/// 悬浮球配置模型
struct FloatingBallConfiguration {
    /// 悬浮球大小
    var size: CGFloat = 60
    /// 悬浮球颜色
    var color: UIColor = UIColor.themeColor
    /// 悬浮球透明度
    var alpha: CGFloat = 0.8
    /// 是否启用拖拽
    var isDragEnabled: Bool = true
    /// 是否启用边缘吸附
    var isEdgeSnapEnabled: Bool = true
    /// 最后一次位置
    var lastPosition: CGPoint?

    /// 创建默认配置
    static func `default`() -> FloatingBallConfiguration {
        return FloatingBallConfiguration()
    }
}

// MARK: - Predefined Colors

extension FloatingBallConfiguration {
    /// 预定义颜色选项
    enum PredefinedColor: CaseIterable {
        case theme
        case red
        case blue
        case green
        case orange
        case purple

        var color: UIColor {
            switch self {
            case .theme:
                return UIColor.themeColor
            case .red:
                return .systemRed
            case .blue:
                return .systemBlue
            case .green:
                return .systemGreen
            case .orange:
                return .systemOrange
            case .purple:
                return .systemPurple
            }
        }

        var title: String {
            switch self {
            case .theme:
                return "主题色"
            case .red:
                return "红色"
            case .blue:
                return "蓝色"
            case .green:
                return "绿色"
            case .orange:
                return "橙色"
            case .purple:
                return "紫色"
            }
        }
    }

    /// 预定义大小选项
    enum PredefinedSize: CaseIterable {
        case small
        case medium
        case large

        var size: CGFloat {
            switch self {
            case .small:
                return 50
            case .medium:
                return 60
            case .large:
                return 80
            }
        }

        var title: String {
            switch self {
            case .small:
                return "小"
            case .medium:
                return "中"
            case .large:
                return "大"
            }
        }
    }
}