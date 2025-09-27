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
                let systemBarVC = SystemBarViewController()
                self.pushViewController(systemBarVC)
            },
            ListItemModel(title: "窗口管理", subtitle: "设置悬浮球") {
                let windowManagerVC = WindowManagerViewController()
                self.pushViewController(windowManagerVC)
            },
            ListItemModel(title: "权限管理", subtitle: "学习请求权限") {
                let permissionManagerVC = PermissionManagerViewController()
                self.pushViewController(permissionManagerVC)
            },
            ListItemModel(title: "本地存储", subtitle: "学习本地存储的方法") {
                let localStorageVC = LocalStorageViewController()
                self.pushViewController(localStorageVC)
            },
            ListItemModel(title: "沙盒管理，文件操作", subtitle: "获取沙盒路径，文件操作等") {
                let sandboxFileVC = SandboxFileViewController()
                self.pushViewController(sandboxFileVC)
            },
            ListItemModel(title: "多线程", subtitle: "GCD，NSOperation等") {
                let concurrencyVC = ConcurrencyViewController()
                self.pushViewController(concurrencyVC)
            },
            ListItemModel(title: "手势操作", subtitle: "点击、滑动、捏合等手势识别") {
                let gestureVC = GestureViewController()
                self.pushViewController(gestureVC)
            },
            ListItemModel(title: "动画", subtitle: "UIView动画，核心动画等") {
                let animationVC = AnimationViewController()
                self.pushViewController(animationVC)
            },
            ListItemModel(title: "图片加载库", subtitle: "介绍图片加载库Kingfisher") {
                let kingfisherVC = KingfisherViewController()
                self.pushViewController(kingfisherVC)
            },
            ListItemModel(title: "网络请求库", subtitle: "介绍网络请求库Alamofire") {
                let networkRequestVC = NetworkRequestViewController()
                self.pushViewController(networkRequestVC)
            },
            ListItemModel(title: "音频播放", subtitle: "介绍音频播放库") {
                let audioPlayerVC = AudioPlayerViewController()
                self.pushViewController(audioPlayerVC)
            },
            ListItemModel(title: "视频播放", subtitle: "介绍视频播放库") {
                let videoPlayerVC = VideoPlayerViewController()
                self.pushViewController(videoPlayerVC)
            },
            ListItemModel(title: "响应式编程框架", subtitle: "RxSwift简介") {
                let rxSwiftVC = RxSwiftViewController()
                self.pushViewController(rxSwiftVC)
            },
            ListItemModel(title: "响应式生态系统", subtitle: "RxCocoa、RxDataSources等") {
                let rxEcosystemVC = RxEcosystemViewController()
                self.pushViewController(rxEcosystemVC)
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
