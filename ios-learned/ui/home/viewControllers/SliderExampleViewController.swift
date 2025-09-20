//
//  SliderExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// UISlider滑块控件示例页面
/// 展示UISlider的各种自定义样式和交互效果
class SliderExampleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var volumeSlider: UISlider!
    private var brightnessSlider: UISlider!
    private var customSlider: UISlider!
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
        navigationBar.configure(title: "UISlider 滑块控件") { [weak self] in
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
        titleLabel.text = "UISlider - 滑块控件"
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
        resultLabel.text = "音量: 50% | 亮度: 75% | 自定义: 25%"
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

        // 音量滑块
        let volumeLabel = UILabel()
        volumeLabel.text = "🔊 音量"
        volumeLabel.font = UIFont.systemFont(ofSize: 16)

        volumeSlider = UISlider()
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 100
        volumeSlider.value = 50
        volumeSlider.minimumTrackTintColor = UIColor.systemBlue
        volumeSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)

        view.addSubview(volumeLabel)
        view.addSubview(volumeSlider)

        volumeLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }

        volumeSlider.snp.makeConstraints { make in
            make.centerY.equalTo(volumeLabel)
            make.left.equalTo(volumeLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

        // 亮度滑块
        let brightnessLabel = UILabel()
        brightnessLabel.text = "☀️ 亮度"
        brightnessLabel.font = UIFont.systemFont(ofSize: 16)

        brightnessSlider = UISlider()
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 100
        brightnessSlider.value = 75
        brightnessSlider.minimumTrackTintColor = UIColor.systemYellow
        brightnessSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)

        view.addSubview(brightnessLabel)
        view.addSubview(brightnessSlider)

        brightnessLabel.snp.makeConstraints { make in
            make.top.equalTo(volumeSlider.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }

        brightnessSlider.snp.makeConstraints { make in
            make.centerY.equalTo(brightnessLabel)
            make.left.equalTo(brightnessLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

        // 自定义滑块
        let customLabel = UILabel()
        customLabel.text = "⚙️ 自定义"
        customLabel.font = UIFont.systemFont(ofSize: 16)

        customSlider = UISlider()
        customSlider.minimumValue = 0
        customSlider.maximumValue = 100
        customSlider.value = 25
        customSlider.minimumTrackTintColor = UIColor.themeColor
        customSlider.maximumTrackTintColor = UIColor.systemGray4
        customSlider.thumbTintColor = UIColor.themeColor
        customSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)

        // 自定义滑块图标
        customSlider.minimumValueImage = UIImage(systemName: "minus.circle")
        customSlider.maximumValueImage = UIImage(systemName: "plus.circle")

        view.addSubview(customLabel)
        view.addSubview(customSlider)

        customLabel.snp.makeConstraints { make in
            make.top.equalTo(brightnessSlider.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }

        customSlider.snp.makeConstraints { make in
            make.centerY.equalTo(customLabel)
            make.left.equalTo(customLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

        // 连续值滑块示例
        let continuousLabel = UILabel()
        continuousLabel.text = "📊 连续值"
        continuousLabel.font = UIFont.systemFont(ofSize: 16)

        let continuousSlider = UISlider()
        continuousSlider.minimumValue = 0
        continuousSlider.maximumValue = 1
        continuousSlider.value = 0.5
        continuousSlider.minimumTrackTintColor = UIColor.systemPurple
        continuousSlider.isContinuous = true
        continuousSlider.addTarget(self, action: #selector(continuousSliderChanged(_:)), for: .valueChanged)

        view.addSubview(continuousLabel)
        view.addSubview(continuousSlider)

        continuousLabel.snp.makeConstraints { make in
            make.top.equalTo(customSlider.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }

        continuousSlider.snp.makeConstraints { make in
            make.centerY.equalTo(continuousLabel)
            make.left.equalTo(continuousLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

        // 离散值滑块示例
        let discreteLabel = UILabel()
        discreteLabel.text = "🎯 离散值"
        discreteLabel.font = UIFont.systemFont(ofSize: 16)

        let discreteSlider = UISlider()
        discreteSlider.minimumValue = 1
        discreteSlider.maximumValue = 10
        discreteSlider.value = 5
        discreteSlider.minimumTrackTintColor = UIColor.systemRed
        discreteSlider.isContinuous = false
        discreteSlider.addTarget(self, action: #selector(discreteSliderChanged(_:)), for: .valueChanged)

        view.addSubview(discreteLabel)
        view.addSubview(discreteSlider)

        discreteLabel.snp.makeConstraints { make in
            make.top.equalTo(continuousSlider.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }

        discreteSlider.snp.makeConstraints { make in
            make.centerY.equalTo(discreteLabel)
            make.left.equalTo(discreteLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "UISlider支持自定义颜色、图标和范围值\n可以设置连续或离散值模式"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(discreteSlider.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }

        // 功能按钮
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("重置所有滑块", for: .normal)
        resetButton.backgroundColor = UIColor.systemGray
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetAllSliders), for: .touchUpInside)

        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    /// 滑块值改变
    @objc private func sliderValueChanged() {
        let volume = Int(volumeSlider.value)
        let brightness = Int(brightnessSlider.value)
        let custom = Int(customSlider.value)
        resultLabel.text = "音量: \(volume)% | 亮度: \(brightness)% | 自定义: \(custom)%"
    }

    /// 连续值滑块改变
    @objc private func continuousSliderChanged(_ sender: UISlider) {
        logger.info("连续值滑块: \(String(format: "%.2f", sender.value))")
    }

    /// 离散值滑块改变
    @objc private func discreteSliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = Float(roundedValue)
        logger.info("离散值滑块: \(Int(roundedValue))")
    }

    /// 重置所有滑块
    @objc private func resetAllSliders() {
        volumeSlider.value = 50
        brightnessSlider.value = 75
        customSlider.value = 25
        sliderValueChanged()

        showAlert(title: "重置完成", message: "所有滑块已重置为初始值")
    }
}