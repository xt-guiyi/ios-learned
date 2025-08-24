//
//  CustomLoadingDialog.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// 自定义加载弹窗
class CustomLoadingDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    
    /// 初始化加载弹窗
    /// - Parameter message: 加载消息
    init(message: String) {
        super.init(frame: .zero)
        setupUI()
        configure(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupActivityIndicator()
        setupMessageLabel()
        setupConstraints()
    }
    
    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundView.alpha = 0
        addSubview(backgroundView)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 6
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        containerView.alpha = 0
        
        addSubview(containerView)
    }
    
    /// 设置活动指示器
    private func setupActivityIndicator() {
        activityIndicator.color = UIColor.themeColor
        activityIndicator.hidesWhenStopped = false
        containerView.addSubview(activityIndicator)
    }
    
    /// 设置消息标签
    private func setupMessageLabel() {
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .label
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
    }
    
    /// 设置约束
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(120)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    /// 配置弹窗内容
    private func configure(message: String) {
        messageLabel.text = message
    }
    
    /// 显示弹窗
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        activityIndicator.stopAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

/// 自定义进度弹窗
class CustomProgressDialog: UIView {
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let percentLabel = UILabel()
    
    /// 初始化进度弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    init(title: String, message: String) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置UI界面
    private func setupUI() {
        setupBackgroundView()
        setupContainerView()
        setupLabels()
        setupProgressView()
        setupConstraints()
    }
    
    /// 设置背景视图
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundView.alpha = 0
        addSubview(backgroundView)
    }
    
    /// 设置容器视图
    private func setupContainerView() {
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 6
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        containerView.alpha = 0
        
        addSubview(containerView)
    }
    
    /// 设置标签
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        percentLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        percentLabel.textColor = .label
        percentLabel.textAlignment = .center
        percentLabel.text = "0%"
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(percentLabel)
    }
    
    /// 设置进度条
    private func setupProgressView() {
        progressView.progressTintColor = UIColor.themeColor
        progressView.trackTintColor = UIColor.systemGray5
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.progress = 0
        
        containerView.addSubview(progressView)
    }
    
    /// 设置约束
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(280)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(4)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 配置弹窗内容
    private func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
    
    /// 更新进度
    /// - Parameter progress: 进度值 (0.0-1.0)
    func updateProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
            self.percentLabel.text = "\(Int(progress * 100))%"
        }
    }
    
    /// 显示弹窗
    func show(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.backgroundView.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 关闭弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 0
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}