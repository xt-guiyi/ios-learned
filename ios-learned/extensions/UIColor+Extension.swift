import UIKit

extension UIColor {
    // MARK: - 便利构造方法
    /// 使用十六进制值创建颜色
    /// - Parameters:
    ///   - hex: 十六进制颜色值，例如 0xFF8000
    ///   - alpha: 透明度，默认为1.0
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
    
    /// 使用十六进制字符串创建颜色
    /// - Parameters:
    ///   - hexString: 十六进制字符串，例如 "#FF8000" 或 "FF8000"
    ///   - alpha: 透明度，默认为1.0
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    // MARK: - 主题颜色
    /// 应用主题色（绿色）
    static var themeColor: UIColor {
        return UIColor(hex: 0x1CC787) // 绿色主题
    }
    
    /// 应用次要主题色
    static var secondaryThemeColor: UIColor {
        return UIColor(hex: 0x5856D6)
    }
    
    /// 文本主色
    static var mainTextColor: UIColor {
        return dynamicColor(light: UIColor(hex: 0x333333), dark: UIColor(hex: 0xFFFFFF))
    }
    
    /// 文本次要色
    static var secondaryTextColor: UIColor {
        return dynamicColor(light: UIColor(hex: 0x666666), dark: UIColor(hex: 0xCCCCCC))
    }
    
    /// 背景色
    static var backgroundColor: UIColor {
        return dynamicColor(light: UIColor(hex: 0xF5F5F5), dark: UIColor(hex: 0x1C1C1E))
    }
    
    // MARK: - 辅助方法
    /// 创建动态颜色（自动适配深色模式）
    /// - Parameters:
    ///   - light: 浅色模式下的颜色
    ///   - dark: 深色模式下的颜色
    /// - Returns: 动态颜色
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return dark
                default:
                    return light
                }
            }
        } else {
            return light
        }
    }
}
