//
//  PageControlExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// UIPageControl页面指示器控件示例页面
/// 展示UIPageControl与ScrollView的联动效果和各种自定义样式
class PageControlExampleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var customPageControl: UIPageControl!
    private var resultLabel: UILabel!

    private let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPages()
    }

    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        setupNavigationBar()
        setupContent()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "UIPageControl 页面指示器") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
    }

    /// 设置主要内容
    private func setupContent() {
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UIPageControl - 页面指示器"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }

        // 结果显示
        resultLabel = UILabel()
        resultLabel.text = "当前页面: 第1页 / 共5页"
        resultLabel.font = UIFont.systemFont(ofSize: 16)
        resultLabel.textAlignment = .center
        resultLabel.backgroundColor = UIColor.themeColor.withAlphaComponent(0.1)
        resultLabel.layer.cornerRadius = 8
        resultLabel.layer.masksToBounds = true

        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // ScrollView
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.systemBackground
        scrollView.layer.cornerRadius = 12

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        // 默认PageControl
        pageControl = UIPageControl()
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.systemGray4
        pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)

        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        // 页面控制标签
        let pageControlLabel = UILabel()
        pageControlLabel.text = "默认样式 - 点击切换页面"
        pageControlLabel.font = UIFont.systemFont(ofSize: 12)
        pageControlLabel.textColor = UIColor.systemGray
        pageControlLabel.textAlignment = .center

        view.addSubview(pageControlLabel)
        pageControlLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        // 自定义PageControl
        customPageControl = UIPageControl()
        customPageControl.numberOfPages = colors.count
        customPageControl.currentPage = 0
        customPageControl.pageIndicatorTintColor = UIColor.systemGray5
        customPageControl.currentPageIndicatorTintColor = UIColor.themeColor
        customPageControl.backgroundStyle = .prominent
        customPageControl.addTarget(self, action: #selector(customPageControlValueChanged), for: .valueChanged)

        view.addSubview(customPageControl)
        customPageControl.snp.makeConstraints { make in
            make.top.equalTo(pageControlLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        // 自定义页面控制标签
        let customPageControlLabel = UILabel()
        customPageControlLabel.text = "自定义样式 - 突出背景"
        customPageControlLabel.font = UIFont.systemFont(ofSize: 12)
        customPageControlLabel.textColor = UIColor.systemGray
        customPageControlLabel.textAlignment = .center

        view.addSubview(customPageControlLabel)
        customPageControlLabel.snp.makeConstraints { make in
            make.top.equalTo(customPageControl.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        // 功能按钮
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 15

        let prevButton = UIButton(type: .system)
        prevButton.setTitle("← 上一页", for: .normal)
        prevButton.backgroundColor = UIColor.systemGray
        prevButton.setTitleColor(.white, for: .normal)
        prevButton.layer.cornerRadius = 8
        prevButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("下一页 →", for: .normal)
        nextButton.backgroundColor = UIColor.themeColor
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)

        let autoButton = UIButton(type: .system)
        autoButton.setTitle("自动播放", for: .normal)
        autoButton.backgroundColor = UIColor.systemBlue
        autoButton.setTitleColor(.white, for: .normal)
        autoButton.layer.cornerRadius = 8
        autoButton.addTarget(self, action: #selector(autoPlay), for: .touchUpInside)

        buttonStack.addArrangedSubview(prevButton)
        buttonStack.addArrangedSubview(nextButton)
        buttonStack.addArrangedSubview(autoButton)

        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(customPageControlLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "滑动页面或点击指示器切换页面\n支持多种样式自定义和编程控制"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    /// 设置页面内容
    private func setupPages() {
        let scrollViewWidth = view.bounds.width - 40  // 减去左右边距
        scrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(colors.count), height: 200)

        for (index, color) in colors.enumerated() {
            let pageView = UIView()
            pageView.backgroundColor = color
            pageView.layer.cornerRadius = 12

            let label = UILabel()
            label.text = "第\(index + 1)页"
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center

            let subtitleLabel = UILabel()
            subtitleLabel.text = "这是第\(index + 1)个页面的内容"
            subtitleLabel.font = UIFont.systemFont(ofSize: 16)
            subtitleLabel.textColor = .white
            subtitleLabel.textAlignment = .center

            pageView.addSubview(label)
            pageView.addSubview(subtitleLabel)
            scrollView.addSubview(pageView)

            let x = scrollViewWidth * CGFloat(index)
            pageView.frame = CGRect(x: x, y: 0, width: scrollViewWidth, height: 200)

            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
        }
    }

    /// PageControl值改变
    @objc private func pageControlValueChanged() {
        let page = pageControl.currentPage
        let scrollViewWidth = view.bounds.width - 40
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth * CGFloat(page), y: 0), animated: true)
        customPageControl.currentPage = page
        updateResultLabel()
    }

    /// 自定义PageControl值改变
    @objc private func customPageControlValueChanged() {
        let page = customPageControl.currentPage
        let scrollViewWidth = view.bounds.width - 40
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth * CGFloat(page), y: 0), animated: true)
        pageControl.currentPage = page
        updateResultLabel()
    }

    /// 上一页
    @objc private func previousPage() {
        let currentPage = pageControl.currentPage
        if currentPage > 0 {
            pageControl.currentPage = currentPage - 1
            pageControlValueChanged()
        }
    }

    /// 下一页
    @objc private func nextPage() {
        let currentPage = pageControl.currentPage
        if currentPage < colors.count - 1 {
            pageControl.currentPage = currentPage + 1
            pageControlValueChanged()
        }
    }

    /// 自动播放
    @objc private func autoPlay() {
        let alert = UIAlertController(title: "自动播放", message: "开始自动播放页面", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "开始", style: .default) { _ in
            self.startAutoPlay()
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }

    /// 开始自动播放
    private func startAutoPlay() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            currentIndex = (currentIndex + 1) % self.colors.count
            self.pageControl.currentPage = currentIndex
            self.pageControlValueChanged()

            // 播放完一轮后停止
            if currentIndex == 0 {
                timer.invalidate()
                self.showAlert(title: "播放完成", message: "自动播放已结束")
            }
        }
    }

    /// 更新结果标签
    private func updateResultLabel() {
        let currentPage = pageControl.currentPage + 1
        resultLabel.text = "当前页面: 第\(currentPage)页 / 共\(colors.count)页"
    }
}

// MARK: - UIScrollViewDelegate
extension PageControlExampleViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = view.bounds.width - 40
        guard scrollViewWidth > 0 else { return }
        let page = Int(scrollView.contentOffset.x / scrollViewWidth)
        if page != pageControl.currentPage && page >= 0 && page < colors.count {
            pageControl.currentPage = page
            customPageControl.currentPage = page
            updateResultLabel()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 确保页面对齐
        let scrollViewWidth = view.bounds.width - 40
        let page = Int(scrollView.contentOffset.x / scrollViewWidth)
        pageControl.currentPage = page
        customPageControl.currentPage = page
        updateResultLabel()
    }
}