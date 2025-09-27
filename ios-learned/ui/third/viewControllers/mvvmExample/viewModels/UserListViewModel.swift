//
//  UserListViewModel.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import Foundation
import RxSwift
import RxCocoa

/// 用户列表视图状态
enum UserListViewState {
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

/// 用户列表ViewModel
class UserListViewModel {
    // MARK: - Dependencies
    /// 用户服务
    private let userService: UserServiceProtocol

    /// DisposeBag
    private let disposeBag = DisposeBag()

    // MARK: - Inputs
    /// 加载触发器
    let loadTrigger = PublishRelay<Void>()

    /// 刷新触发器
    let refreshTrigger = PublishRelay<Void>()

    /// 重试触发器
    let retryTrigger = PublishRelay<Void>()

    /// 用户选择触发器
    let selectUserTrigger = PublishRelay<MVVMUser>()

    /// 删除用户触发器
    let deleteUserTrigger = PublishRelay<MVVMUser>()

    // MARK: - Outputs
    /// 视图状态
    let viewState = BehaviorRelay<UserListViewState>(value: .idle)

    /// 用户列表（用于显示）
    let users = BehaviorRelay<[MVVMUser]>(value: [])

    /// 原始用户列表（完整数据）
    private let originalUsers = BehaviorRelay<[MVVMUser]>(value: [])

    /// 是否正在加载
    let isLoading: Driver<Bool>

    /// 是否正在刷新
    let isRefreshing: Driver<Bool>

    /// 是否显示空状态
    let isEmpty: Driver<Bool>

    /// 错误信息
    let error: Driver<APIError?>

    /// 用户选择事件
    let userSelected: Driver<MVVMUser>

    /// 删除成功事件
    let deleteSuccess: Driver<String>

    /// 删除失败事件
    let deleteError: Driver<APIError>

    // MARK: - Private Properties
    /// 删除成功主题
    private let deleteSuccessSubject = PublishSubject<String>()

    /// 删除失败主题
    private let deleteErrorSubject = PublishSubject<APIError>()

    // MARK: - Initialization
    /// 初始化方法
    /// - Parameter userService: 用户服务，默认使用Moya的Mock服务
    init(userService: UserServiceProtocol = UserService(useMock: false)) {
        self.userService = userService

        // 计算属性
        self.isLoading = viewState
            .map { state in
                if case .loading = state {
                    return true
                }
                return false
            }
            .asDriver(onErrorJustReturn: false)

        self.isRefreshing = viewState
            .map { state in
                if case .refreshing = state {
                    return true
                }
                return false
            }
            .asDriver(onErrorJustReturn: false)

        self.isEmpty = Observable.combineLatest(users, viewState)
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
            .asDriver(onErrorJustReturn: false)

        self.error = viewState
            .map { state in
                if case .error(let error) = state {
                    return error
                }
                return nil
            }
            .asDriver(onErrorJustReturn: nil)

        self.userSelected = selectUserTrigger.asDriver(onErrorDriveWith: .empty())
        self.deleteSuccess = deleteSuccessSubject.asDriver(onErrorJustReturn: "")
        self.deleteError = deleteErrorSubject.asDriver(onErrorDriveWith: .empty())

        setupBindings()
    }

    // MARK: - Private Methods
    /// 设置绑定关系
    private func setupBindings() {
        // 加载用户列表
        let loadUsers = Observable.merge(
            loadTrigger.asObservable(),
            retryTrigger.asObservable()
        )
        .flatMapLatest { [weak self] _ -> Observable<UserListViewState> in
            guard let self = self else { return .empty() }
            return self.loadUsersWithState()
        }

        // 刷新用户列表
        let refreshUsers = refreshTrigger
            .withLatestFrom(users.asObservable())
            .flatMapLatest { [weak self] currentUsers -> Observable<UserListViewState> in
                guard let self = self else { return .empty() }
                return self.refreshUsersWithState(currentUsers: currentUsers)
            }

        // 删除用户
        deleteUserTrigger
            .flatMapLatest { [weak self] user -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.deleteUser(user)
            }
            .subscribe()
            .disposed(by: disposeBag)

        // 合并状态变化
        Observable.merge(loadUsers, refreshUsers)
            .bind(to: viewState)
            .disposed(by: disposeBag)

        // 更新用户列表
        viewState
            .compactMap { state -> [MVVMUser]? in
                switch state {
                case .loaded(let users), .refreshing(let users):
                    return users
                default:
                    return nil
                }
            }
            .subscribe(onNext: { [weak self] userList in
                self?.originalUsers.accept(userList)
                self?.users.accept(userList)
            })
            .disposed(by: disposeBag)
    }

    /// 加载用户并返回状态
    private func loadUsersWithState() -> Observable<UserListViewState> {
        return userService.fetchUsers()
            .asObservable()
            .map { UserListViewState.loaded($0) }
            .catchAndReturn(.error(APIError.unknown))
            .startWith(.loading)
    }

    /// 刷新用户并返回状态
    private func refreshUsersWithState(currentUsers: [MVVMUser]) -> Observable<UserListViewState> {
        return userService.fetchUsers()
            .asObservable()
            .map { UserListViewState.loaded($0) }
            .catchAndReturn(.error(APIError.unknown))
            .startWith(.refreshing(currentUsers))
    }

    /// 删除用户
    private func deleteUser(_ user: MVVMUser) -> Observable<Void> {
        return userService.deleteUser(id: user.id)
            .asObservable()
            .do(onNext: { [weak self] _ in
                // 删除成功，更新本地数据
                let currentOriginalUsers = self?.originalUsers.value ?? []
                let updatedOriginalUsers = currentOriginalUsers.filter { $0.id != user.id }
                self?.originalUsers.accept(updatedOriginalUsers)

                let currentDisplayUsers = self?.users.value ?? []
                let updatedDisplayUsers = currentDisplayUsers.filter { $0.id != user.id }
                self?.users.accept(updatedDisplayUsers)

                self?.deleteSuccessSubject.onNext("用户 \(user.name) 删除成功")
            })
            .catch { [weak self] error in
                if let apiError = error as? APIError {
                    self?.deleteErrorSubject.onNext(apiError)
                } else {
                    self?.deleteErrorSubject.onNext(APIError.unknown)
                }
                return Observable.just(())
            }
    }
}

// MARK: - UserListViewModel Extension
extension UserListViewModel {
    /// 手动添加用户（用于演示）
    func addUser(_ user: MVVMUser) {
        userService.createUser(user)
            .subscribe(
                onSuccess: { [weak self] newUser in
                    var currentOriginalUsers = self?.originalUsers.value ?? []
                    currentOriginalUsers.append(newUser)
                    self?.originalUsers.accept(currentOriginalUsers)

                    var currentDisplayUsers = self?.users.value ?? []
                    currentDisplayUsers.append(newUser)
                    self?.users.accept(currentDisplayUsers)
                },
                onFailure: { [weak self] error in
                    if let apiError = error as? APIError {
                        self?.deleteErrorSubject.onNext(apiError)
                    }
                }
            )
            .disposed(by: disposeBag)
    }

    /// 更新用户信息
    func updateUser(_ user: MVVMUser) {
        userService.updateUser(user)
            .subscribe(
                onSuccess: { [weak self] updatedUser in
                    var currentOriginalUsers = self?.originalUsers.value ?? []
                    if let originalIndex = currentOriginalUsers.firstIndex(where: { $0.id == updatedUser.id }) {
                        currentOriginalUsers[originalIndex] = updatedUser
                        self?.originalUsers.accept(currentOriginalUsers)
                    }

                    var currentDisplayUsers = self?.users.value ?? []
                    if let displayIndex = currentDisplayUsers.firstIndex(where: { $0.id == updatedUser.id }) {
                        currentDisplayUsers[displayIndex] = updatedUser
                        self?.users.accept(currentDisplayUsers)
                    }
                },
                onFailure: { [weak self] error in
                    if let apiError = error as? APIError {
                        self?.deleteErrorSubject.onNext(apiError)
                    }
                }
            )
            .disposed(by: disposeBag)
    }

    /// 根据关键词搜索用户
    func searchUsers(keyword: String) {
        let allUsers = originalUsers.value

        if keyword.isEmpty {
            // 如果搜索关键词为空，显示所有用户
            users.accept(allUsers)
            return
        }

        let filteredUsers = allUsers.filter { user in
            user.name.lowercased().contains(keyword.lowercased()) ||
            user.email.lowercased().contains(keyword.lowercased())
        }

        users.accept(filteredUsers)
    }
}