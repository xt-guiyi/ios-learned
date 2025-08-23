//
//  FunctionViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

class FunctionRootViewController: UIViewController {
    
    private let headerView = PageHeaderView()
    private var listViewController: CardListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupHeaderView()
        setupListViewController()
    }
    
    private func setupHeaderView() {
        // 配置头部内容
        headerView.configure(title: "进阶学习", subtitle: "学习api、第三方库用法以及其他知识")
        
        view.addSubview(headerView)
        
        // HeaderView 延伸到安全区域上方（包括状态栏）
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        // 设置内部约束以适配安全区域
        headerView.setupConstraintsForSafeArea()
    }
    
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller
        
        // 配置列表数据
        let listData = [
            ListItemModel(title: "自定义弹窗", subtitle: "学习如何创建自定义弹窗") {
                print("点击了：自定义弹窗")
            },
            ListItemModel(title: "网络请求", subtitle: "学习网络请求的封装和使用") {
                print("点击了：网络请求")
            },
            ListItemModel(title: "数据库操作", subtitle: "学习Core Data的使用") {
                print("点击了：数据库操作")
            },
            ListItemModel(title: "动画效果", subtitle: "学习各种动画的实现") {
                print("点击了：动画效果")
            },
            ListItemModel(title: "图片处理", subtitle: "学习图片的裁剪、滤镜等操作") {
                print("点击了：图片处理")
            },
            ListItemModel(title: "音视频播放", subtitle: "学习音视频播放功能") {
                print("点击了：音视频播放")
            }
        ]
        
        controller.updateData(listData)
        
        // 设置点击回调
        controller.onItemSelected = { [weak self] model, index in
            print("功能页 - 选择了第 \(index) 项：\(model.title)")
            // 这里可以进行页面跳转等操作
        }
        
        addChild(childViewController: controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
}
