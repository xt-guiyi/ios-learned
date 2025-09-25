//
//  LifecycleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

class LifecycleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private let logTextView = UITextView()
    private let buttonStackView = UIStackView()
    private var lifecycleLog: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        logLifecycleEvent("viewDidLoad - 视图加载完成")
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logLifecycleEvent("viewWillAppear - 视图即将出现")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logLifecycleEvent("viewDidAppear - 视图已经出现")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logLifecycleEvent("viewWillDisappear - 视图即将消失")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logLifecycleEvent("viewDidDisappear - 视图已经消失")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logLifecycleEvent("viewWillLayoutSubviews - 即将布局子视图")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logLifecycleEvent("viewDidLayoutSubviews - 已经布局子视图")
    }

    deinit {
        print("LifecycleViewController - deinit 释放内存")
    }

    /// 设置UI界面
    private func setupUI() {
        setupNavigationBar()
        setupLogTextView()
        setupButtonStackView()
        setupConstraints()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "生命周期演示") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)
    }

    /// 设置日志文本视图
    private func setupLogTextView() {
        logTextView.backgroundColor = UIColor.systemGray6
        logTextView.layer.cornerRadius = 8
        logTextView.layer.borderWidth = 1
        logTextView.layer.borderColor = UIColor.systemGray4.cgColor
        logTextView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        logTextView.isEditable = false
        logTextView.text = "生命周期日志将显示在这里...\n"
        view.addSubview(logTextView)
    }

    /// 设置按钮堆栈视图
    private func setupButtonStackView() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually

        // 创建测试按钮
        let buttons = [
            ("Push新页面", #selector(pushNewViewController)),
            ("Present模态页面", #selector(presentModalViewController)),
            ("显示Alert", #selector(showAlertExample)),
            ("模拟内存警告", #selector(simulateMemoryWarning)),
            ("旋转设备(模拟)", #selector(simulateRotation)),
            ("清空日志", #selector(clearLog))
        ]

        buttons.forEach { title, action in
            let button = createButton(title: title, action: action)
            buttonStackView.addArrangedSubview(button)
        }

        view.addSubview(buttonStackView)
    }

    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        logTextView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(logTextView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    /// 创建按钮
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    /// 记录生命周期事件
    private func logLifecycleEvent(_ event: String) {
        let timestamp = DateFormatter().apply {
            $0.dateFormat = "HH:mm:ss.SSS"
        }.string(from: Date())

        let logEntry = "[\(timestamp)] \(event)"
        lifecycleLog.append(logEntry)

        DispatchQueue.main.async {
            self.updateLogDisplay()
        }

        // 同时打印到控制台
        print("LifecycleViewController - \(logEntry)")
    }

    /// 更新日志显示
    private func updateLogDisplay() {
        let logText = lifecycleLog.joined(separator: "\n") + "\n"
        logTextView.text = logText

        // 滚动到底部
        let bottom = NSMakeRange(logText.count - 1, 1)
        logTextView.scrollRangeToVisible(bottom)
    }

    // MARK: - 按钮事件处理

    /// Push新页面
    @objc private func pushNewViewController() {
        let newVc = SecondLifecycleViewController()
        newVc.parentLifecycleController = self
        navigationController?.pushViewController(newVc, animated: true)
    }

    /// Present模态页面
    @objc private func presentModalViewController() {
        let modalVc = ThirdLifecycleViewController()
        modalVc.parentLifecycleController = self
        modalVc.modalPresentationStyle = .pageSheet
        present(modalVc, animated: true)
    }

    /// 显示Alert
    @objc private func showAlertExample() {
        let alert = UIAlertController(
            title: "生命周期测试",
            message: "Alert的出现和消失不会触发视图控制器的生命周期方法",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }

    /// 模拟内存警告
    @objc private func simulateMemoryWarning() {
        logLifecycleEvent("模拟内存警告 - didReceiveMemoryWarning")
        // 在真实场景中，这会触发didReceiveMemoryWarning方法
    }

    /// 模拟设备旋转
    @objc private func simulateRotation() {
        logLifecycleEvent("模拟设备旋转 - viewWillTransition")

        // 模拟布局变化
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    /// 清空日志
    @objc private func clearLog() {
        lifecycleLog.removeAll()
        logTextView.text = "日志已清空\n"
    }

    /// 从子控制器接收生命周期事件
    func logChildLifecycleEvent(_ event: String) {
        logLifecycleEvent("子控制器: \(event)")
    }
}

// MARK: - 第二个生命周期演示页面
class SecondLifecycleViewController: BaseViewController {

    weak var parentLifecycleController: LifecycleViewController?
    private let navigationBar = CustomNavigationBar()
    private let instructionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        parentLifecycleController?.logChildLifecycleEvent("SecondVC - viewDidLoad")
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parentLifecycleController?.logChildLifecycleEvent("SecondVC - viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parentLifecycleController?.logChildLifecycleEvent("SecondVC - viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        parentLifecycleController?.logChildLifecycleEvent("SecondVC - viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        parentLifecycleController?.logChildLifecycleEvent("SecondVC - viewDidDisappear")
    }

    deinit {
        parentLifecycleController?.logChildLifecycleEvent("SecondVC - deinit")
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)

        navigationBar.configure(title: "第二个页面") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navigationBar)

        instructionLabel.text = "这是第二个页面\n\n观察生命周期日志的变化\n\n点击返回按钮或手势返回\n查看相应的生命周期方法调用"
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        view.addSubview(instructionLabel)

        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        instructionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
    }
}

// MARK: - 第三个生命周期演示页面 (模态)
class ThirdLifecycleViewController: UIViewController {

    weak var parentLifecycleController: LifecycleViewController?
    private let instructionLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        parentLifecycleController?.logChildLifecycleEvent("ThirdVC(Modal) - viewDidLoad")
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parentLifecycleController?.logChildLifecycleEvent("ThirdVC(Modal) - viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parentLifecycleController?.logChildLifecycleEvent("ThirdVC(Modal) - viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        parentLifecycleController?.logChildLifecycleEvent("ThirdVC(Modal) - viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        parentLifecycleController?.logChildLifecycleEvent("ThirdVC(Modal) - viewDidDisappear")
    }

    deinit {
        parentLifecycleController?.logChildLifecycleEvent("ThirdVC(Modal) - deinit")
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)

        instructionLabel.text = "这是一个模态页面\n\n模态页面的生命周期与Push页面略有不同\n\n观察日志中的差异"
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        view.addSubview(instructionLabel)

        closeButton.setTitle("关闭模态页面", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 8
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        view.addSubview(closeButton)

        instructionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }

        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }

    @objc private func closeModal() {
        dismiss(animated: true)
    }
}

// MARK: - 扩展DateFormatter
extension DateFormatter {
    func apply(closure: (DateFormatter) -> Void) -> DateFormatter {
        closure(self)
        return self
    }
}
