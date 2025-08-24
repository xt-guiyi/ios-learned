//
//  CustomNavigationBar.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var onBackButtonTapped: (() -> Void)?
    
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
        
        // 设置标题
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        let arrowImage = UIImage.arrowLeft.resized(to: CGSize(width: 28, height: 28))?.withRenderingMode(.alwaysOriginal)
        // 设置返回按钮
        backButton.setImage(arrowImage, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(backButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(0)
            make.centerX.equalToSuperview()

        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    @objc private func backButtonTapped() {
        onBackButtonTapped?()
    }
    
    func configure(title: String, onBackTapped: @escaping () -> Void) {
        self.title = title
        self.onBackButtonTapped = onBackTapped
    }
}
