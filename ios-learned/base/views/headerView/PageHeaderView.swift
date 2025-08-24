//
//  PageHeaderView.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class PageHeaderView: UIView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.themeColor
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    func setupConstraintsForSafeArea() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(0)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
}
