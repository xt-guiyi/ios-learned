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
                self.pushViewController(buttonExampleVC)
            },
            ListItemModel(title: "文本控件", subtitle: "学习UILabel的各种使用方式") {
                let textExampleVC = TextExampleViewController()
                self.pushViewController(textExampleVC)
            },
            ListItemModel(title: "图片控件", subtitle: "学习UIImageView的各种使用方式") {
                let imageExampleVC = ImageExampleViewController()
                self.pushViewController(imageExampleVC)
            },
            ListItemModel(title: "输入控件", subtitle: "学习UITextField和UITextView的各种使用方式") {
                let inputExampleVC = InputExampleViewController()
                self.pushViewController(inputExampleVC)
            },
            ListItemModel(title: "单选按钮控件", subtitle: "学习单选按钮在协议确认场景的使用") {
                let radioButtonExampleVC = RadioButtonExampleViewController()
                self.pushViewController(radioButtonExampleVC)
            },
            ListItemModel(title: "多选按钮", subtitle: "学习复选框在多项选择场景的使用") {
                let checkboxExampleVC = CheckboxExampleViewController()
                self.pushViewController(checkboxExampleVC)
            },
            ListItemModel(title: "切换按钮", subtitle: "学习UISwitch在设置开关场景的使用") {
                let switchExampleVC = SwitchExampleViewController()
                self.pushViewController(switchExampleVC)
            },
            ListItemModel(title: "底部导航栏控件", subtitle: "学习底部导航按钮各种样式的使用") {
                let bottomNavExampleVC = BottomNavigationExampleViewController()
                self.pushViewController(bottomNavExampleVC)
            },
            ListItemModel(title: "UIStackView控件", subtitle: "学习UIStackView的使用") {
                let stackViewExampleVC = StackViewExampleViewController()
                self.pushViewController(stackViewExampleVC)
            },
            ListItemModel(title: "上下文菜单控件", subtitle: "学习UIContextMenu的各种使用场景") {
                let contextMenuExampleVC = ContextMenuExampleViewController()
                self.pushViewController(contextMenuExampleVC)
            },
            ListItemModel(title: "自定义弹窗", subtitle: "学习各种自定义弹窗的实现和使用") {
                let customDialogExampleVC = CustomDialogExampleViewController()
                self.pushViewController(customDialogExampleVC)
            },
            ListItemModel(title: "底部弹窗", subtitle: "学习BottomSheet各种样式和交互的使用") {
                let bottomSheetExampleVC = BottomSheetExampleViewController()
                self.pushViewController(bottomSheetExampleVC)
            },
            ListItemModel(title: "Toast 提示", subtitle: "学习Toast消息提示的各种样式和用法") {
                let toastExampleVC = ToastExampleViewController()
                self.pushViewController(toastExampleVC)
            },
            ListItemModel(title: "进度条控件", subtitle: "学习各种进度条的实现和动画效果") {
                let progressBarExampleVC = ProgressBarExampleViewController()
                self.pushViewController(progressBarExampleVC)
            },
            ListItemModel(title: "轮播图控件", subtitle: "学习FSPagerView各种轮播图样式和效果") {
                let pagerViewExampleVC = PagerViewExampleViewController()
                self.pushViewController(pagerViewExampleVC)
            },
            ListItemModel(title: "表格视图控件", subtitle: "学习UITableView的各种使用方式和技巧") {
                let tableViewExampleVC = TableViewExampleViewController()
                self.pushViewController(tableViewExampleVC)
            },
            ListItemModel(title: "集合视图控件", subtitle: "学习UICollectionView的各种布局和自定义样式") {
                let collectionViewExampleVC = CollectionViewExampleViewController()
                self.pushViewController(collectionViewExampleVC)
            },
            ListItemModel(title: "ViewPager控件", subtitle: "学习类似Android ViewPager的滑动页面实现") {
                let viewPagerExampleVC = ViewPagerExampleViewController()
                self.pushViewController(viewPagerExampleVC)
            },
            ListItemModel(title: "WebView控件", subtitle: "学习WKWebView的各种使用方式和JavaScript交互") {
                let webViewExampleVC = WebViewExampleViewController()
                self.pushViewController(webViewExampleVC)
            },
            ListItemModel(title: "PickerView选择器", subtitle: "学习UIPickerView的各种使用方式和弹出模式") {
                let pickerViewExampleVC = PickerViewExampleViewController()
                self.pushViewController(pickerViewExampleVC)
            },
            ListItemModel(title: "DatePicker日期选择器", subtitle: "学习UIDatePicker的各种模式和样式") {
                let datePickerExampleVC = DatePickerExampleViewController()
                self.pushViewController(datePickerExampleVC)
            },
            ListItemModel(title: "Slider滑块控件", subtitle: "学习UISlider的自定义样式和交互") {
                let sliderExampleVC = SliderExampleViewController()
                self.pushViewController(sliderExampleVC)
            },
            ListItemModel(title: "Stepper步进器", subtitle: "学习UIStepper的配置和使用场景") {
                let stepperExampleVC = StepperExampleViewController()
                self.pushViewController(stepperExampleVC)
            },
            ListItemModel(title: "PageControl页面指示器", subtitle: "学习UIPageControl与ScrollView的联动") {
                let pageControlExampleVC = PageControlExampleViewController()
                self.pushViewController(pageControlExampleVC)
            },
            ListItemModel(title: "ActivityIndicator活动指示器", subtitle: "学习UIActivityIndicatorView的显示控制") {
                let activityIndicatorExampleVC = ActivityIndicatorExampleViewController()
                self.pushViewController(activityIndicatorExampleVC)
            },
            ListItemModel(title: "Storyboard加载方式", subtitle: "学习如何使用Storyboard加载ViewController") {
               let storeboard = UIStoryboard(name: "StoryboardExample", bundle: nil)
               let animationExampleVC = storeboard.instantiateViewController(withIdentifier: "StoryboardPage1") as! StoryboardExampleViewController
               self.pushViewController(animationExampleVC)
            },
            ListItemModel(title: "nib加载方式", subtitle: "学习如何使用Nib加载ViewController") { [weak self] in
                let nibExampleVC = NibExampleViewController(nibName: "NibExampleViewController", bundle: nil)
                self?.logger.info("点击了nib加载方式")
                self?.pushViewController(nibExampleVC)
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
