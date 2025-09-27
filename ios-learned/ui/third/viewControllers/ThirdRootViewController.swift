//
//  ThirdViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

class ThirdRootViewController: BaseViewController {
    
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
        headerView.configure(title: "案例库", subtitle: "综合案例")
        
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
            ListItemModel(title: "mvvm架构", subtitle: "标准MVVM架构，集成Moya+RxSwift+Alamofire+Kingfisher") {
                let userListVC = UserListViewController()
                self.navigationController?.pushViewController(userListVC, animated: true)
            },
            ListItemModel(title: "自定义相机界面", subtitle: "定制一个相机界面，可以加上识别人脸功能") {
                let cameraVC = CustomCameraViewController()
                self.pushViewController(cameraVC)
            },
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
