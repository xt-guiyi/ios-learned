//
//  CustomTabBarItem.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

/// 自定义TabBar项目数据模型
public struct CustomTabBarItemModel {
    public let title: String
    public let normalImage: UIImage?
    public let selectedImage: UIImage?
    public let viewController: UIViewController

    public init(title: String, normalImage: UIImage?, selectedImage: UIImage?, viewController: UIViewController) {
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.viewController = viewController
    }
}

/// 自定义TabBar单个项目视图
class CustomTabBarItem: UIView {

    // MARK: - UI Components

    /// 图标视图
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    /// 标题标签
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()


    // MARK: - Properties

    /// 数据模型
    private var model: CustomTabBarItemModel?

    /// 是否选中
    var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    /// 点击回调
    var onTap: (() -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    /// 配置TabBar项目
    /// - Parameter model: 项目数据模型
    func configure(with model: CustomTabBarItemModel) {
        self.model = model
        titleLabel.text = model.title
        iconImageView.image = model.normalImage?.resized(to: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
        updateAppearance()
    }

    // MARK: - Private Methods

    /// 设置UI界面
    private func setupUI() {
        backgroundColor = .clear

        addSubview(iconImageView)
        addSubview(titleLabel)

        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(25)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(4)
            make.height.equalTo(15)
        }
    }

    /// 设置手势识别
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    /// 更新外观显示
    private func updateAppearance() {
        guard let model = model else { return }

        if isSelected {
            // 选中状态
            iconImageView.image = model.selectedImage?.resized(to: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
            titleLabel.textColor = UIColor.themeColor
        } else {
            // 未选中状态
            iconImageView.image = model.normalImage?.resized(to: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
            titleLabel.textColor = .black
        }
    }

    /// 处理点击手势
    @objc private func handleTap() {
        // 直接执行点击回调，无任何动画
        onTap?()
    }
}