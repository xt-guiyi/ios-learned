//
//  swift语法学习.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/19.
//

import Foundation


// MARK: 枚举
// 普通枚举
enum CompassPoint {
    case north
    case south
    case ease
    case west
}

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

// 关联值--枚举的每个 case 可以携带不同类型和数量的关联数据。
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

// 原始值 -- 枚举 case 可以预设一个原始值（如 Int、String 等），必须是相同类型。
enum Fruit: String {
    case apple = "苹果"
    case banana = "香蕉"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


// 枚举中的方法和属性 -- 枚举可以定义实例方法、静态方法、计算属性等。
enum Device {
    case iPhone, iPad, mac

    var description: String {
        switch self {
        case .iPhone:
            return "苹果手机"
        case .iPad:
            return "苹果平板"
        case .mac:
            return "苹果电脑"
        }
    }

    mutating func upgrade() {
        if self == .iPhone {
            self = .iPad
        }
    }

    static func allDevices() -> [Device] {
        return [.iPhone, .iPad, .mac]
    }
}


// 遵循协议，扩展
enum Priority: Comparable {
    case low, medium, high

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        let order: [Priority: Int] = [.low: 0, .medium: 1, .high: 2]
        return order[lhs]! < order[rhs]!
    }
}


// 遵循 CustomStringConvertible
extension Priority: CustomStringConvertible {
    var description: String {
        switch self {
        case .low: return "低优先级"
        case .medium: return "中优先级"
        case .high: return "高优先级"
        }
    }
}

// 枚举与泛型结合
enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum NetworkError: Error {
    case timeout
    case noInternet
}



func executeEnum() {
    var direction = CompassPoint.ease
    direction = .north // 类型已知时可以省略枚举名
    
    switch direction {
    case .ease:
        print("向东")
    case .north:
        print("向北")
    case .south:
        print("向南")
    case .west:
        print("向西")
    }
    
    
    var productBarcode = Barcode.upc(8, 85909, 51223, 3)
    productBarcode = .qrCode("ABCDEFGHJKL")
    
    switch productBarcode {
    case .upc(let numberSystem, let manufacturer, let product, let check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
    case .qrCode(let code):
            print("QR Code: \(code)")
    }
    
    
    let fruit = Fruit.apple
    print(fruit.rawValue)
    let method = HTTPMethod.post
    print(method.rawValue) // "POST"
    // 通过原始值创建枚举（返回可选值）
    var apple = Fruit(rawValue: "苹果")
    if apple == Fruit.apple {
        print("这是水果")
    }
    
    
    var myDevice = Device.iPhone
    print(myDevice.description) // "苹果手机"
    myDevice.upgrade()
    print(myDevice) // iPad

    print(Device.allDevices()) // [.iPhone, .iPad, .mac]
    
    
    print(Priority.low < Priority.high) // true
    print(Priority.high) // "高优先级"
    
    let result: Result<String, NetworkError> = .success("数据加载成功")

    switch result {
    case .success(let data):
        print("成功：\(data)")
    case .failure(let error):
        print("失败：\(error)")
    }
    
    
    
}




