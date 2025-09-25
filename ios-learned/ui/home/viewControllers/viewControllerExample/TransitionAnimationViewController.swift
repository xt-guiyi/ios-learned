//
//  TransitionAnimationViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

class TransitionAnimationViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var listViewController: CardListViewController?

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
        navigationBar.configure(title: "转场动画") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置转场动画列表
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller

        let transitionData = [
            ListItemModel(title: "Push动画", subtitle: "默认推入动画效果") { [weak self] in
                self?.showPushAnimation()
            },
            ListItemModel(title: "Present模态", subtitle: "模态弹出动画效果") { [weak self] in
                self?.showPresentAnimation()
            },
            ListItemModel(title: "淡入淡出", subtitle: "CrossDissolve转场效果") { [weak self] in
                self?.showCrossDissolveAnimation()
            },
            ListItemModel(title: "翻页效果", subtitle: "FlipHorizontal转场效果") { [weak self] in
                self?.showFlipAnimation()
            },
            ListItemModel(title: "卷曲效果", subtitle: "CurlUp转场效果") { [weak self] in
                self?.showCurlAnimation()
            },
            ListItemModel(title: "自定义动画", subtitle: "自定义转场动画实现") { [weak self] in
                self?.showCustomAnimation()
            }
        ]

        controller.updateData(transitionData)

        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - 转场动画方法

    /// Push动画
    private func showPushAnimation() {
        let detailVc = createDetailViewController(title: "Push动画",
                                                backgroundColor: UIColor.systemBlue,
                                                description: "这是默认的Push动画效果\n从右侧推入，带有滑动效果")
        navigationController?.pushViewController(detailVc, animated: true)
    }

    /// Present模态动画
    private func showPresentAnimation() {
        let detailVc = createDetailViewController(title: "Present模态",
                                                backgroundColor: UIColor.systemGreen,
                                                description: "这是模态弹出动画效果\n从底部弹出，覆盖当前页面")
        detailVc.modalPresentationStyle = .pageSheet
        present(detailVc, animated: true)
    }

    /// 淡入淡出动画
    private func showCrossDissolveAnimation() {
        let detailVc = createDetailViewController(title: "淡入淡出",
                                                backgroundColor: UIColor.systemPurple,
                                                description: "CrossDissolve转场效果\n渐显渐隐的平滑过渡")
        detailVc.modalTransitionStyle = .crossDissolve
        detailVc.modalPresentationStyle = .fullScreen
        present(detailVc, animated: true)
    }

    /// 翻页动画
    private func showFlipAnimation() {
        let detailVc = createDetailViewController(title: "翻页效果",
                                                backgroundColor: UIColor.systemOrange,
                                                description: "FlipHorizontal转场效果\n水平翻转页面切换")
        detailVc.modalTransitionStyle = .flipHorizontal
        detailVc.modalPresentationStyle = .fullScreen
        present(detailVc, animated: true)
    }

    /// 卷曲动画
    private func showCurlAnimation() {
        let detailVc = createDetailViewController(title: "卷曲效果",
                                                backgroundColor: UIColor.systemRed,
                                                description: "PartialCurl转场效果\n页面向上卷曲显示下层内容")
        detailVc.modalTransitionStyle = .partialCurl
        detailVc.modalPresentationStyle = .fullScreen
        present(detailVc, animated: true)
    }

    /// 自定义动画
    private func showCustomAnimation() {
        let detailVc = createDetailViewController(title: "自定义动画",
                                                backgroundColor: UIColor.systemTeal,
                                                description: "自定义转场动画\n使用UIView动画实现缩放效果")

        // 设置初始状态
        detailVc.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        detailVc.view.alpha = 0

        present(detailVc, animated: false) {
            // 执行自定义动画
            UIView.animate(withDuration: 0.5,
                         delay: 0,
                         usingSpringWithDamping: 0.7,
                         initialSpringVelocity: 0.5) {
                detailVc.view.transform = CGAffineTransform.identity
                detailVc.view.alpha = 1
            }
        }
    }

    // MARK: - 辅助方法

    /// 创建详情页面
    private func createDetailViewController(title: String, backgroundColor: UIColor, description: String) -> TransitionDetailViewController {
        let detailVc = TransitionDetailViewController()
        detailVc.configure(title: title, backgroundColor: backgroundColor, description: description)
        return detailVc
    }

}

// MARK: - 转场详情页面
class TransitionDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// 配置页面内容
    func configure(title: String, backgroundColor: UIColor, description: String) {
        view.backgroundColor = backgroundColor

        // 添加标题标签
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // 添加描述标签
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // 添加关闭按钮
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 25
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        // 确保按钮可以响应触摸事件
        closeButton.isUserInteractionEnabled = true
        closeButton.isEnabled = true

        // 添加调试信息
        closeButton.accessibilityIdentifier = "closeButton"
        print("🔴 关闭按钮已创建并添加target，target: \(self)")

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
    }

    /// 关闭按钮点击事件
    @objc private func closeButtonTapped() {
        print("🔴 关闭按钮被点击了!")

        // 检查是否是通过navigationController推入的
        if let navigationController = navigationController,
           navigationController.viewControllers.count > 1 {
            // 如果是Push进来的，使用pop返回
            print("🔴 使用navigationController.popViewController")
            navigationController.popViewController(animated: true)
        } else {
            // 如果是Present进来的，使用dismiss关闭
            print("🔴 使用dismiss，当前转场样式: \(modalTransitionStyle.rawValue)")

            // 对于特殊的转场样式，使用特殊处理避免冲突
            if modalTransitionStyle == .flipHorizontal || modalTransitionStyle == .partialCurl {
                print("🔴 检测到特殊转场样式，使用延迟无动画关闭")
                // 添加短暂延迟确保当前动画状态稳定
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.dismiss(animated: false)
                }
            } else {
                dismiss(animated: true)
            }
        }
    }
}