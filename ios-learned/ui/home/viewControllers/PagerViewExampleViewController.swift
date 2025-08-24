//
//  PagerViewExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit
import FSPagerView

class PagerViewExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 滚动容器
    private let scrollView = UIScrollView()
    
    /// 内容容器
    private let contentView = UIView()
    
    /// 基础轮播图
    private let basicPagerView = FSPagerView()
    private let basicPageControl = UIPageControl()
    
    /// 卡片样式轮播图
    private let cardPagerView = FSPagerView()
    private let cardPageControl = UIPageControl()
    
    /// 覆盖样式轮播图
    private let coverFlowPagerView = FSPagerView()
    private let coverFlowPageControl = UIPageControl()
    
    /// 线性样式轮播图
    private let linearPagerView = FSPagerView()
    private let linearPageControl = UIPageControl()
    
    /// 控制按钮
    private let autoScrollButton = UIButton(type: .system)
    private let transformerButton = UIButton(type: .system)
    
    /// 数据源
    private let imageNames = ["home", "function", "third", "home-select", "function-select", "third-select"]
    private let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemPurple, .systemTeal]
    private let titles = ["首页", "功能", "第三方", "首页选中", "功能选中", "第三方选中"]
    
    /// 状态变量
    private var isAutoScrollEnabled = false
    private var currentTransformerType = 0
    private let transformerTypes: [FSPagerViewTransformerType] = [.crossFading, .zoomOut, .depth, .linear, .overlap, .ferrisWheel, .invertedFerrisWheel, .coverFlow, .cubic]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupPagerViews()
    }
    
    /// 设置用户界面
    private func setupUI() {
        setupNavigationBar()
        setupScrollView()
        setupPagerViews()
        setupControlButtons()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "轮播图控件") {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    /// 设置轮播图视图
    private func setupPagerViews() {
        setupBasicPagerView()
        setupCardPagerView()
        setupCoverFlowPagerView()
        setupLinearPagerView()
    }
    
    /// 设置基础轮播图
    private func setupBasicPagerView() {
        basicPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BasicCell")
        basicPagerView.dataSource = self
        basicPagerView.delegate = self
        basicPagerView.backgroundColor = UIColor.systemGray6
        basicPagerView.layer.cornerRadius = 12
        basicPagerView.clipsToBounds = true
        basicPagerView.itemSize = FSPagerView.automaticSize
        basicPagerView.isInfinite = true
        basicPagerView.automaticSlidingInterval = 3.0
      
        contentView.addSubview(basicPagerView)
        
        // 页面指示器
        basicPageControl.numberOfPages = imageNames.count
        basicPageControl.pageIndicatorTintColor = .lightGray
        basicPageControl.currentPageIndicatorTintColor = UIColor.themeColor
        contentView.addSubview(basicPageControl)
        
        // 标题标签
        let basicLabel = createSectionLabel(text: "基础轮播图")
        contentView.addSubview(basicLabel)
    }
    
    /// 设置卡片样式轮播图
    private func setupCardPagerView() {
        cardPagerView.register(CardPagerViewCell.self, forCellWithReuseIdentifier: "CardCell")
        cardPagerView.dataSource = self
        cardPagerView.delegate = self
        cardPagerView.backgroundColor = .clear
        cardPagerView.itemSize = CGSize(width: 280, height: 180)
        cardPagerView.interitemSpacing = 20
        cardPagerView.isInfinite = true
        cardPagerView.transformer = FSPagerViewTransformer(type: .zoomOut)
        contentView.addSubview(cardPagerView)
        
        cardPageControl.numberOfPages = colors.count
        cardPageControl.pageIndicatorTintColor = .lightGray
        cardPageControl.currentPageIndicatorTintColor = UIColor.themeColor
        contentView.addSubview(cardPageControl)
        
        let cardLabel = createSectionLabel(text: "卡片样式轮播图")
        contentView.addSubview(cardLabel)
    }
    
    /// 设置覆盖样式轮播图
    private func setupCoverFlowPagerView() {
        coverFlowPagerView.register(ImagePagerViewCell.self, forCellWithReuseIdentifier: "CoverFlowCell")
        coverFlowPagerView.dataSource = self
        coverFlowPagerView.delegate = self
        coverFlowPagerView.backgroundColor = .clear
        coverFlowPagerView.itemSize = CGSize(width: 200, height: 140)
        coverFlowPagerView.interitemSpacing = 10
        coverFlowPagerView.isInfinite = true
        coverFlowPagerView.transformer = FSPagerViewTransformer(type: .coverFlow)
        contentView.addSubview(coverFlowPagerView)
        
        coverFlowPageControl.numberOfPages = imageNames.count
        coverFlowPageControl.pageIndicatorTintColor = .lightGray
        coverFlowPageControl.currentPageIndicatorTintColor = UIColor.themeColor
        contentView.addSubview(coverFlowPageControl)
        
        let coverFlowLabel = createSectionLabel(text: "CoverFlow样式轮播图")
        contentView.addSubview(coverFlowLabel)
    }
    
    /// 设置线性样式轮播图
    private func setupLinearPagerView() {
        linearPagerView.register(LinearPagerViewCell.self, forCellWithReuseIdentifier: "LinearCell")
        linearPagerView.dataSource = self
        linearPagerView.delegate = self
        linearPagerView.backgroundColor = .clear
        linearPagerView.itemSize = CGSize(width: 300, height: 120)
        linearPagerView.interitemSpacing = 15
        linearPagerView.isInfinite = true
        linearPagerView.transformer = FSPagerViewTransformer(type: .linear)
        contentView.addSubview(linearPagerView)
        
        linearPageControl.numberOfPages = titles.count
        linearPageControl.pageIndicatorTintColor = .lightGray
        linearPageControl.currentPageIndicatorTintColor = UIColor.themeColor
        contentView.addSubview(linearPageControl)
        
        let linearLabel = createSectionLabel(text: "线性样式轮播图")
        contentView.addSubview(linearLabel)
    }
    
    /// 设置控制按钮
    private func setupControlButtons() {
        autoScrollButton.setTitle("开启自动轮播", for: .normal)
        autoScrollButton.backgroundColor = UIColor.systemBlue
        autoScrollButton.setTitleColor(.white, for: .normal)
        autoScrollButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        autoScrollButton.layer.cornerRadius = 8
        contentView.addSubview(autoScrollButton)
        
        transformerButton.setTitle("切换动画效果", for: .normal)
        transformerButton.backgroundColor = UIColor.systemGreen
        transformerButton.setTitleColor(.white, for: .normal)
        transformerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        transformerButton.layer.cornerRadius = 8
        contentView.addSubview(transformerButton)
    }
    
    /// 创建分区标签
    private func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        return label
    }
    
    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        var previousView: UIView = contentView
        var topOffset: Int = 30
        
        // 基础轮播图约束
        if let basicLabel = contentView.subviews.first(where: { ($0 as? UILabel)?.text == "基础轮播图" }) {
            basicLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(topOffset)
                make.left.equalToSuperview().offset(20)
            }
            previousView = basicLabel
            topOffset = 15
        }
        
        basicPagerView.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(topOffset)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        basicPageControl.snp.makeConstraints { make in
            make.top.equalTo(basicPagerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        previousView = basicPageControl
        topOffset = 40
        
        // 卡片样式轮播图约束
        if let cardLabel = contentView.subviews.first(where: { ($0 as? UILabel)?.text == "卡片样式轮播图" }) {
            cardLabel.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(topOffset)
                make.left.equalToSuperview().offset(20)
            }
            previousView = cardLabel
            topOffset = 15
        }
        
        cardPagerView.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(topOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
        }
        
        cardPageControl.snp.makeConstraints { make in
            make.top.equalTo(cardPagerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        previousView = cardPageControl
        topOffset = 40
        
        // CoverFlow样式轮播图约束
        if let coverFlowLabel = contentView.subviews.first(where: { ($0 as? UILabel)?.text == "CoverFlow样式轮播图" }) {
            coverFlowLabel.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(topOffset)
                make.left.equalToSuperview().offset(20)
            }
            previousView = coverFlowLabel
            topOffset = 15
        }
        
        coverFlowPagerView.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(topOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        coverFlowPageControl.snp.makeConstraints { make in
            make.top.equalTo(coverFlowPagerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        previousView = coverFlowPageControl
        topOffset = 40
        
        // 线性样式轮播图约束
        if let linearLabel = contentView.subviews.first(where: { ($0 as? UILabel)?.text == "线性样式轮播图" }) {
            linearLabel.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(topOffset)
                make.left.equalToSuperview().offset(20)
            }
            previousView = linearLabel
            topOffset = 15
        }
        
        linearPagerView.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(topOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        linearPageControl.snp.makeConstraints { make in
            make.top.equalTo(linearPagerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        // 控制按钮约束
        let buttonStackView = UIStackView(arrangedSubviews: [autoScrollButton, transformerButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        contentView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(linearPageControl.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    /// 设置按钮事件
    private func setupActions() {
        autoScrollButton.addTarget(self, action: #selector(toggleAutoScroll), for: .touchUpInside)
        transformerButton.addTarget(self, action: #selector(switchTransformer), for: .touchUpInside)
    }
    
    /// 切换自动轮播
    @objc private func toggleAutoScroll() {
        isAutoScrollEnabled.toggle()
        
        let title = isAutoScrollEnabled ? "关闭自动轮播" : "开启自动轮播"
        let backgroundColor = isAutoScrollEnabled ? UIColor.systemRed : UIColor.systemBlue
        
        autoScrollButton.setTitle(title, for: .normal)
        autoScrollButton.backgroundColor = backgroundColor
        

        view.makeToast(isAutoScrollEnabled ? "自动轮播已开启" : "自动轮播已关闭")
    }
    
    /// 切换动画效果
    @objc private func switchTransformer() {
        currentTransformerType = (currentTransformerType + 1) % transformerTypes.count
        let transformerType = transformerTypes[currentTransformerType]
        
        cardPagerView.transformer = FSPagerViewTransformer(type: transformerType)
        
        let transformerName = getTransformerName(transformerType)
        view.makeToast("切换到：\(transformerName)")
    }
    
    /// 获取动画效果名称
    private func getTransformerName(_ type: FSPagerViewTransformerType) -> String {
        switch type {
        case .crossFading: return "交叉淡化"
        case .zoomOut: return "缩放"
        case .depth: return "深度"
        case .linear: return "线性"
        case .overlap: return "重叠"
        case .ferrisWheel: return "摩天轮"
        case .invertedFerrisWheel: return "倒转摩天轮"
        case .coverFlow: return "CoverFlow"
        case .cubic: return "立方体"
        @unknown default: return "未知"
        }
    }
}

// MARK: - FSPagerViewDataSource
extension PagerViewExampleViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        switch pagerView {
        case basicPagerView, coverFlowPagerView:
            return imageNames.count
        case cardPagerView:
            return colors.count
        case linearPagerView:
            return titles.count
        default:
            return 0
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        switch pagerView {
        case basicPagerView:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BasicCell", at: index)
            cell.imageView?.image = UIImage(named: imageNames[index])
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
            return cell
            
        case cardPagerView:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "CardCell", at: index) as! CardPagerViewCell
            cell.configure(color: colors[index], title: "卡片 \(index + 1)", subtitle: "这是第\(index + 1)个卡片的描述信息")
            return cell
            
        case coverFlowPagerView:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "CoverFlowCell", at: index) as! ImagePagerViewCell
            cell.configure(imageName: imageNames[index], title: titles[index])
            return cell
            
        case linearPagerView:
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "LinearCell", at: index) as! LinearPagerViewCell
            cell.configure(title: titles[index], subtitle: "线性样式 - \(titles[index])", color: colors[index % colors.count])
            return cell
            
        default:
            return FSPagerViewCell()
        }
    }
}

// MARK: - FSPagerViewDelegate
extension PagerViewExampleViewController: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        var message = ""
        switch pagerView {
        case basicPagerView:
            message = "点击了基础轮播图第\(index + 1)项"
        case cardPagerView:
            message = "点击了卡片轮播图第\(index + 1)项"
        case coverFlowPagerView:
            message = "点击了CoverFlow轮播图第\(index + 1)项"
        case linearPagerView:
            message = "点击了线性轮播图第\(index + 1)项"
        default:
            break
        }
        view.makeToast(message)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        switch pagerView {
        case basicPagerView:
            basicPageControl.currentPage = targetIndex
        case cardPagerView:
            cardPageControl.currentPage = targetIndex
        case coverFlowPagerView:
            coverFlowPageControl.currentPage = targetIndex
        case linearPagerView:
            linearPageControl.currentPage = targetIndex
        default:
            break
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        switch pagerView {
        case basicPagerView:
            basicPageControl.currentPage = pagerView.currentIndex
        case cardPagerView:
            cardPageControl.currentPage = pagerView.currentIndex
        case coverFlowPagerView:
            coverFlowPageControl.currentPage = pagerView.currentIndex
        case linearPagerView:
            linearPageControl.currentPage = pagerView.currentIndex
        default:
            break
        }
    }
}

// MARK: - 自定义Cell类

/// 卡片样式Cell
class CardPagerViewCell: FSPagerViewCell {
    
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 卡片容器
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 8
        contentView.addSubview(cardView)
        
        // 图标
        iconImageView.image = UIImage(systemName: "star.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        cardView.addSubview(iconImageView)
        
        // 标题
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        cardView.addSubview(titleLabel)
        
        // 副标题
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.numberOfLines = 2
        cardView.addSubview(subtitleLabel)
        
        // 约束
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func configure(color: UIColor, title: String, subtitle: String) {
        cardView.backgroundColor = color
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

/// 图片样式Cell
class ImagePagerViewCell: FSPagerViewCell {
    
    private let containerView = UIView()
    private let customImageView = UIImageView()
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
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.systemGray6
        contentView.addSubview(containerView)
        
        customImageView.contentMode = .scaleAspectFit
        customImageView.tintColor = UIColor.themeColor
        containerView.addSubview(customImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        customImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    func configure(imageName: String, title: String) {
        customImageView.image = UIImage(named: imageName)
        titleLabel.text = title
    }
}

/// 线性样式Cell
class LinearPagerViewCell: FSPagerViewCell {
    
    private let containerView = UIView()
    private let colorView = UIView()
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
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.addSubview(containerView)
        
        colorView.layer.cornerRadius = 6
        containerView.addSubview(colorView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        containerView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryLabel
        containerView.addSubview(subtitleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        colorView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(colorView.snp.right).offset(15)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(colorView.snp.right).offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(15)
        }
    }
    
    func configure(title: String, subtitle: String, color: UIColor) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        colorView.backgroundColor = color
    }
}
