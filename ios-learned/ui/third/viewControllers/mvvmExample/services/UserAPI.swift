//
//  UserAPI.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import Foundation
import Moya

/// 用户相关API接口定义
enum UserAPI {
    /// 获取所有用户
    case getAllUsers

    /// 根据ID获取用户
    case getUser(id: Int)

    /// 创建用户
    case createUser(user: MVVMUser)

    /// 更新用户
    case updateUser(user: MVVMUser)

    /// 删除用户
    case deleteUser(id: Int)
}

// MARK: - Moya TargetType实现
extension UserAPI: TargetType {

    /// 基础URL
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    /// 请求路径
    var path: String {
        switch self {
        case .getAllUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        case .updateUser(let user):
            return "/users/\(user.id)"
        case .deleteUser(let id):
            return "/users/\(id)"
        }
    }

    /// HTTP请求方法
    var method: Moya.Method {
        switch self {
        case .getAllUsers, .getUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }

    /// 请求任务类型
    var task: Task {
        switch self {
        case .getAllUsers, .getUser, .deleteUser:
            return .requestPlain

        case .createUser(let user), .updateUser(let user):
            do {
                let encoder = JSONEncoder()
                let userData = try encoder.encode(user)
                return .requestData(userData)
            } catch {
                // 如果编码失败，返回空请求
                return .requestPlain
            }
        }
    }

    /// 请求头
    var headers: [String: String]? {
        var headers: [String: String] = [:]

        switch self {
        case .createUser, .updateUser:
            headers["Content-Type"] = "application/json"
        default:
            break
        }

        // 通用请求头
        headers["Accept"] = "application/json"
        headers["User-Agent"] = "iOS-Learned-App/1.0"

        return headers
    }

    /// 示例数据（用于测试）
    var sampleData: Data {
        switch self {
        case .getAllUsers:
            return mockUsersListJSON.data(using: .utf8) ?? Data()
        case .getUser:
            return mockUserJSON.data(using: .utf8) ?? Data()
        case .createUser(let user), .updateUser(let user):
            return createMockUserJSON(for: user).data(using: .utf8) ?? Data()
        case .deleteUser:
            return "{}".data(using: .utf8) ?? Data()
        }
    }
}

// MARK: - Mock数据
extension UserAPI {

    /// 模拟用户列表JSON
    private var mockUsersListJSON: String {
        return """
        [
            {
                "id": 1,
                "name": "张三",
                "email": "zhangsan@example.com",
                "phone": "13800138001",
                "website": "https://zhangsan.com",
                "address": {
                    "street": "中山路",
                    "suite": "1001室",
                    "city": "北京",
                    "zipcode": "100000",
                    "geo": {
                        "lat": "39.9042",
                        "lng": "116.4074"
                    }
                },
                "company": {
                    "name": "科技有限公司",
                    "catchPhrase": "创新驱动未来",
                    "bs": "软件开发"
                }
            },
            {
                "id": 2,
                "name": "李四",
                "email": "lisi@example.com",
                "phone": "13800138002",
                "website": "https://lisi.com",
                "address": {
                    "street": "解放路",
                    "suite": "2002室",
                    "city": "上海",
                    "zipcode": "200000",
                    "geo": {
                        "lat": "31.2304",
                        "lng": "121.4737"
                    }
                },
                "company": {
                    "name": "互联网科技",
                    "catchPhrase": "连接世界",
                    "bs": "互联网服务"
                }
            },
            {
                "id": 3,
                "name": "王五",
                "email": "wangwu@example.com",
                "phone": "13800138003",
                "website": "https://wangwu.com",
                "address": {
                    "street": "人民路",
                    "suite": "3003室",
                    "city": "广州",
                    "zipcode": "510000",
                    "geo": {
                        "lat": "23.1291",
                        "lng": "113.2644"
                    }
                },
                "company": {
                    "name": "金融科技",
                    "catchPhrase": "智慧金融",
                    "bs": "金融服务"
                }
            }
        ]
        """
    }

    /// 模拟单个用户JSON
    private var mockUserJSON: String {
        return """
        {
            "id": 1,
            "name": "张三",
            "email": "zhangsan@example.com",
            "phone": "13800138001",
            "website": "https://zhangsan.com",
            "address": {
                "street": "中山路",
                "suite": "1001室",
                "city": "北京",
                "zipcode": "100000",
                "geo": {
                    "lat": "39.9042",
                    "lng": "116.4074"
                }
            },
            "company": {
                "name": "科技有限公司",
                "catchPhrase": "创新驱动未来",
                "bs": "软件开发"
            }
        }
        """
    }

    /// 为指定用户创建模拟JSON
    /// - Parameter user: 用户对象
    /// - Returns: JSON字符串
    private func createMockUserJSON(for user: MVVMUser) -> String {
        return """
        {
            "id": \(user.id),
            "name": "\(user.name)",
            "email": "\(user.email)",
            "phone": "\(user.phone ?? "")",
            "website": "\(user.website ?? "")",
            "address": {
                "street": "\(user.address?.street ?? "")",
                "suite": "\(user.address?.suite ?? "")",
                "city": "\(user.address?.city ?? "")",
                "zipcode": "\(user.address?.zipcode ?? "")",
                "geo": {
                    "lat": "\(user.address?.geo.lat ?? "")",
                    "lng": "\(user.address?.geo.lng ?? "")"
                }
            },
            "company": {
                "name": "\(user.company?.name ?? "")",
                "catchPhrase": "\(user.company?.catchPhrase ?? "")",
                "bs": "\(user.company?.bs ?? "")"
            }
        }
        """
    }
}

// MARK: - 网络配置
extension UserAPI {

    /// 获取真实API的Provider
    static var realProvider: MoyaProvider<UserAPI> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60

        let session = Session(configuration: configuration)

        return MoyaProvider<UserAPI>(
            session: session,
            plugins: [
                NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            ]
        )
    }

    /// 获取Mock API的Provider（用于测试）
    static var mockProvider: MoyaProvider<UserAPI> {
        return MoyaProvider<UserAPI>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [
                NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            ]
        )
    }
}