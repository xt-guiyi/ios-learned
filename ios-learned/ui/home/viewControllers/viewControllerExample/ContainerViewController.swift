//
//  ContainerViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

class ContainerViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private let segmentedControl = UISegmentedControl(items: ["页面1", "页面2", "页面3"])
    private let containerView = UIView()
    private var customChildControllers: [UIViewController] = []
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChildViewControllers()
        showChildViewController(at: 0)
    }

    /// 设置UI界面
    private func setupUI() {
        setupNavigationBar()
        setupSegmentedControl()
        setupContainerView()
        setupConstraints()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "容器视图") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
    }

    /// 设置分段控制器
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = UIColor.themeColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
    }

    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
    }

    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    /// 设置子视图控制器
    private func setupChildViewControllers() {
        // 创建三个不同的子视图控制器
        let firstChild = FirstChildViewController()
        let secondChild = SecondChildViewController()
        let thirdChild = ThirdChildViewController()

        customChildControllers = [firstChild, secondChild, thirdChild]
    }

    /// 显示指定索引的子视图控制器
    private func showChildViewController(at index: Int) {
        guard index >= 0 && index < customChildControllers.count else { return }

        // 移除当前显示的子视图控制器
        if currentIndex < customChildControllers.count {
            let currentChild = customChildControllers[currentIndex]
            currentChild.willMove(toParent: nil)
            currentChild.view.removeFromSuperview()
            currentChild.removeFromParent()
        }

        // 添加新的子视图控制器
        let newChild = customChildControllers[index]
        addChild(newChild)
        containerView.addSubview(newChild.view)

        // 设置子视图约束
        newChild.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        newChild.didMove(toParent: self)
        currentIndex = index

        // 添加切换动画
        newChild.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            newChild.view.alpha = 1
        }
    }

    /// 分段控制器值改变事件
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        showChildViewController(at: sender.selectedSegmentIndex)
    }
}

// MARK: - 第一个子视图控制器
class FirstChildViewController: UIViewController {

    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let listView = UITableView()

    private let items = ["项目 1", "项目 2", "项目 3", "项目 4", "项目 5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)

        // 标题
        titleLabel.text = "页面1 - 列表页面"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // 描述
        descriptionLabel.text = "这是第一个子视图控制器\n展示了如何在容器中管理列表视图"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.systemGray
        view.addSubview(descriptionLabel)

        // 操作按钮
        actionButton.setTitle("添加项目", for: .normal)
        actionButton.backgroundColor = UIColor.themeColor
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 8
        actionButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        view.addSubview(actionButton)

        // 列表视图
        listView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        listView.dataSource = self
        listView.delegate = self
        listView.layer.cornerRadius = 8
        view.addSubview(listView)

        // 设置约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        actionButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        listView.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    @objc private func addItem() {
        let alert = UIAlertController(title: "添加项目", message: "请输入项目名称", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "项目名称"
        }
        alert.addAction(UIAlertAction(title: "添加", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                // 这里可以添加到数据源并刷新列表
                print("添加项目: \(text)")
            }
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        if let parentVc = parent {
            parentVc.present(alert, animated: true)
        }
    }
}

extension FirstChildViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = items[indexPath.row]

        let alert = UIAlertController(title: "选中项目", message: "你选择了: \(selectedItem)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))

        if let parentVc = parent {
            parentVc.present(alert, animated: true)
        }
    }
}

// MARK: - 第二个子视图控制器
class SecondChildViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)

        // 滚动视图
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)

        // 堆栈视图
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        scrollView.addSubview(stackView)

        // 添加内容
        addContentToStackView()

        // 设置约束
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.width.equalTo(scrollView).offset(-40)
        }
    }

    private func addContentToStackView() {
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "页面2 - 表单页面"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)

        // 描述
        let descriptionLabel = UILabel()
        descriptionLabel.text = "这是第二个子视图控制器\n展示了表单输入和滚动视图的使用"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.systemGray
        stackView.addArrangedSubview(descriptionLabel)

        // 表单字段
        let formFields = ["姓名", "邮箱", "电话", "地址", "公司", "职位"]
        formFields.forEach { fieldName in
            let textField = createTextField(placeholder: fieldName)
            stackView.addArrangedSubview(textField)
        }

        // 开关控制
        let switchContainer = createSwitchContainer(title: "接收通知", isOn: true)
        stackView.addArrangedSubview(switchContainer)

        // 分段控制器
        let segmentContainer = createSegmentContainer()
        stackView.addArrangedSubview(segmentContainer)

        // 提交按钮
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("提交表单", for: .normal)
        submitButton.backgroundColor = UIColor.themeColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        stackView.addArrangedSubview(submitButton)

        submitButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemBackground
        return textField
    }

    private func createSwitchContainer(title: String, isOn: Bool) -> UIView {
        let container = UIView()
        let label = UILabel()
        let switchControl = UISwitch()

        label.text = title
        label.font = UIFont.systemFont(ofSize: 16)
        switchControl.isOn = isOn

        container.addSubview(label)
        container.addSubview(switchControl)

        label.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }

        switchControl.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
        }

        container.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        return container
    }

    private func createSegmentContainer() -> UIView {
        let container = UIView()
        let label = UILabel()
        let segmentControl = UISegmentedControl(items: ["选项1", "选项2", "选项3"])

        label.text = "偏好设置"
        label.font = UIFont.systemFont(ofSize: 16)
        segmentControl.selectedSegmentIndex = 0

        container.addSubview(label)
        container.addSubview(segmentControl)

        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }

        segmentControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }

        return container
    }

    @objc private func submitForm() {
        let alert = UIAlertController(title: "表单提交", message: "表单提交成功！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))

        if let parentVc = parent {
            parentVc.present(alert, animated: true)
        }
    }
}

// MARK: - 第三个子视图控制器
class ThirdChildViewController: UIViewController {

    private let collectionView: UICollectionView
    private let colors: [UIColor] = [
        .systemRed, .systemBlue, .systemGreen, .systemOrange,
        .systemPurple, .systemPink, .systemTeal, .systemIndigo,
        .systemBrown, .systemGray
    ]

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "页面3 - 网格页面"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // 描述
        let descriptionLabel = UILabel()
        descriptionLabel.text = "这是第三个子视图控制器\n展示了集合视图的网格布局"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.systemGray
        view.addSubview(descriptionLabel)

        // 集合视图
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)

        // 设置约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ThirdChildViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.configure(with: colors[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.item]
        let alert = UIAlertController(title: "颜色选择", message: "你选择了第 \(indexPath.item + 1) 个颜色", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))

        if let parentVc = parent {
            parentVc.present(alert, animated: true)
        }
    }
}

// MARK: - 颜色单元格
class ColorCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
    }

    func configure(with color: UIColor) {
        backgroundColor = color
    }

    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.themeColor.cgColor : UIColor.systemGray4.cgColor
            layer.borderWidth = isSelected ? 3 : 2
        }
    }
}