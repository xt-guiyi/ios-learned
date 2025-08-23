//
//  ViewController+Extension.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//


import UIKit

extension UIViewController {
    
    
    /// 添加子控制器
    /// - Parameters:
    ///   - childViewController: 子控制器
    ///   - layoutCallback: 布局回调
    func addChild(childViewController: UIViewController?, layoutCallback: (_ view: UIView) -> Void) {
        guard let childViewController = childViewController else { return }
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        layoutCallback(childViewController.view)
    }
    
}
