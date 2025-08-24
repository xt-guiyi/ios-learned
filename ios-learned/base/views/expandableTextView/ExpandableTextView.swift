//
//  ExpandableTextView.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class ExpandableTextView: UIView {
    private let label = UILabel()
    private var fullText = ""
    private var isExpanded = false
    
    // 可配置属性
    var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            label.font = font
            updateContent()
        }
    }
    
    var textColor: UIColor = .black {
        didSet {
            updateContent()
        }
    }
    
    var expandText: String = "展开" {
        didSet {
            updateContent()
        }
    }
    
    var collapseText: String = "收起" {
        didSet {
            updateContent()
        }
    }
    
    var buttonColor: UIColor = UIColor.themeColor {
        didSet {
            updateContent()
        }
    }
    
    var numberOfLines: Int = 2 {
        didSet {
            updateContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(label)
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpansion))
        label.addGestureRecognizer(tapGesture)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setText(_ text: String) {
        fullText = text
        updateContent()
    }
    
    @objc private func toggleExpansion() {
        isExpanded.toggle()
        UIView.animate(withDuration: 0.3) {
            self.updateContent()
            self.superview?.layoutIfNeeded()
        }
    }
    
    private func updateContent() {
        if isExpanded {
            // 展开状态：显示完整文本 + 收起按钮
            let collapseButtonText = " " + collapseText
            let expandedText = fullText + collapseButtonText
            let attributedString = NSMutableAttributedString(string: expandedText)
            
            // 设置基础文本属性
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: expandedText.count))
            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: fullText.count))
            
            // 精确设置收起按钮的位置和颜色
            let buttonRange = NSRange(location: fullText.count, length: collapseButtonText.count)
            attributedString.addAttribute(.foregroundColor, value: buttonColor, range: buttonRange)
            
            label.attributedText = attributedString
            label.numberOfLines = 0
        } else {
            // 收起状态：先设置临时文本，等布局完成后创建带展开按钮的截断文本
            label.text = fullText
            label.numberOfLines = numberOfLines
            label.lineBreakMode = .byTruncatingTail
            
            DispatchQueue.main.async {
                self.createCollapsedText()
            }
        }
    }
    
    private func createCollapsedText() {
        // 先检查文本是否需要截断
        let fullSize = fullText.boundingRect(
            with: CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        let maxHeight = font.lineHeight * CGFloat(numberOfLines)
        
        if fullSize.height <= maxHeight {
            // 不需要截断，直接显示
            let attributedString = NSMutableAttributedString(string: fullText)
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: fullText.count))
            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: fullText.count))
            label.attributedText = attributedString
            label.numberOfLines = numberOfLines
            return
        }
        
        // 需要截断，创建带展开按钮的文本
        let expandButtonText = " " + expandText
        let ellipsis = "..."
        
        // 通过二分查找确定最佳截断位置
        var left = 0
        var right = fullText.count
        var bestTruncation = ""
        
        while left <= right {
            let mid = (left + right) / 2
            let truncatedContent = String(fullText.prefix(mid))
            let testText = truncatedContent + ellipsis + expandButtonText
            
            let testSize = testText.boundingRect(
                with: CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )
            
            if testSize.height <= maxHeight {
                bestTruncation = truncatedContent
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        // 创建最终的富文本
        let finalText = bestTruncation.trimmingCharacters(in: .whitespaces) + ellipsis + expandButtonText
        let attributedString = NSMutableAttributedString(string: finalText)
        
        // 设置基础文本属性
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: finalText.count))
        attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: finalText.count))
        
        // 精确设置展开按钮的颜色（从ellipsis之后开始）
        let ellipsisEndIndex = bestTruncation.trimmingCharacters(in: .whitespaces).count + ellipsis.count
        let expandButtonRange = NSRange(location: ellipsisEndIndex, length: expandButtonText.count)
        attributedString.addAttribute(.foregroundColor, value: buttonColor, range: expandButtonRange)
        
        label.attributedText = attributedString
        label.numberOfLines = numberOfLines
    }
}