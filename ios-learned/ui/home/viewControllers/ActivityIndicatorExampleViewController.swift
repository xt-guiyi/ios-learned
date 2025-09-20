//
//  ActivityIndicatorExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// UIActivityIndicatorView活动指示器控件示例页面
/// 展示UIActivityIndicatorView的各种样式和控制方式
class ActivityIndicatorExampleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var defaultIndicator: UIActivityIndicatorView!
    private var largeIndicator: UIActivityIndicatorView!
    private var customIndicator: UIActivityIndicatorView!
    private var resultLabel: UILabel!

    private var timer: Timer?
    private var progress: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    deinit {
        timer?.invalidate()
    }

    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        setupNavigationBar()
        setupContent()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "UIActivityIndicator 活动指示器") { [weak self] in
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
        titleLabel.text = "UIActivityIndicatorView - 活动指示器"
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
        resultLabel.text = "点击按钮控制加载状态"
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

        // 默认样式指示器
        let defaultLabel = UILabel()
        defaultLabel.text = "默认样式"
        defaultLabel.font = UIFont.systemFont(ofSize: 14)
        defaultLabel.textAlignment = .center

        defaultIndicator = UIActivityIndicatorView(style: .medium)
        defaultIndicator.startAnimating()

        // 大号样式指示器
        let largeLabel = UILabel()
        largeLabel.text = "大号样式"
        largeLabel.font = UIFont.systemFont(ofSize: 14)
        largeLabel.textAlignment = .center

        largeIndicator = UIActivityIndicatorView(style: .large)
        largeIndicator.startAnimating()

        // 自定义样式指示器
        let customLabel = UILabel()
        customLabel.text = "自定义样式"
        customLabel.font = UIFont.systemFont(ofSize: 14)
        customLabel.textAlignment = .center

        customIndicator = UIActivityIndicatorView(style: .large)
        customIndicator.color = UIColor.themeColor
        customIndicator.startAnimating()

        // 指示器容器
        let indicatorStack = UIStackView(arrangedSubviews: [
            createIndicatorContainer(label: defaultLabel, indicator: defaultIndicator),
            createIndicatorContainer(label: largeLabel, indicator: largeIndicator),
            createIndicatorContainer(label: customLabel, indicator: customIndicator)
        ])
        indicatorStack.axis = .horizontal
        indicatorStack.distribution = .fillEqually
        indicatorStack.spacing = 20

        view.addSubview(indicatorStack)
        indicatorStack.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(100)
        }

        // 控制按钮
        let startButton = UIButton(type: .system)
        startButton.setTitle("开始加载", for: .normal)
        startButton.backgroundColor = UIColor.themeColor
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.addTarget(self, action: #selector(startLoading), for: .touchUpInside)

        let stopButton = UIButton(type: .system)
        stopButton.setTitle("停止加载", for: .normal)
        stopButton.backgroundColor = UIColor.systemGray
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.cornerRadius = 8
        stopButton.addTarget(self, action: #selector(stopLoading), for: .touchUpInside)

        let simulateButton = UIButton(type: .system)
        simulateButton.setTitle("模拟加载过程", for: .normal)
        simulateButton.backgroundColor = UIColor.systemBlue
        simulateButton.setTitleColor(.white, for: .normal)
        simulateButton.layer.cornerRadius = 8
        simulateButton.addTarget(self, action: #selector(simulateLoading), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [startButton, stopButton, simulateButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 15
        buttonStack.distribution = .fillEqually

        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(indicatorStack.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(120)
        }

        // 特殊效果演示
        let effectContainer = UIView()
        effectContainer.backgroundColor = UIColor.systemGray6
        effectContainer.layer.cornerRadius = 12

        let effectTitleLabel = UILabel()
        effectTitleLabel.text = "🎨 特殊效果演示"
        effectTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        effectTitleLabel.textAlignment = .center

        let rainbowIndicator = UIActivityIndicatorView(style: .large)
        rainbowIndicator.startAnimating()

        let animateColorButton = UIButton(type: .system)
        animateColorButton.setTitle("彩虹动画", for: .normal)
        animateColorButton.backgroundColor = UIColor.systemPurple
        animateColorButton.setTitleColor(.white, for: .normal)
        animateColorButton.layer.cornerRadius = 6
        animateColorButton.addTarget(self, action: #selector(animateRainbowColors), for: .touchUpInside)

        effectContainer.addSubview(effectTitleLabel)
        effectContainer.addSubview(rainbowIndicator)
        effectContainer.addSubview(animateColorButton)

        view.addSubview(effectContainer)

        effectContainer.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }

        effectTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }

        rainbowIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        animateColorButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "UIActivityIndicatorView用于显示加载状态\n支持不同样式和自定义颜色，可以通过编程控制启停"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(effectContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    /// 创建指示器容器
    /// - Parameters:
    ///   - label: 标签
    ///   - indicator: 指示器
    /// - Returns: 容器视图
    private func createIndicatorContainer(label: UILabel, indicator: UIActivityIndicatorView) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12

        container.addSubview(indicator)
        container.addSubview(label)

        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.left.right.equalToSuperview().inset(5)
        }

        return container
    }

    /// 开始加载
    @objc private func startLoading() {
        [defaultIndicator, largeIndicator, customIndicator].forEach { $0?.startAnimating() }
        resultLabel.text = "正在加载中..."
        logger.info("活动指示器开始动画")
    }

    /// 停止加载
    @objc private func stopLoading() {
        [defaultIndicator, largeIndicator, customIndicator].forEach { $0?.stopAnimating() }
        resultLabel.text = "加载已停止"
        timer?.invalidate()
        timer = nil
        progress = 0
        logger.info("活动指示器停止动画")
    }

    /// 模拟加载过程
    @objc private func simulateLoading() {
        progress = 0
        startLoading()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.progress += 0.02
            let percentage = Int(self.progress * 100)
            self.resultLabel.text = "加载进度: \(percentage)%"

            if self.progress >= 1.0 {
                self.timer?.invalidate()
                self.timer = nil
                self.stopLoading()
                self.resultLabel.text = "加载完成! ✅"
                self.logger.info("模拟加载过程完成")
            }
        }
    }

    /// 彩虹颜色动画
    @objc private func animateRainbowColors() {
        let colors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple]
        var colorIndex = 0

        let colorTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            self.customIndicator.color = colors[colorIndex]
            colorIndex = (colorIndex + 1) % colors.count

            // 动画5秒后停止
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                timer.invalidate()
                self.customIndicator.color = UIColor.themeColor
            }
        }

        // 确保timer在主线程运行
        RunLoop.main.add(colorTimer, forMode: .common)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
}