//
//  NetworkTest.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import Foundation
import RxSwift

/// 网络层测试类
class NetworkTest {
    /// DisposeBag
    private let disposeBag = DisposeBag()

    /// 测试真实API
    func testRealAPI() {
        print("🚀 开始测试真实API...")

        let realService = UserService(useMock: false)

        realService.fetchUsers()
            .subscribe(
                onSuccess: { users in
                    print("✅ 真实API测试成功，获取到 \(users.count) 个用户")
                    users.forEach { user in
                        print("👤 用户: \(user.name) - \(user.email)")
                    }
                },
                onFailure: { error in
                    print("❌ 真实API测试失败: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }

    /// 测试Mock API
    func testMockAPI() {
        print("🎭 开始测试Mock API...")

        let mockService = UserService(useMock: true)

        mockService.fetchUsers()
            .subscribe(
                onSuccess: { users in
                    print("✅ Mock API测试成功，获取到 \(users.count) 个用户")
                    users.forEach { user in
                        print("👤 用户: \(user.name) - \(user.email)")
                    }
                },
                onFailure: { error in
                    print("❌ Mock API测试失败: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }

    /// 测试CRUD操作
    func testCRUDOperations() {
        print("🔧 开始测试CRUD操作...")

        let service = UserService(useMock: true)

        // 测试创建用户
        let newUser = MVVMUser(
            id: 999,
            name: "测试用户",
            email: "test@example.com",
            avatarURL: nil,
            phone: "13800138999",
            website: "https://test.com",
            address: nil,
            company: nil
        )

        service.createUser(newUser)
            .flatMap { createdUser -> Single<MVVMUser> in
                print("✅ 创建用户成功: \(createdUser.name)")

                // 测试更新用户
                let updatedUser = MVVMUser(
                    id: createdUser.id,
                    name: "更新后的用户",
                    email: createdUser.email,
                    avatarURL: createdUser.avatarURL,
                    phone: createdUser.phone,
                    website: createdUser.website,
                    address: createdUser.address,
                    company: createdUser.company
                )

                return service.updateUser(updatedUser)
            }
            .flatMap { updatedUser -> Single<Void> in
                print("✅ 更新用户成功: \(updatedUser.name)")

                // 测试删除用户
                return service.deleteUser(id: updatedUser.id)
            }
            .subscribe(
                onSuccess: {
                    print("✅ 删除用户成功")
                    print("🎉 CRUD操作测试全部完成")
                },
                onFailure: { error in
                    print("❌ CRUD操作测试失败: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }

    /// 执行所有测试
    func runAllTests() {
        print("🧪 开始运行所有网络层测试...")
        print(String(repeating: "=", count: 50))

        // 等待2秒后开始测试
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.testMockAPI()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.testRealAPI()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.testCRUDOperations()
        }
    }
}