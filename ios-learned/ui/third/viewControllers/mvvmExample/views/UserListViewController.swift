//
//  UserListViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast_Swift

/// MVVM架构的用户列表页面
class UserListViewController: UIViewController {
    // MARK: - UI Components
    /// 导航栏
    private let navigationBar = CustomNavigationBar()

    /// 搜索文本框
    private let searchTextField = UITextField()

    /// 刷新控件
    private let refreshControl = UIRefreshControl()

    /// 表格视图
    private let tableView = UITableView()

    /// 空状态视图
    private let emptyStateView = UIView()

    /// 空状态图片
    private let emptyImageView = UIImageView()

    /// 空状态标题
    private let emptyTitleLabel = UILabel()

    /// 空状态副标题
    private let emptySubtitleLabel = UILabel()

    /// 重试按钮
    private let retryButton = UIButton(type: .system)

    /// 加载指示器
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    /// 添加用户按钮
    private let addUserButton = UIButton(type: .system)

    // MARK: - Properties
    /// ViewModel
    private let viewModel = UserListViewModel()

    /// DisposeBag
    private let disposeBag = DisposeBag()

    /// 搜索关键词防抖
    private let searchSubject = PublishSubject<String>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()

        // 开发模式：测试网络层
        #if DEBUG
        let networkTest = NetworkTest()
        networkTest.runAllTests()
        #endif

        // 触发初始加载
        viewModel.loadTrigger.accept(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏系统导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI Setup
    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        setupNavigationBar()
        setupSearchTextField()
        setupTableView()
        setupEmptyStateView()
        setupLoadingIndicator()
        setupAddUserButton()
        setupConstraints()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.title = "MVVM 用户列表"
        navigationBar.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
    }

    /// 设置搜索文本框
    private func setupSearchTextField() {
        searchTextField.placeholder = "搜索用户名或邮箱"
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.backgroundColor = UIColor.systemBackground
        searchTextField.clearButtonMode = .whileEditing

        view.addSubview(searchTextField)
    }

    /// 设置表格视图
    private func setupTableView() {
        tableView.backgroundColor = UIColor.systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
    }

    /// 设置空状态视图
    private func setupEmptyStateView() {
        emptyStateView.isHidden = true
        emptyStateView.backgroundColor = UIColor.systemBackground

        // 空状态图片
        emptyImageView.image = UIImage(systemName: "person.3.fill")
        emptyImageView.tintColor = UIColor.systemGray3
        emptyImageView.contentMode = .scaleAspectFit

        // 空状态标题
        emptyTitleLabel.text = "暂无用户数据"
        emptyTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        emptyTitleLabel.textColor = UIColor.label
        emptyTitleLabel.textAlignment = .center

        // 空状态副标题
        emptySubtitleLabel.text = "点击重试按钮重新加载数据"
        emptySubtitleLabel.font = UIFont.systemFont(ofSize: 14)
        emptySubtitleLabel.textColor = UIColor.secondaryLabel
        emptySubtitleLabel.textAlignment = .center
        emptySubtitleLabel.numberOfLines = 0

        // 重试按钮
        retryButton.setTitle("重试", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = UIColor.systemBlue
        retryButton.layer.cornerRadius = 8
        retryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        [emptyImageView, emptyTitleLabel, emptySubtitleLabel, retryButton].forEach {
            emptyStateView.addSubview($0)
        }

        view.addSubview(emptyStateView)
    }

    /// 设置加载指示器
    private func setupLoadingIndicator() {
        loadingIndicator.color = UIColor.systemBlue
        loadingIndicator.hidesWhenStopped = true

        view.addSubview(loadingIndicator)
    }

    /// 设置添加用户按钮
    private func setupAddUserButton() {
        addUserButton.setTitle("+ 添加用户", for: .normal)
        addUserButton.setTitleColor(.white, for: .normal)
        addUserButton.backgroundColor = UIColor.systemGreen
        addUserButton.layer.cornerRadius = 25
        addUserButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        // 添加阴影
        addUserButton.layer.shadowColor = UIColor.black.cgColor
        addUserButton.layer.shadowOpacity = 0.3
        addUserButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addUserButton.layer.shadowRadius = 4

        view.addSubview(addUserButton)
    }


    /// 设置约束
    private func setupConstraints() {
        // 导航栏约束
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }

        // 搜索框约束
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }

        // 表格视图约束
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }

        // 空状态视图约束
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }

        // 空状态图片约束
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.height.equalTo(80)
        }

        // 空状态标题约束
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }

        // 空状态副标题约束
        emptySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }

        // 重试按钮约束
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(emptySubtitleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
        }

        // 加载指示器约束
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }

        // 添加用户按钮约束
        addUserButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }

    // MARK: - Bindings
    /// 设置RxSwift绑定
    private func setupBindings() {
        // 输入绑定
        setupInputBindings()

        // 输出绑定
        setupOutputBindings()

        // 搜索绑定
        setupSearchBindings()
    }

    /// 设置输入绑定
    private func setupInputBindings() {
        // 刷新控件绑定
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)

        // 重试按钮绑定
        retryButton.rx.tap
            .bind(to: viewModel.retryTrigger)
            .disposed(by: disposeBag)

        // 添加用户按钮绑定
        addUserButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showAddUserDialog()
            })
            .disposed(by: disposeBag)
    }

    /// 设置输出绑定
    private func setupOutputBindings() {
        // 用户列表绑定
        viewModel.users
            .bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.identifier, cellType: UserTableViewCell.self)) { row, user, cell in
                cell.configure(with: user)
            }
            .disposed(by: disposeBag)

        // 加载状态绑定
        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        // 刷新状态绑定
        viewModel.isRefreshing
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // 空状态绑定
        viewModel.isEmpty
            .map { !$0 }
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)

        // 错误处理绑定
        viewModel.error
            .compactMap { $0 }
            .drive(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)

        // 用户选择绑定
        tableView.rx.modelSelected(MVVMUser.self)
            .bind(to: viewModel.selectUserTrigger)
            .disposed(by: disposeBag)

        // 用户选择事件绑定
        viewModel.userSelected
            .drive(onNext: { [weak self] user in
                self?.showUserDetail(user)
            })
            .disposed(by: disposeBag)

        // 删除成功绑定
        viewModel.deleteSuccess
            .filter { !$0.isEmpty }
            .drive(onNext: { [weak self] message in
                self?.view.makeToast(message, duration: 2.0, position: .top)
            })
            .disposed(by: disposeBag)

        // 删除失败绑定
        viewModel.deleteError
            .drive(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
    }

    /// 设置搜索绑定
    private func setupSearchBindings() {
        // 绑定搜索框文本变化
        searchTextField.rx.text.orEmpty
            .bind(to: searchSubject)
            .disposed(by: disposeBag)

        searchSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] keyword in
                self?.viewModel.searchUsers(keyword: keyword)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - User Actions
    /// 显示添加用户对话框
    private func showAddUserDialog() {
        let alert = UIAlertController(title: "添加用户", message: "请输入用户信息", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "用户名"
        }

        alert.addTextField { textField in
            textField.placeholder = "邮箱"
            textField.keyboardType = .emailAddress
        }

        alert.addTextField { textField in
            textField.placeholder = "电话"
            textField.keyboardType = .phonePad
        }

        let addAction = UIAlertAction(title: "添加", style: .default) { [weak self] _ in
            guard let nameField = alert.textFields?[0],
                  let emailField = alert.textFields?[1],
                  let phoneField = alert.textFields?[2],
                  let name = nameField.text, !name.isEmpty,
                  let email = emailField.text, !email.isEmpty else {
                self?.view.makeToast("请填写完整信息", duration: 2.0, position: .top)
                return
            }

            let newUser = MVVMUser(
                id: Int.random(in: 1000...9999),
                name: name,
                email: email,
                avatarURL: nil,
                phone: phoneField.text,
                website: nil,
                address: nil,
                company: nil
            )

            self?.viewModel.addUser(newUser)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    /// 显示用户详情
    /// - Parameter user: 用户数据
    private func showUserDetail(_ user: MVVMUser) {
        let message = """
        姓名: \(user.name)
        邮箱: \(user.email)
        电话: \(user.phone ?? "暂无")
        网站: \(user.website ?? "暂无")
        地址: \(user.fullAddress)
        """

        let alert = UIAlertController(title: "用户详情", message: message, preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteUserTrigger.accept(user)
        }

        let editAction = UIAlertAction(title: "编辑", style: .default) { [weak self] _ in
            self?.showEditUserDialog(user)
        }

        let closeAction = UIAlertAction(title: "关闭", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(closeAction)

        present(alert, animated: true)
    }

    /// 显示编辑用户对话框
    /// - Parameter user: 要编辑的用户
    private func showEditUserDialog(_ user: MVVMUser) {
        let alert = UIAlertController(title: "编辑用户", message: "修改用户信息", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "用户名"
            textField.text = user.name
        }

        alert.addTextField { textField in
            textField.placeholder = "邮箱"
            textField.text = user.email
            textField.keyboardType = .emailAddress
        }

        alert.addTextField { textField in
            textField.placeholder = "电话"
            textField.text = user.phone
            textField.keyboardType = .phonePad
        }

        let saveAction = UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            guard let nameField = alert.textFields?[0],
                  let emailField = alert.textFields?[1],
                  let phoneField = alert.textFields?[2],
                  let name = nameField.text, !name.isEmpty,
                  let email = emailField.text, !email.isEmpty else {
                self?.view.makeToast("请填写完整信息", duration: 2.0, position: .top)
                return
            }

            let updatedUser = MVVMUser(
                id: user.id,
                name: name,
                email: email,
                avatarURL: user.avatarURL,
                phone: phoneField.text,
                website: user.website,
                address: user.address,
                company: user.company
            )

            self?.viewModel.updateUser(updatedUser)
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    /// 显示错误信息
    /// - Parameter error: 错误对象
    private func showError(_ error: APIError) {
        view.makeToast(error.localizedDescription, duration: 3.0, position: .top)
    }
}

// MARK: - UITableViewDelegate
extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let users = viewModel.users.value
        guard indexPath.row < users.count else { return nil }

        let user = users[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] _, _, completion in
            self?.viewModel.deleteUserTrigger.accept(user)
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash")

        let editAction = UIContextualAction(style: .normal, title: "编辑") { [weak self] _, _, completion in
            self?.showEditUserDialog(user)
            completion(true)
        }

        editAction.backgroundColor = UIColor.systemBlue
        editAction.image = UIImage(systemName: "pencil")

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

