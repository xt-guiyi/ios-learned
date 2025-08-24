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
            ListItemModel(title: "SnapKit", subtitle: "Auto Layout 的 DSL 库") {
                print("点击了：SnapKit")
            },
            ListItemModel(title: "Alamofire", subtitle: "Swift 网络请求库") {
                print("点击了：Alamofire")
            },
            ListItemModel(title: "Kingfisher", subtitle: "图片下载和缓存库") {
                print("点击了：Kingfisher")
            },
            ListItemModel(title: "RxSwift", subtitle: "响应式编程框架") {
                print("点击了：RxSwift")
            },
            ListItemModel(title: "Moya", subtitle: "网络抽象层库") {
                print("点击了：Moya")
            },
            ListItemModel(title: "SwiftyJSON", subtitle: "JSON 解析库") {
                print("点击了：SwiftyJSON")
            }
        ]
        
        controller.updateData(listData)
        
        // 设置点击回调
        controller.onItemSelected = { [weak self] model, index in
            print("第三方库页 - 选择了第 \(index) 项：\(model.title)")
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
