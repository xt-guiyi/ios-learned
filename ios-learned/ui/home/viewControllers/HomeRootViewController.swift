//
//  HomeViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//
import UIKit
import SnapKit

class HomeRootViewController: BaseViewController {
    
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
            ListItemModel(title: "按钮控件", subtitle: "学习UIButton的各种使用方式") {
                let buttonExampleVC = ButtonExampleViewController()
                self.navigationController?.pushViewController(buttonExampleVC, animated: true)
            },
            ListItemModel(title: "文本控件", subtitle: "学习UILabel的各种使用方式") {
                let textExampleVC = TextExampleViewController()
                self.navigationController?.pushViewController(textExampleVC, animated: true)
            },
            ListItemModel(title: "图片控件", subtitle: "学习UIImageView的各种使用方式") {
                let imageExampleVC = ImageExampleViewController()
                self.navigationController?.pushViewController(imageExampleVC, animated: true)
            },
            ListItemModel(title: "输入控件", subtitle: "学习UITextField和UITextView的各种使用方式") {
                let inputExampleVC = InputExampleViewController()
                self.navigationController?.pushViewController(inputExampleVC, animated: true)
            },
            ListItemModel(title: "单选按钮控件", subtitle: "学习单选按钮在协议确认场景的使用") {
                let radioButtonExampleVC = RadioButtonExampleViewController()
                self.navigationController?.pushViewController(radioButtonExampleVC, animated: true)
            },
            ListItemModel(title: "多选按钮", subtitle: "学习复选框在多项选择场景的使用") {
                let checkboxExampleVC = CheckboxExampleViewController()
                self.navigationController?.pushViewController(checkboxExampleVC, animated: true)
            },
            ListItemModel(title: "切换按钮", subtitle: "学习UISwitch在设置开关场景的使用") {
                let switchExampleVC = SwitchExampleViewController()
                self.navigationController?.pushViewController(switchExampleVC, animated: true)
            },
            ListItemModel(title: "底部导航栏控件", subtitle: "学习底部导航按钮各种样式的使用") {
                let bottomNavExampleVC = BottomNavigationExampleViewController()
                self.navigationController?.pushViewController(bottomNavExampleVC, animated: true)
            },
            ListItemModel(title: "UIStackView控件", subtitle: "学习UIStackView的使用") {
                let stackViewExampleVC = StackViewExampleViewController()
                self.navigationController?.pushViewController(stackViewExampleVC, animated: true)
            },
            ListItemModel(title: "上下文菜单控件", subtitle: "学习UIContextMenu的各种使用场景") {
                let contextMenuExampleVC = ContextMenuExampleViewController()
                self.navigationController?.pushViewController(contextMenuExampleVC, animated: true)
            },
            ListItemModel(title: "自定义弹窗", subtitle: "学习各种自定义弹窗的实现和使用") {
                let customDialogExampleVC = CustomDialogExampleViewController()
                self.navigationController?.pushViewController(customDialogExampleVC, animated: true)
            },
            ListItemModel(title: "底部弹窗", subtitle: "学习BottomSheet各种样式和交互的使用") {
                let bottomSheetExampleVC = BottomSheetExampleViewController()
                self.navigationController?.pushViewController(bottomSheetExampleVC, animated: true)
            },
            ListItemModel(title: "Toast 提示", subtitle: "学习Toast消息提示的各种样式和用法") {
                let toastExampleVC = ToastExampleViewController()
                self.navigationController?.pushViewController(toastExampleVC, animated: true)
            },
            ListItemModel(title: "进度条控件", subtitle: "学习各种进度条的实现和动画效果") {
                let progressBarExampleVC = ProgressBarExampleViewController()
                self.navigationController?.pushViewController(progressBarExampleVC, animated: true)
            },
            ListItemModel(title: "轮播图控件", subtitle: "学习FSPagerView各种轮播图样式和效果") {
                let pagerViewExampleVC = PagerViewExampleViewController()
                self.navigationController?.pushViewController(pagerViewExampleVC, animated: true)
            },
            ListItemModel(title: "表格视图控件", subtitle: "学习UITableView的各种使用方式和技巧") {
                let tableViewExampleVC = TableViewExampleViewController()
                self.navigationController?.pushViewController(tableViewExampleVC, animated: true)
            },
            ListItemModel(title: "集合视图控件", subtitle: "学习UICollectionView的各种布局和自定义样式") {
                let collectionViewExampleVC = CollectionViewExampleViewController()
                self.navigationController?.pushViewController(collectionViewExampleVC, animated: true)
            },
            ListItemModel(title: "ViewPager控件", subtitle: "学习类似Android ViewPager的滑动页面实现") {
                let viewPagerExampleVC = ViewPagerExampleViewController()
                self.navigationController?.pushViewController(viewPagerExampleVC, animated: true)
            },
            ListItemModel(title: "WebView控件", subtitle: "学习WKWebView的各种使用方式和JavaScript交互") {
                let webViewExampleVC = WebViewExampleViewController()
                self.navigationController?.pushViewController(webViewExampleVC, animated: true)
            },
            ListItemModel(title: "高级控件", subtitle: "学习PickerView、DatePicker、Slider等高级控件的使用") {
                let advancedControlsVC = AdvancedControlsViewController()
                self.navigationController?.pushViewController(advancedControlsVC, animated: true)
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
    
}
