//
//  APIError.swift
//  ios-learned
//
//  Created by Claude on 2025/9/27.
//

import Foundation

/// API错误类型定义
enum APIError: Error, LocalizedError {
    /// 网络错误
    case networkError(Error)

    /// 无效的URL
    case invalidURL

    /// 无数据
    case noData

    /// 解析错误
    case decodingError(Error)

    /// 服务器错误
    case serverError(Int)

    /// 未知错误
    case unknown

    /// 错误描述
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .invalidURL:
            return "无效的URL"
        case .noData:
            return "没有数据"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .serverError(let code):
            return "服务器错误: \(code)"
        case .unknown:
            return "未知错误"
        }
    }
}