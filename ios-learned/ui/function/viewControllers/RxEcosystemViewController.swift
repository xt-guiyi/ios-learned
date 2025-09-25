//
//  RxEcosystemViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/09/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard
import RxGesture
// import RxAnimated // 移除，使用UIView动画代替
// import RxTheme // 暂时移除，版本不兼容

/**
 * RxSwift生态库学习页面
 * 演示RxDataSources、RxKeyboard、RxGesture、RxAnimated、RxTheme的使用
 */
class RxEcosystemViewController: BaseViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    private let disposeBag = DisposeBag()

    // UI组件
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // RxDataSources示例
    private let dataSourcesLabel = UILabel()
    private let tableView = UITableView()
    private let addItemBtn = UIButton()
    private let removeItemBtn = UIButton()

    // RxKeyboard示例
    private let keyboardLabel = UILabel()
    private let keyboardTextField = UITextField()
    private let keyboardStatusLabel = UILabel()

    // RxGesture示例
    private let gestureLabel = UILabel()
    private let gestureView = UIView()
    private let gestureStatusLabel = UILabel()

    // RxAnimated示例
    private let animatedLabel = UILabel()
    private let animatedView = UIView()
    private let animateBtn = UIButton()


    // 数据模型
    struct ListItem {
        let id: Int
        let title: String
        let subtitle: String
    }

    // 数据源
    private let itemsSubject = BehaviorSubject<[ListItem]>(value: [
        ListItem(id: 1, title: "第一项", subtitle: "这是第一个列表项"),
        ListItem(id: 2, title: "第二项", subtitle: "这是第二个列表项"),
        ListItem(id: 3, title: "第三项", subtitle: "这是第三个列表项")
    ])


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupRxDataSources()
        setupRxKeyboard()
        setupRxGesture()
    }

    /**
     * 配置用户界面
     */
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground

        setupNavigationBar()
        setupScrollView()
        setupHeaderSection()
        setupDataSourcesSection()
        setupKeyboardSection()
        setupGestureSection()
        setupAnimatedSection()

        layoutSubviews()
    }

    /**
     * 设置导航栏
     */
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "RxSwift生态库") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(customNavigationBar)

        customNavigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /**
     * 设置滚动视图
     */
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }

    /**
     * 设置头部信息
     */
    private func setupHeaderSection() {
        titleLabel.text = "RxSwift生态库演示"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label

        descriptionLabel.text = "学习RxDataSources、RxKeyboard、RxGesture的实际应用"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    /**
     * 设置RxDataSources示例区域
     */
    private func setupDataSourcesSection() {
        dataSourcesLabel.text = "RxDataSources - 响应式数据源"
        dataSourcesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        dataSourcesLabel.textColor = UIColor.themeColor

        // TableView设置
        tableView.backgroundColor = .systemGray6
        tableView.layer.cornerRadius = 8
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 60

        // 按钮设置
        configureButton(addItemBtn, title: "添加项", color: UIColor.systemGreen)
        configureButton(removeItemBtn, title: "删除项", color: UIColor.systemRed)

        contentView.addSubview(dataSourcesLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(addItemBtn)
        contentView.addSubview(removeItemBtn)
    }

    /**
     * 设置RxKeyboard示例区域
     */
    private func setupKeyboardSection() {
        keyboardLabel.text = "RxKeyboard - 键盘响应"
        keyboardLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        keyboardLabel.textColor = UIColor.themeColor

        keyboardTextField.placeholder = "点击输入框测试键盘响应"
        keyboardTextField.borderStyle = .roundedRect
        keyboardTextField.font = UIFont.systemFont(ofSize: 16)

        keyboardStatusLabel.text = "键盘状态: 隐藏"
        keyboardStatusLabel.font = UIFont.systemFont(ofSize: 16)
        keyboardStatusLabel.textColor = .secondaryLabel

        contentView.addSubview(keyboardLabel)
        contentView.addSubview(keyboardTextField)
        contentView.addSubview(keyboardStatusLabel)
    }

    /**
     * 设置RxGesture示例区域
     */
    private func setupGestureSection() {
        gestureLabel.text = "RxGesture - 手势识别"
        gestureLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        gestureLabel.textColor = UIColor.themeColor

        gestureView.backgroundColor = UIColor.themeColor.withAlphaComponent(0.2)
        gestureView.layer.cornerRadius = 8
        gestureView.layer.borderWidth = 2
        gestureView.layer.borderColor = UIColor.themeColor.cgColor

        let tapLabel = UILabel()
        tapLabel.text = "点击、长按、滑动试试"
        tapLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tapLabel.textColor = UIColor.themeColor
        tapLabel.textAlignment = .center
        gestureView.addSubview(tapLabel)

        tapLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        gestureStatusLabel.text = "手势状态: 无"
        gestureStatusLabel.font = UIFont.systemFont(ofSize: 16)
        gestureStatusLabel.textColor = .secondaryLabel
        gestureStatusLabel.numberOfLines = 0

        contentView.addSubview(gestureLabel)
        contentView.addSubview(gestureView)
        contentView.addSubview(gestureStatusLabel)
    }

    /**
     * 设置动画示例区域
     */
    private func setupAnimatedSection() {
        animatedLabel.text = "响应式动画 - UIView动画"
        animatedLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        animatedLabel.textColor = UIColor.themeColor

        animatedView.backgroundColor = UIColor.systemBlue
        animatedView.layer.cornerRadius = 25

        configureButton(animateBtn, title: "开始动画", color: UIColor.systemBlue)

        contentView.addSubview(animatedLabel)
        contentView.addSubview(animatedView)
        contentView.addSubview(animateBtn)
    }


    /**
     * 配置按钮样式
     */
    private func configureButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }

    /**
     * 设置数据绑定
     */
    private func setupBindings() {
        // RxDataSources按钮事件
        addItemBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.addNewItem()
            })
            .disposed(by: disposeBag)

        removeItemBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.removeLastItem()
            })
            .disposed(by: disposeBag)

        // RxAnimated按钮事件
        animateBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.performAnimation()
            })
            .disposed(by: disposeBag)

    }

    /**
     * 设置RxDataSources
     */
    private func setupRxDataSources() {
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ListItem>>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.subtitle
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        )

        // 绑定数据
        itemsSubject
            .map { [SectionModel(model: "列表项", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        // 监听选择事件
        tableView.rx.modelSelected(ListItem.self)
            .subscribe(onNext: { item in
                print("选择了: \(item.title)")
                // 取消选择
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    /**
     * 设置RxKeyboard
     */
    private func setupRxKeyboard() {
        // 监听键盘显示
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                let isVisible = keyboardHeight > 0
                self?.keyboardStatusLabel.text = isVisible ?
                    "键盘状态: 显示 (高度: \(Int(keyboardHeight)))" :
                    "键盘状态: 隐藏"
            })
            .disposed(by: disposeBag)

        // 键盘出现时调整视图
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }

                UIView.animate(withDuration: 0.3) {
                    if keyboardHeight > 0 {
                        // 键盘出现，向上移动内容
                        self.scrollView.contentInset.bottom = keyboardHeight
                        self.scrollView.scrollIndicatorInsets.bottom = keyboardHeight

                        // 滚动到输入框
                        let textFieldFrame = self.keyboardTextField.convert(self.keyboardTextField.bounds, to: self.scrollView)
                        self.scrollView.scrollRectToVisible(textFieldFrame, animated: false)
                    } else {
                        // 键盘隐藏，恢复内容
                        self.scrollView.contentInset.bottom = 0
                        self.scrollView.scrollIndicatorInsets.bottom = 0
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    /**
     * 设置RxGesture
     */
    private func setupRxGesture() {
        // 点击手势
        gestureView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.gestureStatusLabel.text = "手势状态: 单击 👆"
            })
            .disposed(by: disposeBag)

        // 长按手势
        gestureView.rx.longPressGesture()
            .when(.began)
            .subscribe(onNext: { [weak self] _ in
                self?.gestureStatusLabel.text = "手势状态: 长按开始 ✋"
            })
            .disposed(by: disposeBag)

        // 滑动手势
        gestureView.rx.swipeGesture(.left, .right, .up, .down)
            .when(.recognized)
            .subscribe(onNext: { [weak self] gesture in
                var direction = ""
                switch gesture.direction {
                case .left: direction = "左滑 ⬅️"
                case .right: direction = "右滑 ➡️"
                case .up: direction = "上滑 ⬆️"
                case .down: direction = "下滑 ⬇️"
                default: direction = "滑动"
                }
                self?.gestureStatusLabel.text = "手势状态: \(direction)"
            })
            .disposed(by: disposeBag)

        // 拖拽手势
        gestureView.rx.panGesture()
            .when(.changed)
            .subscribe(onNext: { [weak self] gesture in
                let translation = gesture.translation(in: self?.gestureView)
                self?.gestureStatusLabel.text = "手势状态: 拖拽 📱\n位移: x:\(Int(translation.x)), y:\(Int(translation.y))"
            })
            .disposed(by: disposeBag)
    }


    /**
     * 添加新项目
     */
    private func addNewItem() {
        do {
            let currentItems = try itemsSubject.value()
            let newId = (currentItems.map { $0.id }.max() ?? 0) + 1
            let newItem = ListItem(
                id: newId,
                title: "第\(newId)项",
                subtitle: "这是第\(newId)个列表项"
            )
            itemsSubject.onNext(currentItems + [newItem])
        } catch {
            print("添加项目失败: \(error)")
        }
    }

    /**
     * 删除最后一项
     */
    private func removeLastItem() {
        do {
            let currentItems = try itemsSubject.value()
            if !currentItems.isEmpty {
                let newItems = Array(currentItems.dropLast())
                itemsSubject.onNext(newItems)
            }
        } catch {
            print("删除项目失败: \(error)")
        }
    }

    /**
     * 执行动画
     */
    private func performAnimation() {
        // 使用RxSwift + UIView动画
        // 随机位置
        let randomX = CGFloat.random(in: 0...200)
        let randomY = CGFloat.random(in: 0...100)

        // 随机颜色
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
        let randomColor = colors.randomElement() ?? .systemBlue

        // 执行动画
        Observable.just(())
            .subscribe(onNext: { [weak self] in
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.5,
                    options: [.curveEaseInOut],
                    animations: {
                        self?.animatedView.transform = CGAffineTransform(translationX: randomX, y: randomY)
                        self?.animatedView.backgroundColor = randomColor
                    },
                    completion: { _ in
                        // 动画完成后恢复
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            UIView.animate(
                                withDuration: 0.5,
                                animations: {
                                    self?.animatedView.transform = .identity
                                    self?.animatedView.backgroundColor = .systemBlue
                                }
                            )
                        }
                    }
                )
            })
            .disposed(by: disposeBag)
    }

    /**
     * 布局所有子视图
     */
    private func layoutSubviews() {
        let margin: CGFloat = 20
        let buttonHeight: CGFloat = 44
        let spacing: CGFloat = 15

        // 头部区域
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
        }

        // RxDataSources区域
        dataSourcesLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(dataSourcesLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(200)
        }

        addItemBtn.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(spacing)
            make.left.equalToSuperview().offset(margin)
            make.width.equalTo(80)
            make.height.equalTo(buttonHeight)
        }

        removeItemBtn.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(spacing)
            make.left.equalTo(addItemBtn.snp.right).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(buttonHeight)
        }

        // RxKeyboard区域
        keyboardLabel.snp.makeConstraints { make in
            make.top.equalTo(addItemBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        keyboardTextField.snp.makeConstraints { make in
            make.top.equalTo(keyboardLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        keyboardStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(keyboardTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }

        // RxGesture区域
        gestureLabel.snp.makeConstraints { make in
            make.top.equalTo(keyboardStatusLabel.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        gestureView.snp.makeConstraints { make in
            make.top.equalTo(gestureLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(120)
        }

        gestureStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(gestureView.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }

        // RxAnimated区域
        animatedLabel.snp.makeConstraints { make in
            make.top.equalTo(gestureStatusLabel.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        animatedView.snp.makeConstraints { make in
            make.top.equalTo(animatedLabel.snp.bottom).offset(spacing)
            make.left.equalToSuperview().offset(margin)
            make.width.height.equalTo(50)
        }

        animateBtn.snp.makeConstraints { make in
            make.centerY.equalTo(animatedView)
            make.left.equalTo(animatedView.snp.right).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(buttonHeight)
        }

        // 设置底部约束
        animateBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-margin)
        }
    }
}