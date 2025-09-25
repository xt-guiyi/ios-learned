//
//  ImageTransitionAnimator.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit

/// 图片转场代理
/// 管理图片无缝转场动画的转场代理
class ImageTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    /// 源图片视图（列表中的小图）
    weak var sourceImageView: UIImageView?

    /// 源图片的frame（在window坐标系中）
    var sourceFrame: CGRect = .zero

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator(transitionType: .present, sourceImageView: sourceImageView, sourceFrame: sourceFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageTransitionAnimator(transitionType: .dismiss, sourceImageView: sourceImageView, sourceFrame: sourceFrame)
    }
}

/// 图片转场动画器
/// 实现图片从列表位置无缝移动到详情页位置的动画效果
class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    /// 转场类型
    enum TransitionType {
        case present // 显示
        case dismiss // 关闭
    }

    // MARK: - Properties

    private let transitionType: TransitionType
    private weak var sourceImageView: UIImageView?
    private let sourceFrame: CGRect
    private let animationDuration: TimeInterval = 0.6

    // MARK: - Initialization

    init(transitionType: TransitionType, sourceImageView: UIImageView?, sourceFrame: CGRect) {
        self.transitionType = transitionType
        self.sourceImageView = sourceImageView
        self.sourceFrame = sourceFrame
        super.init()
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            animatePresentTransition(using: transitionContext)
        case .dismiss:
            animateDismissTransition(using: transitionContext)
        }
    }

    // MARK: - Present Animation

    /// 显示动画
    private func animatePresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let toView = transitionContext.view(forKey: .to),
              let detailVC = toVC as? ImageDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        // 设置目标视图的初始状态
        toView.frame = finalFrame
        toView.alpha = 0

        // 添加到容器视图
        containerView.addSubview(toView)

        // 获取源图片和目标图片
        guard let sourceImage = sourceImageView?.image,
              let sourceImageView = self.sourceImageView else {
            // 如果没有源图片，执行简单的淡入动画
            UIView.animate(withDuration: animationDuration) {
                toView.alpha = 1
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
            return
        }

        // 计算源frame在window坐标系中的位置
        let sourceFrameInWindow = sourceImageView.superview?.convert(sourceImageView.frame, to: nil) ?? sourceFrame

        // 计算目标frame
        let targetImageView = detailVC.imageView
        let targetFrame = calculateTargetFrame(for: targetImageView, in: containerView)

        // 创建临时动画图片视图
        let transitionImageView = UIImageView()
        transitionImageView.image = sourceImage
        transitionImageView.contentMode = sourceImageView.contentMode
        transitionImageView.frame = sourceFrameInWindow
        transitionImageView.clipsToBounds = true
        transitionImageView.layer.cornerRadius = sourceImageView.layer.cornerRadius
        transitionImageView.tintColor = sourceImageView.tintColor
        containerView.addSubview(transitionImageView)

        // 隐藏源图片和目标图片
        sourceImageView.alpha = 0
        targetImageView.alpha = 0

        // 执行动画
        UIView.animate(withDuration: animationDuration,
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0.5,
                      options: [.curveEaseInOut]) {
            // 移动和缩放图片
            transitionImageView.frame = targetFrame
            transitionImageView.layer.cornerRadius = 0

            // 淡入背景和其他元素
            toView.alpha = 1
        } completion: { _ in
            // 清理临时视图
            transitionImageView.removeFromSuperview()

            // 恢复目标图片显示
            targetImageView.alpha = 1

            // 完成转场
            transitionContext.completeTransition(true)
        }
    }

    // MARK: - Dismiss Animation

    /// 关闭动画
    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = transitionContext.view(forKey: .from),
              let detailVC = fromVC as? ImageDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        // 获取目标图片视图和源图片
        guard let targetImage = detailVC.imageView.image,
              let sourceImageView = self.sourceImageView else {
            // 如果没有目标图片，执行简单的淡出动画
            UIView.animate(withDuration: animationDuration) {
                fromView.alpha = 0
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
            return
        }

        // 计算当前图片的frame
        let currentImageView = detailVC.imageView
        let currentFrame = currentImageView.superview?.convert(currentImageView.frame, to: containerView) ?? currentImageView.frame

        // 计算目标frame（回到列表中的位置）
        let targetFrameInWindow = sourceImageView.superview?.convert(sourceImageView.frame, to: nil) ?? sourceFrame

        // 创建临时动画图片视图
        let transitionImageView = UIImageView()
        transitionImageView.image = targetImage
        transitionImageView.contentMode = currentImageView.contentMode
        transitionImageView.frame = currentFrame
        transitionImageView.clipsToBounds = true
        transitionImageView.tintColor = currentImageView.tintColor
        containerView.addSubview(transitionImageView)

        // 隐藏当前图片
        currentImageView.alpha = 0

        // 执行动画
        UIView.animate(withDuration: animationDuration,
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0.5,
                      options: [.curveEaseInOut]) {
            // 移动和缩放图片回到原位置
            transitionImageView.frame = targetFrameInWindow
            transitionImageView.layer.cornerRadius = sourceImageView.layer.cornerRadius

            // 淡出背景和其他元素
            fromView.alpha = 0
        } completion: { _ in
            // 清理临时视图
            transitionImageView.removeFromSuperview()

            // 恢复源图片显示
            sourceImageView.alpha = 1

            // 完成转场
            transitionContext.completeTransition(true)
        }
    }

    // MARK: - Helper Methods

    /// 计算目标图片的frame
    private func calculateTargetFrame(for imageView: UIImageView, in containerView: UIView) -> CGRect {
        // 获取图片的实际显示大小
        guard let image = imageView.image else {
            return CGRect(x: containerView.bounds.midX - 150,
                         y: containerView.bounds.midY - 150,
                         width: 300,
                         height: 300)
        }

        let containerSize = containerView.bounds.size
        let imageSize = image.size

        // 计算保持宽高比的适合大小
        let scale = min(containerSize.width / imageSize.width,
                       containerSize.height / imageSize.height) * 0.8 // 留出边距

        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale

        // 居中显示
        let x = (containerSize.width - scaledWidth) / 2
        let y = (containerSize.height - scaledHeight) / 2

        return CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
    }
}

/// UIView扩展，用于获取在window中的frame
extension UIView {
    /// 获取视图在window坐标系中的frame
    var frameInWindow: CGRect? {
        return superview?.convert(frame, to: nil)
    }

    /// 将frame从一个视图转换到另一个视图的坐标系
    func convert(frame: CGRect, to view: UIView?) -> CGRect {
        return superview?.convert(frame, to: view) ?? frame
    }
}