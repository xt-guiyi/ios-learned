//
//  ImageDetailViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

/// 图片详情页面
/// 显示大图并支持缩放，实现与列表页的无缝转场
class ImageDetailViewController: UIViewController {

    // MARK: - Properties

    private let imageItem: ImageItem
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    /// 主图片视图，用于转场动画
    let imageView = UIImageView()

    private let backgroundView = UIView()
    private let infoContainerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    // MARK: - Initialization

    init(imageItem: ImageItem) {
        self.imageItem = imageItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithImageItem()
        setupGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 确保状态栏隐藏
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - Status Bar

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    // MARK: - UI Setup

    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupScrollView()
        setupImageView()
        setupInfoContainer()
        setupCloseButton()
        setupConstraints()
    }

    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .black
        view.addSubview(backgroundView)
    }

    /// 设置滚动视图
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)

        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
    }

    /// 设置图片视图
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        contentView.addSubview(imageView)
    }

    /// 设置信息容器
    private func setupInfoContainer() {
        infoContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        infoContainerView.layer.cornerRadius = 12
        view.addSubview(infoContainerView)

        // 标题标签
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        infoContainerView.addSubview(titleLabel)

        // 描述标签
        descriptionLabel.textColor = UIColor.lightGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        infoContainerView.addSubview(descriptionLabel)
    }

    /// 设置关闭按钮
    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        closeButton.layer.cornerRadius = 22
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
    }

    /// 设置约束
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(300) // 初始大小
        }

        infoContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.greaterThanOrEqualTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(44)
        }
    }

    /// 配置图片数据
    private func configureWithImageItem() {
        // 设置图片
        imageView.image = UIImage(systemName: imageItem.imageName)?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 120, weight: .light)
        )

        // 设置文本信息
        titleLabel.text = imageItem.title
        descriptionLabel.text = imageItem.description
    }

    /// 设置手势
    private func setupGestures() {
        // 双击缩放手势
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)

        // 拖拽关闭手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    // MARK: - Actions

    /// 关闭按钮点击事件
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    /// 双击缩放处理
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            // 放大到2倍
            let location = gesture.location(in: imageView)
            let rect = CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100)
            scrollView.zoom(to: rect, animated: true)
        } else {
            // 缩小到原始大小
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }

    /// 拖拽关闭处理
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            // 只允许向下拖拽
            if translation.y > 0 {
                let progress = min(translation.y / 200, 1.0)

                // 调整视图位置和透明度
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
                backgroundView.alpha = 1.0 - progress
                infoContainerView.alpha = 1.0 - progress
                closeButton.alpha = 1.0 - progress
            }

        case .ended, .cancelled:
            let shouldDismiss = translation.y > 100 || velocity.y > 500

            if shouldDismiss {
                // 执行关闭动画
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                    self.backgroundView.alpha = 0
                    self.infoContainerView.alpha = 0
                    self.closeButton.alpha = 0
                }) { _ in
                    self.dismiss(animated: false)
                }
            } else {
                // 恢复原始状态
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                    self.backgroundView.alpha = 1.0
                    self.infoContainerView.alpha = 1.0
                    self.closeButton.alpha = 1.0
                }
            }

        default:
            break
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 缩放时保持图片居中
        let boundsSize = scrollView.bounds.size
        let contentFrame = imageView.frame

        let contentInsetX = max(0, (boundsSize.width - contentFrame.width) / 2)
        let contentInsetY = max(0, (boundsSize.height - contentFrame.height) / 2)

        scrollView.contentInset = UIEdgeInsets(
            top: contentInsetY,
            left: contentInsetX,
            bottom: contentInsetY,
            right: contentInsetX
        )
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ImageDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 允许拖拽手势与滚动手势同时进行
        return true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: view)
            // 只有当垂直速度大于水平速度且scrollView在顶部时才允许拖拽关闭
            return abs(velocity.y) > abs(velocity.x) && scrollView.contentOffset.y <= 0
        }
        return true
    }
}