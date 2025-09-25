//
//  ViewControllerUsageViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

class ViewControllerUsageViewController: BaseViewController {

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
        navigationBar.configure(title: "ViewController使用") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置功能列表
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller

        // 配置ViewController使用功能列表
        let vcUsageData = [
            ListItemModel(title: "转场动画", subtitle: "各种页面跳转动画效果") { [weak self] in
                let transitionVc = TransitionAnimationViewController()
                self?.navigationController?.pushViewController(transitionVc, animated: true)
            },
            ListItemModel(title: "数据传值", subtitle: "ViewController之间的数据传递") { [weak self] in
                let dataPassingVc = DataPassingViewController()
                self?.navigationController?.pushViewController(dataPassingVc, animated: true)
            },
            ListItemModel(title: "模态弹出", subtitle: "Present、ActionSheet、Alert等") { [weak self] in
                let modalVc = ModalPresentationViewController()
                self?.navigationController?.pushViewController(modalVc, animated: true)
            },
            ListItemModel(title: "生命周期", subtitle: "ViewController生命周期演示") { [weak self] in
                let lifecycleVc = LifecycleViewController()
                self?.navigationController?.pushViewController(lifecycleVc, animated: true)
            },
            ListItemModel(title: "容器视图", subtitle: "Child ViewController管理") { [weak self] in
                let containerVc = ContainerViewController()
                self?.navigationController?.pushViewController(containerVc, animated: true)
            },
            ListItemModel(title: "自定义转场", subtitle: "自定义转场动画和交互") { [weak self] in
                let customTransitionVc = CustomTransitionViewController()
                self?.navigationController?.pushViewController(customTransitionVc, animated: true)
            },
            ListItemModel(title: "图片转场", subtitle: "图片无缝转场效果演示") { [weak self] in
                let imageTransitionVc = ImageTransitionViewController()
                self?.navigationController?.pushViewController(imageTransitionVc, animated: true)
            }
        ]

        controller.updateData(vcUsageData)

        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
}