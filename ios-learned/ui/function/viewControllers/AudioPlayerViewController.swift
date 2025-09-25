import UIKit
import SnapKit
import AVFoundation
import MediaPlayer

/// 音频播放示例页面
/// 展示AVAudioPlayer和AVPlayer的使用，包括本地音频和网络音频播放
class AudioPlayerViewController: UIViewController {

    private var customNavigationBar: CustomNavigationBar!
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    // 音频播放器
    private var audioPlayer: AVAudioPlayer?
    private var avPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?

    // 通知栏播放器
    private var notificationPlayer: AVPlayer?
    private var notificationPlayerItem: AVPlayerItem?

    // UI 组件
    private var statusLabel: UILabel!

    // 音频信息显示
    private var localAudioInfoLabel: UILabel!
    private var networkAudioInfoLabel: UILabel!

    // 本地音频播放区域
    private var localAudioView: UIView!
    private var localPlayButton: UIButton!
    private var localPauseButton: UIButton!
    private var localStopButton: UIButton!
    private var localVolumeSlider: UISlider!
    private var localProgressSlider: UISlider!
    private var localTimeLabel: UILabel!

    // 网络音频播放区域
    private var networkAudioView: UIView!
    private var networkPlayButton: UIButton!
    private var networkPauseButton: UIButton!
    private var networkStopButton: UIButton!
    private var networkVolumeSlider: UISlider!
    private var networkProgressSlider: UISlider!
    private var networkTimeLabel: UILabel!
    private var networkStatusLabel: UILabel!

    // 通知栏播放区域
    private var notificationAudioView: UIView!
    private var notificationPlayButton: UIButton!
    private var notificationPauseButton: UIButton!
    private var notificationStopButton: UIButton!
    private var notificationVolumeSlider: UISlider!
    private var notificationProgressSlider: UISlider!
    private var notificationTimeLabel: UILabel!
    private var notificationStatusLabel: UILabel!
    private var notificationAudioInfoLabel: UILabel!

    // 定时器
    private var progressTimer: Timer?

    // 示例音频URL
    private let networkAudioURL = "https://audios.cubox.pro/iw3rni/file/2024063018174248065/Roys+-+Can't+you+say%E6%81%8B%E7%88%B1%E7%A6%81%E6%AD%A2%E4%B8%96%E7%95%8Ced.mp3"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioSession()
        setupLocalAudio()
        setupRemoteCommandCenter()
        startProgressTimer() // 确保定时器总是启动
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllAudio()
    }

    deinit {
        stopAllAudio()
        progressTimer?.invalidate()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupScrollView()
        setupStatusLabel()
        setupLocalAudioView()
        setupNetworkAudioView()
        setupNotificationAudioView()
        setupConstraints()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        customNavigationBar = CustomNavigationBar()
        customNavigationBar.configure(title: "音频播放示例") { [weak self] in
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
        statusLabel.text = "音频播放功能演示"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        statusLabel.textColor = .systemBlue
        statusLabel.numberOfLines = 0

        contentView.addSubview(statusLabel)
    }

    /// 设置本地音频播放区域
    private func setupLocalAudioView() {
        localAudioView = createAudioPlayerView(title: "本地音频播放 (AVAudioPlayer)")

        localPlayButton = createControlButton(title: "播放", action: #selector(playLocalAudio))
        localPauseButton = createControlButton(title: "暂停", action: #selector(pauseLocalAudio))
        localStopButton = createControlButton(title: "停止", action: #selector(stopLocalAudio))

        localVolumeSlider = createSlider(minimumValue: 0.0, maximumValue: 1.0, value: 0.5)
        localVolumeSlider.addTarget(self, action: #selector(localVolumeChanged(_:)), for: .valueChanged)

        localProgressSlider = createSlider(minimumValue: 0.0, maximumValue: 1.0, value: 0.0)
        localProgressSlider.addTarget(self, action: #selector(localProgressChanged(_:)), for: .valueChanged)

        localTimeLabel = createTimeLabel()

        // 本地音频信息标签
        localAudioInfoLabel = UILabel()
        localAudioInfoLabel.text = "本地音频：未加载"
        localAudioInfoLabel.font = UIFont.systemFont(ofSize: 12)
        localAudioInfoLabel.textColor = .systemGray
        localAudioInfoLabel.numberOfLines = 2

        let localVolumeLabel = createLabel(text: "音量")
        let localProgressLabel = createLabel(text: "进度")

        localAudioView.addSubview(localPlayButton)
        localAudioView.addSubview(localPauseButton)
        localAudioView.addSubview(localStopButton)
        localAudioView.addSubview(localAudioInfoLabel)
        localAudioView.addSubview(localVolumeLabel)
        localAudioView.addSubview(localVolumeSlider)
        localAudioView.addSubview(localProgressLabel)
        localAudioView.addSubview(localProgressSlider)
        localAudioView.addSubview(localTimeLabel)

        contentView.addSubview(localAudioView)
    }

    /// 设置网络音频播放区域
    private func setupNetworkAudioView() {
        networkAudioView = createAudioPlayerView(title: "网络音频播放 (AVPlayer)")

        networkPlayButton = createControlButton(title: "播放", action: #selector(playNetworkAudio))
        networkPauseButton = createControlButton(title: "暂停", action: #selector(pauseNetworkAudio))
        networkStopButton = createControlButton(title: "停止", action: #selector(stopNetworkAudio))

        networkVolumeSlider = createSlider(minimumValue: 0.0, maximumValue: 1.0, value: 0.5)
        networkVolumeSlider.addTarget(self, action: #selector(networkVolumeChanged(_:)), for: .valueChanged)

        networkProgressSlider = createSlider(minimumValue: 0.0, maximumValue: 1.0, value: 0.0)
        networkProgressSlider.addTarget(self, action: #selector(networkProgressChanged(_:)), for: .valueChanged)

        networkTimeLabel = createTimeLabel()

        networkStatusLabel = UILabel()
        networkStatusLabel.text = "准备播放网络音频"
        networkStatusLabel.font = UIFont.systemFont(ofSize: 12)
        networkStatusLabel.textColor = .systemGray
        networkStatusLabel.textAlignment = .center

        // 网络音频信息标签
        networkAudioInfoLabel = UILabel()
        networkAudioInfoLabel.text = "网络音频：未加载"
        networkAudioInfoLabel.font = UIFont.systemFont(ofSize: 12)
        networkAudioInfoLabel.textColor = .systemGray
        networkAudioInfoLabel.numberOfLines = 2

        let networkVolumeLabel = createLabel(text: "音量")
        let networkProgressLabel = createLabel(text: "进度")

        networkAudioView.addSubview(networkPlayButton)
        networkAudioView.addSubview(networkPauseButton)
        networkAudioView.addSubview(networkStopButton)
        networkAudioView.addSubview(networkAudioInfoLabel)
        networkAudioView.addSubview(networkVolumeLabel)
        networkAudioView.addSubview(networkVolumeSlider)
        networkAudioView.addSubview(networkProgressLabel)
        networkAudioView.addSubview(networkProgressSlider)
        networkAudioView.addSubview(networkTimeLabel)
        networkAudioView.addSubview(networkStatusLabel)

        contentView.addSubview(networkAudioView)
    }

    /// 设置通知栏音频播放区域
    private func setupNotificationAudioView() {
        notificationAudioView = createAudioPlayerView(title: "网络音频播放 + 通知栏控制 (AVPlayer + MediaPlayer)")

        notificationPlayButton = createControlButton(title: "播放", action: #selector(playNotificationAudio))
        notificationPauseButton = createControlButton(title: "暂停", action: #selector(pauseNotificationAudio))
        notificationStopButton = createControlButton(title: "停止", action: #selector(stopNotificationAudio))

        notificationVolumeSlider = createSlider(minimumValue: 0.0, maximumValue: 1.0, value: 0.5)
        notificationVolumeSlider.addTarget(self, action: #selector(notificationVolumeChanged(_:)), for: .valueChanged)

        notificationProgressSlider = createSlider(minimumValue: 0.0, maximumValue: 1.0, value: 0.0)
        notificationProgressSlider.addTarget(self, action: #selector(notificationProgressChanged(_:)), for: .valueChanged)

        notificationTimeLabel = createTimeLabel()

        notificationStatusLabel = UILabel()
        notificationStatusLabel.text = "准备播放网络音频（支持通知栏控制）"
        notificationStatusLabel.font = UIFont.systemFont(ofSize: 12)
        notificationStatusLabel.textColor = .systemGray
        notificationStatusLabel.textAlignment = .center

        // 通知栏音频信息标签
        notificationAudioInfoLabel = UILabel()
        notificationAudioInfoLabel.text = "通知栏音频：未加载"
        notificationAudioInfoLabel.font = UIFont.systemFont(ofSize: 12)
        notificationAudioInfoLabel.textColor = .systemGray
        notificationAudioInfoLabel.numberOfLines = 2

        let notificationVolumeLabel = createLabel(text: "音量")
        let notificationProgressLabel = createLabel(text: "进度")

        notificationAudioView.addSubview(notificationPlayButton)
        notificationAudioView.addSubview(notificationPauseButton)
        notificationAudioView.addSubview(notificationStopButton)
        notificationAudioView.addSubview(notificationAudioInfoLabel)
        notificationAudioView.addSubview(notificationVolumeLabel)
        notificationAudioView.addSubview(notificationVolumeSlider)
        notificationAudioView.addSubview(notificationProgressLabel)
        notificationAudioView.addSubview(notificationProgressSlider)
        notificationAudioView.addSubview(notificationTimeLabel)
        notificationAudioView.addSubview(notificationStatusLabel)

        contentView.addSubview(notificationAudioView)
    }

    /// 创建音频播放器容器视图
    /// - Parameter title: 标题
    /// - Returns: 配置好的容器视图
    private func createAudioPlayerView(title: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center

        containerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        return containerView
    }

    /// 创建控制按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - action: 按钮事件
    /// - Returns: 配置好的按钮
    private func createControlButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.themeColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    /// 创建滑块
    /// - Parameters:
    ///   - minimumValue: 最小值
    ///   - maximumValue: 最大值
    ///   - value: 当前值
    /// - Returns: 配置好的滑块
    private func createSlider(minimumValue: Float, maximumValue: Float, value: Float) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = value
        slider.thumbTintColor = UIColor.themeColor
        slider.minimumTrackTintColor = UIColor.themeColor
        return slider
    }

    /// 创建标签
    /// - Parameter text: 标签文本
    /// - Returns: 配置好的标签
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }

    /// 创建时间标签
    /// - Returns: 配置好的时间标签
    private func createTimeLabel() -> UILabel {
        let label = UILabel()
        label.text = "00:00 / 00:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
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

        localAudioView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(240)
        }

        setupLocalAudioConstraints()

        networkAudioView.snp.makeConstraints { make in
            make.top.equalTo(localAudioView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(260)
        }

        setupNetworkAudioConstraints()

        notificationAudioView.snp.makeConstraints { make in
            make.top.equalTo(networkAudioView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(260)
            make.bottom.equalToSuperview().offset(-20)
        }

        setupNotificationAudioConstraints()
    }

    /// 设置本地音频控件约束
    private func setupLocalAudioConstraints() {
        if let titleLabel = localAudioView.subviews.first as? UILabel {
            localPlayButton.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(60)
                make.height.equalTo(32)
            }

            localPauseButton.snp.makeConstraints { make in
                make.centerY.equalTo(localPlayButton)
                make.leading.equalTo(localPlayButton.snp.trailing).offset(10)
                make.width.height.equalTo(localPlayButton)
            }

            localStopButton.snp.makeConstraints { make in
                make.centerY.equalTo(localPlayButton)
                make.leading.equalTo(localPauseButton.snp.trailing).offset(10)
                make.width.height.equalTo(localPlayButton)
            }

            // 音频信息标签
            localAudioInfoLabel.snp.makeConstraints { make in
                make.top.equalTo(localPlayButton.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview().inset(20)
            }

            // 创建音量标签的引用
            guard let volumeLabel = localAudioView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "音量" }) else { return }

            volumeLabel.snp.makeConstraints { make in
                make.top.equalTo(localAudioInfoLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(40)
            }

            localVolumeSlider.snp.makeConstraints { make in
                make.centerY.equalTo(volumeLabel)
                make.leading.equalTo(volumeLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview().offset(-20)
            }

            // 创建进度标签的引用
            guard let progressLabel = localAudioView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "进度" }) else { return }

            progressLabel.snp.makeConstraints { make in
                make.top.equalTo(volumeLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(40)
            }

            localProgressSlider.snp.makeConstraints { make in
                make.centerY.equalTo(progressLabel)
                make.leading.equalTo(progressLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview().offset(-20)
            }

            localTimeLabel.snp.makeConstraints { make in
                make.top.equalTo(progressLabel.snp.bottom).offset(15)
                make.centerX.equalToSuperview()
            }
        }
    }

    /// 设置网络音频控件约束
    private func setupNetworkAudioConstraints() {
        if let titleLabel = networkAudioView.subviews.first as? UILabel {
            networkPlayButton.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(60)
                make.height.equalTo(32)
            }

            networkPauseButton.snp.makeConstraints { make in
                make.centerY.equalTo(networkPlayButton)
                make.leading.equalTo(networkPlayButton.snp.trailing).offset(10)
                make.width.height.equalTo(networkPlayButton)
            }

            networkStopButton.snp.makeConstraints { make in
                make.centerY.equalTo(networkPlayButton)
                make.leading.equalTo(networkPauseButton.snp.trailing).offset(10)
                make.width.height.equalTo(networkPlayButton)
            }

            // 音频信息标签
            networkAudioInfoLabel.snp.makeConstraints { make in
                make.top.equalTo(networkPlayButton.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview().inset(20)
            }

            // 创建音量标签的引用
            guard let volumeLabel = networkAudioView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "音量" }) else { return }

            volumeLabel.snp.makeConstraints { make in
                make.top.equalTo(networkAudioInfoLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(40)
            }

            networkVolumeSlider.snp.makeConstraints { make in
                make.centerY.equalTo(volumeLabel)
                make.leading.equalTo(volumeLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview().offset(-20)
            }

            // 创建进度标签的引用
            guard let progressLabel = networkAudioView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "进度" }) else { return }

            progressLabel.snp.makeConstraints { make in
                make.top.equalTo(volumeLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(40)
            }

            networkProgressSlider.snp.makeConstraints { make in
                make.centerY.equalTo(progressLabel)
                make.leading.equalTo(progressLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview().offset(-20)
            }

            networkTimeLabel.snp.makeConstraints { make in
                make.top.equalTo(progressLabel.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }

            networkStatusLabel.snp.makeConstraints { make in
                make.top.equalTo(networkTimeLabel.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
            }
        }
    }

    /// 设置通知栏音频控件约束
    private func setupNotificationAudioConstraints() {
        if let titleLabel = notificationAudioView.subviews.first as? UILabel {
            notificationPlayButton.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(60)
                make.height.equalTo(32)
            }

            notificationPauseButton.snp.makeConstraints { make in
                make.centerY.equalTo(notificationPlayButton)
                make.leading.equalTo(notificationPlayButton.snp.trailing).offset(10)
                make.width.height.equalTo(notificationPlayButton)
            }

            notificationStopButton.snp.makeConstraints { make in
                make.centerY.equalTo(notificationPlayButton)
                make.leading.equalTo(notificationPauseButton.snp.trailing).offset(10)
                make.width.height.equalTo(notificationPlayButton)
            }

            // 音频信息标签
            notificationAudioInfoLabel.snp.makeConstraints { make in
                make.top.equalTo(notificationPlayButton.snp.bottom).offset(10)
                make.leading.trailing.equalToSuperview().inset(20)
            }

            // 创建音量标签的引用
            guard let volumeLabel = notificationAudioView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "音量" }) else { return }

            volumeLabel.snp.makeConstraints { make in
                make.top.equalTo(notificationAudioInfoLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(40)
            }

            notificationVolumeSlider.snp.makeConstraints { make in
                make.centerY.equalTo(volumeLabel)
                make.leading.equalTo(volumeLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview().offset(-20)
            }

            // 创建进度标签的引用
            guard let progressLabel = notificationAudioView.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "进度" }) else { return }

            progressLabel.snp.makeConstraints { make in
                make.top.equalTo(volumeLabel.snp.bottom).offset(15)
                make.leading.equalToSuperview().offset(20)
                make.width.equalTo(40)
            }

            notificationProgressSlider.snp.makeConstraints { make in
                make.centerY.equalTo(progressLabel)
                make.leading.equalTo(progressLabel.snp.trailing).offset(10)
                make.trailing.equalToSuperview().offset(-20)
            }

            notificationTimeLabel.snp.makeConstraints { make in
                make.top.equalTo(progressLabel.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }

            notificationStatusLabel.snp.makeConstraints { make in
                make.top.equalTo(notificationTimeLabel.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
            }
        }
    }

    // MARK: - 音频设置

    /// 设置音频会话
    private func setupAudioSession() {
        do {
            // 设置音频会话类别为播放，选项为支持后台播放和混音
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowBluetooth, .allowBluetoothA2DP]
            )
            try AVAudioSession.sharedInstance().setActive(true)
            updateStatus("音频会话设置成功，支持后台播放")
        } catch {
            updateStatus("音频会话设置失败: \(error.localizedDescription)")
        }
    }

    /// 设置远程控制中心
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        // 启用播放按钮
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.handleRemotePlay()
            return .success
        }

        // 启用暂停按钮
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.handleRemotePause()
            return .success
        }

        // 启用播放/暂停切换按钮
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.handleRemoteTogglePlayPause()
            return .success
        }

        // 启用下一曲按钮（可选）
        commandCenter.nextTrackCommand.isEnabled = false

        // 启用上一曲按钮（可选）
        commandCenter.previousTrackCommand.isEnabled = false

        // 启用播放位置改变
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                self?.handleRemoteSeek(to: event.positionTime)
                return .success
            }
            return .commandFailed
        }
    }

    /// 设置本地音频
    private func setupLocalAudio() {
        // 使用项目中的本地音频文件
        guard let soundPath = Bundle.main.path(forResource: "1", ofType: "mp3") else {
            // 如果没有找到音频文件，使用演示音频
            createDemoAudio()
            return
        }

        let soundURL = URL(fileURLWithPath: soundPath)
        setupAudioPlayer(with: soundURL)
        updateLocalAudioInfo()
        updateStatus("已加载本地音频文件: 1.mp3")
    }

    /// 创建演示音频（如果没有本地音频文件）
    private func createDemoAudio() {
        updateStatus("未找到本地音频文件，使用系统音效演示")

        // 使用系统音效作为替代
        guard let soundPath = Bundle.main.path(forResource: "SystemSounds/sms-received1.caf", ofType: nil) else {
            updateStatus("无法加载演示音频")
            return
        }

        let soundURL = URL(fileURLWithPath: soundPath)
        setupAudioPlayer(with: soundURL)
    }

    /// 设置音频播放器
    /// - Parameter url: 音频文件URL
    private func setupAudioPlayer(with url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 0.5

            // 启动定时器更新进度
            startProgressTimer()

            updateStatus("本地音频加载成功")
        } catch {
            updateStatus("音频播放器初始化失败: \(error.localizedDescription)")
        }
    }

    // MARK: - 本地音频控制

    /// 播放本地音频
    @objc private func playLocalAudio() {
        // 停止网络音频播放
        if avPlayer != nil {
            pauseNetworkAudio()
            updateStatus("停止网络音频，开始播放本地音频")
        }

        audioPlayer?.play()
        updateStatus("开始播放本地音频")
    }

    /// 暂停本地音频
    @objc private func pauseLocalAudio() {
        audioPlayer?.pause()
        updateStatus("暂停本地音频")
    }

    /// 停止本地音频
    @objc private func stopLocalAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        localProgressSlider.value = 0
        updateLocalTimeLabel()
        updateStatus("停止本地音频")
    }

    /// 本地音量改变
    /// - Parameter slider: 音量滑块
    @objc private func localVolumeChanged(_ slider: UISlider) {
        audioPlayer?.volume = slider.value
    }

    /// 本地进度改变
    /// - Parameter slider: 进度滑块
    @objc private func localProgressChanged(_ slider: UISlider) {
        guard let player = audioPlayer else { return }
        let newTime = TimeInterval(slider.value) * player.duration
        player.currentTime = newTime
        updateLocalTimeLabel()
    }

    // MARK: - 网络音频控制

    /// 播放网络音频
    @objc private func playNetworkAudio() {
        // 停止本地音频播放
        if let player = audioPlayer, player.isPlaying {
            pauseLocalAudio()
            updateStatus("停止本地音频，开始播放网络音频")
        }

        // 如果已经有播放器实例，直接播放
        if let player = avPlayer {
            player.play()
            networkStatusLabel.text = "正在播放网络音频"
            updateStatus("继续播放网络音频")
            return
        }

        // 首次播放，创建新的播放器
        guard let url = URL(string: networkAudioURL) else {
            updateStatus("无效的网络音频URL")
            return
        }

        networkStatusLabel.text = "正在加载网络音频..."

        playerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer?.volume = networkVolumeSlider.value

        // 添加播放结束通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkAudioDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )

        // 添加播放项状态监听
        playerItem?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)

        avPlayer?.play()
        networkStatusLabel.text = "正在播放网络音频"
        updateStatus("开始播放网络音频")
    }

    /// 暂停网络音频
    @objc private func pauseNetworkAudio() {
        avPlayer?.pause()
        networkStatusLabel.text = "网络音频已暂停"
        updateStatus("暂停网络音频")
    }

    /// 停止网络音频
    @objc private func stopNetworkAudio() {
        avPlayer?.pause()
        avPlayer?.seek(to: .zero)

        // 清理播放器实例，下次播放时重新创建
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        if let item = playerItem {
            item.removeObserver(self, forKeyPath: "status")
        }
        avPlayer = nil
        playerItem = nil

        networkProgressSlider.value = 0
        updateNetworkTimeLabel()
        networkStatusLabel.text = "网络音频已停止"
        updateStatus("停止网络音频")
    }

    /// 网络音频播放完成
    @objc private func networkAudioDidFinishPlaying() {
        networkStatusLabel.text = "网络音频播放完成"
        updateStatus("网络音频播放完成")

        // 播放完成后清理实例，下次播放从头开始
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        if let item = playerItem {
            item.removeObserver(self, forKeyPath: "status")
        }
        avPlayer = nil
        playerItem = nil
    }

    /// 网络音量改变
    /// - Parameter slider: 音量滑块
    @objc private func networkVolumeChanged(_ slider: UISlider) {
        avPlayer?.volume = slider.value
    }

    /// 网络音频进度改变
    /// - Parameter slider: 进度滑块
    @objc private func networkProgressChanged(_ slider: UISlider) {
        guard let player = avPlayer,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else { return }

        let newTime = Double(slider.value) * duration
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
        updateNetworkTimeLabel()
    }

    // MARK: - 通知栏播放控制

    /// 播放通知栏音频
    @objc private func playNotificationAudio() {
        // 停止其他音频播放
        stopOtherAudioPlayers(except: "notification")

        // 如果已经有播放器实例，直接播放
        if let player = notificationPlayer {
            player.play()
            notificationStatusLabel.text = "正在播放通知栏音频"
            updateStatus("继续播放通知栏音频")
            setupNowPlayingInfo()
            return
        }

        // 首次播放，创建新的播放器
        guard let url = URL(string: networkAudioURL) else {
            updateStatus("无效的网络音频URL")
            return
        }

        notificationStatusLabel.text = "正在加载通知栏音频..."

        notificationPlayerItem = AVPlayerItem(url: url)
        notificationPlayer = AVPlayer(playerItem: notificationPlayerItem)
        notificationPlayer?.volume = notificationVolumeSlider.value

        // 添加播放结束通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationAudioDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: notificationPlayerItem
        )

        // 添加播放项状态监听
        notificationPlayerItem?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)

        notificationPlayer?.play()
        notificationStatusLabel.text = "正在播放通知栏音频"
        updateStatus("开始播放通知栏音频")
        setupNowPlayingInfo()
    }

    /// 暂停通知栏音频
    @objc private func pauseNotificationAudio() {
        notificationPlayer?.pause()
        notificationStatusLabel.text = "通知栏音频已暂停"
        updateStatus("暂停通知栏音频")
        updateNowPlayingInfo()
    }

    /// 停止通知栏音频
    @objc private func stopNotificationAudio() {
        notificationPlayer?.pause()
        notificationPlayer?.seek(to: .zero)

        // 清理播放器实例，下次播放时重新创建
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: notificationPlayerItem)
        if let item = notificationPlayerItem {
            item.removeObserver(self, forKeyPath: "status")
        }
        notificationPlayer = nil
        notificationPlayerItem = nil

        notificationProgressSlider.value = 0
        updateNotificationTimeLabel()
        notificationStatusLabel.text = "通知栏音频已停止"
        updateStatus("停止通知栏音频")

        // 清除通知栏信息
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    /// 通知栏音频播放完成
    @objc private func notificationAudioDidFinishPlaying() {
        notificationStatusLabel.text = "通知栏音频播放完成"
        updateStatus("通知栏音频播放完成")

        // 播放完成后清理实例，下次播放从头开始
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: notificationPlayerItem)
        if let item = notificationPlayerItem {
            item.removeObserver(self, forKeyPath: "status")
        }
        notificationPlayer = nil
        notificationPlayerItem = nil

        // 清除通知栏信息
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    /// 通知栏音量改变
    @objc private func notificationVolumeChanged(_ slider: UISlider) {
        notificationPlayer?.volume = slider.value
    }

    /// 通知栏音频进度改变
    @objc private func notificationProgressChanged(_ slider: UISlider) {
        guard let player = notificationPlayer,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else { return }

        let newTime = Double(slider.value) * duration
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
        updateNotificationTimeLabel()
        updateNowPlayingInfo()
    }

    /// 停止其他音频播放器
    private func stopOtherAudioPlayers(except: String) {
        if except != "local" {
            audioPlayer?.pause()
        }
        if except != "network" {
            avPlayer?.pause()
        }
        if except != "notification" {
            notificationPlayer?.pause()
        }
    }

    // MARK: - MediaPlayer 控制

    /// 设置 Now Playing 信息
    private func setupNowPlayingInfo() {
        guard let player = notificationPlayer,
              let item = player.currentItem,
              item.status == .readyToPlay else { return }

        var nowPlayingInfo = [String: Any]()

        // 音频基本信息
        nowPlayingInfo[MPMediaItemPropertyTitle] = "网络示例音频"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "iOS 学习项目"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "音频播放示例"

        // 播放时长
        let duration = item.duration.seconds
        if !duration.isNaN {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }

        // 当前播放时间
        let currentTime = player.currentTime().seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime

        // 播放速率（1.0 表示正常播放，0.0 表示暂停）
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        // 设置到系统
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        updateStatus("已设置通知栏播放信息（模拟器可能不显示，请在真机测试）")
    }

    /// 更新 Now Playing 信息
    private func updateNowPlayingInfo() {
        guard let player = notificationPlayer,
              let item = player.currentItem,
              item.status == .readyToPlay else { return }

        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()

        // 更新当前播放时间
        let currentTime = player.currentTime().seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime

        // 更新播放速率
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        // 设置到系统
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - 远程控制事件处理

    /// 处理远程播放命令
    private func handleRemotePlay() {
        updateStatus("收到远程播放命令")
        if notificationPlayer != nil {
            playNotificationAudio()
        }
    }

    /// 处理远程暂停命令
    private func handleRemotePause() {
        updateStatus("收到远程暂停命令")
        if notificationPlayer != nil {
            pauseNotificationAudio()
        }
    }

    /// 处理远程播放/暂停切换命令
    private func handleRemoteTogglePlayPause() {
        guard let player = notificationPlayer else { return }

        if player.rate > 0 {
            pauseNotificationAudio()
        } else {
            playNotificationAudio()
        }
    }

    /// 处理远程进度调整命令
    private func handleRemoteSeek(to time: TimeInterval) {
        guard let player = notificationPlayer else { return }

        player.seek(to: CMTime(seconds: time, preferredTimescale: 600))
        updateNotificationTimeLabel()
        updateNowPlayingInfo()
        updateStatus("远程控制调整播放进度到 \(formatTime(time))")
    }

    // MARK: - 进度更新

    /// 启动进度定时器
    private func startProgressTimer() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    /// 更新播放进度
    private func updateProgress() {
        updateLocalProgress()
        updateNetworkProgress()
        updateNotificationProgress()
    }

    /// 更新本地音频进度
    private func updateLocalProgress() {
        guard let player = audioPlayer, player.isPlaying else { return }

        let currentTime = player.currentTime
        let duration = player.duration

        if duration > 0 {
            localProgressSlider.value = Float(currentTime / duration)
        }

        updateLocalTimeLabel()
    }

    /// 更新网络音频进度
    private func updateNetworkProgress() {
        guard let player = avPlayer else { return }

        // 检查播放项是否就绪
        guard let item = player.currentItem,
              item.status == .readyToPlay else {
            return
        }

        let duration = item.duration.seconds
        guard !duration.isNaN && duration > 0 else { return }

        let currentTime = player.currentTime().seconds
        let progress = Float(currentTime / duration)

        // 更新进度条
        networkProgressSlider.value = progress

        // 调试信息（可以在发布时移除）
        if Int(currentTime) % 2 == 0 { // 每2秒打印一次，避免日志太多
            print("网络音频进度: \(Int(currentTime))秒/\(Int(duration))秒, 进度: \(Int(progress * 100))%")
        }

        updateNetworkTimeLabel()
    }

    /// 更新通知栏音频进度
    private func updateNotificationProgress() {
        guard let player = notificationPlayer else { return }

        // 检查播放项是否就绪
        guard let item = player.currentItem,
              item.status == .readyToPlay else {
            return
        }

        let duration = item.duration.seconds
        guard !duration.isNaN && duration > 0 else { return }

        let currentTime = player.currentTime().seconds
        let progress = Float(currentTime / duration)

        // 更新进度条
        notificationProgressSlider.value = progress

        // 更新通知栏信息
        if player.rate > 0 { // 只在播放时更新
            updateNowPlayingInfo()
        }

        updateNotificationTimeLabel()
    }

    /// 更新本地时间标签
    private func updateLocalTimeLabel() {
        guard let player = audioPlayer else {
            localTimeLabel.text = "00:00 / 00:00"
            return
        }

        let currentTime = player.currentTime
        let duration = player.duration

        localTimeLabel.text = "\(formatTime(currentTime)) / \(formatTime(duration))"
    }

    /// 更新网络时间标签
    private func updateNetworkTimeLabel() {
        guard let player = avPlayer,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else {
            networkTimeLabel.text = "00:00 / 00:00"
            return
        }

        let currentTime = player.currentTime().seconds

        networkTimeLabel.text = "\(formatTime(currentTime)) / \(formatTime(duration))"
    }

    /// 更新通知栏时间标签
    private func updateNotificationTimeLabel() {
        guard let player = notificationPlayer,
              let duration = player.currentItem?.duration.seconds,
              !duration.isNaN else {
            notificationTimeLabel.text = "00:00 / 00:00"
            return
        }

        let currentTime = player.currentTime().seconds

        notificationTimeLabel.text = "\(formatTime(currentTime)) / \(formatTime(duration))"
    }

    /// 格式化时间
    /// - Parameter time: 时间（秒）
    /// - Returns: 格式化后的时间字符串
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// 停止所有音频
    private func stopAllAudio() {
        audioPlayer?.stop()
        avPlayer?.pause()
        notificationPlayer?.pause()

        // 清理KVO观察者和通知
        NotificationCenter.default.removeObserver(self)
        if let item = playerItem {
            item.removeObserver(self, forKeyPath: "status")
        }
        if let item = notificationPlayerItem {
            item.removeObserver(self, forKeyPath: "status")
        }

        progressTimer?.invalidate()
        progressTimer = nil

        avPlayer = nil
        playerItem = nil
        notificationPlayer = nil
        notificationPlayerItem = nil

        // 清除通知栏信息
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    /// 更新状态标签
    /// - Parameter text: 状态文本
    private func updateStatus(_ text: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = text
            print("AudioPlayer: \(text)")
        }
    }

    /// 更新本地音频信息
    private func updateLocalAudioInfo() {
        guard let player = audioPlayer else {
            localAudioInfoLabel.text = "本地音频：未加载"
            return
        }

        let fileName = "1.mp3"
        let duration = player.duration
        let fileSize = getLocalAudioFileSize()

        let durationText = formatTime(duration)
        let sizeText = formatFileSize(fileSize)

        localAudioInfoLabel.text = "文件：\(fileName)\n时长：\(durationText) | 大小：\(sizeText)"
    }

    /// 更新网络音频信息
    private func updateNetworkAudioInfo() {
        guard let player = avPlayer,
              let item = player.currentItem,
              item.status == .readyToPlay else {
            networkAudioInfoLabel.text = "网络音频：未加载"
            return
        }

        let fileName = "网络音频.mp3"
        let duration = item.duration.seconds
        let durationText = formatTime(duration)

        networkAudioInfoLabel.text = "文件：\(fileName)\n时长：\(durationText) | 来源：网络"
    }

    /// 更新通知栏音频信息
    private func updateNotificationAudioInfo() {
        guard let player = notificationPlayer,
              let item = player.currentItem,
              item.status == .readyToPlay else {
            notificationAudioInfoLabel.text = "通知栏音频：未加载"
            return
        }

        let fileName = "网络音频.mp3"
        let duration = item.duration.seconds
        let durationText = formatTime(duration)

        notificationAudioInfoLabel.text = "文件：\(fileName)\n时长：\(durationText) | 支持：通知栏控制"
    }

    /// 获取本地音频文件大小
    /// - Returns: 文件大小（字节）
    private func getLocalAudioFileSize() -> Int64 {
        guard let soundPath = Bundle.main.path(forResource: "1", ofType: "mp3") else {
            return 0
        }

        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: soundPath)
            return attributes[.size] as? Int64 ?? 0
        } catch {
            return 0
        }
    }

    /// 格式化文件大小
    /// - Parameter bytes: 文件大小（字节）
    /// - Returns: 格式化后的文件大小字符串
    private func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }

    // MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "status" else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        if let item = object as? AVPlayerItem {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                // 判断是哪个播放器的 item
                let isNetworkPlayer = item === self.playerItem
                let isNotificationPlayer = item === self.notificationPlayerItem

                switch item.status {
                case .readyToPlay:
                    if isNetworkPlayer {
                        self.networkStatusLabel?.text = "网络音频加载完成"
                        self.updateStatus("网络音频准备就绪，可以播放")
                        self.updateNetworkAudioInfo()
                    } else if isNotificationPlayer {
                        self.notificationStatusLabel?.text = "通知栏音频加载完成"
                        self.updateStatus("通知栏音频准备就绪，可以播放")
                        self.updateNotificationAudioInfo()
                        self.setupNowPlayingInfo()
                    }
                case .failed:
                    if let error = item.error {
                        if isNetworkPlayer {
                            self.networkStatusLabel?.text = "加载失败"
                            self.updateStatus("网络音频加载失败: \(error.localizedDescription)")
                        } else if isNotificationPlayer {
                            self.notificationStatusLabel?.text = "加载失败"
                            self.updateStatus("通知栏音频加载失败: \(error.localizedDescription)")
                        }
                    }
                case .unknown:
                    if isNetworkPlayer {
                        self.networkStatusLabel?.text = "加载中..."
                        self.updateStatus("网络音频状态未知")
                    } else if isNotificationPlayer {
                        self.notificationStatusLabel?.text = "加载中..."
                        self.updateStatus("通知栏音频状态未知")
                    }
                @unknown default:
                    break
                }
            }
        }
    }
}
