//
//  UIImage+Extension.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit

extension UIImage {
    // 调整图片大小
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    // 按比例调整图片大小
    func resized(withMaxWidth maxWidth: CGFloat) -> UIImage? {
        let aspectRatio = size.height / size.width
        let newHeight = maxWidth * aspectRatio
        return resized(to: CGSize(width: maxWidth, height: newHeight))
    }
    
    // 按比例调整图片大小
    func resized(withMaxHeight maxHeight: CGFloat) -> UIImage? {
        let aspectRatio = size.width / size.height
        let newWidth = maxHeight * aspectRatio
        return resized(to: CGSize(width: newWidth, height: maxHeight))
    }
}
