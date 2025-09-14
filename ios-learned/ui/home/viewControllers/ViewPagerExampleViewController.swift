//
//  ViewPagerExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit
import Toast_Swift

class ViewPagerExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 分段控制器
    private let segmentedControl = UISegmentedControl(items: ["基础", "带指示器", "标签页", "卡片", "无限循环"])
    
    /// 容器视图
    private let containerView = UIView()
    
    /// 当前显示的ViewPager
    private var currentViewPager: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        showViewPager(at: 0)
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
        navigationBar.configure(title: "滑动页面控件") {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
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
        showViewPager(at: sender.selectedSegmentIndex)
    }
    
    /// 显示对应的ViewPager
    private func showViewPager(at index: Int) {
        // 移除当前ViewPager
        currentViewPager?.willMove(toParent: nil)
        currentViewPager?.view.removeFromSuperview()
        currentViewPager?.removeFromParent()
        
        // 创建新的ViewPager控制器
        let newViewController: UIViewController
        
        switch index {
        case 0:
            newViewController = BasicViewPagerViewController()
        case 1:
            newViewController = IndicatorViewPagerViewController()
        case 2:
            newViewController = TabViewPagerViewController()
        case 3:
            newViewController = CardViewPagerViewController()
        case 4:
            newViewController = InfiniteViewPagerViewController()
        default:
            newViewController = BasicViewPagerViewController()
        }
        
        // 添加新的ViewPager控制器
        addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        newViewController.didMove(toParent: self)
        
        currentViewPager = newViewController
    }
}

// MARK: - 基础ViewPager
class BasicViewPagerViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
    private let titles = ["页面一", "页面二", "页面三", "页面四", "页面五"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPager()
    }
    
    /// 设置ViewPager
    private func setupViewPager() {
        setupScrollView()
        setupPageControl()
        setupPages()
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
    }
    
    /// 设置页面控制器
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.themeColor
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    /// 设置页面
    private func setupPages() {
        let screenWidth = view.bounds.width
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(colors.count), height: 0)
        
        for (index, color) in colors.enumerated() {
            let pageView = createPageView(color: color, title: titles[index], index: index)
            pageView.frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: scrollView.bounds.height)
            scrollView.addSubview(pageView)
        }
    }
    
    /// 创建页面视图
    private func createPageView(color: UIColor, title: String, index: Int) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = color.withAlphaComponent(0.8)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        pageView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "这是第\(index + 1)个页面"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        pageView.addSubview(subtitleLabel)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "star.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        pageView.addSubview(iconImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        return pageView
    }
    
    /// 页面控制器变化
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPages()
    }
}

// MARK: - UIScrollViewDelegate for BasicViewPagerViewController
extension BasicViewPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if let parentVC = parent?.parent as? ViewPagerExampleViewController {
            parentVC.view.makeToast("切换到：\(titles[pageIndex])")
        }
    }
}

// MARK: - 带指示器的ViewPager
class IndicatorViewPagerViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var progressView: UIProgressView!
    private var pageLabel: UILabel!
    private let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed, .systemPurple, .systemTeal]
    private let titles = ["首页", "发现", "消息", "我的", "设置", "帮助"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPager()
    }
    
    /// 设置ViewPager
    private func setupViewPager() {
        setupScrollView()
        setupIndicators()
        setupPages()
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    /// 设置指示器
    private func setupIndicators() {
        // 进度条
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.themeColor
        progressView.trackTintColor = UIColor.systemGray5
        view.addSubview(progressView)
        
        // 页面标签
        pageLabel = UILabel()
        pageLabel.text = "1 / \(colors.count)"
        pageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pageLabel.textColor = .label
        pageLabel.textAlignment = .center
        view.addSubview(pageLabel)
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(4)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    /// 设置页面
    private func setupPages() {
        let screenWidth = view.bounds.width
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(colors.count), height: 0)
        
        for (index, color) in colors.enumerated() {
            let pageView = createDetailPageView(color: color, title: titles[index], index: index)
            pageView.frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: scrollView.bounds.height)
            scrollView.addSubview(pageView)
        }
        
        updateProgress()
    }
    
    /// 创建详细页面视图
    private func createDetailPageView(color: UIColor, title: String, index: Int) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = .systemBackground
        
        // 顶部彩色条
        let colorBar = UIView()
        colorBar.backgroundColor = color
        pageView.addSubview(colorBar)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        pageView.addSubview(titleLabel)
        
        // 描述
        let descriptionLabel = UILabel()
        descriptionLabel.text = "这是\(title)页面的详细内容描述，展示了如何创建美观的滑动页面效果。"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        pageView.addSubview(descriptionLabel)
        
        // 内容区域
        let contentView = UIView()
        contentView.backgroundColor = color.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 12
        pageView.addSubview(contentView)
        
        let contentLabel = UILabel()
        contentLabel.text = "页面内容区域\n\n这里可以放置具体的功能模块或内容展示"
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .tertiaryLabel
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        
        // 约束
        colorBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(colorBar.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(150)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        return pageView
    }
    
    /// 更新进度
    private func updateProgress() {
        guard scrollView.bounds.width > 0 else { return }
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let progress = Float(currentPage + 1) / Float(colors.count)
        progressView.setProgress(progress, animated: true)
        pageLabel.text = "\(currentPage + 1) / \(colors.count)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPages()
    }
}

// MARK: - UIScrollViewDelegate for IndicatorViewPagerViewController
extension IndicatorViewPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let currentPage = scrollView.contentOffset.x / scrollView.bounds.width
        let progress = Float(currentPage + 1) / Float(colors.count)
        progressView.setProgress(progress, animated: false)
        
        let pageIndex = Int(round(currentPage))
        pageLabel.text = "\(pageIndex + 1) / \(colors.count)"
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if let parentVC = parent?.parent as? ViewPagerExampleViewController {
            parentVC.view.makeToast("切换到：\(titles[pageIndex])")
        }
    }
}

// MARK: - 标签页ViewPager
class TabViewPagerViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var tabScrollView: UIScrollView!
    private var tabStackView: UIStackView!
    private var indicatorView: UIView!
    private var indicatorWidthConstraint: Constraint?
    private var indicatorCenterConstraint: Constraint?
    
    private let tabs = ["推荐", "热门", "关注", "视频", "直播", "科技", "体育", "娱乐"]
    private let colors: [UIColor] = [
        .systemBlue, .systemRed, .systemGreen, .systemOrange, 
        .systemPurple, .systemTeal, .systemPink, .systemIndigo
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPager()
    }
    
    /// 设置ViewPager
    private func setupViewPager() {
        setupTabBar()
        setupScrollView()
        setupPages()
    }
    
    /// 设置标签栏
    private func setupTabBar() {
        // 标签滚动视图
        tabScrollView = UIScrollView()
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.backgroundColor = .systemBackground
        view.addSubview(tabScrollView)
        
        // 标签容器
        tabStackView = UIStackView()
        tabStackView.axis = .horizontal
        tabStackView.distribution = .equalSpacing
        tabStackView.spacing = 0
        tabScrollView.addSubview(tabStackView)
        
        // 指示器
        indicatorView = UIView()
        indicatorView.backgroundColor = UIColor.themeColor
        indicatorView.layer.cornerRadius = 2
        tabScrollView.addSubview(indicatorView)
        
        // 添加标签按钮
        for (index, tab) in tabs.enumerated() {
            let button = createTabButton(title: tab, index: index)
            tabStackView.addArrangedSubview(button)
        }
        
        // 约束
        tabScrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tabStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        // 初始化指示器位置
        DispatchQueue.main.async {
            self.updateIndicator(for: 0, animated: false)
        }
    }
    
    /// 创建标签按钮
    private func createTabButton(title: String, index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.setTitleColor(UIColor.themeColor, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tag = index
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        
        if index == 0 {
            button.isSelected = true
        }
        
        button.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(60)
        }
        
        return button
    }
    
    /// 设置内容滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(tabScrollView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 设置页面
    private func setupPages() {
        let screenWidth = view.bounds.width
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(tabs.count), height: 0)
        
        for (index, tab) in tabs.enumerated() {
            let pageView = createTabPageView(title: tab, color: colors[index], index: index)
            pageView.frame = CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: scrollView.bounds.height)
            scrollView.addSubview(pageView)
        }
    }
    
    /// 创建标签页面视图
    private func createTabPageView(title: String, color: UIColor, index: Int) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = .systemBackground
        
        // 模拟列表内容
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = index
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TabCell")
        pageView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return pageView
    }
    
    /// 标签按钮点击
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        scrollToPage(index, animated: true)
    }
    
    /// 滚动到指定页面
    private func scrollToPage(_ index: Int, animated: Bool) {
        let x = CGFloat(index) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
        updateTabSelection(index)
        updateIndicator(for: index, animated: animated)
    }
    
    /// 更新标签选择状态
    private func updateTabSelection(_ index: Int) {
        for (i, view) in tabStackView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.isSelected = (i == index)
            }
        }
    }
    
    /// 更新指示器位置
    private func updateIndicator(for index: Int, animated: Bool) {
        guard index < tabStackView.arrangedSubviews.count else { return }
        
        let targetButton = tabStackView.arrangedSubviews[index]
        let buttonWidth = targetButton.bounds.width
        let buttonCenter = targetButton.center.x
        
        if indicatorWidthConstraint == nil {
            indicatorView.snp.makeConstraints { make in
                make.bottom.equalTo(tabStackView.snp.bottom)
                make.height.equalTo(4)
                self.indicatorWidthConstraint = make.width.equalTo(buttonWidth - 20).constraint
                self.indicatorCenterConstraint = make.centerX.equalTo(targetButton.snp.centerX).constraint
            }
        } else {
            indicatorWidthConstraint?.update(offset: buttonWidth - 20)
            indicatorCenterConstraint?.update(offset: buttonCenter - targetButton.bounds.width / 2)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPages()
    }
}

// MARK: - UIScrollViewDelegate for TabViewPagerViewController
extension TabViewPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        updateTabSelection(Int(pageIndex))
        updateIndicator(for: Int(pageIndex), animated: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if let parentVC = parent?.parent as? ViewPagerExampleViewController {
            parentVC.view.makeToast("切换到：\(tabs[pageIndex])")
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate for TabViewPagerViewController
extension TabViewPagerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabCell", for: indexPath)
        let tabTitle = tabs[tableView.tag]
        cell.textLabel?.text = "\(tabTitle) - 第\(indexPath.row + 1)项内容"
        cell.imageView?.image = UIImage(systemName: "star.fill")
        cell.imageView?.tintColor = colors[tableView.tag]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tabTitle = tabs[tableView.tag]
        if let parentVC = parent?.parent as? ViewPagerExampleViewController {
            parentVC.view.makeToast("点击了：\(tabTitle) - 第\(indexPath.row + 1)项")
        }
    }
}

// MARK: - 卡片ViewPager
class CardViewPagerViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private let cardData = [
        CardItem(title: "旅行攻略", subtitle: "探索世界的美好", image: "airplane", color: .systemBlue),
        CardItem(title: "美食推荐", subtitle: "品味生活的精致", image: "fork.knife", color: .systemOrange),
        CardItem(title: "运动健身", subtitle: "保持健康的活力", image: "figure.run", color: .systemGreen),
        CardItem(title: "读书笔记", subtitle: "知识的海洋", image: "book", color: .systemPurple),
        CardItem(title: "音乐欣赏", subtitle: "心灵的慰藉", image: "music.note", color: .systemRed)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPager()
    }
    
    /// 设置ViewPager
    private func setupViewPager() {
        setupScrollView()
        setupCards()
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemGroupedBackground
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 设置卡片
    private func setupCards() {
        let screenWidth = view.bounds.width
        let cardWidth = screenWidth - 80
        let cardSpacing: CGFloat = 20
        
        scrollView.contentSize = CGSize(
            width: CGFloat(cardData.count) * (cardWidth + cardSpacing) + 40,
            height: 0
        )
        
        for (index, card) in cardData.enumerated() {
            let cardView = createCardView(card: card, index: index)
            let x = 40 + CGFloat(index) * (cardWidth + cardSpacing)
            cardView.frame = CGRect(x: x, y: 100, width: cardWidth, height: 400)
            scrollView.addSubview(cardView)
        }
    }
    
    /// 创建卡片视图
    private func createCardView(card: CardItem, index: Int) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowRadius = 20
        
        // 背景渐变
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        gradientLayer.colors = [
            card.color.withAlphaComponent(0.8).cgColor,
            card.color.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.cornerRadius = 20
        cardView.layer.insertSublayer(gradientLayer, at: 0)
        
        // 图标
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: card.image)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        cardView.addSubview(iconView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = card.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        cardView.addSubview(titleLabel)
        
        // 副标题
        let subtitleLabel = UILabel()
        subtitleLabel.text = card.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        cardView.addSubview(subtitleLabel)
        
        // 内容区域
        let contentLabel = UILabel()
        contentLabel.text = "这里是\(card.title)的详细内容介绍。您可以在这里查看相关的信息和功能。"
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        cardView.addSubview(contentLabel)
        
        // 约束
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(30)
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.tag = index
        
        return cardView
    }
    
    /// 卡片点击
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        let index = sender.view?.tag ?? 0
        let card = cardData[index]
        
        if let parentVC = parent?.parent as? ViewPagerExampleViewController {
            parentVC.view.makeToast("查看：\(card.title)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCards()
    }
}

// MARK: - CardItem模型
struct CardItem {
    let title: String
    let subtitle: String
    let image: String
    let color: UIColor
}

// MARK: - UIScrollViewDelegate for CardViewPagerViewController
extension CardViewPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = view.bounds.width
        let cardWidth = screenWidth - 80
        let cardSpacing: CGFloat = 20
        guard (cardWidth + cardSpacing) > 0 else { return }
        let currentIndex = Int((scrollView.contentOffset.x + 40) / (cardWidth + cardSpacing))
        
        if currentIndex >= 0 && currentIndex < cardData.count {
            let card = cardData[currentIndex]
            if let parentVC = parent?.parent as? ViewPagerExampleViewController {
                parentVC.view.makeToast("当前：\(card.title)")
            }
        }
    }
}

// MARK: - 无限循环ViewPager
class InfiniteViewPagerViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var timer: Timer?
    private let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen]
    private let titles = ["广告一", "广告二", "广告三"]
    private let realCount = 3
    private let totalCount = 1000 // 很大的数，用于模拟无限循环
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewPager()
        startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    /// 设置ViewPager
    private func setupViewPager() {
        setupScrollView()
        setupPageControl()
        setupPages()
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
    }
    
    /// 设置页面控制器
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = realCount
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.themeColor
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    /// 设置页面
    private func setupPages() {
        let screenWidth = view.bounds.width
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(totalCount), height: 0)
        
        // 设置初始位置到中间
        let middleIndex = totalCount / 2
        scrollView.contentOffset = CGPoint(x: screenWidth * CGFloat(middleIndex), y: 0)
        
        // 清除之前的页面
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        // 创建可见的页面
        createVisiblePages()
    }
    
    /// 创建可见页面
    private func createVisiblePages() {
        let screenWidth = view.bounds.width
        guard screenWidth > 0 else { return }
        let currentIndex = Int(scrollView.contentOffset.x / screenWidth)
        
        // 创建前后各3页，确保流畅滚动
        for i in (currentIndex - 3)...(currentIndex + 3) {
            if i >= 0 && i < totalCount {
                let realIndex = i % realCount
                let pageView = createInfinitePageView(color: colors[realIndex], title: titles[realIndex], index: realIndex)
                pageView.frame = CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: scrollView.bounds.height)
                pageView.tag = i
                scrollView.addSubview(pageView)
            }
        }
    }
    
    /// 创建无限循环页面视图
    private func createInfinitePageView(color: UIColor, title: String, index: Int) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = color.withAlphaComponent(0.9)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        pageView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "自动轮播 · 无限循环"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        pageView.addSubview(subtitleLabel)
        
        let autoLabel = UILabel()
        autoLabel.text = "5秒自动切换"
        autoLabel.font = UIFont.systemFont(ofSize: 12)
        autoLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        autoLabel.textAlignment = .center
        pageView.addSubview(autoLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        autoLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return pageView
    }
    
    /// 开始自动滚动
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.scrollToNext()
        }
    }
    
    /// 停止自动滚动
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 滚动到下一页
    private func scrollToNext() {
        let screenWidth = view.bounds.width
        let currentOffset = scrollView.contentOffset.x
        let nextOffset = currentOffset + screenWidth
        
        scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
    }
    
    /// 更新页面控制器
    private func updatePageControl() {
        let screenWidth = view.bounds.width
        guard screenWidth > 0 else { return }
        let currentIndex = Int(scrollView.contentOffset.x / screenWidth) % realCount
        pageControl.currentPage = currentIndex
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPages()
    }
}

// MARK: - UIScrollViewDelegate for InfiniteViewPagerViewController
extension InfiniteViewPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl()
        
        // 检查是否需要重新定位
        let screenWidth = view.bounds.width
        guard screenWidth > 0 else { return }
        let currentIndex = Int(scrollView.contentOffset.x / screenWidth)
        
        // 如果滚动到边界，重新定位到中间
        if currentIndex <= 10 || currentIndex >= totalCount - 10 {
            let middleIndex = totalCount / 2 + (currentIndex % realCount)
            scrollView.contentOffset = CGPoint(x: screenWidth * CGFloat(middleIndex), y: 0)
        }
        
        createVisiblePages()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = view.bounds.width
        guard screenWidth > 0 else { return }
        let currentIndex = Int(scrollView.contentOffset.x / screenWidth) % realCount
        
        if let parentVC = parent?.parent as? ViewPagerExampleViewController {
            parentVC.view.makeToast("当前：\(titles[currentIndex])")
        }
        
        startAutoScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startAutoScroll()
        }
    }
}
