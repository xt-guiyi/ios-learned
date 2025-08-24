//
//  ImageExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//
import UIKit
import SnapKit

class ImageExampleViewController: BaseViewController {
    
    private let navigationBar = CustomNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupScrollView()
        setupImageExamples()
    }
    
    /// 设置头部导航栏
    private func setupNavigationBar() {
      navigationBar.configure(title: "图片控件") { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      }

      view.addSubview(navigationBar)
      navigationBar.snp.makeConstraints { make in
        make.top.equalToSuperview()
        make.left.right.equalToSuperview()
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
      }
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    /// 设置图片控件示例
    private func setupImageExamples() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        
        // 创建img1图片
        let img1 = UIImage.img1
        
        // 定义不同的缩放模式
        let contentModes: [(UIView.ContentMode, String, String)] = [
            (.scaleAspectFit, "scaleAspectFit", "等比缩放，完整显示"),
            (.scaleAspectFill, "scaleAspectFill", "等比缩放，填满容器"),
            (.scaleToFill, "scaleToFill", "拉伸填满容器"),
            (.center, "center", "居中显示，不缩放"),
            (.top, "top", "顶部对齐，不缩放"),
            (.bottom, "bottom", "底部对齐，不缩放"),
            (.left, "left", "左对齐，不缩放"),
            (.right, "right", "右对齐，不缩放"),
            (.topLeft, "topLeft", "左上角对齐"),
            (.topRight, "topRight", "右上角对齐"),
            (.bottomLeft, "bottomLeft", "左下角对齐"),
            (.bottomRight, "bottomRight", "右下角对齐")
        ]
        
        var previousView: UIView = contentView
        
        // 添加图片缩放模式示例
        for (mode, title, description) in contentModes {
            let cardView = createImageExampleCard(title: title, description: description, image: img1, contentMode: mode)
            
            contentView.addSubview(cardView)
            cardView.snp.makeConstraints { make in
                if previousView == contentView {
                    make.top.equalTo(previousView.snp.top).offset(20)
                } else {
                    make.top.equalTo(previousView.snp.bottom).offset(20)
                }
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            
            previousView = cardView
        }
        
        // 创建用户头像图片
        let userImage = UIImage.user
        
        // 定义不同的头像样式
        let avatarStyles: [(AvatarStyle, String, String)] = [
            (.basic, "基础头像", "普通的正方形头像显示"),
            (.roundedCorner, "圆角头像", "设置圆角的头像效果"),
            (.circular, "圆形头像", "完全圆形的头像效果"),
            (.circularBorder, "带边框圆形头像", "圆形头像 + 边框装饰"),
            (.diamond, "棱形头像", "45度旋转的棱形效果"),
            (.hexagon, "六边形头像", "六边形裁剪的头像效果"),
            (.shadow, "阴影头像", "带阴影效果的圆形头像"),
            (.gradient, "渐变边框头像", "彩色渐变边框的圆形头像"),
            (.ring, "环形头像", "双环边框的圆形头像"),
            (.badge, "徽章头像", "右上角带状态点的头像"),
            (.frame, "相框头像", "带装饰边框的头像效果"),
            (.mask, "遮罩头像", "使用遮罩图片的特殊形状头像")
        ]
        
        // 添加头像样式示例
        for (style, title, description) in avatarStyles {
            let cardView = createAvatarExampleCard(title: title, description: description, image: userImage, style: style)
            
            contentView.addSubview(cardView)
            cardView.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            
            previousView = cardView
        }
        
        // 设置内容视图的底部约束
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(previousView.snp.bottom).offset(20)
        }
    }
    
    /// 创建图片示例卡片
    /// - Parameters:
    ///   - title: 标题
    ///   - description: 描述
    ///   - image: 图片
    ///   - contentMode: 内容模式
    /// - Returns: 卡片视图
    private func createImageExampleCard(title: String, description: String, image: UIImage, contentMode: UIView.ContentMode) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 3
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .gray
        descLabel.numberOfLines = 0
        
        // 图片视图容器
        let imageContainer = UIView()
        imageContainer.backgroundColor = .systemGray6
        imageContainer.layer.borderWidth = 1
        imageContainer.layer.borderColor = UIColor.systemGray4.cgColor
        imageContainer.layer.cornerRadius = 8
        imageContainer.clipsToBounds = true
        
        // 图片视图
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = contentMode
        if contentMode == .scaleAspectFill {
            imageView.clipsToBounds = true
        }
        
        imageContainer.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(imageContainer)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        
        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return containerView
    }
    
    /// 创建头像示例卡片
    /// - Parameters:
    ///   - title: 标题
    ///   - description: 描述
    ///   - image: 头像图片
    ///   - style: 头像样式
    /// - Returns: 卡片视图
    private func createAvatarExampleCard(title: String, description: String, image: UIImage, style: AvatarStyle) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 3
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .gray
        descLabel.numberOfLines = 0
        
        // 创建头像视图
        let avatarView = createAvatarView(image: image, style: style)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(avatarView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return containerView
    }
    
    /// 创建头像视图
    /// - Parameters:
    ///   - image: 头像图片
    ///   - style: 头像样式
    /// - Returns: 头像视图
    private func createAvatarView(image: UIImage, style: AvatarStyle) -> UIView {
        let containerView = UIView()
        
        switch style {
        case .basic:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .roundedCorner:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .circular:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 40
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .circularBorder:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 36
            imageView.layer.borderWidth = 4
            imageView.layer.borderColor = UIColor.themeColor.cgColor
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(4)
            }
            
        case .diamond:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray6
            
            // 创建菱形遮罩
            let diamondPath = createDiamondPath(size: CGSize(width: 80, height: 80))
            let maskLayer = CAShapeLayer()
            maskLayer.path = diamondPath.cgPath
            imageView.layer.mask = maskLayer
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .hexagon:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray6
            
            // 创建六边形路径
            let hexagonPath = createHexagonPath(size: CGSize(width: 80, height: 80))
            let maskLayer = CAShapeLayer()
            maskLayer.path = hexagonPath.cgPath
            imageView.layer.mask = maskLayer
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .shadow:
            let shadowView = UIView()
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
            shadowView.layer.shadowOpacity = 0.3
            shadowView.layer.shadowRadius = 8
            
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 40
            imageView.backgroundColor = .systemGray6
            
            shadowView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            containerView.addSubview(shadowView)
            shadowView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .gradient:
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.systemPink.cgColor,
                UIColor.systemOrange.cgColor,
                UIColor.systemYellow.cgColor,
                UIColor.systemGreen.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.systemPurple.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            gradientLayer.cornerRadius = 40
            
            let gradientView = UIView()
            gradientView.layer.addSublayer(gradientLayer)
            
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 36
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(gradientView)
            containerView.addSubview(imageView)
            
            gradientView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(72)
            }
            
        case .ring:
            let outerRing = UIView()
            outerRing.layer.cornerRadius = 40
            outerRing.layer.borderWidth = 3
            outerRing.layer.borderColor = UIColor.themeColor.cgColor
            
            let innerRing = UIView()
            innerRing.layer.cornerRadius = 36
            innerRing.layer.borderWidth = 2
            innerRing.layer.borderColor = UIColor.white.cgColor
            
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 32
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(outerRing)
            containerView.addSubview(innerRing)
            containerView.addSubview(imageView)
            
            outerRing.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            innerRing.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(72)
            }
            
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(64)
            }
            
        case .badge:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 40
            imageView.backgroundColor = .systemGray6
            
            let badgeView = UIView()
            badgeView.backgroundColor = .systemGreen
            badgeView.layer.cornerRadius = 12
            badgeView.layer.borderWidth = 2
            badgeView.layer.borderColor = UIColor.white.cgColor
            
            containerView.addSubview(imageView)
            containerView.addSubview(badgeView)
            
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            badgeView.snp.makeConstraints { make in
                make.top.right.equalToSuperview()
                make.width.height.equalTo(24)
            }
            
        case .frame:
            let frameView = UIView()
            frameView.backgroundColor = .white
            frameView.layer.cornerRadius = 40
            frameView.layer.borderWidth = 4
            frameView.layer.borderColor = UIColor.systemYellow.cgColor
            frameView.layer.shadowColor = UIColor.black.cgColor
            frameView.layer.shadowOffset = CGSize(width: 0, height: 2)
            frameView.layer.shadowOpacity = 0.2
            frameView.layer.shadowRadius = 4
            
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 32
            imageView.backgroundColor = .systemGray6
            
            containerView.addSubview(frameView)
            frameView.addSubview(imageView)
            
            frameView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(64)
            }
            
        case .mask:
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray6
            
            // 创建星形遮罩
            let starPath = createStarPath(size: CGSize(width: 80, height: 80))
            let maskLayer = CAShapeLayer()
            maskLayer.path = starPath.cgPath
            imageView.layer.mask = maskLayer
            
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        return containerView
    }
    
    /// 创建菱形路径
    /// - Parameter size: 大小
    /// - Returns: 菱形路径
    private func createDiamondPath(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let halfWidth = size.width / 2
        let halfHeight = size.height / 2
        
        // 菱形的四个顶点
        let topPoint = CGPoint(x: center.x, y: center.y - halfHeight)
        let rightPoint = CGPoint(x: center.x + halfWidth, y: center.y)
        let bottomPoint = CGPoint(x: center.x, y: center.y + halfHeight)
        let leftPoint = CGPoint(x: center.x - halfWidth, y: center.y)
        
        path.move(to: topPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: leftPoint)
        path.close()
        
        return path
    }
    
    /// 创建六边形路径
    /// - Parameter size: 大小
    /// - Returns: 六边形路径
    private func createHexagonPath(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.close()
        return path
    }
    
    /// 创建星形路径
    /// - Parameter size: 大小
    /// - Returns: 星形路径
    private func createStarPath(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let outerRadius = min(size.width, size.height) / 2
        let innerRadius = outerRadius * 0.4
        
        for i in 0..<10 {
            let angle = CGFloat(i) * .pi / 5 - .pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.close()
        return path
    }
}

/// 头像样式枚举
enum AvatarStyle {
    case basic
    case roundedCorner
    case circular
    case circularBorder
    case diamond
    case hexagon
    case shadow
    case gradient
    case ring
    case badge
    case frame
    case mask
}
