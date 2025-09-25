//
//  FloatingBallView.swift
//  ios-learned
//
//  Created by Claude on 2025/9/21.
//

import UIKit
import SnapKit

/// 悬浮球自定义视图
/// 支持拖拽、边缘吸附、点击交互等功能
class FloatingBallView: UIView {

    // MARK: - Properties

    /// 拖拽手势识别器
    private var panGesture: UIPanGestureRecognizer!
    /// 点击手势识别器
    private var tapGesture: UITapGestureRecognizer!

    /// 是否启用拖拽功能
    var isDragEnabled: Bool = true {
        didSet {
            panGesture.isEnabled = isDragEnabled
        }
    }

    /// 是否启用边缘吸附
    var isEdgeSnapEnabled: Bool = true

    /// 悬浮球大小
    var ballSize: CGFloat = 60 {
        didSet {
            updateSize()
        }
    }

    /// 悬浮球颜色
    var ballColor: UIColor = UIColor.themeColor {
        didSet {
            updateAppearance()
        }
    }

    /// 悬浮球透明度
    var ballAlpha: CGFloat = 0.8 {
        didSet {
            updateAppearance()
        }
    }

    /// 点击回调
    var onTapped: (() -> Void)?

    /// 位置改变回调
    var onPositionChanged: ((CGPoint) -> Void)?

    // MARK: - UI Components

    /// 内容容器视图
    private let contentView = UIView()
    /// 图标标签
    private let iconLabel = UILabel()

    // MARK: - Initialization

    /// 初始化悬浮球视图
    /// - Parameter frame: 初始frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }

    /// 便利初始化器
    /// - Parameters:
    ///   - size: 悬浮球大小
    ///   - color: 悬浮球颜色
    convenience init(size: CGFloat = 60, color: UIColor = UIColor.themeColor) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.ballSize = size
        self.ballColor = color
        updateSize()
        updateAppearance()
    }

    // MARK: - UI Setup

    /// 设置UI界面
    private func setupUI() {
        // 配置主视图
        backgroundColor = .clear

        // 配置内容视图
        contentView.backgroundColor = ballColor
        contentView.layer.cornerRadius = ballSize / 2
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowRadius = 8

        // 添加边框
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        // 配置图标标签
        iconLabel.text = "🚀"
        iconLabel.font = UIFont.systemFont(ofSize: ballSize * 0.5)
        iconLabel.textAlignment = .center
        iconLabel.textColor = .white

        // 添加子视图
        addSubview(contentView)
        contentView.addSubview(iconLabel)

        // 设置约束
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 初始外观
        updateAppearance()

        // 添加脉冲动画效果
        addPulseAnimation()

        // 添加悬停浮动效果
        addFloatingAnimation()

        // 添加粒子效果
        addParticleEffect()
    }

    /// 设置手势识别器
    private func setupGestures() {
        // 拖拽手势
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)

        // 点击手势
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    // MARK: - Update Methods

    /// 更新悬浮球大小
    private func updateSize() {
        // 更新frame
        frame.size = CGSize(width: ballSize, height: ballSize)

        // 更新圆角
        contentView.layer.cornerRadius = ballSize / 2

        // 更新图标大小
        iconLabel.font = UIFont.systemFont(ofSize: ballSize * 0.4)

        // 重新布局
        setNeedsLayout()
        layoutIfNeeded()
    }

    /// 更新外观
    private func updateAppearance() {
        contentView.backgroundColor = ballColor.withAlphaComponent(ballAlpha)

        // 添加现代化渐变效果
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)

        // 创建更丰富的渐变色彩
        let lightColor = ballColor.withAlphaComponent(ballAlpha)
        let darkColor = ballColor.darker(by: 0.3).withAlphaComponent(ballAlpha)
        let highlightColor = ballColor.lighter(by: 0.4).withAlphaComponent(ballAlpha * 0.8)

        gradientLayer.colors = [
            highlightColor.cgColor,
            lightColor.cgColor,
            darkColor.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.2)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.8)
        gradientLayer.cornerRadius = ballSize / 2

        // 更新边框颜色
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor

        contentView.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Gesture Handlers

    /// 处理拖拽手势
    /// - Parameter gesture: 拖拽手势识别器
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isDragEnabled else { return }

        let translation = gesture.translation(in: superview)

        switch gesture.state {
        case .began:
            // 开始拖拽时增加不透明度和移除脉冲动画
            animateAlpha(to: 1.0, duration: 0.2)
            removePulseAnimation()

        case .changed:
            // 移动悬浮球
            let newCenter = CGPoint(
                x: center.x + translation.x,
                y: center.y + translation.y
            )
            center = constrainToSuperviewBounds(newCenter)
            gesture.setTranslation(.zero, in: superview)

            // 通知位置改变
            onPositionChanged?(center)

        case .ended, .cancelled:
            // 结束拖拽时恢复透明度和所有动画
            animateAlpha(to: ballAlpha, duration: 0.2)
            addPulseAnimation()
            addFloatingAnimation()

            // 边缘吸附
            if isEdgeSnapEnabled {
                snapToNearestEdge()
            }

        default:
            break
        }
    }

    /// 处理点击手势
    /// - Parameter gesture: 点击手势识别器
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        // 点击动画
        animatePress {
            self.onTapped?()
        }
    }

    // MARK: - Animation Methods

    /// 透明度动画
    /// - Parameters:
    ///   - alpha: 目标透明度
    ///   - duration: 动画时长
    private func animateAlpha(to alpha: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.contentView.alpha = alpha
        })
    }

    /// 按压动画
    /// - Parameter completion: 动画完成回调
    private func animatePress(completion: @escaping () -> Void) {
        // 暂时移除动画避免冲突
        removePulseAnimation()

        // 添加点击波纹效果
        addRippleEffect()

        // 缩放动画
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
                self.transform = CGAffineTransform.identity
            }) { _ in
                // 恢复动画
                self.addPulseAnimation()
                completion()
            }
        }
    }

    /// 添加点击波纹效果
    private func addRippleEffect() {
        let rippleLayer = CAShapeLayer()
        let ripplePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ballSize, height: ballSize))
        rippleLayer.path = ripplePath.cgPath
        rippleLayer.fillColor = UIColor.clear.cgColor
        rippleLayer.strokeColor = ballColor.lighter(by: 0.5).cgColor
        rippleLayer.lineWidth = 3
        rippleLayer.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)

        // 波纹扩散动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 2.0
        scaleAnimation.duration = 0.6

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 0.6

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 0.6

        contentView.layer.addSublayer(rippleLayer)
        rippleLayer.add(animationGroup, forKey: "ripple")

        // 动画完成后移除
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            rippleLayer.removeFromSuperlayer()
        }
    }

    /// 添加脉冲动画效果
    private func addPulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 2.5
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.08
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        contentView.layer.add(pulseAnimation, forKey: "pulse")

        // 添加图标旋转动画
        addIconRotationAnimation()

        // 添加光晕效果
        addGlowAnimation()
    }

    /// 移除脉冲动画
    private func removePulseAnimation() {
        contentView.layer.removeAnimation(forKey: "pulse")
        iconLabel.layer.removeAnimation(forKey: "rotation")
        layer.removeAnimation(forKey: "floating")
        removeGlowAnimation()
    }

    /// 添加图标旋转动画
    private func addIconRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = 8.0
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        iconLabel.layer.add(rotationAnimation, forKey: "rotation")
    }

    /// 添加光晕效果
    private func addGlowAnimation() {
        // 创建光晕层
        let glowLayer = CALayer()
        glowLayer.frame = CGRect(x: -10, y: -10, width: ballSize + 20, height: ballSize + 20)
        glowLayer.cornerRadius = (ballSize + 20) / 2
        glowLayer.backgroundColor = ballColor.withAlphaComponent(0.3).cgColor
        glowLayer.name = "glowLayer"

        // 光晕动画
        let glowAnimation = CABasicAnimation(keyPath: "opacity")
        glowAnimation.duration = 1.5
        glowAnimation.fromValue = 0.0
        glowAnimation.toValue = 0.6
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity
        glowAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        glowLayer.add(glowAnimation, forKey: "glow")

        // 添加到底层
        layer.insertSublayer(glowLayer, at: 0)
    }

    /// 移除光晕效果
    private func removeGlowAnimation() {
        layer.sublayers?.removeAll { sublayer in
            sublayer.name == "glowLayer"
        }
    }

    /// 添加悬停浮动效果
    private func addFloatingAnimation() {
        let floatingAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        floatingAnimation.duration = 3.0
        floatingAnimation.fromValue = -2
        floatingAnimation.toValue = 2
        floatingAnimation.autoreverses = true
        floatingAnimation.repeatCount = .infinity
        floatingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        layer.add(floatingAnimation, forKey: "floating")
    }

    /// 添加粒子效果
    private func addParticleEffect() {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: ballSize / 2, y: ballSize / 2)
        emitterLayer.emitterSize = CGSize(width: ballSize, height: ballSize)
        emitterLayer.emitterShape = .circle
        emitterLayer.renderMode = .additive

        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 2.0
        cell.lifetimeRange = 1.0
        cell.velocity = 20
        cell.velocityRange = 10
        cell.emissionRange = .pi * 2
        cell.scaleRange = 0.3
        cell.scale = 0.1
        cell.scaleSpeed = -0.05
        cell.alphaRange = 0.5
        cell.alphaSpeed = -0.25

        // 创建粒子图像
        let size = CGSize(width: 4, height: 4)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.withAlphaComponent(0.8).setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        let particleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.contents = particleImage?.cgImage
        cell.color = ballColor.cgColor

        emitterLayer.emitterCells = [cell]
        layer.addSublayer(emitterLayer)
    }

    /// 边缘吸附动画
    private func snapToNearestEdge() {
        guard let superview = superview else { return }

        let superBounds = superview.bounds
        let safeAreaInsets = superview.safeAreaInsets
        let currentX = center.x
        let margin: CGFloat = 10
        let leftEdge = ballSize / 2 + safeAreaInsets.left + margin
        let rightEdge = superBounds.width - ballSize / 2 - safeAreaInsets.right - margin

        let leftDistance = abs(currentX - leftEdge)
        let rightDistance = abs(currentX - rightEdge)

        // 计算目标X坐标
        let targetX: CGFloat
        if leftDistance < rightDistance {
            // 吸附到左边
            targetX = leftEdge
        } else {
            // 吸附到右边
            targetX = rightEdge
        }

        let targetCenter = CGPoint(x: targetX, y: center.y)
        let constrainedTarget = constrainToSuperviewBounds(targetCenter)

        // 执行吸附动画 - 更强烈的弹性效果
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            self.center = constrainedTarget
        }) { _ in
            self.onPositionChanged?(self.center)
        }
    }

    // MARK: - Helper Methods

    /// 限制悬浮球在父视图边界内
    /// - Parameter point: 目标点
    /// - Returns: 限制后的点
    private func constrainToSuperviewBounds(_ point: CGPoint) -> CGPoint {
        guard let superview = superview else { return point }

        let superBounds = superview.bounds
        let halfSize = ballSize / 2

        // 考虑安全区域
        let safeAreaInsets = superview.safeAreaInsets
        let topInset = safeAreaInsets.top
        let bottomInset = safeAreaInsets.bottom
        let leftInset = safeAreaInsets.left
        let rightInset = safeAreaInsets.right

        let constrainedX = max(halfSize + leftInset, min(point.x, superBounds.width - halfSize - rightInset))
        let constrainedY = max(halfSize + topInset, min(point.y, superBounds.height - halfSize - bottomInset))

        return CGPoint(x: constrainedX, y: constrainedY)
    }

    // MARK: - Public Methods

    /// 移动到指定位置
    /// - Parameters:
    ///   - point: 目标位置
    ///   - animated: 是否使用动画
    func moveTo(_ point: CGPoint, animated: Bool = true) {
        let constrainedPoint = constrainToSuperviewBounds(point)

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.center = constrainedPoint
            }) { _ in
                self.onPositionChanged?(self.center)
            }
        } else {
            center = constrainedPoint
            onPositionChanged?(center)
        }
    }

    /// 重置到默认位置
    /// - Parameter animated: 是否使用动画
    func resetToDefaultPosition(animated: Bool = true) {
        guard let superview = superview else { return }

        let bounds = superview.bounds
        let safeAreaInsets = superview.safeAreaInsets
        let margin: CGFloat = 10

        let defaultPoint = CGPoint(
            x: bounds.width - ballSize / 2 - safeAreaInsets.right - margin,
            y: bounds.height / 2
        )

        moveTo(defaultPoint, animated: animated)
    }

    /// 设置悬浮球配置
    /// - Parameters:
    ///   - size: 大小
    ///   - color: 颜色
    ///   - alpha: 透明度
    func configure(size: CGFloat? = nil, color: UIColor? = nil, alpha: CGFloat? = nil) {
        if let size = size {
            ballSize = size
        }

        if let color = color {
            ballColor = color
        }

        if let alpha = alpha {
            ballAlpha = alpha
        }

        updateSize()
        updateAppearance()
    }
}