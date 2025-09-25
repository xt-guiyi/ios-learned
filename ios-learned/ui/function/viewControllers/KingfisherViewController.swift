import UIKit
import SnapKit
import Kingfisher

/// Kingfisher 图片加载库示例页面
/// 展示 Kingfisher 的各种功能：基础加载、占位图、缓存、处理器、动画等
class KingfisherViewController: UIViewController {

    private var customNavigationBar: CustomNavigationBar!
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    // 示例图片URL
    private let imageUrls = [
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=200&fit=crop",
        "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=300&h=200&fit=crop",
        "https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=300&h=200&fit=crop",
        "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=300&h=200&fit=crop",
        "https://images.unsplash.com/photo-1504700610630-ac6aba3536d3?w=300&h=200&fit=crop"
    ]

    // UI 组件
    private var basicImageView: UIImageView!
    private var placeholderImageView: UIImageView!
    private var roundedImageView: UIImageView!
    private var progressImageView: UIImageView!
    private var cacheImageView: UIImageView!
    private var processorImageView: UIImageView!

    // 按钮
    private var loadBasicButton: UIButton!
    private var loadPlaceholderButton: UIButton!
    private var loadRoundedButton: UIButton!
    private var loadProgressButton: UIButton!
    private var clearCacheButton: UIButton!
    private var loadProcessorButton: UIButton!

    // 进度条
    private var progressView: UIProgressView!

    // 状态标签
    private var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupScrollView()
        setupImageViews()
        setupButtons()
        setupConstraints()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar = CustomNavigationBar()
        customNavigationBar.configure(title: "Kingfisher 图片加载") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(customNavigationBar)
    }

    /// 设置滚动视图
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear

        contentView = UIView()
        contentView.backgroundColor = .clear

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    /// 设置图片视图
    private func setupImageViews() {
        // 状态标签
        statusLabel = UILabel()
        statusLabel.text = "点击按钮体验 Kingfisher 图片加载功能"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .systemBlue
        statusLabel.numberOfLines = 0

        // 基础图片加载
        basicImageView = createImageView(title: "基础加载")

        // 占位图片加载
        placeholderImageView = createImageView(title: "占位图加载")

        // 圆角图片加载
        roundedImageView = createImageView(title: "圆角处理")
        roundedImageView.layer.cornerRadius = 8

        // 带进度的图片加载
        progressImageView = createImageView(title: "进度加载")

        // 进度条
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.themeColor
        progressView.trackTintColor = .systemGray5
        progressView.progress = 0.0

        // 缓存示例
        cacheImageView = createImageView(title: "缓存管理")

        // 处理器示例
        processorImageView = createImageView(title: "图片处理器")

        contentView.addSubview(statusLabel)
        contentView.addSubview(basicImageView)
        contentView.addSubview(placeholderImageView)
        contentView.addSubview(roundedImageView)
        contentView.addSubview(progressImageView)
        contentView.addSubview(progressView)
        contentView.addSubview(cacheImageView)
        contentView.addSubview(processorImageView)
    }

    /// 创建图片视图容器
    /// - Parameter title: 标题
    /// - Returns: 配置好的容器视图
    private func createImageView(title: String) -> UIImageView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.textAlignment = .center

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 8

        containerView.addSubview(titleLabel)
        containerView.addSubview(imageView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-12)
        }

        return imageView
    }

    /// 设置按钮
    private func setupButtons() {
        loadBasicButton = createButton(title: "基础加载", action: #selector(loadBasicImage))
        loadPlaceholderButton = createButton(title: "占位图加载", action: #selector(loadPlaceholderImage))
        loadRoundedButton = createButton(title: "圆角加载", action: #selector(loadRoundedImage))
        loadProgressButton = createButton(title: "进度加载", action: #selector(loadProgressImage))
        clearCacheButton = createButton(title: "清除缓存", action: #selector(clearCache))
        loadProcessorButton = createButton(title: "处理器加载", action: #selector(loadProcessorImage))

        contentView.addSubview(loadBasicButton)
        contentView.addSubview(loadPlaceholderButton)
        contentView.addSubview(loadRoundedButton)
        contentView.addSubview(loadProgressButton)
        contentView.addSubview(clearCacheButton)
        contentView.addSubview(loadProcessorButton)
    }

    /// 创建按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - action: 按钮点击事件
    /// - Returns: 配置好的按钮
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.themeColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    /// 设置约束布局
    private func setupConstraints() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        // 第一行：基础加载和占位图加载
        basicImageView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo((UIScreen.main.bounds.width - 60) / 2)
        }

        loadBasicButton.snp.makeConstraints { make in
            make.top.equalTo(basicImageView.snp.bottom).offset(8)
            make.centerX.equalTo(basicImageView)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }

        placeholderImageView.snp.makeConstraints { make in
            make.top.width.equalTo(basicImageView)
            make.trailing.equalToSuperview().offset(-20)
        }

        loadPlaceholderButton.snp.makeConstraints { make in
            make.top.equalTo(placeholderImageView.snp.bottom).offset(8)
            make.centerX.equalTo(placeholderImageView)
            make.width.height.equalTo(loadBasicButton)
        }

        // 第二行：圆角加载和进度加载
        roundedImageView.snp.makeConstraints { make in
            make.top.equalTo(loadBasicButton.snp.bottom).offset(20)
            make.leading.width.equalTo(basicImageView)
        }

        loadRoundedButton.snp.makeConstraints { make in
            make.top.equalTo(roundedImageView.snp.bottom).offset(8)
            make.centerX.equalTo(roundedImageView)
            make.width.height.equalTo(loadBasicButton)
        }

        progressImageView.snp.makeConstraints { make in
            make.top.width.equalTo(roundedImageView)
            make.trailing.equalToSuperview().offset(-20)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(progressImageView.snp.bottom).offset(4)
            make.centerX.equalTo(progressImageView)
            make.width.equalTo(progressImageView).offset(-20)
        }

        loadProgressButton.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(8)
            make.centerX.equalTo(progressImageView)
            make.width.height.equalTo(loadBasicButton)
        }

        // 第三行：缓存管理和处理器
        cacheImageView.snp.makeConstraints { make in
            make.top.equalTo(loadRoundedButton.snp.bottom).offset(20)
            make.leading.width.equalTo(basicImageView)
        }

        clearCacheButton.snp.makeConstraints { make in
            make.top.equalTo(cacheImageView.snp.bottom).offset(8)
            make.centerX.equalTo(cacheImageView)
            make.width.height.equalTo(loadBasicButton)
        }

        processorImageView.snp.makeConstraints { make in
            make.top.width.equalTo(cacheImageView)
            make.trailing.equalToSuperview().offset(-20)
        }

        loadProcessorButton.snp.makeConstraints { make in
            make.top.equalTo(processorImageView.snp.bottom).offset(8)
            make.centerX.equalTo(processorImageView)
            make.width.height.equalTo(loadBasicButton)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Kingfisher 示例方法

    /// 基础图片加载
    @objc private func loadBasicImage() {
        guard let url = URL(string: imageUrls[0]) else { return }

        updateStatus("开始基础图片加载...")

        basicImageView.kf.setImage(with: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    self?.updateStatus("基础加载成功 - 图片大小: \(value.image.size)")
                case .failure(let error):
                    self?.updateStatus("基础加载失败: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 带占位图的图片加载
    @objc private func loadPlaceholderImage() {
        guard let url = URL(string: imageUrls[1]) else { return }

        updateStatus("开始占位图加载...")

        // 使用系统图标作为占位图
        let placeholder = UIImage(systemName: "photo.circle")

        placeholderImageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.updateStatus("占位图加载成功，带淡入动画")
                case .failure(let error):
                    self?.updateStatus("占位图加载失败: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 圆角图片加载
    @objc private func loadRoundedImage() {
        guard let url = URL(string: imageUrls[2]) else { return }

        updateStatus("开始圆角图片加载...")

        let processor = RoundCornerImageProcessor(cornerRadius: 20)

        roundedImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.flipFromLeft(0.5)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.updateStatus("圆角加载成功，带翻转动画")
                case .failure(let error):
                    self?.updateStatus("圆角加载失败: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 带进度的图片加载
    @objc private func loadProgressImage() {
        guard let url = URL(string: imageUrls[3]) else { return }

        updateStatus("开始进度加载...")

        // 立即重置进度条，不使用动画
        progressView.setProgress(0.0, animated: false)

        progressImageView.kf.setImage(
            with: url,
            options: [
                .forceRefresh, // 强制刷新，确保能看到进度
                .transition(.fade(0.3))
            ],
            progressBlock: { [weak self] receivedSize, totalSize in
                let progress = Float(receivedSize) / Float(totalSize)
                DispatchQueue.main.async {
                    // 使用较短的动画时间，避免进度滞后
                    self?.progressView.setProgress(progress, animated: false)
                    self?.updateStatus("下载进度: \(Int(progress * 100))%")
                }
            }
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    // 确保进度条立即显示100%
                    self?.progressView.setProgress(1.0, animated: false)
                    self?.updateStatus("进度加载成功")
                case .failure(let error):
                    self?.updateStatus("进度加载失败: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 清除缓存
    @objc private func clearCache() {
        updateStatus("正在清除缓存...")

        let cache = ImageCache.default

        // 先显示一个占位图到缓存图片视图
        if let placeholderImage = UIImage(systemName: "folder.fill") {
            cacheImageView.image = placeholderImage
            cacheImageView.tintColor = .systemBlue
        }

        // 获取缓存大小
        cache.calculateDiskStorageSize { [weak self] result in
            switch result {
            case .success(let size):
                let sizeInMB = Double(size) / (1024 * 1024)

                // 清除缓存
                cache.clearCache {
                    DispatchQueue.main.async {
                        self?.updateStatus("缓存已清除，释放空间: \(String(format: "%.2f", sizeInMB)) MB")
                        // 清除缓存后移除图片，显示空状态
                        self?.cacheImageView.image = UIImage(systemName: "trash.fill")
                        self?.cacheImageView.tintColor = .systemGray
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.updateStatus("缓存清除失败: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 图片处理器加载
    @objc private func loadProcessorImage() {
        guard let url = URL(string: imageUrls[4]) else { return }

        updateStatus("开始处理器加载...")

        // 组合多个处理器：调整大小 + 模糊 + 圆角
        let resizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 200, height: 200))
        let blurProcessor = BlurImageProcessor(blurRadius: 3.0)
        let roundProcessor = RoundCornerImageProcessor(cornerRadius: 15)

        let combinedProcessor = resizeProcessor |> blurProcessor |> roundProcessor

        processorImageView.kf.setImage(
            with: url,
            options: [
                .processor(combinedProcessor),
                .transition(.flipFromBottom(0.5)),
                .backgroundDecode
            ]
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.updateStatus("处理器加载成功：缩放+模糊+圆角")
                case .failure(let error):
                    self?.updateStatus("处理器加载失败: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 更新状态标签
    /// - Parameter text: 状态文本
    private func updateStatus(_ text: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = text
            print("Kingfisher: \(text)")
        }
    }
}