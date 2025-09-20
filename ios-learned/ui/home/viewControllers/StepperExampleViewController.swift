//
//  StepperExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// UIStepper步进器控件示例页面
/// 展示UIStepper的各种配置和使用场景
class StepperExampleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var quantityStepper: UIStepper!
    private var speedStepper: UIStepper!
    private var customStepper: UIStepper!
    private var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置UI界面
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        setupNavigationBar()
        setupContent()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "UIStepper 步进器") { [weak self] in
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
        titleLabel.text = "UIStepper - 步进器控件"
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
        resultLabel.text = "数量: 1 | 速度: 1.0x | 自定义: 50"
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

        // 数量步进器
        let quantityContainer = createStepperContainer(
            emoji: "📦",
            title: "商品数量",
            description: "整数步进，范围 1-99"
        )

        quantityStepper = UIStepper()
        quantityStepper.minimumValue = 1
        quantityStepper.maximumValue = 99
        quantityStepper.stepValue = 1
        quantityStepper.value = 1
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)

        view.addSubview(quantityContainer)
        quantityContainer.addSubview(quantityStepper)

        quantityContainer.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }

        quantityStepper.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        // 播放速度步进器
        let speedContainer = createStepperContainer(
            emoji: "🎵",
            title: "播放速度",
            description: "小数步进，范围 0.5x-3.0x"
        )

        speedStepper = UIStepper()
        speedStepper.minimumValue = 0.5
        speedStepper.maximumValue = 3.0
        speedStepper.stepValue = 0.25
        speedStepper.value = 1.0
        speedStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)

        view.addSubview(speedContainer)
        speedContainer.addSubview(speedStepper)

        speedContainer.snp.makeConstraints { make in
            make.top.equalTo(quantityContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }

        speedStepper.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        // 自定义步进器
        let customContainer = createStepperContainer(
            emoji: "⚙️",
            title: "自定义值",
            description: "循环模式，步长为5，支持长按"
        )

        customStepper = UIStepper()
        customStepper.minimumValue = 0
        customStepper.maximumValue = 100
        customStepper.stepValue = 5
        customStepper.value = 50
        customStepper.wraps = true  // 循环模式
        customStepper.autorepeat = true  // 长按连续变化
        customStepper.tintColor = UIColor.themeColor
        customStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)

        view.addSubview(customContainer)
        customContainer.addSubview(customStepper)

        customContainer.snp.makeConstraints { make in
            make.top.equalTo(speedContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }

        customStepper.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        // 特殊功能演示
        let demoContainer = UIView()
        demoContainer.backgroundColor = UIColor.systemGray6
        demoContainer.layer.cornerRadius = 12

        let demoTitleLabel = UILabel()
        demoTitleLabel.text = "🎯 特殊功能演示"
        demoTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        let demoDescLabel = UILabel()
        demoDescLabel.text = "禁用状态和动画效果"
        demoDescLabel.font = UIFont.systemFont(ofSize: 14)
        demoDescLabel.textColor = UIColor.systemGray

        let disabledStepper = UIStepper()
        disabledStepper.isEnabled = false
        disabledStepper.value = 10

        demoContainer.addSubview(demoTitleLabel)
        demoContainer.addSubview(demoDescLabel)
        demoContainer.addSubview(disabledStepper)

        view.addSubview(demoContainer)

        demoContainer.snp.makeConstraints { make in
            make.top.equalTo(customContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }

        demoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
        }

        demoDescLabel.snp.makeConstraints { make in
            make.top.equalTo(demoTitleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
        }

        disabledStepper.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        // 功能按钮
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 15

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("重置所有", for: .normal)
        resetButton.backgroundColor = UIColor.systemGray
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetAllSteppers), for: .touchUpInside)

        let animateButton = UIButton(type: .system)
        animateButton.setTitle("动画演示", for: .normal)
        animateButton.backgroundColor = UIColor.themeColor
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.layer.cornerRadius = 8
        animateButton.addTarget(self, action: #selector(animateSteppers), for: .touchUpInside)

        buttonStack.addArrangedSubview(resetButton)
        buttonStack.addArrangedSubview(animateButton)

        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(demoContainer.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "UIStepper支持自定义步长、范围、循环模式和长按连续变化\n可以通过tintColor自定义颜色主题"
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

    /// 创建步进器容器
    /// - Parameters:
    ///   - emoji: 图标
    ///   - title: 标题
    ///   - description: 描述
    /// - Returns: 容器视图
    private func createStepperContainer(emoji: String, title: String, description: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = "\(emoji) \(title)"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray

        container.addSubview(titleLabel)
        container.addSubview(descLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
        }

        return container
    }

    /// 步进器值改变
    @objc private func stepperValueChanged() {
        let quantity = Int(quantityStepper.value)
        let speed = speedStepper.value
        let custom = Int(customStepper.value)
        resultLabel.text = "数量: \(quantity) | 速度: \(String(format: "%.2f", speed))x | 自定义: \(custom)"
    }

    /// 重置所有步进器
    @objc private func resetAllSteppers() {
        quantityStepper.value = 1
        speedStepper.value = 1.0
        customStepper.value = 50
        stepperValueChanged()

        showAlert(title: "重置完成", message: "所有步进器已重置为初始值")
    }

    /// 动画演示步进器变化
    @objc private func animateSteppers() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.duration = 0.2
        animation.autoreverses = true

        [quantityStepper, speedStepper, customStepper].forEach { stepper in
            stepper?.layer.add(animation, forKey: "scaleAnimation")
        }

        // 同时改变值
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.quantityStepper.value += 1
            self.speedStepper.value += 0.25
            self.customStepper.value += 5
            self.stepperValueChanged()
        }
    }
}