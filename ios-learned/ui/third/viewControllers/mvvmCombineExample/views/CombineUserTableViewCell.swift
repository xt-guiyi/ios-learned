//
//  CombineUserTableViewCell.swift
//  ios-learned
//
//  Created by Claude on 2025/10/01.
//

import UIKit
import SnapKit
import Kingfisher

/// Combine 版本的用户列表单元格
class CombineUserTableViewCell: UITableViewCell {
    // MARK: - Constants
    /// 复用标识符
    static let identifier = "CombineUserTableViewCell"

    // MARK: - UI Components
    /// 容器视图
    private let containerView = UIView()

    /// 头像图片视图
    private let avatarImageView = UIImageView()

    /// 用户名标签
    private let nameLabel = UILabel()

    /// 邮箱标签
    private let emailLabel = UILabel()

    /// 电话标签
    private let phoneLabel = UILabel()

    /// 网站标签
    private let websiteLabel = UILabel()

    /// 状态指示器
    private let statusIndicator = UIView()

    /// 箭头图标
    private let arrowImageView = UIImageView()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    /// 设置UI界面
    private func setupUI() {
        setupContainerView()
        setupAvatarImageView()
        setupLabels()
        setupStatusIndicator()
        setupArrowImageView()
        setupConstraints()
    }

    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4

        contentView.addSubview(containerView)
    }

    /// 设置头像图片视图
    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = UIColor.systemGray5

        containerView.addSubview(avatarImageView)
    }

    /// 设置标签
    private func setupLabels() {
        // 用户名标签
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 1

        // 邮箱标签
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = UIColor.systemBlue
        emailLabel.numberOfLines = 1

        // 电话标签
        phoneLabel.font = UIFont.systemFont(ofSize: 13)
        phoneLabel.textColor = UIColor.systemGray
        phoneLabel.numberOfLines = 1

        // 网站标签
        websiteLabel.font = UIFont.systemFont(ofSize: 13)
        websiteLabel.textColor = UIColor.systemGray
        websiteLabel.numberOfLines = 1

        [nameLabel, emailLabel, phoneLabel, websiteLabel].forEach {
            containerView.addSubview($0)
        }
    }

    /// 设置状态指示器
    private func setupStatusIndicator() {
        statusIndicator.layer.cornerRadius = 5
        statusIndicator.backgroundColor = UIColor.systemGreen

        containerView.addSubview(statusIndicator)
    }

    /// 设置箭头图标
    private func setupArrowImageView() {
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = UIColor.systemGray3
        arrowImageView.contentMode = .scaleAspectFit

        containerView.addSubview(arrowImageView)
    }

    /// 设置约束
    private func setupConstraints() {
        // 容器视图约束
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
            make.height.greaterThanOrEqualTo(80)
        }

        // 头像约束
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }

        // 状态指示器约束
        statusIndicator.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView).offset(-2)
            make.right.equalTo(avatarImageView).offset(2)
            make.width.height.equalTo(10)
        }

        // 用户名约束
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.right.equalTo(arrowImageView.snp.left).offset(-16)
        }

        // 邮箱约束
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
        }

        // 电话约束
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(2)
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
        }

        // 网站约束
        websiteLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(2)
            make.left.equalTo(nameLabel)
            make.right.equalTo(nameLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }

        // 箭头约束
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(16)
        }
    }

    // MARK: - Configuration
    /// 配置单元格数据
    /// - Parameter user: 用户数据
    func configure(with user: MVVMUser) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone ?? "暂无电话"
        websiteLabel.text = user.website ?? "暂无网站"

        // 设置头像
        if let avatarURL = user.avatarURL, let url = URL(string: avatarURL) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: createPlaceholderImage(for: user),
                options: [.transition(.fade(0.3))]
            )
        } else {
            avatarImageView.image = createPlaceholderImage(for: user)
        }

        // 设置状态指示器
        statusIndicator.backgroundColor = user.isProfileComplete ? UIColor.systemGreen : UIColor.systemOrange

        // 设置选中状态
        selectionStyle = .none
    }

    /// 创建占位头像
    /// - Parameter user: 用户数据
    /// - Returns: 占位头像图片
    private func createPlaceholderImage(for user: MVVMUser) -> UIImage? {
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        // 绘制背景圆形
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.themeColor.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))

        // 绘制首字母
        let firstLetter = String(user.name.prefix(1)).uppercased()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.white
        ]

        let text = NSAttributedString(string: firstLetter, attributes: attributes)
        let textSize = text.size()
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )

        text.draw(in: textRect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil
        nameLabel.text = nil
        emailLabel.text = nil
        phoneLabel.text = nil
        websiteLabel.text = nil
        statusIndicator.backgroundColor = UIColor.systemGray
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.containerView.alpha = highlighted ? 0.8 : 1.0
        }
    }
}
