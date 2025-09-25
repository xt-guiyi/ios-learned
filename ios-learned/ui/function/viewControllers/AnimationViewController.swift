import UIKit
import SnapKit

/// 动画示例页面
/// 展示iOS中各种动画效果的使用方法，包括UIView动画、核心动画等
class AnimationViewController: UIViewController {

    private var customNavigationBar: CustomNavigationBar!
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    // 动画展示视图
    private var basicAnimationView: UIView!
    private var springAnimationView: UIView!
    private var keyframeAnimationView: UIView!
    private var transformAnimationView: UIView!
    private var fadeAnimationView: UIView!
    private var shapeLayerAnimationView: UIView!

    // 控制按钮
    private var basicAnimationButton: UIButton!
    private var springAnimationButton: UIButton!
    private var keyframeAnimationButton: UIButton!
    private var transformAnimationButton: UIButton!
    private var fadeAnimationButton: UIButton!
    private var shapeLayerAnimationButton: UIButton!

    // CAShapeLayer 用于形状动画
    private var circleLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupScrollView()
        setupAnimationViews()
        setupButtons()
        setupConstraints()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar = CustomNavigationBar()
        customNavigationBar.configure(title: "动画示例") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear

        contentView = UIView()
        contentView.backgroundColor = .clear

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    /// 设置动画展示视图
    private func setupAnimationViews() {
        // 基础动画视图
        basicAnimationView = createAnimationView(color: .systemBlue, title: "基础动画")

        // 弹簧动画视图
        springAnimationView = createAnimationView(color: .systemGreen, title: "弹簧动画")

        // 关键帧动画视图
        keyframeAnimationView = createAnimationView(color: .systemOrange, title: "关键帧动画")

        // 变换动画视图
        transformAnimationView = createAnimationView(color: .systemPurple, title: "变换动画")

        // 淡入淡出动画视图
        fadeAnimationView = createAnimationView(color: .systemRed, title: "淡入淡出")

        // 形状层动画视图
        shapeLayerAnimationView = createAnimationView(color: .systemTeal, title: "形状动画")

        // 隐藏原来的正方形，只显示自定义的圆形动画
        if let animationBox = shapeLayerAnimationView.subviews.last {
            animationBox.isHidden = true
        }

        setupShapeLayer()

        contentView.addSubview(basicAnimationView)
        contentView.addSubview(springAnimationView)
        contentView.addSubview(keyframeAnimationView)
        contentView.addSubview(transformAnimationView)
        contentView.addSubview(fadeAnimationView)
        contentView.addSubview(shapeLayerAnimationView)
    }

    /// 创建动画展示视图
    /// - Parameters:
    ///   - color: 视图颜色
    ///   - title: 标题
    /// - Returns: 配置好的视图
    private func createAnimationView(color: UIColor, title: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.textAlignment = .center

        let animationBox = UIView()
        animationBox.backgroundColor = color
        animationBox.layer.cornerRadius = 8

        containerView.addSubview(titleLabel)
        containerView.addSubview(animationBox)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        animationBox.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }

        return containerView
    }

    /// 设置形状层
    private func setupShapeLayer() {
        circleLayer = CAShapeLayer()

        // 延迟添加到视图，确保视图已经创建完成
        DispatchQueue.main.async {
            // 获取容器视图的中心点
            let containerBounds = self.shapeLayerAnimationView.bounds
            let center = CGPoint(x: containerBounds.width / 2, y: containerBounds.height / 2)

            let circlePath = UIBezierPath(arcCenter: center,
                                        radius: 25,
                                        startAngle: 0,
                                        endAngle: 2 * .pi,
                                        clockwise: true)
            self.circleLayer.path = circlePath.cgPath
            self.circleLayer.fillColor = UIColor.clear.cgColor
            self.circleLayer.strokeColor = UIColor.systemTeal.cgColor
            self.circleLayer.lineWidth = 4
            self.circleLayer.lineCap = .round

            // 直接添加到容器视图的图层
            self.shapeLayerAnimationView.layer.addSublayer(self.circleLayer)
        }
    }

    /// 设置控制按钮
    private func setupButtons() {
        basicAnimationButton = createButton(title: "基础动画", action: #selector(performBasicAnimation))
        springAnimationButton = createButton(title: "弹簧动画", action: #selector(performSpringAnimation))
        keyframeAnimationButton = createButton(title: "关键帧动画", action: #selector(performKeyframeAnimation))
        transformAnimationButton = createButton(title: "变换动画", action: #selector(performTransformAnimation))
        fadeAnimationButton = createButton(title: "淡入淡出", action: #selector(performFadeAnimation))
        shapeLayerAnimationButton = createButton(title: "形状动画", action: #selector(performShapeLayerAnimation))

        contentView.addSubview(basicAnimationButton)
        contentView.addSubview(springAnimationButton)
        contentView.addSubview(keyframeAnimationButton)
        contentView.addSubview(transformAnimationButton)
        contentView.addSubview(fadeAnimationButton)
        contentView.addSubview(shapeLayerAnimationButton)
    }

    /// 创建按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - action: 按钮点击事件
    /// - Returns: 配置好的按钮
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.themeColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    /// 设置约束布局
    private func setupConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // 基础动画 - 第一行
        basicAnimationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(180)
        }

        basicAnimationButton.snp.makeConstraints { make in
            make.top.equalTo(basicAnimationView.snp.bottom).offset(12)
            make.centerX.equalTo(basicAnimationView)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        // 弹簧动画 - 第二行
        springAnimationView.snp.makeConstraints { make in
            make.top.equalTo(basicAnimationButton.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(basicAnimationView)
        }

        springAnimationButton.snp.makeConstraints { make in
            make.top.equalTo(springAnimationView.snp.bottom).offset(12)
            make.centerX.width.height.equalTo(basicAnimationButton)
        }

        // 关键帧动画 - 第三行
        keyframeAnimationView.snp.makeConstraints { make in
            make.top.equalTo(springAnimationButton.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(basicAnimationView)
        }

        keyframeAnimationButton.snp.makeConstraints { make in
            make.top.equalTo(keyframeAnimationView.snp.bottom).offset(12)
            make.centerX.width.height.equalTo(basicAnimationButton)
        }

        // 变换动画 - 第四行
        transformAnimationView.snp.makeConstraints { make in
            make.top.equalTo(keyframeAnimationButton.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(basicAnimationView)
        }

        transformAnimationButton.snp.makeConstraints { make in
            make.top.equalTo(transformAnimationView.snp.bottom).offset(12)
            make.centerX.width.height.equalTo(basicAnimationButton)
        }

        // 淡入淡出动画 - 第五行
        fadeAnimationView.snp.makeConstraints { make in
            make.top.equalTo(transformAnimationButton.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(basicAnimationView)
        }

        fadeAnimationButton.snp.makeConstraints { make in
            make.top.equalTo(fadeAnimationView.snp.bottom).offset(12)
            make.centerX.width.height.equalTo(basicAnimationButton)
        }

        // 形状层动画 - 第六行
        shapeLayerAnimationView.snp.makeConstraints { make in
            make.top.equalTo(fadeAnimationButton.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(basicAnimationView)
        }

        shapeLayerAnimationButton.snp.makeConstraints { make in
            make.top.equalTo(shapeLayerAnimationView.snp.bottom).offset(12)
            make.centerX.width.height.equalTo(basicAnimationButton)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    // MARK: - 动画方法

    /// 基础动画 - 位置移动
    @objc private func performBasicAnimation() {
        guard let animationBox = basicAnimationView.subviews.last else { return }

        // 重置位置
        animationBox.transform = .identity

        UIView.animate(withDuration: 0.8,
                      delay: 0,
                      options: [.curveEaseInOut],
                      animations: {
            animationBox.transform = CGAffineTransform(translationX: 60, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.8,
                          delay: 0,
                          options: [.curveEaseInOut],
                          animations: {
                animationBox.transform = .identity
            })
        }
    }

    /// 弹簧动画 - 缩放效果
    @objc private func performSpringAnimation() {
        guard let animationBox = springAnimationView.subviews.last else { return }

        // 重置状态
        animationBox.transform = .identity

        UIView.animate(withDuration: 0.8,
                      delay: 0,
                      usingSpringWithDamping: 0.2,
                      initialSpringVelocity: 1.0,
                      options: [.curveEaseInOut],
                      animations: {
            animationBox.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }) { _ in
            UIView.animate(withDuration: 0.5,
                          delay: 0,
                          usingSpringWithDamping: 0.7,
                          initialSpringVelocity: 0.5,
                          options: []) {
                animationBox.transform = .identity
            }
        }
    }

    /// 关键帧动画 - 路径移动
    @objc private func performKeyframeAnimation() {
        guard let animationBox = keyframeAnimationView.subviews.last else { return }

        // 重置位置
        animationBox.transform = .identity

        UIView.animateKeyframes(withDuration: 2.0,
                               delay: 0,
                               options: [.calculationModeLinear]) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                animationBox.transform = CGAffineTransform(translationX: 50, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                animationBox.transform = CGAffineTransform(translationX: 50, y: -30)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                animationBox.transform = CGAffineTransform(translationX: 0, y: -30)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                animationBox.transform = .identity
            }
        }
    }

    /// 变换动画 - 旋转、缩放、倾斜组合
    @objc private func performTransformAnimation() {
        guard let animationBox = transformAnimationView.subviews.last else { return }

        // 重置状态
        animationBox.transform = .identity

        // 第一阶段：旋转 + 放大
        UIView.animate(withDuration: 0.6,
                      delay: 0,
                      options: [.curveEaseOut],
                      animations: {
            let rotation = CGAffineTransform(rotationAngle: .pi)
            let scale = CGAffineTransform(scaleX: 1.5, y: 1.5)
            animationBox.transform = rotation.concatenating(scale)
        }) { _ in
            // 第二阶段：继续旋转 + 缩小 + 倾斜
            UIView.animate(withDuration: 0.8,
                          delay: 0,
                          options: [.curveEaseInOut],
                          animations: {
                let rotation = CGAffineTransform(rotationAngle: 3 * .pi)
                let scale = CGAffineTransform(scaleX: 0.2, y: 0.2)
                let skew = CGAffineTransform(a: 1, b: 0.3, c: 0.3, d: 1, tx: 0, ty: 0)
                animationBox.transform = rotation.concatenating(scale).concatenating(skew)
            }) { _ in
                // 第三阶段：弹簧恢复
                UIView.animate(withDuration: 1.0,
                              delay: 0,
                              usingSpringWithDamping: 0.4,
                              initialSpringVelocity: 1.0,
                              options: [.curveEaseOut]) {
                    animationBox.transform = .identity
                }
            }
        }
    }

    /// 淡入淡出动画
    @objc private func performFadeAnimation() {
        guard let animationBox = fadeAnimationView.subviews.last else { return }

        // 重置透明度
        animationBox.alpha = 1.0

        UIView.animate(withDuration: 0.8,
                      delay: 0,
                      options: [.curveEaseInOut],
                      animations: {
            animationBox.alpha = 0.0
            animationBox.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.8,
                          delay: 0,
                          options: [.curveEaseOut]) {
                animationBox.alpha = 1.0
                animationBox.transform = .identity
            }
        }
    }

    /// 形状层动画 - 描边动画
    @objc private func performShapeLayerAnimation() {
        // 移除之前的动画
        circleLayer.removeAllAnimations()

        // 重置初始状态
        circleLayer.strokeEnd = 0.0
        circleLayer.transform = CATransform3DIdentity

        // 创建描边动画
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.duration = 2.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // 创建旋转动画
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 2.0

        // 创建颜色变化动画
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = UIColor.systemTeal.cgColor
        colorAnimation.toValue = UIColor.systemPink.cgColor
        colorAnimation.duration = 2.0

        // 创建动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeAnimation, rotationAnimation, colorAnimation]
        animationGroup.duration = 2.0
        animationGroup.repeatCount = 1
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        // 添加动画完成回调
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // 动画完成后重置状态
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.circleLayer.removeAllAnimations()
                self.circleLayer.strokeEnd = 1.0
                self.circleLayer.strokeColor = UIColor.systemTeal.cgColor
                self.circleLayer.transform = CATransform3DIdentity
            }
        }

        // 添加动画
        circleLayer.add(animationGroup, forKey: "shapeAnimation")
        CATransaction.commit()
    }
}
