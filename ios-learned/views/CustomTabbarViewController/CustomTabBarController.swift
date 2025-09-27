//
//  CustomTabBarController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

/// 自定义TabBar主控制器基类 - 开放式设计，可被继承和定制
 class CustomTabBarController: BaseViewController {

    // MAR11 - UI Components

    /// 内容容器视图
    public let contentContainerView: UIView = {
        let view = UIView()
       ///vview.backgroundColor = .red
        return view
    }()

    /// 自定义TabBar视图
    public let customTabBar: CustomTabBar = {
        let tabBar = CustomTabBar()
        return tabBar
    }()

    // MARK: - Properties

    /// 子视图控制器数组
    public var tabChildViewControllers: [UIViewController] = []

    /// 当前显示的视图控制器
    public var currentViewController: UIViewController?

    /// 当前选中索引
    public var selectedIndex: Int = 0

    // MARK: - View Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.themeColor
        setupUI()
        setupTabBar()
        setupTabBarItems()
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Public Methods

    /// 配置TabBar项目和对应的视图控制器
    /// - Parameter items: TabBar项目配置数组
    public func configureTabBar(with items: [CustomTabBarItemModel]) {
        self.tabChildViewControllers = items.map { $0.viewController }
        customTabBar.configureItems(with: items)

        // 显示第一个视图控制器
        if !items.isEmpty {
            showViewController(at: 0)
        }
    }

    /// 选中指定索引的TabBar项目
    /// - Parameter index: 项目索引
    public func selectTabBarItem(at index: Int) {
        customTabBar.selectItem(at: index)
    }

    // MARK: - Private Methods

    /// 设置UI界面
    open func setupUI() {
        view.backgroundColor = UIColor.themeColor

        view.addSubview(contentContainerView)
        view.addSubview(customTabBar)

        contentContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(customTabBar.snp.top)
        }

        customTabBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(80 + view.safeAreaInsets.bottom)
        }
    }

    /// 设置TabBar代理
    open func setupTabBar() {
        customTabBar.delegate = self
    }

    /// 设置TabBar项目 - 子类必须重写此方法来提供具体的TabBar项目
    open func setupTabBarItems() {
        fatalError("子类必须重写 setupTabBarItems() 方法来提供具体的TabBar项目")
    }

    /// 显示指定索引的视图控制器
    /// - Parameter index: 视图控制器索引
    open func showViewController(at index: Int) {
        guard index >= 0 && index < tabChildViewControllers.count else { return }

        let targetViewController = tabChildViewControllers[index]

        // 如果是同一个控制器，不需要切换
        if currentViewController === targetViewController {
            return
        }

        // 移除当前控制器
        if let current = currentViewController {
            removeTabChildViewController(current)
        }

        // 添加新控制器
        addTabChildViewController(targetViewController)
        currentViewController = targetViewController
        selectedIndex = index

        // 添加切换动画
        addTransitionAnimation()
    }

    /// 添加子视图控制器
    /// - Parameter viewController: 要添加的视图控制器
    open func addTabChildViewController(_ viewController: UIViewController) {
        addChild(viewController)
        contentContainerView.addSubview(viewController.view)

        viewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }

        viewController.didMove(toParent: self)
    }

    /// 移除子视图控制器
    /// - Parameter viewController: 要移除的视图控制器
    open func removeTabChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    /// 添加切换动画效果
    open func addTransitionAnimation() {
        // guard let currentView = currentViewController?.view else { return }

        // // 设置初始状态
        // currentView.alpha = 0
        // currentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        // // 执行进入动画
        // UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
        //     currentView.alpha = 1
        //     currentView.transform = CGAffineTransform.identity
        // }
    }

    /// TabBar项目选中回调
    /// - Parameters:
    ///   - tabBar: TabBar视图
    ///   - index: 选中的项目索引
    open func customTabBar(_ tabBar: CustomTabBar, didSelectItemAt index: Int) {
        showViewController(at: index)
    }
}

// MARK: - CustomTabBarDelegate

extension CustomTabBarController: CustomTabBarDelegate {}
