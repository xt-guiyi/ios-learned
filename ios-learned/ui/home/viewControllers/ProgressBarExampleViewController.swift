//
//  ProgressBarExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class ProgressBarExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 滚动容器
    private let scrollView = UIScrollView()
    
    /// 内容容器
    private let contentView = UIView()
    
    /// 系统进度条
    private let systemProgressView = UIProgressView(progressViewStyle: .default)
    private let systemProgressLabel = UILabel()
    
    /// 自定义线性进度条
    private let customLinearProgressView = CustomLinearProgressView()
    private let customLinearLabel = UILabel()
    
    /// 圆形进度条
    private let circularProgressView = CircularProgressView()
    private let circularProgressLabel = UILabel()
    
    /// 环形进度条
    private let ringProgressView = RingProgressView()
    private let ringProgressLabel = UILabel()
    
    /// 渐变进度条
    private let gradientProgressView = GradientProgressView()
    private let gradientProgressLabel = UILabel()
    
    /// 分段进度条
    private let segmentedProgressView = SegmentedProgressView()
    private let segmentedProgressLabel = UILabel()
    
    /// 控制按钮
    private let startButton = UIButton(type: .system)
    private let pauseButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let randomButton = UIButton(type: .system)
    
    /// 定时器
    private var timer: Timer?
    private var currentProgress: Float = 0.0
    private var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    /// 设置用户界面
    private func setupUI() {
        setupNavigationBar()
        setupScrollView()
        setupProgressViews()
        setupControlButtons()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "进度条控件") {
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    /// 设置进度条视图
    private func setupProgressViews() {
        // 系统进度条
        systemProgressView.progressTintColor = UIColor.themeColor
        systemProgressView.trackTintColor = UIColor.systemGray5
        systemProgressView.layer.cornerRadius = 2
        systemProgressView.clipsToBounds = true
        contentView.addSubview(systemProgressView)
        
        systemProgressLabel.text = "系统进度条 - 0%"
        systemProgressLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        systemProgressLabel.textColor = .label
        contentView.addSubview(systemProgressLabel)
        
        // 自定义线性进度条
        customLinearProgressView.backgroundColor = .clear
        contentView.addSubview(customLinearProgressView)
        
        customLinearLabel.text = "自定义线性进度条 - 0%"
        customLinearLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        customLinearLabel.textColor = .label
        contentView.addSubview(customLinearLabel)
        
        // 圆形进度条
        circularProgressView.backgroundColor = .clear
        contentView.addSubview(circularProgressView)
        
        circularProgressLabel.text = "圆形进度条 - 0%"
        circularProgressLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        circularProgressLabel.textColor = .label
        circularProgressLabel.textAlignment = .center
        contentView.addSubview(circularProgressLabel)
        
        // 环形进度条
        ringProgressView.backgroundColor = .clear
        contentView.addSubview(ringProgressView)
        
        ringProgressLabel.text = "环形进度条 - 0%"
        ringProgressLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        ringProgressLabel.textColor = .label
        ringProgressLabel.textAlignment = .center
        contentView.addSubview(ringProgressLabel)
        
        // 渐变进度条
        gradientProgressView.backgroundColor = .clear
        contentView.addSubview(gradientProgressView)
        
        gradientProgressLabel.text = "渐变进度条 - 0%"
        gradientProgressLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        gradientProgressLabel.textColor = .label
        contentView.addSubview(gradientProgressLabel)
        
        // 分段进度条
        segmentedProgressView.backgroundColor = .clear
        segmentedProgressView.segmentCount = 5
        contentView.addSubview(segmentedProgressView)
        
        segmentedProgressLabel.text = "分段进度条 - 0%"
        segmentedProgressLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        segmentedProgressLabel.textColor = .label
        contentView.addSubview(segmentedProgressLabel)
    }
    
    /// 设置控制按钮
    private func setupControlButtons() {
        let buttons = [startButton, pauseButton, resetButton, randomButton]
        let titles = ["开始", "暂停", "重置", "随机"]
        let colors: [UIColor] = [.systemGreen, .systemOrange, .systemRed, .systemBlue]
        
        for (index, button) in buttons.enumerated() {
            button.setTitle(titles[index], for: .normal)
            button.backgroundColor = colors[index]
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = 8
            contentView.addSubview(button)
        }
    }
    
    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 系统进度条
        systemProgressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        systemProgressView.snp.makeConstraints { make in
            make.top.equalTo(systemProgressLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(8)
        }
        
        // 自定义线性进度条
        customLinearLabel.snp.makeConstraints { make in
            make.top.equalTo(systemProgressView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        customLinearProgressView.snp.makeConstraints { make in
            make.top.equalTo(customLinearLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(12)
        }
        
        // 圆形进度条
        circularProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(customLinearProgressView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        circularProgressView.snp.makeConstraints { make in
            make.top.equalTo(circularProgressLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        // 环形进度条
        ringProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(circularProgressView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        ringProgressView.snp.makeConstraints { make in
            make.top.equalTo(ringProgressLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        // 渐变进度条
        gradientProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(ringProgressView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        gradientProgressView.snp.makeConstraints { make in
            make.top.equalTo(gradientProgressLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(16)
        }
        
        // 分段进度条
        segmentedProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(gradientProgressView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        segmentedProgressView.snp.makeConstraints { make in
            make.top.equalTo(segmentedProgressLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(12)
        }
        
        // 控制按钮
        let buttonStackView = UIStackView(arrangedSubviews: [startButton, pauseButton, resetButton, randomButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        contentView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentedProgressView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    /// 设置按钮事件
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetAnimation), for: .touchUpInside)
        randomButton.addTarget(self, action: #selector(setRandomProgress), for: .touchUpInside)
    }
    
    /// 开始动画
    @objc private func startAnimation() {
        guard !isAnimating else { return }
        
        isAnimating = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.currentProgress += 0.01
            
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.pauseAnimation()
            }
            
            self.updateProgress(self.currentProgress)
        }
    }
    
    /// 暂停动画
    @objc private func pauseAnimation() {
        isAnimating = false
        timer?.invalidate()
        timer = nil
    }
    
    /// 重置动画
    @objc private func resetAnimation() {
        pauseAnimation()
        currentProgress = 0.0
        updateProgress(currentProgress)
    }
    
    /// 设置随机进度
    @objc private func setRandomProgress() {
        pauseAnimation()
        currentProgress = Float.random(in: 0...1)
        updateProgress(currentProgress)
    }
    
    /// 更新所有进度条
    private func updateProgress(_ progress: Float) {
        let percentage = Int(progress * 100)
        
        // 系统进度条
        systemProgressView.setProgress(progress, animated: true)
        systemProgressLabel.text = "系统进度条 - \(percentage)%"
        
        // 自定义线性进度条
        customLinearProgressView.progress = progress
        customLinearLabel.text = "自定义线性进度条 - \(percentage)%"
        
        // 圆形进度条
        circularProgressView.progress = progress
        circularProgressLabel.text = "圆形进度条 - \(percentage)%"
        
        // 环形进度条
        ringProgressView.progress = progress
        ringProgressLabel.text = "环形进度条 - \(percentage)%"
        
        // 渐变进度条
        gradientProgressView.progress = progress
        gradientProgressLabel.text = "渐变进度条 - \(percentage)%"
        
        // 分段进度条
        segmentedProgressView.progress = progress
        segmentedProgressLabel.text = "分段进度条 - \(percentage)%"
    }
}

// MARK: - 自定义线性进度条
class CustomLinearProgressView: UIView {
    
    var progress: Float = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 背景
        context.setFillColor(UIColor.systemGray5.cgColor)
        context.fill(rect)
        
        // 进度
        let progressWidth = rect.width * CGFloat(progress)
        let progressRect = CGRect(x: 0, y: 0, width: progressWidth, height: rect.height)
        context.setFillColor(UIColor.themeColor.cgColor)
        context.fill(progressRect)
        
        // 圆角
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
}

// MARK: - 圆形进度条
class CircularProgressView: UIView {
    
    var progress: Float = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 10
        let lineWidth: CGFloat = 8
        
        // 背景圆环
        context.setStrokeColor(UIColor.systemGray5.cgColor)
        context.setLineWidth(lineWidth)
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context.strokePath()
        
        // 进度圆弧
        let progressAngle = 2 * .pi * CGFloat(progress)
        context.setStrokeColor(UIColor.themeColor.cgColor)
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.addArc(center: center, radius: radius, startAngle: -.pi/2, endAngle: -.pi/2 + progressAngle, clockwise: false)
        context.strokePath()
        
        // 进度文字
        let percentageText = "\(Int(progress * 100))%"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label
        ]
        let textSize = percentageText.size(withAttributes: attributes)
        let textRect = CGRect(
            x: center.x - textSize.width / 2,
            y: center.y - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )
        percentageText.draw(in: textRect, withAttributes: attributes)
    }
}

// MARK: - 环形进度条
class RingProgressView: UIView {
    
    var progress: Float = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2 - 5
        let innerRadius = outerRadius - 20
        
        // 背景环
        let backgroundPath = UIBezierPath()
        backgroundPath.addArc(withCenter: center, radius: outerRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        backgroundPath.addArc(withCenter: center, radius: innerRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        backgroundPath.usesEvenOddFillRule = true
        
        context.setFillColor(UIColor.systemGray5.cgColor)
        backgroundPath.fill()
        
        // 进度环
        if progress > 0 {
            let progressAngle = 2 * .pi * CGFloat(progress)
            let progressPath = UIBezierPath()
            progressPath.move(to: CGPoint(x: center.x, y: center.y - outerRadius))
            progressPath.addArc(withCenter: center, radius: outerRadius, startAngle: -.pi/2, endAngle: -.pi/2 + progressAngle, clockwise: true)
            progressPath.addLine(to: CGPoint(
                x: center.x + innerRadius * cos(-.pi/2 + progressAngle),
                y: center.y + innerRadius * sin(-.pi/2 + progressAngle)
            ))
            progressPath.addArc(withCenter: center, radius: innerRadius, startAngle: -.pi/2 + progressAngle, endAngle: -.pi/2, clockwise: false)
            progressPath.close()
            
            context.setFillColor(UIColor.themeColor.cgColor)
            progressPath.fill()
        }
        
        // 中心文字
        let percentageText = "\(Int(progress * 100))%"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        let textSize = percentageText.size(withAttributes: attributes)
        let textRect = CGRect(
            x: center.x - textSize.width / 2,
            y: center.y - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )
        percentageText.draw(in: textRect, withAttributes: attributes)
    }
}

// MARK: - 渐变进度条
class GradientProgressView: UIView {
    
    var progress: Float = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 背景
        context.setFillColor(UIColor.systemGray5.cgColor)
        context.fill(rect)
        
        // 渐变进度
        if progress > 0 {
            let progressWidth = rect.width * CGFloat(progress)
            let progressRect = CGRect(x: 0, y: 0, width: progressWidth, height: rect.height)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [
                UIColor.systemBlue.cgColor,
                UIColor.systemGreen.cgColor,
                UIColor.themeColor.cgColor
            ]
            let locations: [CGFloat] = [0.0, 0.5, 1.0]
            
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) {
                context.saveGState()
                context.clip(to: progressRect)
                context.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: progressRect.width, y: 0),
                    options: []
                )
                context.restoreGState()
            }
        }
        
        // 圆角
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
}

// MARK: - 分段进度条
class SegmentedProgressView: UIView {
    
    var progress: Float = 0.0 {
        didSet {
            progress = max(0.0, min(1.0, progress))
            setNeedsDisplay()
        }
    }
    
    var segmentCount: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard segmentCount > 0 else { return }
        
        let segmentSpacing: CGFloat = 4
        let totalSpacing = CGFloat(segmentCount - 1) * segmentSpacing
        let segmentWidth = (rect.width - totalSpacing) / CGFloat(segmentCount)
        let completedSegments = Int(progress * Float(segmentCount))
        let partialProgress = (progress * Float(segmentCount)) - Float(completedSegments)
        
        for i in 0..<segmentCount {
            let x = CGFloat(i) * (segmentWidth + segmentSpacing)
            let segmentRect = CGRect(x: x, y: 0, width: segmentWidth, height: rect.height)
            
            if i < completedSegments {
                // 完整的分段
                context.setFillColor(UIColor.themeColor.cgColor)
                context.fill(segmentRect)
            } else if i == completedSegments && partialProgress > 0 {
                // 部分完成的分段
                let partialWidth = segmentWidth * CGFloat(partialProgress)
                let partialRect = CGRect(x: x, y: 0, width: partialWidth, height: rect.height)
                context.setFillColor(UIColor.themeColor.cgColor)
                context.fill(partialRect)
                
                // 剩余部分
                let remainingRect = CGRect(x: x + partialWidth, y: 0, width: segmentWidth - partialWidth, height: rect.height)
                context.setFillColor(UIColor.systemGray5.cgColor)
                context.fill(remainingRect)
            } else {
                // 未完成的分段
                context.setFillColor(UIColor.systemGray5.cgColor)
                context.fill(segmentRect)
            }
        }
        
        // 圆角
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
}
