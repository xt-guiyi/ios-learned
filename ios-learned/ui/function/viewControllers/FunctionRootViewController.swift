//
//  FunctionViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

class FunctionRootViewController: BaseViewController {
    
    private let headerView = PageHeaderView()
    private var listViewController: CardListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
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
            ListItemModel(title: "系统栏管理", subtitle: "设置系统栏的样式和行为") {
                print("点击了：自定义弹窗")
            },
            ListItemModel(title: "通知管理", subtitle: "学习通知用法") {
                print("点击了：网络请求")
            },
            ListItemModel(title: "窗口管理", subtitle: "设置悬浮球") {
                print("点击了：数据库操作")
            },
            ListItemModel(title: "权限管理", subtitle: "学习请求权限") {
                print("点击了：动画效果")
            },
            ListItemModel(title: "viewController使用", subtitle: "跳转动画，传值等") {
                print("点击了：图片处理")
            },
            ListItemModel(title: "本地存储", subtitle: "学习本地存储的方法") {
                print("点击了：音视频播放")
            },
            ListItemModel(title: "沙盒管理，文件操作", subtitle: "获取沙盒路径，文件操作等") {
                print("点击了：第三方库")
            },
            ListItemModel(title: "多线程", subtitle: "GCD，NSOperation等") {
                print("点击了：其他知识")
            },
            ListItemModel(title: "手势操作", subtitle: "URLSession等") {

            },
            ListItemModel(title: "动画", subtitle: "UIView动画，核心动画等") {
                print("点击了：其他知识")
            },
            ListItemModel(title: "图片加载库", subtitle: "介绍图片加载库Kingfisher") {
                print("点击了：其他知识")
            },
            ListItemModel(title: "网络请求库", subtitle: "介绍网络请求库Alamofire") {
                print("点击了：其他知识")
            },
            ListItemModel(title: "音频播放", subtitle: "介绍音频播放库") {
                print("点击了：其他知识")
            },  
            ListItemModel(title: "视频播放", subtitle: "介绍视频播放库") {
                print("点击了：其他知识")
            },
            ListItemModel(title: "响应式编程框架", subtitle: "RxSwift简介") {
                print("点击了：其他知识")
            },
            ListItemModel(title: "网络抽象层库", subtitle: "Moya简介") {
                print("点击了：其他知识")
            }
           
        ]
        
        controller.updateData(listData)
        
        
        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
}
