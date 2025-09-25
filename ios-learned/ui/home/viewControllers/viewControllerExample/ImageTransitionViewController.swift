//
//  ImageTransitionViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

/// 图片转场示例页面
/// 展示图片网格，点击后无缝转场到详情页面
class ImageTransitionViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var collectionView: UICollectionView!
    private var imageTransitionDelegate: ImageTransitionDelegate?

    // 示例图片数据
    private let imageItems: [ImageItem] = [
        ImageItem(id: "photo1", imageName: "photo", title: "风景照片1", description: "美丽的自然风景"),
        ImageItem(id: "photo2", imageName: "photo.fill", title: "风景照片2", description: "壮观的山脉景色"),
        ImageItem(id: "photo3", imageName: "camera", title: "相机设备", description: "专业摄影设备"),
        ImageItem(id: "photo4", imageName: "camera.fill", title: "相机工具", description: "现代数码相机"),
        ImageItem(id: "photo5", imageName: "video", title: "视频内容", description: "高清视频素材"),
        ImageItem(id: "photo6", imageName: "video.fill", title: "视频播放", description: "多媒体播放器"),
        ImageItem(id: "photo7", imageName: "paintbrush", title: "艺术创作", description: "数字艺术作品"),
        ImageItem(id: "photo8", imageName: "paintbrush.fill", title: "绘画工具", description: "创意设计工具"),
        ImageItem(id: "photo9", imageName: "heart", title: "喜爱收藏", description: "精选图片集合"),
        ImageItem(id: "photo10", imageName: "heart.fill", title: "热门推荐", description: "最受欢迎的图片"),
        ImageItem(id: "photo11", imageName: "star", title: "精品推荐", description: "优质图片内容"),
        ImageItem(id: "photo12", imageName: "star.fill", title: "五星好评", description: "用户最爱图片")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTransitionDelegate()
    }

    /// 设置UI界面
    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "图片转场效果") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置图片网格
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // 计算item大小 (2列布局)
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing
        let itemWidth = (screenWidth - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageTransitionCell.self, forCellWithReuseIdentifier: "ImageTransitionCell")

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    /// 设置转场代理
    private func setupTransitionDelegate() {
        imageTransitionDelegate = ImageTransitionDelegate()
    }

    /// 获取指定图片项的cell
    private func getCellForImageItem(at indexPath: IndexPath) -> ImageTransitionCell? {
        return collectionView.cellForItem(at: indexPath) as? ImageTransitionCell
    }
}

// MARK: - UICollectionViewDataSource
extension ImageTransitionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTransitionCell", for: indexPath) as! ImageTransitionCell
        let imageItem = imageItems[indexPath.item]
        cell.configure(with: imageItem)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ImageTransitionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let imageItem = imageItems[indexPath.item]
        let sourceCell = getCellForImageItem(at: indexPath)

        // 创建详情页面
        let detailVC = ImageDetailViewController(imageItem: imageItem)

        // 设置转场信息
        if let transitionDelegate = imageTransitionDelegate {
            transitionDelegate.sourceImageView = sourceCell?.imageView
            transitionDelegate.sourceFrame = sourceCell?.imageView.frame ?? .zero
            detailVC.transitioningDelegate = transitionDelegate
            detailVC.modalPresentationStyle = .custom
        }

        present(detailVC, animated: true)
    }
}

// MARK: - 图片数据模型
struct ImageItem {
    let id: String
    let imageName: String
    let title: String
    let description: String
}

// MARK: - 图片转场Cell
class ImageTransitionCell: UICollectionViewCell {

    let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let overlayView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 设置UI
    private func setupUI() {
        // 设置cell样式
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        clipsToBounds = false

        // 图片视图
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor.systemGray6
        imageView.tintColor = UIColor.themeColor
        contentView.addSubview(imageView)

        // 渐变遮罩
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.layer.cornerRadius = 12
        contentView.addSubview(overlayView)

        // 标题标签
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        overlayView.addSubview(titleLabel)

        // 设置约束
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    /// 配置cell数据
    func configure(with imageItem: ImageItem) {
        // 使用SF Symbols作为示例图片
        imageView.image = UIImage(systemName: imageItem.imageName)?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        )
        titleLabel.text = imageItem.title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
}