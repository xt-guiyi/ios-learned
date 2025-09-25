import UIKit
import SnapKit

/// 手势操作示例页面
/// 展示iOS提供的各种手势识别器的使用方法
class GestureViewController: UIViewController {

    private var customNavigationBar: CustomNavigationBar!
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    // 手势展示区域
    private var tapView: UIView!
    private var longPressView: UIView!
    private var panView: UIView!
    private var pinchView: UIView!
    private var rotationView: UIView!
    private var swipeView: UIView!

    // 状态标签
    private var gestureStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // 创建自定义导航栏
        customNavigationBar = CustomNavigationBar()
        customNavigationBar.configure(title: "手势操作示例") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(customNavigationBar)
         customNavigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        // 创建滚动视图
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear

        contentView = UIView()
        contentView.backgroundColor = .clear

        // 创建状态标签
        gestureStatusLabel = UILabel()
        gestureStatusLabel.text = "触摸上方区域体验不同手势"
        gestureStatusLabel.textAlignment = .center
        gestureStatusLabel.font = UIFont.systemFont(ofSize: 16)
        gestureStatusLabel.textColor = .systemBlue
        gestureStatusLabel.numberOfLines = 0

        // 创建手势展示区域
        createGestureViews()

        // 添加子视图
        view.addSubview(customNavigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(gestureStatusLabel)
        contentView.addSubview(tapView)
        contentView.addSubview(longPressView)
        contentView.addSubview(panView)
        contentView.addSubview(pinchView)
        contentView.addSubview(rotationView)
        contentView.addSubview(swipeView)

        setupConstraints()
    }

    /// 创建手势展示区域
    private func createGestureViews() {
        // 点击手势区域
        tapView = createGestureView(
            title: "点击手势",
            subtitle: "单击/双击此区域",
            backgroundColor: .systemBlue
        )

        // 长按手势区域
        longPressView = createGestureView(
            title: "长按手势",
            subtitle: "长按此区域",
            backgroundColor: .systemGreen
        )

        // 拖拽手势区域
        panView = createGestureView(
            title: "拖拽手势",
            subtitle: "拖拽此区域",
            backgroundColor: .systemOrange
        )

        // 缩放手势区域
        pinchView = createGestureView(
            title: "缩放手势",
            subtitle: "双指捏合/放大",
            backgroundColor: .systemPurple
        )

        // 旋转手势区域
        rotationView = createGestureView(
            title: "旋转手势",
            subtitle: "双指旋转",
            backgroundColor: .systemRed
        )

        // 滑动手势区域
        swipeView = createGestureView(
            title: "滑动手势",
            subtitle: "四个方向滑动",
            backgroundColor: .systemTeal
        )
    }

    /// 创建手势展示视图
    /// - Parameters:
    ///   - title: 标题
    ///   - subtitle: 副标题
    ///   - backgroundColor: 背景色
    /// - Returns: 配置好的视图
    private func createGestureView(title: String, subtitle: String, backgroundColor: UIColor) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = backgroundColor.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = backgroundColor.cgColor

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = backgroundColor
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center

        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }

        return containerView
    }

    /// 设置约束布局
    private func setupConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        gestureStatusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        tapView.snp.makeConstraints { make in
            make.top.equalTo(gestureStatusLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }

        longPressView.snp.makeConstraints { make in
            make.top.equalTo(tapView.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(tapView)
        }

        panView.snp.makeConstraints { make in
            make.top.equalTo(longPressView.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(tapView)
        }

        pinchView.snp.makeConstraints { make in
            make.top.equalTo(panView.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(tapView)
        }

        rotationView.snp.makeConstraints { make in
            make.top.equalTo(pinchView.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(tapView)
        }

        swipeView.snp.makeConstraints { make in
            make.top.equalTo(rotationView.snp.bottom).offset(15)
            make.leading.trailing.height.equalTo(tapView)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    /// 设置手势识别器
    private func setupGestures() {
        // 1. 点击手势 (单击和双击)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        tapView.addGestureRecognizer(singleTap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        tapView.addGestureRecognizer(doubleTap)

        // 设置单击手势等待双击手势失败后再触发
        singleTap.require(toFail: doubleTap)

        // 2. 长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 1.0
        longPressView.addGestureRecognizer(longPress)

        // 3. 拖拽手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panView.addGestureRecognizer(pan)

        // 4. 缩放手势
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchView.addGestureRecognizer(pinch)

        // 5. 旋转手势
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        rotationView.addGestureRecognizer(rotation)

        // 6. 滑动手势 (四个方向)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        swipeView.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        swipeView.addGestureRecognizer(swipeDown)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeView.addGestureRecognizer(swipeRight)

        // 启用用户交互
        tapView.isUserInteractionEnabled = true
        longPressView.isUserInteractionEnabled = true
        panView.isUserInteractionEnabled = true
        pinchView.isUserInteractionEnabled = true
        rotationView.isUserInteractionEnabled = true
        swipeView.isUserInteractionEnabled = true
    }

    // MARK: - 手势处理方法

    /// 处理单击手势
    /// - Parameter gesture: 点击手势识别器
    @objc private func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        updateStatusLabel("检测到单击手势 👆")
        animateView(tapView, color: .systemBlue)
    }

    /// 处理双击手势
    /// - Parameter gesture: 点击手势识别器
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        updateStatusLabel("检测到双击手势 👆👆")
        animateView(tapView, color: .systemBlue, scale: 1.2)
    }

    /// 处理长按手势
    /// - Parameter gesture: 长按手势识别器
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            updateStatusLabel("开始长按 ⏳")
            animateView(longPressView, color: .systemGreen, scale: 0.95)
        case .ended, .cancelled:
            updateStatusLabel("长按结束 ✋")
            animateView(longPressView, color: .systemGreen)
        default:
            break
        }
    }

    /// 处理拖拽手势
    /// - Parameter gesture: 拖拽手势识别器
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: panView)
        let velocity = gesture.velocity(in: panView)

        switch gesture.state {
        case .began:
            updateStatusLabel("开始拖拽 ✋")
        case .changed:
            let direction = abs(velocity.x) > abs(velocity.y) ? "水平" : "垂直"
            updateStatusLabel("拖拽中: \(direction)方向, 距离: (\(Int(translation.x)), \(Int(translation.y)))")

            // 视觉反馈
            panView.transform = CGAffineTransform(translationX: translation.x * 0.1, y: translation.y * 0.1)
        case .ended, .cancelled:
            updateStatusLabel("拖拽结束 🎯")
            UIView.animate(withDuration: 0.3) {
                self.panView.transform = .identity
            }
        default:
            break
        }
    }

    /// 处理缩放手势
    /// - Parameter gesture: 缩放手势识别器
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            updateStatusLabel("开始缩放 🔍")
        case .changed:
            let scale = gesture.scale
            updateStatusLabel("缩放比例: \(String(format: "%.2f", scale))x")
            pinchView.transform = CGAffineTransform(scaleX: scale, y: scale)
        case .ended, .cancelled:
            updateStatusLabel("缩放结束 📐")
            UIView.animate(withDuration: 0.3) {
                self.pinchView.transform = .identity
            }
        default:
            break
        }
    }

    /// 处理旋转手势
    /// - Parameter gesture: 旋转手势识别器
    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            updateStatusLabel("开始旋转 🔄")
        case .changed:
            let rotation = gesture.rotation
            let degrees = rotation * 180 / .pi
            updateStatusLabel("旋转角度: \(String(format: "%.1f", degrees))°")
            rotationView.transform = CGAffineTransform(rotationAngle: rotation)
        case .ended, .cancelled:
            updateStatusLabel("旋转结束 🎪")
            UIView.animate(withDuration: 0.3) {
                self.rotationView.transform = .identity
            }
        default:
            break
        }
    }

    /// 处理滑动手势
    /// - Parameter gesture: 滑动手势识别器
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var direction = ""
        var emoji = ""

        switch gesture.direction {
        case .up:
            direction = "向上"
            emoji = "⬆️"
        case .down:
            direction = "向下"
            emoji = "⬇️"
        case .left:
            direction = "向左"
            emoji = "⬅️"
        case .right:
            direction = "向右"
            emoji = "➡️"
        default:
            direction = "未知"
            emoji = "❓"
        }

        updateStatusLabel("检测到\(direction)滑动 \(emoji)")
        animateView(swipeView, color: .systemTeal)
    }

    /// 更新状态标签
    /// - Parameter text: 要显示的文本
    private func updateStatusLabel(_ text: String) {
        DispatchQueue.main.async {
            self.gestureStatusLabel.text = text

            // 添加文本变化动画
            UIView.transition(with: self.gestureStatusLabel,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil,
                            completion: nil)
        }
    }

    /// 为视图添加动画效果
    /// - Parameters:
    ///   - view: 要添加动画的视图
    ///   - color: 动画颜色
    ///   - scale: 缩放比例，默认为1.0
    private func animateView(_ view: UIView, color: UIColor, scale: CGFloat = 1.0) {
        UIView.animate(withDuration: 0.2,
                      animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
            view.backgroundColor = color.withAlphaComponent(0.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                view.transform = .identity
                view.backgroundColor = color.withAlphaComponent(0.1)
            }
        }
    }
}
