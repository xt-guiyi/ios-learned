//
//  HomeViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//
import UIKit
import SnapKit

class HomeRootViewController: UIViewController {
    
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
        headerView.configure(title: "空间中心", subtitle: "学习ios控件")
        
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
            ListItemModel(title: "按钮控件", subtitle: "学习UIButton的各种使用方式") { [weak self] in
                self?.navigateToButtonExample()
            },
            ListItemModel(title: "文本控件", subtitle: "学习UILabel的各种使用方式") {
                print("点击了：通知管理")
            },
            ListItemModel(title: "图片控件", subtitle: "学习UIImageView的各种使用方式") {
                print("点击了：窗口管理")
            },
            ListItemModel(title: "输入控件", subtitle: "学习UIInput的各种使用方式") {
                print("点击了：权限管理")
            },
            ListItemModel(title: "单选按钮控件", subtitle: "学习UIRadioButton的各种使用方式") {
                print("点击了：软键盘与输入框实践")
            },
            ListItemModel(title: "多选按钮", subtitle: "学习UICheckBox的各种使用方式") {
                print("点击了：Activity使用")
            },
            ListItemModel(title: "切换按钮", subtitle: "学习UISwitchButton的各种使用方式") {
                print("点击了：Activity使用")
            },
        ]
        
        controller.updateData(listData)
     
        
        addChild(childViewController: controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    private func navigateToButtonExample() {
        let buttonExampleVC = ButtonExampleViewController()
        
        // 使用当前 NavigationController 进行 push 导航
        navigationController?.pushViewController(buttonExampleVC, animated: true)
    }
}
