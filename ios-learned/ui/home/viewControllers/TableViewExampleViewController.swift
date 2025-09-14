//
//  TableViewExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit
import Toast_Swift

class TableViewExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 分段控制器
    private let segmentedControl = UISegmentedControl(items: ["基础", "分组", "自定义", "编辑", "搜索"])
    
    /// 表格视图容器
    private let containerView = UIView()
    
    /// 当前显示的表格视图
    private var currentTableViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        showTableView(at: 0)
    }
    
    /// 设置用户界面
    private func setupUI() {
        setupNavigationBar()
        setupSegmentedControl()
        setupContainerView()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "表格视图控件") {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }
    
    /// 设置分段控制器
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = UIColor.themeColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        view.addSubview(segmentedControl)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        view.addSubview(containerView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 设置按钮事件
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    /// 分段控制器变化
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        showTableView(at: sender.selectedSegmentIndex)
    }
    
    /// 显示对应的表格视图
    private func showTableView(at index: Int) {
        // 移除当前表格视图
        currentTableViewController?.willMove(toParent: nil)
        currentTableViewController?.view.removeFromSuperview()
        currentTableViewController?.removeFromParent()
        
        // 创建新的表格视图控制器
        let newViewController: UIViewController
        
        switch index {
        case 0:
            newViewController = BasicTableViewController()
        case 1:
            newViewController = GroupedTableViewController()
        case 2:
            newViewController = CustomTableViewController()
        case 3:
            newViewController = EditableTableViewController()
        case 4:
            newViewController = SearchableTableViewController()
        default:
            newViewController = BasicTableViewController()
        }
        
        // 添加新的表格视图控制器
        addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        newViewController.didMove(toParent: self)
        
        currentTableViewController = newViewController
    }
}

// MARK: - 基础表格视图
class BasicTableViewController: UIViewController {
    
    private let tableView = UITableView()
    private let dataSource = [
        "iPhone 15 Pro Max",
        "iPhone 15 Pro", 
        "iPhone 15 Plus",
        "iPhone 15",
        "iPhone 14 Pro Max",
        "iPhone 14 Pro",
        "iPhone 14 Plus", 
        "iPhone 14",
        "iPhone 13 Pro Max",
        "iPhone 13 Pro",
        "iPhone 13 mini",
        "iPhone 13",
        "iPhone SE (第3代)"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 60
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate for BasicTableViewController
extension BasicTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "iphone")
        cell.imageView?.tintColor = UIColor.themeColor
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = dataSource[indexPath.row]
        if let parentVC = parent as? TableViewExampleViewController {
            parentVC.view.makeToast("选择了：\(selectedItem)")
        }
    }
}

// MARK: - 分组表格视图
class GroupedTableViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let sectionTitles = ["iPhone", "iPad", "Mac", "Apple Watch"]
    private let dataSource = [
        ["iPhone 15 Pro Max", "iPhone 15 Pro", "iPhone 15 Plus", "iPhone 15"],
        ["iPad Pro 12.9英寸", "iPad Pro 11英寸", "iPad Air", "iPad", "iPad mini"],
        ["MacBook Pro", "MacBook Air", "iMac", "Mac Studio", "Mac Pro"],
        ["Apple Watch Ultra 2", "Apple Watch Series 9", "Apple Watch SE"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroupedCell")
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate for GroupedTableViewController
extension GroupedTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupedCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        
        // 根据分组设置不同的图标
        let iconNames = ["iphone", "ipad", "laptopcomputer", "applewatch"]
        cell.imageView?.image = UIImage(systemName: iconNames[indexPath.section])
        cell.imageView?.tintColor = UIColor.themeColor
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = dataSource[indexPath.section][indexPath.row]
        if let parentVC = parent as? TableViewExampleViewController {
            parentVC.view.makeToast("选择了：\(selectedItem)")
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let selectedItem = dataSource[indexPath.section][indexPath.row]
        if let parentVC = parent as? TableViewExampleViewController {
            parentVC.view.makeToast("查看详情：\(selectedItem)")
        }
    }
}

// MARK: - 自定义表格视图
class CustomTableViewController: UIViewController {
    
    private let tableView = UITableView()
    private let contacts = [
        Contact(name: "张三", phone: "13800138001", email: "zhangsan@example.com", avatar: "person.circle.fill"),
        Contact(name: "李四", phone: "13800138002", email: "lisi@example.com", avatar: "person.circle.fill"),
        Contact(name: "王五", phone: "13800138003", email: "wangwu@example.com", avatar: "person.circle.fill"),
        Contact(name: "赵六", phone: "13800138004", email: "zhaoliu@example.com", avatar: "person.circle.fill"),
        Contact(name: "钱七", phone: "13800138005", email: "qianqi@example.com", avatar: "person.circle.fill"),
        Contact(name: "孙八", phone: "13800138006", email: "sunba@example.com", avatar: "person.circle.fill"),
        Contact(name: "周九", phone: "13800138007", email: "zhoujiu@example.com", avatar: "person.circle.fill"),
        Contact(name: "吴十", phone: "13800138008", email: "wushi@example.com", avatar: "person.circle.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Contact模型
struct Contact {
    let name: String
    let phone: String
    let email: String
    let avatar: String
}

// MARK: - UITableViewDataSource & UITableViewDelegate for CustomTableViewController
extension CustomTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let contact = contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = contacts[indexPath.row]
        if let parentVC = parent as? TableViewExampleViewController {
            parentVC.view.makeToast("联系：\(contact.name)")
        }
    }
}

// MARK: - 自定义表格单元格
class CustomTableViewCell: UITableViewCell {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let emailLabel = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    /// 设置UI
    private func setupUI() {
        selectionStyle = .none
        
        // 容器视图
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.addSubview(containerView)
        
        // 头像
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.tintColor = UIColor.themeColor
        containerView.addSubview(avatarImageView)
        
        // 姓名
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        containerView.addSubview(nameLabel)
        
        // 电话
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.textColor = .secondaryLabel
        containerView.addSubview(phoneLabel)
        
        // 邮箱
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailLabel.textColor = .tertiaryLabel
        containerView.addSubview(emailLabel)
        
        setupConstraints()
    }
    
    /// 设置约束
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(15)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(15)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalTo(phoneLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }
    
    /// 配置单元格
    func configure(with contact: Contact) {
        avatarImageView.image = UIImage(systemName: contact.avatar)
        nameLabel.text = contact.name
        phoneLabel.text = contact.phone
        emailLabel.text = contact.email
    }
}

// MARK: - 可编辑表格视图
class EditableTableViewController: UIViewController {
    
    private let tableView = UITableView()
    private var items = [
        "待办事项 1",
        "待办事项 2", 
        "待办事项 3",
        "待办事项 4",
        "待办事项 5",
        "待办事项 6",
        "待办事项 7",
        "待办事项 8"
    ]
    
    private let editButton = UIButton(type: .system)
    private let addButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupButtons()
        setupTableView()
        setupConstraints()
    }
    
    /// 设置按钮
    private func setupButtons() {
        editButton.setTitle("编辑", for: .normal)
        editButton.backgroundColor = UIColor.systemOrange
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        editButton.layer.cornerRadius = 6
        view.addSubview(editButton)
        
        addButton.setTitle("添加", for: .normal)
        addButton.backgroundColor = UIColor.themeColor
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addButton.layer.cornerRadius = 6
        view.addSubview(addButton)
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EditableCell")
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 55
        view.addSubview(tableView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        let buttonStackView = UIStackView(arrangedSubviews: [editButton, addButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 设置按钮事件
    private func setupActions() {
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
    }
    
    /// 切换编辑模式
    @objc private func toggleEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.setTitle(tableView.isEditing ? "完成" : "编辑", for: .normal)
        editButton.backgroundColor = tableView.isEditing ? UIColor.systemRed : UIColor.systemOrange
    }
    
    /// 添加项目
    @objc private func addItem() {
        let newItem = "新待办事项 \(items.count + 1)"
        items.insert(newItem, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        if let parentVC = parent as? TableViewExampleViewController {
            parentVC.view.makeToast("添加了：\(newItem)")
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate for EditableTableViewController
extension EditableTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditableCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "circle")
        cell.imageView?.tintColor = UIColor.themeColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedItem = items[indexPath.row]
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let parentVC = parent as? TableViewExampleViewController {
                parentVC.view.makeToast("删除了：\(deletedItem)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedItem = items.remove(at: fromIndexPath.row)
        items.insert(movedItem, at: to.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !tableView.isEditing {
            let selectedItem = items[indexPath.row]
            if let parentVC = parent as? TableViewExampleViewController {
                parentVC.view.makeToast("完成了：\(selectedItem)")
            }
            
            // 切换完成状态
            let cell = tableView.cellForRow(at: indexPath)
            let isCompleted = cell?.imageView?.image == UIImage(systemName: "checkmark.circle.fill")
            cell?.imageView?.image = UIImage(systemName: isCompleted ? "circle" : "checkmark.circle.fill")
        }
    }
}

// MARK: - 可搜索表格视图
class SearchableTableViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    private let allItems = [
        "苹果", "香蕉", "橘子", "葡萄", "草莓", "蓝莓", "樱桃", "桃子",
        "梨", "柠檬", "西瓜", "哈密瓜", "火龙果", "猕猴桃", "芒果", "椰子"
    ]
    
    private var filteredItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        filteredItems = allItems
    }
    
    /// 设置搜索控制器
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "搜索水果..."
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    /// 设置表格视图
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchableCell")
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 50
        tableView.tableHeaderView = searchController.searchBar
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 搜索过滤
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { item in
                item.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate for SearchableTableViewController
extension SearchableTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchableCell", for: indexPath)
        cell.textLabel?.text = filteredItems[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "leaf.fill")
        cell.imageView?.tintColor = UIColor.systemGreen
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = filteredItems[indexPath.row]
        if let parentVC = parent as? TableViewExampleViewController {
            parentVC.view.makeToast("选择了：\(selectedItem)")
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SearchableTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterItems(with: searchText)
    }
}
