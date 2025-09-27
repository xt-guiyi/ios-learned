//
//  User.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import Foundation

/// 用户数据模型
struct MVVMUser: Codable {
    /// 用户ID
    let id: Int

    /// 用户名
    let name: String

    /// 用户邮箱
    let email: String

    /// 用户头像URL
    let avatarURL: String?

    /// 用户电话
    let phone: String?

    /// 用户网站
    let website: String?

    /// 用户地址
    let address: Address?

    /// 用户公司信息
    let company: Company?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, website, address, company
        case avatarURL = "avatar_url"
    }
}

/// 地址模型
struct Address: Codable {
    /// 街道地址
    let street: String

    /// 套房/单元号
    let suite: String

    /// 城市
    let city: String

    /// 邮政编码
    let zipcode: String

    /// 地理位置
    let geo: Geo
}

/// 地理位置模型
struct Geo: Codable {
    /// 纬度
    let lat: String

    /// 经度
    let lng: String
}

/// 公司模型
struct Company: Codable {
    /// 公司名称
    let name: String

    /// 公司口号
    let catchPhrase: String

    /// 业务范围
    let bs: String
}

// MARK: - User 扩展方法
extension MVVMUser {
    /// 获取完整地址字符串
    var fullAddress: String {
        guard let address = address else { return "暂无地址" }
        return "\(address.street), \(address.suite), \(address.city) \(address.zipcode)"
    }

    /// 获取显示用的头像URL（如果没有头像则使用默认头像）
    var displayAvatarURL: String {
        return avatarURL ?? "https://via.placeholder.com/150/92c5f7/ffffff?text=\(name.prefix(1))"
    }

    /// 检查用户信息是否完整
    var isProfileComplete: Bool {
        return !name.isEmpty && !email.isEmpty && phone != nil && website != nil
    }
}