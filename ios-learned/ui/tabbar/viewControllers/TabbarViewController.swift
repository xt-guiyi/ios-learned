//
//  TabbarViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit

class TabbarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 设置底部导航栏样式
    setupTabBarAppearance()
    
    // 首页
    let homeVC = HomeRootViewController()
    addChildViewController(
      childViewController: homeVC, title: "控件", image: UIImage.home, selectImage: UIImage.homeSelect
    )
    // 功能
    let functionVC = FunctionRootViewController()
    addChildViewController(
      childViewController: functionVC, title: "进阶", image: UIImage.function,
      selectImage: UIImage.functionSelect)
    // 第三方
    let thirdVC = ThirdRootViewController()
    addChildViewController(
      childViewController: thirdVC, title: "案例库", image: UIImage.third,
      selectImage: UIImage.thirdSelect)
  }
  
  private func setupTabBarAppearance() {
    // 设置 TabBar 背景为白色
    tabBar.backgroundColor = .white
    tabBar.barTintColor = .white
  }

  // 添加导航项子控制器
  private func addChildViewController(
    childViewController: UIViewController, title: String?, image: UIImage? = nil,
    selectImage: UIImage? = nil
  ) {
    // 创建TabBarItem
    let tabItem = UITabBarItem()
    tabItem.title = title
    tabItem.image = image?.resized(to: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
    tabItem.selectedImage = selectImage?.resized(to: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
    
    // 统一调整所有图标的位置，给顶部留出更多空间
    tabItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
    tabItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
    
    if title != nil {
      // 设置标题颜色
      tabItem.setTitleTextAttributes(
        [
          NSAttributedString.Key.foregroundColor: UIColor.black,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
        ], for: UIControl.State.normal)
      tabItem.setTitleTextAttributes(
        [
          NSAttributedString.Key.foregroundColor: UIColor.themeColor,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
        ], for: UIControl.State.selected)
    }
    
    // 设置控制器的TabBarItem
    childViewController.tabBarItem = tabItem
    
    // 添加子控制器
    addChild(childViewController)
  }
}
