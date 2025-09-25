//
//  CustomTransitionViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

class CustomTransitionViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var listViewController: CardListViewController?

    // 强引用转场代理，防止被释放
    private var currentTransitionDelegate: NSObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置UI界面
    private func setupUI() {
        setupNavigationBar()
        setupListViewController()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "自定义转场") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置自定义转场示例列表
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller

        let customTransitionData = [
          ListItemModel(title: "滑动转场", subtitle: "自定义滑动转场动画") { [weak self] in
                self?.showSlideTransition()
            },
            ListItemModel(title: "淡入缩放", subtitle: "淡入同时缩放的转场效果") { [weak self] in
                self?.showFadeScaleTransition()
            },
            ListItemModel(title: "旋转转场", subtitle: "3D旋转转场动画") { [weak self] in
                self?.showRotationTransition()
            },
            ListItemModel(title: "圆形扩散", subtitle: "从圆形扩散的转场效果") { [weak self] in
                self?.showCircularTransition()
            },
            ListItemModel(title: "交互式转场", subtitle: "支持手势的交互式转场") { [weak self] in
                self?.showInteractiveTransition()
            },
            ListItemModel(title: "卡片展开", subtitle: "卡片式展开转场动画") { [weak self] in
                self?.showCardTransition()
            }
        ]

        controller.updateData(customTransitionData)

        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - 自定义转场方法

    /// 滑动转场
    private func showSlideTransition() {
        let detailVc = CustomTransitionDetailViewController(
            title: "滑动转场",
            backgroundColor: UIColor.systemBlue,
            transitionType: .slide
        )
        let transitionDelegate = SlideTransitionDelegate()
        currentTransitionDelegate = transitionDelegate
        detailVc.transitioningDelegate = transitionDelegate
        detailVc.modalPresentationStyle = .custom
        present(detailVc, animated: true)
    }

    /// 淡入缩放转场
    private func showFadeScaleTransition() {
        let detailVc = CustomTransitionDetailViewController(
            title: "淡入缩放转场",
            backgroundColor: UIColor.systemGreen,
            transitionType: .fadeScale
        )
        let transitionDelegate = FadeScaleTransitionDelegate()
        currentTransitionDelegate = transitionDelegate
        detailVc.transitioningDelegate = transitionDelegate
        detailVc.modalPresentationStyle = .custom
        present(detailVc, animated: true)
    }

    /// 旋转转场
    private func showRotationTransition() {
        let detailVc = CustomTransitionDetailViewController(
            title: "旋转转场",
            backgroundColor: UIColor.systemPurple,
            transitionType: .rotation
        )
        let transitionDelegate = RotationTransitionDelegate()
        currentTransitionDelegate = transitionDelegate
        detailVc.transitioningDelegate = transitionDelegate
        detailVc.modalPresentationStyle = .custom
        present(detailVc, animated: true)
    }

    /// 圆形扩散转场
    private func showCircularTransition() {
        let detailVc = CustomTransitionDetailViewController(
            title: "圆形扩散转场",
            backgroundColor: UIColor.systemOrange,
            transitionType: .circular
        )
        let transitionDelegate = CircularTransitionDelegate()
        currentTransitionDelegate = transitionDelegate
        detailVc.transitioningDelegate = transitionDelegate
        detailVc.modalPresentationStyle = .custom
        present(detailVc, animated: true)
    }

    /// 交互式转场
    private func showInteractiveTransition() {
        let detailVc = CustomTransitionDetailViewController(
            title: "交互式转场",
            backgroundColor: UIColor.systemRed,
            transitionType: .interactive
        )
        let interactiveDelegate = InteractiveTransitionDelegate()
        currentTransitionDelegate = interactiveDelegate
        detailVc.transitioningDelegate = interactiveDelegate
        detailVc.modalPresentationStyle = .custom

        // 添加交互手势
        interactiveDelegate.attachToViewController(detailVc)

        present(detailVc, animated: true)
    }

    /// 卡片转场
    private func showCardTransition() {
        let detailVc = CustomTransitionDetailViewController(
            title: "卡片展开转场",
            backgroundColor: UIColor.systemTeal,
            transitionType: .card
        )
        let transitionDelegate = CardTransitionDelegate()
        currentTransitionDelegate = transitionDelegate
        detailVc.transitioningDelegate = transitionDelegate
        detailVc.modalPresentationStyle = .custom
        present(detailVc, animated: true)
    }
}

// MARK: - 转场类型枚举
enum TransitionType {
    case slide, fadeScale, rotation, circular, interactive, card
}

// MARK: - 详情页面
class CustomTransitionDetailViewController: UIViewController {

    private let transitionType: TransitionType
    private let titleText: String
    private let backgroundColorValue: UIColor

    init(title: String, backgroundColor: UIColor, transitionType: TransitionType) {
        self.titleText = title
        self.backgroundColorValue = backgroundColor
        self.transitionType = transitionType
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
        view.backgroundColor = backgroundColorValue

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // 描述
        let descriptionLabel = UILabel()
        descriptionLabel.text = getDescription()
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // 关闭按钮
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 25
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        closeButton.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        view.addSubview(closeButton)

        // 设置约束
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(40)
        }

        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }

        // 为交互式转场添加特殊提示
        if transitionType == .interactive {
            addInteractiveInstructions()
        }
    }

    private func getDescription() -> String {
        switch transitionType {
        case .slide:
            return "这是自定义滑动转场动画\n页面从右侧滑入"
        case .fadeScale:
            return "这是淡入缩放转场动画\n页面淡入的同时进行缩放"
        case .rotation:
            return "这是3D旋转转场动画\n页面以3D旋转方式进入"
        case .circular:
            return "这是圆形扩散转场动画\n从圆心向外扩散显示页面"
        case .interactive:
            return "这是交互式转场动画\n支持手势控制转场进度\n可以拖拽下方的控制条"
        case .card:
            return "这是卡片展开转场动画\n模拟卡片展开的效果"
        }
    }

    private func addInteractiveInstructions() {
        let gestureView = UIView()
        gestureView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        gestureView.layer.cornerRadius = 20
        view.addSubview(gestureView)

        let gestureLabel = UILabel()
        gestureLabel.text = "拖拽这里体验交互"
        gestureLabel.font = UIFont.systemFont(ofSize: 14)
        gestureLabel.textColor = .white
        gestureLabel.textAlignment = .center
        gestureView.addSubview(gestureLabel)

        gestureView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-150)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }

        gestureLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func closeViewController() {
        dismiss(animated: true)
    }
}

// MARK: - 滑动转场代理
class SlideTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimator()
    }
}

// MARK: - 滑入动画器
class SlideInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        // 设置初始位置
        toView.frame = containerView.bounds
        toView.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0.5) {
            toView.transform = CGAffineTransform.identity
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 滑出动画器
class SlideOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.transform = CGAffineTransform(translationX: containerView.bounds.width, y: 0)
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 淡入缩放转场代理
class FadeScaleTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeScaleInAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeScaleOutAnimator()
    }
}

// MARK: - 淡入缩放动画器
class FadeScaleInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        toView.frame = containerView.bounds
        toView.alpha = 0
        toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                      delay: 0,
                      usingSpringWithDamping: 0.7,
                      initialSpringVelocity: 0.5) {
            toView.alpha = 1
            toView.transform = CGAffineTransform.identity
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 淡出缩放动画器
class FadeScaleOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.alpha = 0
            fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 旋转转场代理
class RotationTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RotationInAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RotationOutAnimator()
    }
}

// MARK: - 旋转入场动画器
class RotationInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        toView.frame = containerView.bounds
        toView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0.5) {
            toView.layer.transform = CATransform3DIdentity
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 旋转退场动画器
class RotationOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 圆形转场代理
class CircularTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularInAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularOutAnimator()
    }
}

// MARK: - 圆形入场动画器
class CircularInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        toView.frame = containerView.bounds

        // 创建圆形遮罩
        let center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
        let initialRadius: CGFloat = 0
        let finalRadius = sqrt(pow(containerView.bounds.width, 2) + pow(containerView.bounds.height, 2))

        let initialPath = UIBezierPath(arcCenter: center, radius: initialRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let finalPath = UIBezierPath(arcCenter: center, radius: finalRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)

        let maskLayer = CAShapeLayer()
        maskLayer.path = initialPath.cgPath
        toView.layer.mask = maskLayer

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        maskLayer.add(animation, forKey: "pathAnimation")
        maskLayer.path = finalPath.cgPath

        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration(using: transitionContext)) {
            toView.layer.mask = nil
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: - 圆形退场动画器
class CircularOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        let center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
        let initialRadius = sqrt(pow(containerView.bounds.width, 2) + pow(containerView.bounds.height, 2))
        let finalRadius: CGFloat = 0

        let initialPath = UIBezierPath(arcCenter: center, radius: initialRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let finalPath = UIBezierPath(arcCenter: center, radius: finalRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)

        let maskLayer = CAShapeLayer()
        maskLayer.path = initialPath.cgPath
        fromView.layer.mask = maskLayer

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = initialPath.cgPath
        animation.toValue = finalPath.cgPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        maskLayer.add(animation, forKey: "pathAnimation")
        maskLayer.path = finalPath.cgPath

        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration(using: transitionContext)) {
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: - 交互式转场代理
class InteractiveTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private var interactionController: UIPercentDrivenInteractiveTransition?

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimator()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    func attachToViewController(_ viewController: UIViewController) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        viewController.view.addGestureRecognizer(gesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }

        let translation = gesture.translation(in: view)
        let progress = translation.x / view.bounds.width

        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            if let viewController = view.findViewController() {
                viewController.dismiss(animated: true)
            }
        case .changed:
            interactionController?.update(max(0, progress))
        case .ended, .cancelled:
            if progress > 0.3 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }
}

// MARK: - 卡片转场代理
class CardTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardInAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardOutAnimator()
    }
}

// MARK: - 卡片入场动画器
class CardInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        toView.frame = containerView.bounds
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: containerView.bounds.height))
        toView.layer.cornerRadius = 20
        toView.alpha = 0.8

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0.5) {
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
            toView.layer.cornerRadius = 0
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - 卡片退场动画器
class CardOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: containerView.bounds.height))
            fromView.alpha = 0
            fromView.layer.cornerRadius = 20
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

// MARK: - UIView 扩展
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}