//
//  PickerViewExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// UIPickerView选择器控件示例页面
/// 展示UIPickerView的多种使用方式：底部弹出、ActionSheet样式、嵌入式等
class PickerViewExampleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var resultLabel: UILabel!
    private var showPickerButton: UIButton!
    private var showActionSheetButton: UIButton!

    private let fruits = ["苹果", "香蕉", "橙子", "葡萄", "草莓", "西瓜", "芒果", "菠萝"]
    private let colors = ["红色", "蓝色", "绿色", "黄色", "紫色", "橙色", "粉色", "黑色"]

    private var selectedFruit = "苹果"
    private var selectedColor = "红色"

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
        navigationBar.configure(title: "UIPickerView 选择器") { [weak self] in
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
        titleLabel.text = "UIPickerView - 选择器控件"
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
        resultLabel.text = "选择: \(selectedFruit) - \(selectedColor)"
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

        // 底部弹出按钮
        showPickerButton = UIButton(type: .system)
        showPickerButton.setTitle("🍎 底部弹出选择器", for: .normal)
        showPickerButton.backgroundColor = UIColor.themeColor
        showPickerButton.setTitleColor(.white, for: .normal)
        showPickerButton.layer.cornerRadius = 12
        showPickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showPickerButton.addTarget(self, action: #selector(showBottomPicker), for: .touchUpInside)

        view.addSubview(showPickerButton)
        showPickerButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // ActionSheet样式按钮
        showActionSheetButton = UIButton(type: .system)
        showActionSheetButton.setTitle("📋 ActionSheet样式选择", for: .normal)
        showActionSheetButton.backgroundColor = UIColor.systemBlue
        showActionSheetButton.setTitleColor(.white, for: .normal)
        showActionSheetButton.layer.cornerRadius = 12
        showActionSheetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showActionSheetButton.addTarget(self, action: #selector(showActionSheetPicker), for: .touchUpInside)

        view.addSubview(showActionSheetButton)
        showActionSheetButton.snp.makeConstraints { make in
            make.top.equalTo(showPickerButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // 嵌入式PickerView
        let embeddedPickerView = UIPickerView()
        embeddedPickerView.delegate = self
        embeddedPickerView.dataSource = self
        embeddedPickerView.backgroundColor = UIColor.systemGray6
        embeddedPickerView.layer.cornerRadius = 12

        view.addSubview(embeddedPickerView)
        embeddedPickerView.snp.makeConstraints { make in
            make.top.equalTo(showActionSheetButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "支持底部弹出和嵌入页面两种模式\n上方按钮弹出选择器，下方为嵌入式选择器"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(embeddedPickerView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    /// 显示底部弹出选择器
    @objc private func showBottomPicker() {
        let bottomSheet = BottomPickerViewController()
        bottomSheet.fruits = fruits
        bottomSheet.colors = colors
        bottomSheet.selectedFruit = selectedFruit
        bottomSheet.selectedColor = selectedColor
        bottomSheet.onSelectionComplete = { [weak self] fruit, color in
            self?.selectedFruit = fruit
            self?.selectedColor = color
            self?.updateResultLabel()
        }

        bottomSheet.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        present(bottomSheet, animated: true)
    }

    /// 显示ActionSheet样式选择器
    @objc private func showActionSheetPicker() {
        let alert = UIAlertController(title: "选择水果", message: nil, preferredStyle: .actionSheet)

        for fruit in fruits {
            alert.addAction(UIAlertAction(title: fruit, style: .default) { [weak self] _ in
                self?.selectedFruit = fruit
                self?.showColorActionSheet()
            })
        }

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        // iPad适配
        if let popover = alert.popoverPresentationController {
            popover.sourceView = showActionSheetButton
            popover.sourceRect = showActionSheetButton.bounds
        }

        present(alert, animated: true)
    }

    /// 显示颜色选择ActionSheet
    private func showColorActionSheet() {
        let alert = UIAlertController(title: "选择颜色", message: nil, preferredStyle: .actionSheet)

        for color in colors {
            alert.addAction(UIAlertAction(title: color, style: .default) { [weak self] _ in
                self?.selectedColor = color
                self?.updateResultLabel()
            })
        }

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        // iPad适配
        if let popover = alert.popoverPresentationController {
            popover.sourceView = showActionSheetButton
            popover.sourceRect = showActionSheetButton.bounds
        }

        present(alert, animated: true)
    }

    /// 更新结果显示
    private func updateResultLabel() {
        resultLabel.text = "选择: \(selectedFruit) - \(selectedColor)"
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension PickerViewExampleViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? fruits.count : colors.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? fruits[row] : colors[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFruit = fruits[pickerView.selectedRow(inComponent: 0)]
        selectedColor = colors[pickerView.selectedRow(inComponent: 1)]
        updateResultLabel()
    }
}

// MARK: - 底部弹出选择器
class BottomPickerViewController: UIViewController {

    var fruits: [String] = []
    var colors: [String] = []
    var selectedFruit: String = ""
    var selectedColor: String = ""
    var onSelectionComplete: ((String, String) -> Void)?

    private var pickerView: UIPickerView!
    private var confirmButton: UIButton!
    private var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground

        // 创建标题栏容器
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(54)
        }

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "请选择"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 取消按钮
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        headerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }

        // 确认按钮
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        headerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }

        // 分隔线
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.systemGray4

        view.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }

        // PickerView
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        // 设置初始选择
        DispatchQueue.main.async {
            if let fruitIndex = self.fruits.firstIndex(of: self.selectedFruit) {
                self.pickerView.selectRow(fruitIndex, inComponent: 0, animated: false)
            }
            if let colorIndex = self.colors.firstIndex(of: self.selectedColor) {
                self.pickerView.selectRow(colorIndex, inComponent: 1, animated: false)
            }
        }
    }

    /// 取消按钮点击
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    /// 确认按钮点击
    @objc private func confirmTapped() {
        let fruitIndex = pickerView.selectedRow(inComponent: 0)
        let colorIndex = pickerView.selectedRow(inComponent: 1)
        let selectedFruit = fruits[fruitIndex]
        let selectedColor = colors[colorIndex]

        onSelectionComplete?(selectedFruit, selectedColor)
        dismiss(animated: true)
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource for BottomPickerViewController
extension BottomPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? fruits.count : colors.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? fruits[row] : colors[row]
    }
}