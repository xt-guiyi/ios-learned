//
//  CombineUserService.swift
//  ios-learned
//
//  Created by Claude on 2025/10/01.
//

import Foundation
import Moya
import Combine


/// Combine 版本的用户服务协议
protocol CombineUserServiceProtocol {
    /// 获取所有用户
    func fetchUsers() -> AnyPublisher<[MVVMUser], Error>

    /// 根据ID获取用户
    func fetchUser(by id: Int) -> AnyPublisher<MVVMUser, Error>

    /// 创建用户
    func createUser(_ user: MVVMUser) -> AnyPublisher<MVVMUser, Error>

    /// 更新用户
    func updateUser(_ user: MVVMUser) -> AnyPublisher<MVVMUser, Error>

    /// 删除用户
    func deleteUser(id: Int) -> AnyPublisher<Void, Error>
}

/// Combine 版本的用户服务实现类（使用 Moya + CombineMoya）
class CombineUserService: CombineUserServiceProtocol {
    /// 单例实例
    static let shared = CombineUserService()

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
    /// - Returns: 用户列表的 Publisher
    func fetchUsers() -> AnyPublisher<[MVVMUser], Error> {
        return provider.requestPublisher(.getAllUsers)
            .map(\.data)
            .decode(type: [MVVMUser].self, decoder: JSONDecoder())
            .mapError { error in
                return self.mapMoyaError(error)
            }
            .eraseToAnyPublisher()
    }

    /// 根据ID获取用户
    /// - Parameter id: 用户ID
    /// - Returns: 用户对象的 Publisher
    func fetchUser(by id: Int) -> AnyPublisher<MVVMUser, Error> {
        return provider.requestPublisher(.getUser(id: id))
            .map(\.data)
            .decode(type: MVVMUser.self, decoder: JSONDecoder())
            .mapError { error in
                return self.mapMoyaError(error)
            }
            .eraseToAnyPublisher()
    }

    /// 创建用户
    /// - Parameter user: 用户对象
    /// - Returns: 创建后的用户对象的 Publisher
    func createUser(_ user: MVVMUser) -> AnyPublisher<MVVMUser, Error> {
        return provider.requestPublisher(.createUser(user: user))
            .map(\.data)
            .decode(type: MVVMUser.self, decoder: JSONDecoder())
            .mapError { error in
                return self.mapMoyaError(error)
            }
            .eraseToAnyPublisher()
    }

    /// 更新用户
    /// - Parameter user: 用户对象
    /// - Returns: 更新后的用户对象的 Publisher
    func updateUser(_ user: MVVMUser) -> AnyPublisher<MVVMUser, Error> {
        return provider.requestPublisher(.updateUser(user: user))
            .map(\.data)
            .decode(type: MVVMUser.self, decoder: JSONDecoder())
            .mapError { error in
                return self.mapMoyaError(error)
            }
            .eraseToAnyPublisher()
    }

    /// 删除用户
    /// - Parameter id: 用户ID
    /// - Returns: 删除操作的 Publisher
    func deleteUser(id: Int) -> AnyPublisher<Void, Error> {
        return provider.requestPublisher(.deleteUser(id: id))
            .map { _ in () }
            .mapError { error in
                return self.mapMoyaError(error)
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    /// 将Moya错误映射为APIError
    /// - Parameter error: Moya或其他错误
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

        if let decodingError = error as? DecodingError {
            return .decodingError(decodingError)
        }

        return .networkError(error)
    }
}

// MARK: - Mock Service (用于测试)

/// Combine 版本的 Mock 用户服务
class CombineMockUserService: CombineUserServiceProtocol {
    /// 模拟数据
    private var mockUsers: [MVVMUser] = [
        MVVMUser(id: 1, name: "张三", email: "zhangsan@example.com", avatarURL: nil, phone: "13800138001", website: "https://zhangsan.com", address: nil, company: nil),
        MVVMUser(id: 2, name: "李四", email: "lisi@example.com", avatarURL: nil, phone: "13800138002", website: "https://lisi.com", address: nil, company: nil),
        MVVMUser(id: 3, name: "王五", email: "wangwu@example.com", avatarURL: nil, phone: "13800138003", website: "https://wangwu.com", address: nil, company: nil)
    ]

    /// 获取所有用户
    /// - Returns: 用户列表的 Publisher
    func fetchUsers() -> AnyPublisher<[MVVMUser], Error> {
        return Just(mockUsers)
            .delay(for: 1, scheduler: DispatchQueue.main) // 模拟网络延时
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    /// 根据ID获取用户
    /// - Parameter id: 用户ID
    /// - Returns: 用户对象的 Publisher
    func fetchUser(by id: Int) -> AnyPublisher<MVVMUser, Error> {
        if let user = mockUsers.first(where: { $0.id == id }) {
            return Just(user)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.serverError(404))
                .eraseToAnyPublisher()
        }
    }

    /// 创建用户
    /// - Parameter user: 用户对象
    /// - Returns: 创建后的用户对象的 Publisher
    func createUser(_ user: MVVMUser) -> AnyPublisher<MVVMUser, Error> {
        let newUser = MVVMUser(
            id: mockUsers.count + 1,
            name: user.name,
            email: user.email,
            avatarURL: user.avatarURL,
            phone: user.phone,
            website: user.website,
            address: user.address,
            company: user.company
        )
        mockUsers.append(newUser)

        return Just(newUser)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    /// 更新用户
    /// - Parameter user: 用户对象
    /// - Returns: 更新后的用户对象的 Publisher
    func updateUser(_ user: MVVMUser) -> AnyPublisher<MVVMUser, Error> {
        if let index = mockUsers.firstIndex(where: { $0.id == user.id }) {
            mockUsers[index] = user
            return Just(user)
                .delay(for: 1, scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.serverError(404))
                .eraseToAnyPublisher()
        }
    }

    /// 删除用户
    /// - Parameter id: 用户ID
    /// - Returns: 删除操作的 Publisher
    func deleteUser(id: Int) -> AnyPublisher<Void, Error> {
        mockUsers.removeAll { $0.id == id }
        return Just(())
            .delay(for: 1, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
