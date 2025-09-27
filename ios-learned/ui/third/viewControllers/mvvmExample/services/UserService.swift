//
//  UserService.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import Foundation
import Moya
import RxSwift

/// 用户服务协议
protocol UserServiceProtocol {
    /// 获取所有用户
    func fetchUsers() -> Single<[MVVMUser]>

    /// 根据ID获取用户
    func fetchUser(by id: Int) -> Single<MVVMUser>

    /// 创建用户
    func createUser(_ user: MVVMUser) -> Single<MVVMUser>

    /// 更新用户
    func updateUser(_ user: MVVMUser) -> Single<MVVMUser>

    /// 删除用户
    func deleteUser(id: Int) -> Single<Void>
}

/// 用户服务实现类（使用Moya）
class UserService: UserServiceProtocol {
    /// 单例实例
    static let shared = UserService()

    /// Moya Provider
    private let provider: MoyaProvider<UserAPI>

    /// 初始化方法
    /// - Parameter useMock: 是否使用Mock数据，默认false使用真实API
    init(useMock: Bool = false) {
        self.provider = useMock ? UserAPI.mockProvider : UserAPI.realProvider
    }

    /// 私有初始化（单例）
    private convenience init() {
        self.init(useMock: false)
    }

    /// 获取所有用户
    func fetchUsers() -> Single<[MVVMUser]> {
        return provider.rx
            .request(.getAllUsers)
            .map([MVVMUser].self)
            .catch { error in
                return Single.error(self.mapMoyaError(error))
            }
    }

    /// 根据ID获取用户
    func fetchUser(by id: Int) -> Single<MVVMUser> {
        return provider.rx
            .request(.getUser(id: id))
            .map(MVVMUser.self)
            .catch { error in
                return Single.error(self.mapMoyaError(error))
            }
    }

    /// 创建用户
    func createUser(_ user: MVVMUser) -> Single<MVVMUser> {
        return provider.rx
            .request(.createUser(user: user))
            .map(MVVMUser.self)
            .catch { error in
                return Single.error(self.mapMoyaError(error))
            }
    }

    /// 更新用户
    func updateUser(_ user: MVVMUser) -> Single<MVVMUser> {
        return provider.rx
            .request(.updateUser(user: user))
            .map(MVVMUser.self)
            .catch { error in
                return Single.error(self.mapMoyaError(error))
            }
    }

    /// 删除用户
    func deleteUser(id: Int) -> Single<Void> {
        return provider.rx
            .request(.deleteUser(id: id))
            .map { _ in () }
            .catch { error in
                return Single.error(self.mapMoyaError(error))
            }
    }

    // MARK: - Private Methods
    /// 将Moya错误映射为APIError
    /// - Parameter error: Moya错误
    /// - Returns: APIError
    private func mapMoyaError(_ error: Error) -> APIError {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .imageMapping, .jsonMapping, .stringMapping, .objectMapping:
                return .decodingError(moyaError)
            case .statusCode(let response):
                return .serverError(response.statusCode)
            case .underlying(let nsError, _):
                return .networkError(nsError)
            default:
                return .unknown
            }
        }
        return .networkError(error)
    }
}

// MARK: - Mock Service (用于测试)
class MockUserService: UserServiceProtocol {
    /// 模拟数据
    private var mockUsers: [MVVMUser] = [
        MVVMUser(id: 1, name: "张三", email: "zhangsan@example.com", avatarURL: nil, phone: "13800138001", website: "https://zhangsan.com", address: nil, company: nil),
        MVVMUser(id: 2, name: "李四", email: "lisi@example.com", avatarURL: nil, phone: "13800138002", website: "https://lisi.com", address: nil, company: nil),
        MVVMUser(id: 3, name: "王五", email: "wangwu@example.com", avatarURL: nil, phone: "13800138003", website: "https://wangwu.com", address: nil, company: nil)
    ]

    func fetchUsers() -> Single<[MVVMUser]> {
        return Single.just(mockUsers)
            .delay(.seconds(1), scheduler: MainScheduler.instance) // 模拟网络延时
    }

    func fetchUser(by id: Int) -> Single<MVVMUser> {
        if let user = mockUsers.first(where: { $0.id == id }) {
            return Single.just(user)
                .delay(.seconds(1), scheduler: MainScheduler.instance)
        } else {
            return Single.error(APIError.serverError(404))
        }
    }

    func createUser(_ user: MVVMUser) -> Single<MVVMUser> {
        let newUser = MVVMUser(id: mockUsers.count + 1, name: user.name, email: user.email, avatarURL: user.avatarURL, phone: user.phone, website: user.website, address: user.address, company: user.company)
        mockUsers.append(newUser)
        return Single.just(newUser)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }

    func updateUser(_ user: MVVMUser) -> Single<MVVMUser> {
        if let index = mockUsers.firstIndex(where: { $0.id == user.id }) {
            mockUsers[index] = user
            return Single.just(user)
                .delay(.seconds(1), scheduler: MainScheduler.instance)
        } else {
            return Single.error(APIError.serverError(404))
        }
    }

    func deleteUser(id: Int) -> Single<Void> {
        mockUsers.removeAll { $0.id == id }
        return Single.just(())
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}