//
//  CombineUserListViewModel.swift
//  ios-learned
//
//  Created by Claude on 2025/10/01.
//

import Foundation
import Combine

/// 用户列表视图状态（Combine版本）
enum CombineUserListViewState {
    /// 空闲状态
    case idle

    /// 加载中
    case loading

    /// 加载成功
    case loaded([MVVMUser])

    /// 加载失败
    case error(APIError)

    /// 刷新中
    case refreshing([MVVMUser])
}

/// Combine 版本的用户列表 ViewModel
class CombineUserListViewModel {
    // MARK: - Dependencies

    /// 用户服务
    private let userService: CombineUserServiceProtocol

    /// Cancellables 集合
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Inputs（输入信号）

    /// 加载触发器
    let loadTrigger = PassthroughSubject<Void, Never>()

    /// 刷新触发器
    let refreshTrigger = PassthroughSubject<Void, Never>()

    /// 重试触发器
    let retryTrigger = PassthroughSubject<Void, Never>()

    /// 用户选择触发器
    let selectUserTrigger = PassthroughSubject<MVVMUser, Never>()

    /// 删除用户触发器
    let deleteUserTrigger = PassthroughSubject<MVVMUser, Never>()

    // MARK: - Outputs（输出状态）

    /// 视图状态
    @Published var viewState: CombineUserListViewState = .idle

    /// 用户列表（用于显示）
    @Published var users: [MVVMUser] = []

    /// 原始用户列表（完整数据）
    @Published private var originalUsers: [MVVMUser] = []

    /// 是否正在加载
    @Published var isLoading: Bool = false

    /// 是否正在刷新
    @Published var isRefreshing: Bool = false

    /// 是否显示空状态
    @Published var isEmpty: Bool = false

    /// 错误信息
    @Published var error: APIError?

    /// 用户选择事件
    let userSelected = PassthroughSubject<MVVMUser, Never>()

    /// 删除成功事件
    let deleteSuccess = PassthroughSubject<String, Never>()

    /// 删除失败事件
    let deleteError = PassthroughSubject<APIError, Never>()

    // MARK: - Initialization

    /// 初始化方法
    /// - Parameter userService: 用户服务，默认使用真实API
    init(userService: CombineUserServiceProtocol = CombineUserService(useMock: false)) {
        self.userService = userService
        setupBindings()
    }

    // MARK: - Private Methods

    /// 设置绑定关系
    private func setupBindings() {
        // 处理加载触发
        let loadUsers = Publishers.Merge(
            loadTrigger,
            retryTrigger
        )
        .flatMap { [weak self] _ -> AnyPublisher<CombineUserListViewState, Never> in
            guard let self = self else {
                return Empty().eraseToAnyPublisher()
            }
            return self.loadUsersWithState()
        }

        // 处理刷新触发
        let refreshUsers = refreshTrigger
            .combineLatest($users)
            .flatMap { [weak self] (_, currentUsers) -> AnyPublisher<CombineUserListViewState, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.refreshUsersWithState(currentUsers: currentUsers)
            }

        // 合并加载和刷新的状态变化
        Publishers.Merge(loadUsers, refreshUsers)
            .sink { [weak self] state in
                self?.viewState = state
            }
            .store(in: &cancellables)

        // 根据视图状态更新用户列表和加载状态
        $viewState
            .sink { [weak self] state in
                switch state {
                case .loaded(let loadedUsers):
                    self?.originalUsers = loadedUsers
                    self?.users = loadedUsers
                    self?.isLoading = false
                    self?.isRefreshing = false
                case .loading:
                    self?.isLoading = true
                    self?.isRefreshing = false
                case .refreshing(let currentUsers):
                    self?.isLoading = false
                    self?.isRefreshing = true
                case .error(let apiError):
                    self?.isLoading = false
                    self?.isRefreshing = false
                    self?.error = apiError
                case .idle:
                    self?.isLoading = false
                    self?.isRefreshing = false
                }
            }
            .store(in: &cancellables)

        // 更新空状态
        Publishers.CombineLatest($users, $viewState)
            .map { users, state in
                if users.isEmpty {
                    switch state {
                    case .idle:
                        return true
                    case .loaded(let loadedUsers):
                        return loadedUsers.isEmpty
                    default:
                        return false
                    }
                }
                return false
            }
            .assign(to: &$isEmpty)

        // 处理删除用户
        deleteUserTrigger
            .flatMap { [weak self] user -> AnyPublisher<Void, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.deleteUser(user)
            }
            .sink { _ in }
            .store(in: &cancellables)

        // 转发用户选择事件
        selectUserTrigger
            .sink { [weak self] user in
                self?.userSelected.send(user)
            }
            .store(in: &cancellables)
    }

    /// 加载用户并返回状态
    /// - Returns: 状态变化的 Publisher
    private func loadUsersWithState() -> AnyPublisher<CombineUserListViewState, Never> {
        return userService.fetchUsers()
            .map { CombineUserListViewState.loaded($0) }
            .catch { error -> Just<CombineUserListViewState> in
                if let apiError = error as? APIError {
                    return Just(.error(apiError))
                }
                return Just(.error(APIError.unknown))
            }
            .prepend(.loading)
            .eraseToAnyPublisher()
    }

    /// 刷新用户并返回状态
    /// - Parameter currentUsers: 当前用户列表
    /// - Returns: 状态变化的 Publisher
    private func refreshUsersWithState(currentUsers: [MVVMUser]) -> AnyPublisher<CombineUserListViewState, Never> {
        return userService.fetchUsers()
            .map { CombineUserListViewState.loaded($0) }
            .catch { error -> Just<CombineUserListViewState> in
                if let apiError = error as? APIError {
                    return Just(.error(apiError))
                }
                return Just(.error(APIError.unknown))
            }
            .prepend(.refreshing(currentUsers))
            .eraseToAnyPublisher()
    }

    /// 删除用户
    /// - Parameter user: 要删除的用户
    /// - Returns: 删除操作的 Publisher
    private func deleteUser(_ user: MVVMUser) -> AnyPublisher<Void, Never> {
        return userService.deleteUser(id: user.id)
            .handleEvents(
                receiveOutput: { [weak self] _ in
                    // 删除成功，更新本地数据
                    self?.originalUsers.removeAll { $0.id == user.id }
                    self?.users.removeAll { $0.id == user.id }
                    self?.deleteSuccess.send("用户 \(user.name) 删除成功")
                }
            )
            .catch { [weak self] error -> Just<Void> in
                if let apiError = error as? APIError {
                    self?.deleteError.send(apiError)
                } else {
                    self?.deleteError.send(APIError.unknown)
                }
                return Just(())
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - UserListViewModel Extension（扩展方法）
extension CombineUserListViewModel {

    /// 手动添加用户（用于演示）
    /// - Parameter user: 要添加的用户
    func addUser(_ user: MVVMUser) {
        userService.createUser(user)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        if let apiError = error as? APIError {
                            self?.deleteError.send(apiError)
                        } else {
                            self?.deleteError.send(APIError.unknown)
                        }
                    }
                },
                receiveValue: { [weak self] newUser in
                    self?.originalUsers.append(newUser)
                    self?.users.append(newUser)
                }
            )
            .store(in: &cancellables)
    }

    /// 更新用户信息
    /// - Parameter user: 要更新的用户
    func updateUser(_ user: MVVMUser) {
        userService.updateUser(user)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        if let apiError = error as? APIError {
                            self?.deleteError.send(apiError)
                        } else {
                            self?.deleteError.send(APIError.unknown)
                        }
                    }
                },
                receiveValue: { [weak self] updatedUser in
                    guard let self = self else { return }

                    // 更新原始列表
                    if let originalIndex = self.originalUsers.firstIndex(where: { $0.id == updatedUser.id }) {
                        self.originalUsers[originalIndex] = updatedUser
                    }

                    // 更新显示列表
                    if let displayIndex = self.users.firstIndex(where: { $0.id == updatedUser.id }) {
                        self.users[displayIndex] = updatedUser
                    }
                }
            )
            .store(in: &cancellables)
    }

    /// 根据关键词搜索用户
    /// - Parameter keyword: 搜索关键词
    func searchUsers(keyword: String) {
        if keyword.isEmpty {
            // 如果搜索关键词为空，显示所有用户
            users = originalUsers
            return
        }

        let filteredUsers = originalUsers.filter { user in
            user.name.lowercased().contains(keyword.lowercased()) ||
            user.email.lowercased().contains(keyword.lowercased())
        }

        users = filteredUsers
    }
}
