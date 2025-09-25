import UIKit
import SnapKit
import AVFoundation
import AVKit

/// 自定义视图，支持触摸穿透
class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 如果视图隐藏或不可交互，则让触摸穿透
        if isHidden || !isUserInteractionEnabled || alpha < 0.01 {
            return false
        }

        // 检查触摸点是否在子视图内
        for subview in subviews.reversed() {
            let convertedPoint = convert(point, to: subview)
            if subview.point(inside: convertedPoint, with: event) {
                return true
            }
        }

        // 如果触摸点不在任何子视图内，则让触摸穿透
        return false
    }
}

/// 视频播放示例页面
/// 展示AVPlayer和AVPlayerViewController的使用，包括本地视频和网络视频播放
class VideoPlayerViewController: UIViewController {

    private var customNavigationBar: CustomNavigationBar!
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    // 视频播放器
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?

    // UI 组件
    private var statusLabel: UILabel!
    private var videoContainerView: UIView!
    private var controlsContainerView: UIView!


    // 覆盖控制层组件
    private var overlayControlsView: UIView!
    private var overlayBackgroundView: UIView!
    private var overlayStackView: UIStackView!

    // 覆盖层控制按钮
    private var playPauseButton: UIButton!
    private var forward15Button: UIButton!
    private var overlayProgressSlider: UISlider!
    private var overlayTimeLabel: UILabel!

    // 全屏按钮（在控制面板中使用）
    private var fullscreenButton: UIButton!

    // 视频选择按钮
    private var localVideoButton: UIButton!
    private var networkVideoButton: UIButton!

    // 定时器
    private var progressTimer: Timer?
    private var hideControlsTimer: Timer?

    // 控制栏状态
    private var isControlsVisible: Bool = false

    // 示例视频URL
    private let networkVideoURL = "https://videos.cubox.pro/iw3rni/file/2024062923083169063/mda-qdq8qnmw9x5wm9jx.mp4"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopVideo()
        hideControlsTimer?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 更新播放器层的frame
        playerLayer?.frame = videoContainerView.bounds
    }

    deinit {
        // 清理定时器
        progressTimer?.invalidate()
        hideControlsTimer?.invalidate()

        // 清理播放器（不调用stopVideo避免UI更新）
        player?.pause()
        cleanupPlayer()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupScrollView()
        setupStatusLabel()
        setupVideoContainer()
        setupOverlayControls()
        setupControlsContainer()
        setupConstraints()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar = CustomNavigationBar()
        customNavigationBar.configure(title: "视频播放示例") { [weak self] in
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

    /// 设置状态标签
    private func setupStatusLabel() {
        statusLabel = UILabel()
        statusLabel.text = "视频播放功能演示"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        statusLabel.textColor = .systemBlue
        statusLabel.numberOfLines = 0

        contentView.addSubview(statusLabel)
    }

    /// 设置视频容器
    private func setupVideoContainer() {
        videoContainerView = UIView()
        videoContainerView.backgroundColor = .black
        videoContainerView.layer.cornerRadius = 12
        videoContainerView.clipsToBounds = true  // 恢复裁剪

        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(videoContainerTapped))
        videoContainerView.addGestureRecognizer(tapGesture)
        videoContainerView.isUserInteractionEnabled = true

        contentView.addSubview(videoContainerView)
    }

    /// 设置覆盖控制层
    private func setupOverlayControls() {
        // 创建覆盖控制层主容器 - 使用自定义的穿透视图
        overlayControlsView = PassThroughView()
        overlayControlsView.backgroundColor = UIColor.clear  // 确保背景透明
        overlayControlsView.isHidden = true
        overlayControlsView.alpha = 0.0
        overlayControlsView.isUserInteractionEnabled = false  // 初始状态禁用交互

        // 创建半透明背景
        overlayBackgroundView = UIView()
        overlayBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayBackgroundView.layer.cornerRadius = 8

        // 创建播放/暂停按钮
        playPauseButton = UIButton(type: .system)
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.tintColor = .white
        playPauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        playPauseButton.layer.cornerRadius = 22
        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)

        // 创建快进15秒按钮
        forward15Button = UIButton(type: .system)
        forward15Button.setTitle("+15s", for: .normal)
        forward15Button.setTitleColor(.white, for: .normal)
        forward15Button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        forward15Button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        forward15Button.layer.cornerRadius = 18
        forward15Button.addTarget(self, action: #selector(forward15Seconds), for: .touchUpInside)

        // 创建进度条
        overlayProgressSlider = createOverlaySlider()
        overlayProgressSlider.addTarget(self, action: #selector(overlayProgressChanged(_:)), for: .valueChanged)

        // 创建时间标签
        overlayTimeLabel = UILabel()
        overlayTimeLabel.text = "00:00 / 00:00"
        overlayTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        overlayTimeLabel.textColor = .white
        overlayTimeLabel.textAlignment = .center

        // 创建水平布局的栈视图
        overlayStackView = UIStackView(arrangedSubviews: [
            playPauseButton,
            overlayProgressSlider,
            forward15Button,
            overlayTimeLabel
        ])
        overlayStackView.axis = .horizontal
        overlayStackView.alignment = .center
        overlayStackView.spacing = 12
        overlayStackView.distribution = .fill

        // 设置子视图约束
        playPauseButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }

        forward15Button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(36)
        }

        overlayTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }

        // 添加子视图
        overlayControlsView.addSubview(overlayBackgroundView)
        overlayControlsView.addSubview(overlayStackView)
        videoContainerView.addSubview(overlayControlsView)

        // 设置约束 - 在视频容器内部的底部，留出圆角空间
        overlayControlsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)  // 距离底部8像素，避免被圆角裁剪
            make.height.equalTo(70)  // 给控制栏足够的高度
        }

        overlayBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
        }

        overlayStackView.snp.makeConstraints { make in
            make.centerY.equalTo(overlayBackgroundView)
            make.leading.trailing.equalTo(overlayBackgroundView).inset(16)
        }
    }

    /// 创建覆盖层滑块
    /// - Returns: 配置好的滑块
    private func createOverlaySlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.thumbTintColor = UIColor.themeColor
        slider.minimumTrackTintColor = UIColor.themeColor
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        return slider
    }

    /// 设置控制面板
    private func setupControlsContainer() {
        controlsContainerView = UIView()
        controlsContainerView.backgroundColor = .systemGray6
        controlsContainerView.layer.cornerRadius = 12
        controlsContainerView.layer.borderWidth = 1
        controlsContainerView.layer.borderColor = UIColor.systemGray4.cgColor

        // 视频选择按钮
        localVideoButton = createButton(title: "本地视频", action: #selector(selectLocalVideo))
        networkVideoButton = createButton(title: "网络视频", action: #selector(selectNetworkVideo))

        // 全屏按钮
        fullscreenButton = UIButton(type: .system)
        fullscreenButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        fullscreenButton.setTitle("全屏", for: .normal)
        fullscreenButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        fullscreenButton.backgroundColor = UIColor.themeColor
        fullscreenButton.setTitleColor(.white, for: .normal)
        fullscreenButton.tintColor = .white
        fullscreenButton.layer.cornerRadius = 8
        fullscreenButton.addTarget(self, action: #selector(enterFullscreen), for: .touchUpInside)

        // 设置图标和文字的布局
        fullscreenButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        fullscreenButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)

        // 创建提示标签
        let hintLabel = UILabel()
        hintLabel.text = "点击视频区域显示播放控制"
        hintLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center

        // 添加控件到容器
        controlsContainerView.addSubview(localVideoButton)
        controlsContainerView.addSubview(networkVideoButton)
        controlsContainerView.addSubview(fullscreenButton)
        controlsContainerView.addSubview(hintLabel)

        // 设置提示标签约束
        hintLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }

        contentView.addSubview(controlsContainerView)
    }

    /// 创建按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - action: 按钮事件
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
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        videoContainerView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(220)
        }

        controlsContainerView.snp.makeConstraints { make in
            make.top.equalTo(videoContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-20)
        }

        setupControlsConstraints()
    }

    /// 设置控制面板约束
    private func setupControlsConstraints() {
        // 视频选择按钮
        localVideoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }

        networkVideoButton.snp.makeConstraints { make in
            make.centerY.equalTo(localVideoButton)
            make.leading.equalTo(localVideoButton.snp.trailing).offset(10)
            make.width.height.equalTo(localVideoButton)
        }

        fullscreenButton.snp.makeConstraints { make in
            make.centerY.equalTo(localVideoButton)
            make.leading.equalTo(networkVideoButton.snp.trailing).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(localVideoButton)
        }
    }

    // MARK: - 音频设置

    /// 设置音频会话
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            updateStatus("音频会话设置失败: \(error.localizedDescription)")
        }
    }

    // MARK: - 视频选择

    /// 选择本地视频
    @objc private func selectLocalVideo() {
        // 使用项目中的本地视频文件
        guard let videoPath = Bundle.main.path(forResource: "1", ofType: "mp4") else {
            updateStatus("未找到本地视频文件: 1.mp4")
            return
        }

        let videoURL = URL(fileURLWithPath: videoPath)
        setupVideoPlayer(with: videoURL)
        updateStatus("加载本地视频文件: 1.mp4")
    }

    /// 选择网络视频
    @objc private func selectNetworkVideo() {
        guard let url = URL(string: networkVideoURL) else {
            updateStatus("无效的网络视频URL")
            return
        }

        setupVideoPlayer(with: url)
        updateStatus("开始加载网络视频...")
    }

    /// 设置视频播放器
    /// - Parameter url: 视频URL
    private func setupVideoPlayer(with url: URL) {
        // 清理之前的播放器
        cleanupPlayer()

        // 创建新的播放器
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // 创建播放器层
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = videoContainerView.bounds

        // 添加到视图
        videoContainerView.layer.addSublayer(playerLayer!)

        // 确保控制层在视频层之上
        videoContainerView.bringSubviewToFront(overlayControlsView)
        overlayControlsView.layer.zPosition = 1000  // 设置更高的层级

        // 设置音量
        player?.volume = 0.5

        // 添加观察者
        addPlayerObservers()

        // 启动定时器
        startProgressTimer()

        updateStatus("视频播放器设置完成")
    }

    /// 添加播放器观察者
    private func addPlayerObservers() {
        // 播放结束通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )

        // 播放器状态观察
        playerItem?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
    }

    /// 清理播放器
    private func cleanupPlayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()

        // 安全地移除观察者
        if let item = playerItem {
            item.removeObserver(self, forKeyPath: "status")
        }
        NotificationCenter.default.removeObserver(self)

        player = nil
        playerLayer = nil
        playerItem = nil
    }

    // MARK: - 覆盖控制层交互

    /// 视频容器点击事件
    @objc private func videoContainerTapped() {
        // 如果有播放器，则切换控制栏；否则提示选择视频
        if player != nil {
            toggleControlsVisibility()
        } else {
            updateStatus("请先选择视频文件")
        }
    }

    /// 切换控制栏显示/隐藏
    private func toggleControlsVisibility() {
        if isControlsVisible {
            hideOverlayControls()
        } else {
            showOverlayControlsWithAutoHide()
        }
    }

    /// 显示覆盖控制栏并自动隐藏
    private func showOverlayControlsWithAutoHide() {
        showOverlayControls()
        startAutoHideTimer()
    }

    /// 显示覆盖控制栏
    private func showOverlayControls() {
        guard !isControlsVisible else { return }

        isControlsVisible = true
        overlayControlsView.isHidden = false
        overlayControlsView.isUserInteractionEnabled = true  // 重新启用交互

        // 恢复透明背景
        overlayControlsView.backgroundColor = UIColor.clear

        UIView.animate(withDuration: 0.3) {
            self.overlayControlsView.alpha = 1.0
        }

    }

    /// 隐藏覆盖控制栏
    private func hideOverlayControls() {
        guard isControlsVisible else { return }

        isControlsVisible = false

        UIView.animate(withDuration: 0.3) {
            self.overlayControlsView.alpha = 0.0
        } completion: { _ in
            self.overlayControlsView.isHidden = true
            self.overlayControlsView.isUserInteractionEnabled = false  // 禁用交互避免拦截点击
        }

        // 取消自动隐藏定时器
        hideControlsTimer?.invalidate()
        hideControlsTimer = nil
    }

    /// 启动自动隐藏定时器
    private func startAutoHideTimer() {
        hideControlsTimer?.invalidate()
        hideControlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.hideOverlayControls()
        }
    }

    /// 重置自动隐藏定时器
    private func resetAutoHideTimer() {
        if isControlsVisible {
            startAutoHideTimer()
        }
    }

    /// 播放/暂停切换
    @objc private func togglePlayPause() {
        guard let player = player else {
            updateStatus("请先选择并加载视频")
            return
        }

        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            updateStatus("暂停视频播放")
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            updateStatus("开始播放视频")
        }

        // 重置自动隐藏定时器
        resetAutoHideTimer()
    }

    /// 快进15秒
    @objc private func forward15Seconds() {
        guard let player = player else { return }

        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: 15, preferredTimescale: 600))

        // 检查是否超过视频总时长
        if let duration = player.currentItem?.duration,
           CMTimeCompare(newTime, duration) <= 0 {
            player.seek(to: newTime)
            updateStatus("快进15秒")
        } else {
            // 如果超过总时长，跳到末尾
            if let duration = player.currentItem?.duration {
                player.seek(to: duration)
                updateStatus("已到视频末尾")
            }
        }

        // 重置自动隐藏定时器
        resetAutoHideTimer()
    }

    /// 覆盖层进度条改变
    @objc private func overlayProgressChanged(_ slider: UISlider) {
        guard let player = player,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else { return }

        let newTime = Double(slider.value) * duration
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
        updateOverlayTimeLabel()

        // 重置自动隐藏定时器
        resetAutoHideTimer()
    }

    // MARK: - 播放控制

    /// 停止视频
    @objc private func stopVideo() {
        player?.pause()
        player?.seek(to: .zero)
        overlayProgressSlider.value = 0
        updateTimeLabel()
        updateOverlayTimeLabel()
        updateStatus("停止视频播放")
    }

    /// 进入全屏
    @objc private func enterFullscreen() {
        guard let player = player else {
            updateStatus("请先选择并加载视频")
            return
        }

        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            self.updateStatus("进入全屏播放模式")
        }
    }

    /// 视频播放完成
    @objc private func videoDidFinishPlaying() {
        updateStatus("视频播放完成")
    }

    // MARK: - 进度更新

    /// 启动进度定时器
    private func startProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    /// 更新播放进度
    private func updateProgress() {
        guard let player = player,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else { return }

        let currentTime = player.currentTime().seconds

        if duration > 0 {
            overlayProgressSlider.value = Float(currentTime / duration)
        }

        updateTimeLabel()
        updateOverlayTimeLabel()

        // 更新播放按钮状态
        updatePlayPauseButtonState()
    }

    /// 更新时间标签
    private func updateTimeLabel() {
        guard let player = player,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else {
            return
        }

        let currentTime = player.currentTime().seconds
    }

    /// 更新覆盖层时间标签
    private func updateOverlayTimeLabel() {
        guard let player = player,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else {
            overlayTimeLabel.text = "00:00 / 00:00"
            return
        }

        let currentTime = player.currentTime().seconds
        overlayTimeLabel.text = "\(formatTime(currentTime)) / \(formatTime(duration))"
    }

    /// 更新播放/暂停按钮状态
    private func updatePlayPauseButtonState() {
        guard let player = player else { return }

        DispatchQueue.main.async {
            if player.timeControlStatus == .playing {
                self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }

    /// 格式化时间
    /// - Parameter time: 时间（秒）
    /// - Returns: 格式化后的时间字符串
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// 更新状态标签
    /// - Parameter text: 状态文本
    private func updateStatus(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statusLabel.text = text
            print("VideoPlayer: \(text)")
        }
    }

    // MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 确保在主线程执行
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if keyPath == "status" {
                if let statusNumber = change?[.newKey] as? NSNumber {
                    let status = AVPlayerItem.Status(rawValue: statusNumber.intValue)
                    switch status {
                    case .readyToPlay:
                        self.updateStatus("视频加载完成，可以播放")
                    case .failed:
                        self.updateStatus("视频加载失败")
                    case .unknown:
                        self.updateStatus("视频状态未知")
                    default:
                        break
                    }
                }
            }
        }
    }
}
