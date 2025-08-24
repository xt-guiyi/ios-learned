//
//  CollectionViewExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit
import Toast_Swift

class CollectionViewExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 分段控制器
    private let segmentedControl = UISegmentedControl(items: ["网格", "流式", "卡片", "瀑布流", "标签"])
    
    /// 集合视图容器
    private let containerView = UIView()
    
    /// 当前显示的集合视图
    private var currentCollectionViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        showCollectionView(at: 0)
    }
    
    /// 设置用户界面
    private func setupUI() {
        setupNavigationBar()
        setupSegmentedControl()
        setupContainerView()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "集合视图控件") {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
    }
    
    /// 设置分段控制器
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = UIColor.themeColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        view.addSubview(segmentedControl)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        view.addSubview(containerView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 设置按钮事件
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    /// 分段控制器变化
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        showCollectionView(at: sender.selectedSegmentIndex)
    }
    
    /// 显示对应的集合视图
    private func showCollectionView(at index: Int) {
        // 移除当前集合视图
        currentCollectionViewController?.willMove(toParent: nil)
        currentCollectionViewController?.view.removeFromSuperview()
        currentCollectionViewController?.removeFromParent()
        
        // 创建新的集合视图控制器
        let newViewController: UIViewController
        
        switch index {
        case 0:
            newViewController = GridCollectionViewController()
        case 1:
            newViewController = FlowCollectionViewController()
        case 2:
            newViewController = CardCollectionViewController()
        case 3:
            newViewController = WaterfallCollectionViewController()
        case 4:
            newViewController = TagCollectionViewController()
        default:
            newViewController = GridCollectionViewController()
        }
        
        // 添加新的集合视图控制器
        addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        newViewController.didMove(toParent: self)
        
        currentCollectionViewController = newViewController
    }
}

// MARK: - 网格布局集合视图
class GridCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let colors: [UIColor] = [
        .systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple,
        .systemTeal, .systemPink, .systemIndigo, .systemBrown, .systemGray,
        .systemYellow, .systemCyan, .systemMint, .systemRed, .systemBlue,
        .systemGreen, .systemOrange, .systemPurple, .systemTeal, .systemPink
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    /// 设置集合视图
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate for GridCollectionViewController
extension GridCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
        cell.configure(color: colors[indexPath.item], title: "颜色 \(indexPath.item + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let parentVC = parent?.parent as? CollectionViewExampleViewController {
            parentVC.view.makeToast("选择了颜色 \(indexPath.item + 1)")
        }
    }
}

// MARK: - 流式布局集合视图
class FlowCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let photos = [
        Photo(title: "风景1", size: CGSize(width: 120, height: 80)),
        Photo(title: "风景2", size: CGSize(width: 100, height: 150)),
        Photo(title: "风景3", size: CGSize(width: 160, height: 120)),
        Photo(title: "风景4", size: CGSize(width: 140, height: 100)),
        Photo(title: "风景5", size: CGSize(width: 110, height: 160)),
        Photo(title: "风景6", size: CGSize(width: 130, height: 90)),
        Photo(title: "风景7", size: CGSize(width: 150, height: 120)),
        Photo(title: "风景8", size: CGSize(width: 120, height: 140)),
        Photo(title: "风景9", size: CGSize(width: 170, height: 110)),
        Photo(title: "风景10", size: CGSize(width: 100, height: 130))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    /// 设置集合视图
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Photo模型
struct Photo {
    let title: String
    let size: CGSize
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate for FlowCollectionViewController
extension FlowCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.item]
        cell.configure(photo: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        if let parentVC = parent?.parent as? CollectionViewExampleViewController {
            parentVC.view.makeToast("查看了：\(photo.title)")
        }
    }
}

// MARK: - 卡片布局集合视图
class CardCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let products = [
        Product(name: "iPhone 15 Pro", price: "¥7,999", image: "iphone"),
        Product(name: "iPad Pro", price: "¥6,799", image: "ipad"),
        Product(name: "MacBook Pro", price: "¥14,999", image: "laptopcomputer"),
        Product(name: "Apple Watch", price: "¥2,999", image: "applewatch"),
        Product(name: "AirPods Pro", price: "¥1,899", image: "airpods"),
        Product(name: "Mac Studio", price: "¥15,999", image: "desktopcomputer"),
        Product(name: "iPad Air", price: "¥4,799", image: "ipad"),
        Product(name: "MacBook Air", price: "¥8,999", image: "laptopcomputer")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    /// 设置集合视图
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 60) / 2 // 减去内边距和间距
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Product模型
struct Product {
    let name: String
    let price: String
    let image: String
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate for CardCollectionViewController
extension CardCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.item]
        cell.configure(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        if let parentVC = parent?.parent as? CollectionViewExampleViewController {
            parentVC.view.makeToast("查看产品：\(product.name)")
        }
    }
}

// MARK: - 瀑布流布局集合视图
class WaterfallCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let items = (1...30).map { "项目 \($0)" }
    private var itemHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomHeights()
        setupCollectionView()
    }
    
    /// 生成随机高度
    private func generateRandomHeights() {
        itemHeights = items.map { _ in
            CGFloat.random(in: 100...250)
        }
    }
    
    /// 设置集合视图
    private func setupCollectionView() {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(WaterfallCollectionViewCell.self, forCellWithReuseIdentifier: "WaterfallCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate for WaterfallCollectionViewController
extension WaterfallCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterfallCell", for: indexPath) as! WaterfallCollectionViewCell
        cell.configure(title: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        if let parentVC = parent?.parent as? CollectionViewExampleViewController {
            parentVC.view.makeToast("选择了：\(item)")
        }
    }
}

// MARK: - WaterfallLayoutDelegate
extension WaterfallCollectionViewController: WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return itemHeights[indexPath.item]
    }
}

// MARK: - 标签布局集合视图
class TagCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let tags = [
        "Swift", "iOS", "UIKit", "SwiftUI", "Objective-C", "Xcode", 
        "Core Data", "Core Animation", "Auto Layout", "SnapKit",
        "Alamofire", "CocoaPods", "Git", "GitHub", "TestFlight",
        "App Store", "Human Interface Guidelines", "MVC", "MVVM",
        "Combine", "RxSwift", "Firebase", "CloudKit"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    /// 设置集合视图
    private func setupCollectionView() {
        let layout = TagFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate for TagCollectionViewController
extension TagCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        cell.configure(tag: tags[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.item]
        if let parentVC = parent?.parent as? CollectionViewExampleViewController {
            parentVC.view.makeToast("选择了标签：\(tag)")
        }
    }
}

// MARK: - 自定义Cell类

/// 颜色单元格
class ColorCollectionViewCell: UICollectionViewCell {
    
    private let colorView = UIView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        colorView.layer.cornerRadius = 8
        contentView.addSubview(colorView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(color: UIColor, title: String) {
        colorView.backgroundColor = color
        titleLabel.text = title
    }
}

/// 照片单元格
class PhotoCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.themeColor.withAlphaComponent(0.3)
        contentView.addSubview(imageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(photo: Photo) {
        titleLabel.text = photo.title
        
        // 设置固定的cell尺寸
        contentView.snp.remakeConstraints { make in
            make.width.equalTo(photo.size.width)
            make.height.equalTo(photo.size.height + 30) // 加上标题高度
        }
    }
}

/// 产品单元格
class ProductCollectionViewCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        contentView.addSubview(containerView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.themeColor
        containerView.addSubview(imageView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        containerView.addSubview(nameLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        priceLabel.textColor = UIColor.themeColor
        priceLabel.textAlignment = .center
        containerView.addSubview(priceLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    func configure(product: Product) {
        imageView.image = UIImage(systemName: product.image)
        nameLabel.text = product.name
        priceLabel.text = product.price
    }
}

/// 瀑布流单元格
class WaterfallCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        // 渐变背景
        gradientLayer.colors = [
            UIColor.themeColor.withAlphaComponent(0.8).cgColor,
            UIColor.themeColor.withAlphaComponent(0.4).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

/// 标签单元格
class TagCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.themeColor.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.themeColor.cgColor
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.themeColor
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(12)
        }
    }
    
    func configure(tag: String) {
        titleLabel.text = tag
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let fittingSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        attributes.size = fittingSize
        return attributes
    }
}

// MARK: - 自定义布局类

/// 瀑布流布局
protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class WaterfallLayout: UICollectionViewLayout {
    
    weak var delegate: WaterfallLayoutDelegate?
    
    var numberOfColumns: Int = 2
    var cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let itemWidth = columnWidth - cellPadding * 2
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath, withWidth: itemWidth) ?? 180
            let height = cellPadding * 2 + itemHeight
            
            let frame = CGRect(
                x: xOffset[column] + cellPadding,
                y: yOffset[column],
                width: itemWidth,
                height: itemHeight
            )
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

/// 标签流式布局
class TagFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        for layoutAttribute in attributes {
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}