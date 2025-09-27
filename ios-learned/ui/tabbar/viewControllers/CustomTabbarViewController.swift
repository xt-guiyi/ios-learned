//
//  CustomTabbarViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit

/// 自定义TabBar控制器实现 - 继承自CustomTabBarController基类
class CustomTabbarViewController: CustomTabBarController {

    /// 重写setupTabBarItems方法，提供具体的TabBar项目配置
    override func setupTabBarItems() {
        // 创建TabBar项目配置
        let items = [
            CustomTabBarItemModel(
                title: "控件",
                normalImage: UIImage.home,
                selectedImage: UIImage.homeSelect,
                viewController: HomeRootViewController()
            ),
            CustomTabBarItemModel(
                title: "进阶",
                normalImage: UIImage.function,
                selectedImage: UIImage.functionSelect,
                viewController: FunctionRootViewController()
            ),
            CustomTabBarItemModel(
                title: "案例库",
                normalImage: UIImage.third,
                selectedImage: UIImage.thirdSelect,
                viewController: ThirdRootViewController()
            )
        ]

        // 配置TabBar
        configureTabBar(with: items)
    }

    /// 可选：重写UI设置方法进行个性化定制
    override func setupUI() {
        super.setupUI()

        // 可以在这里添加特定的UI定制
        view.backgroundColor = .white

        // 自定义TabBar高度
        customTabBar.snp.updateConstraints { make in
            make.height.equalTo(85 + view.safeAreaInsets.bottom)
        }
    }

    /// 可选：重写切换动画，提供自定义动画效果
    // override func addTransitionAnimation() {
    //     guard let currentView = currentViewController?.view else { return }

    //     // 自定义动画效果 - 移除平移，仅保留淡入和缩放
    //     currentView.alpha = 0
    //     currentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

    //     UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
    //         currentView.alpha = 1
    //         currentView.transform = CGAffineTransform.identity
    //     }
    // }

    /// 可选：重写TabBar选中回调，添加自定义逻辑
    override func customTabBar(_ tabBar: CustomTabBar, didSelectItemAt index: Int) {
        // 调用父类方法执行切换
        super.customTabBar(tabBar, didSelectItemAt: index)

        // 添加自定义逻辑，比如统计、日志等
        print("选中了第 \(index) 个TabBar项目")

        // 可以在这里添加震动反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}
