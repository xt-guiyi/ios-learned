//
//  BaseViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import os

/// 基础视图控制器，为所有视图控制器提供通用功能
/// 包含导航栏配置、弹窗提示、加载状态等基础功能
class BaseViewController: UIViewController {

    // MARK: - Properties

    /// 日志记录器，子类不可修改
    public final lazy var logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "app", category: String(describing: type(of: self)))

    /// 加载状态标识，防止重复显示loading
    private var isLoadingPresented = false

    // MARK: - Lifecycle Methods

    /// 视图加载完成后调用，进行基础UI配置
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

 

    // MARK: - Public Alert Methods

    /// 显示简单的提示弹窗
    /// - Parameters:
    ///   - title: 弹窗标题，可为nil
    ///   - message: 弹窗内容，可为nil
    ///   - completion: 点击确定按钮后的回调，可为nil
    func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

    /// 显示确认对话框
    /// - Parameters:
    ///   - title: 弹窗标题，可为nil
    ///   - message: 弹窗内容，可为nil
    ///   - confirmTitle: 确认按钮标题，默认为"确定"
    ///   - cancelTitle: 取消按钮标题，默认为"取消"
    ///   - confirmHandler: 确认按钮点击回调
    ///   - cancelHandler: 取消按钮点击回调，可为nil
    func showConfirmAlert(title: String?,
                         message: String?,
                         confirmTitle: String = "确定",
                         cancelTitle: String = "取消",
                         confirmHandler: @escaping () -> Void,
                         cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler()
        })

        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        })

        present(alert, animated: true)
    }

    /// 显示操作表单弹窗
    /// - Parameters:
    ///   - title: 弹窗标题，可为nil
    ///   - message: 弹窗内容，可为nil
    ///   - actions: 操作按钮数组，格式为(标题, 样式, 点击回调)
    func showActionSheet(title: String?, message: String?, actions: [(String, UIAlertAction.Style, (() -> Void)?)] = []) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for (actionTitle, style, handler) in actions {
            let action = UIAlertAction(title: actionTitle, style: style) { _ in
                handler?()
            }
            actionSheet.addAction(action)
        }

        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(actionSheet, animated: true)
    }

    // MARK: - Loading Methods

    /// 显示加载中弹窗
    /// 包含旋转指示器和"加载中..."文本
    func showLoading() {
        guard !isLoadingPresented else { return }

        let alert = UIAlertController(title: nil, message: "加载中...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        alert.setValue(loadingIndicator, forKey: "accessoryView")

        present(alert, animated: true) { [weak self] in
            self?.isLoadingPresented = true
        }
    }

    /// 显示自定义消息的加载弹窗
    /// - Parameter message: 自定义加载消息
    func showLoading(message: String) {
        guard !isLoadingPresented else { return }

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        alert.setValue(loadingIndicator, forKey: "accessoryView")

        present(alert, animated: true) { [weak self] in
            self?.isLoadingPresented = true
        }
    }

    /// 隐藏加载中弹窗
    func hideLoading() {
        guard isLoadingPresented else { return }

        dismiss(animated: true) { [weak self] in
            self?.isLoadingPresented = false
        }
    }

    // MARK: - Child Controller Management

    /// 添加子控制器到指定容器视图
    /// - Parameters:
    ///   - childController: 要添加的子控制器
    ///   - containerView: 容器视图，默认为当前控制器的主视图
    ///   - constraintsSetup: 约束设置闭包，参数为子控制器的视图
    func addChildController(_ childController: UIViewController,
                           to containerView: UIView? = nil,
                           constraintsSetup: ((UIView) -> Void)? = nil) {
        let container = containerView ?? view

        // 添加子控制器
        addChild(childController)
        container!.addSubview(childController.view)

        // 如果提供了约束设置闭包，则使用它
        if let constraintsSetup = constraintsSetup {
            constraintsSetup(childController.view)
        } else {
            // 默认填满容器
            childController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        // 完成子控制器添加
        childController.didMove(toParent: self)

        logger.debug("添加子控制器: \(String(describing: type(of: childController)))")
    }

    /// 移除指定的子控制器
    /// - Parameter childController: 要移除的子控制器
    func removeChildController(_ childController: UIViewController) {
        guard children.contains(childController) else {
            logger.warning("试图移除不存在的子控制器: \(String(describing: type(of: childController)))")
            return
        }

        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()

        logger.debug("移除子控制器: \(String(describing: type(of: childController)))")
    }

    /// 移除所有子控制器
    func removeAllChildControllers() {
        children.forEach { childController in
            removeChildController(childController)
        }
        logger.debug("移除所有子控制器")
    }

    /// 替换子控制器
    /// - Parameters:
    ///   - oldController: 要替换的旧控制器
    ///   - newController: 新的控制器
    ///   - animated: 是否使用动画
    ///   - constraintsSetup: 新控制器的约束设置
    func replaceChildController(_ oldController: UIViewController,
                               with newController: UIViewController,
                               animated: Bool = false,
                               constraintsSetup: ((UIView) -> Void)? = nil) {
        guard children.contains(oldController) else {
            logger.warning("试图替换不存在的子控制器")
            return
        }

        if animated {
            // 添加新控制器
            addChild(newController)
            view.addSubview(newController.view)

            // 设置新控制器约束
            if let constraintsSetup = constraintsSetup {
                constraintsSetup(newController.view)
            } else {
                newController.view.snp.makeConstraints { make in
                    make.edges.equalTo(oldController.view)
                }
            }

            // 动画过渡
            newController.view.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                oldController.view.alpha = 0
                newController.view.alpha = 1
            }) { _ in
                // 移除旧控制器
                oldController.willMove(toParent: nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParent()

                // 完成新控制器添加
                newController.didMove(toParent: self)

                self.logger.debug("替换子控制器: \(String(describing: type(of: oldController))) -> \(String(describing: type(of: newController)))")
            }
        } else {
            // 无动画替换
            removeChildController(oldController)
            addChildController(newController, constraintsSetup: constraintsSetup)
        }
    }

    // MARK: - Navigation Helper Methods

    /// 执行页面跳转
    /// - Parameter viewController: 要跳转到的视图控制器
    func pushViewController(_ viewController: UIViewController) {
        guard let navigationController = navigationController else {
            present(viewController, animated: true)
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    /// 执行页面返回
    /// - Parameter animated: 是否使用动画，默认为true
    func popViewController(animated: Bool = true) {
        guard let navigationController = navigationController else {
            dismiss(animated: animated)
            return
        }
        navigationController.popViewController(animated: animated)
    }

    /// 返回到指定的视图控制器
    /// - Parameter viewControllerType: 目标视图控制器类型
    func popToViewController<T: UIViewController>(ofType viewControllerType: T.Type) {
        guard let navigationController = navigationController else { return }

        for viewController in navigationController.viewControllers {
            if viewController.isKind(of: viewControllerType) {
                navigationController.popToViewController(viewController, animated: true)
                return
            }
        }
    }

    // MARK: - Modal Navigation Methods

    /// 模态展示视图控制器
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - style: 展示样式，默认为 .automatic
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 展示完成后的回调
    func presentModal(_ viewController: UIViewController,
                     style: UIModalPresentationStyle = .automatic,
                     animated: Bool = true,
                     completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = style
        present(viewController, animated: animated, completion: completion)
    }

    /// 全屏模态展示视图控制器
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 展示完成后的回调
    func presentFullScreen(_ viewController: UIViewController,
                          animated: Bool = true,
                          completion: (() -> Void)? = nil) {
        presentModal(viewController, style: .fullScreen, animated: animated, completion: completion)
    }

    /// 页面表单样式模态展示（iOS 13+）
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 展示完成后的回调
    func presentPageSheet(_ viewController: UIViewController,
                         animated: Bool = true,
                         completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            presentModal(viewController, style: .pageSheet, animated: animated, completion: completion)
        } else {
            presentModal(viewController, style: .formSheet, animated: animated, completion: completion)
        }
    }

    /// 表单样式模态展示
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 展示完成后的回调
    func presentFormSheet(_ viewController: UIViewController,
                         animated: Bool = true,
                         completion: (() -> Void)? = nil) {
        presentModal(viewController, style: .formSheet, animated: animated, completion: completion)
    }

    /// 弹出框样式展示（iPad 专用）
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - sourceView: 弹出源视图
    ///   - sourceRect: 弹出源矩形区域，默认为 sourceView 的 bounds
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 展示完成后的回调
    func presentPopover(_ viewController: UIViewController,
                       from sourceView: UIView,
                       sourceRect: CGRect? = nil,
                       animated: Bool = true,
                       completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .popover

        if let popoverController = viewController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceRect ?? sourceView.bounds
            popoverController.permittedArrowDirections = .any
        }

        present(viewController, animated: animated, completion: completion)
        logger.debug("弹出框展示控制器: \(String(describing: type(of: viewController)))")
    }

    /// 安全地关闭模态视图控制器
    /// - Parameters:
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 关闭完成后的回调
    func dismissModal(animated: Bool = true, completion: (() -> Void)? = nil) {
        if presentedViewController != nil {
            dismiss(animated: animated, completion: completion)
            logger.debug("关闭模态控制器")
        } else {
            logger.warning("没有需要关闭的模态控制器")
            completion?()
        }
    }

    /// 在导航控制器中模态展示视图控制器
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - style: 展示样式，默认为 .automatic
    ///   - animated: 是否使用动画，默认为 true
    ///   - completion: 展示完成后的回调
    func presentInNavigationController(_ viewController: UIViewController,
                                      style: UIModalPresentationStyle = .automatic,
                                      animated: Bool = true,
                                      completion: (() -> Void)? = nil) {
        let navigationController = UINavigationController(rootViewController: viewController)
        presentModal(navigationController, style: style, animated: animated, completion: completion)
    }

    // MARK: - Status Bar Configuration

    /// 状态栏样式配置
    /// 默认为深色内容（浅色背景使用）
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    /// 状态栏显示/隐藏配置
    /// 默认显示状态栏
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Memory Management

    /// 对象销毁时调用，用于清理资源
    deinit {
        // 移除所有通知观察者
        NotificationCenter.default.removeObserver(self)
        logger.debug("✅ \(String(describing: type(of: self))) 已销毁")
    }
}
