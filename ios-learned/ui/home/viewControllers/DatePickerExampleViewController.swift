//
//  DatePickerExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//

import UIKit
import SnapKit

/// UIDatePicker日期选择器控件示例页面
/// 展示UIDatePicker的多种使用方式：底部弹出、紧凑样式、自定义Alert等
class DatePickerExampleViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var resultLabel: UILabel!
    private var showDatePickerButton: UIButton!
    private var showCompactPickerButton: UIButton!
    private var showSystemPickerButton: UIButton!

    private var selectedDate = Date()
    private var currentMode = UIDatePicker.Mode.dateAndTime

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
        navigationBar.configure(title: "UIDatePicker 日期选择器") { [weak self] in
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
        titleLabel.text = "UIDatePicker - 日期选择器"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }

        // 模式选择
        let modeSegmentControl = UISegmentedControl(items: ["日期时间", "日期", "时间", "倒计时"])
        modeSegmentControl.selectedSegmentIndex = 0
        modeSegmentControl.addTarget(self, action: #selector(modeChanged(_:)), for: .valueChanged)

        view.addSubview(modeSegmentControl)
        modeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }

        // 结果显示
        resultLabel = UILabel()
        resultLabel.text = "当前选择: \(DateFormatter.localizedString(from: selectedDate, dateStyle: .medium, timeStyle: .short))"
        resultLabel.font = UIFont.systemFont(ofSize: 16)
        resultLabel.textAlignment = .center
        resultLabel.backgroundColor = UIColor.themeColor.withAlphaComponent(0.1)
        resultLabel.layer.cornerRadius = 8
        resultLabel.layer.masksToBounds = true
        resultLabel.numberOfLines = 0

        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(modeSegmentControl.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        // 底部弹出日期选择器按钮
        showDatePickerButton = UIButton(type: .system)
        showDatePickerButton.setTitle("📅 底部弹出日期选择器", for: .normal)
        showDatePickerButton.backgroundColor = UIColor.themeColor
        showDatePickerButton.setTitleColor(.white, for: .normal)
        showDatePickerButton.layer.cornerRadius = 12
        showDatePickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showDatePickerButton.addTarget(self, action: #selector(showBottomDatePicker), for: .touchUpInside)

        view.addSubview(showDatePickerButton)
        showDatePickerButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // 紧凑样式按钮
        showCompactPickerButton = UIButton(type: .system)
        showCompactPickerButton.setTitle("📱 紧凑样式日期选择器", for: .normal)
        showCompactPickerButton.backgroundColor = UIColor.systemBlue
        showCompactPickerButton.setTitleColor(.white, for: .normal)
        showCompactPickerButton.layer.cornerRadius = 12
        showCompactPickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showCompactPickerButton.addTarget(self, action: #selector(showCompactDatePicker), for: .touchUpInside)

        view.addSubview(showCompactPickerButton)
        showCompactPickerButton.snp.makeConstraints { make in
            make.top.equalTo(showDatePickerButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // 系统样式按钮
        showSystemPickerButton = UIButton(type: .system)
        showSystemPickerButton.setTitle("⚙️ 系统样式日期选择器", for: .normal)
        showSystemPickerButton.backgroundColor = UIColor.systemOrange
        showSystemPickerButton.setTitleColor(.white, for: .normal)
        showSystemPickerButton.layer.cornerRadius = 12
        showSystemPickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showSystemPickerButton.addTarget(self, action: #selector(showSystemDatePicker), for: .touchUpInside)

        view.addSubview(showSystemPickerButton)
        showSystemPickerButton.snp.makeConstraints { make in
            make.top.equalTo(showCompactPickerButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        // 嵌入式DatePicker
        let embeddedDatePicker = UIDatePicker()
        embeddedDatePicker.datePickerMode = .dateAndTime
        embeddedDatePicker.preferredDatePickerStyle = .wheels
        embeddedDatePicker.date = selectedDate
        embeddedDatePicker.backgroundColor = UIColor.systemGray6
        embeddedDatePicker.layer.cornerRadius = 12
        embeddedDatePicker.addTarget(self, action: #selector(embeddedDateChanged(_:)), for: .valueChanged)

        view.addSubview(embeddedDatePicker)
        embeddedDatePicker.snp.makeConstraints { make in
            make.top.equalTo(showSystemPickerButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "支持弹出和嵌入两种模式\n上方按钮弹出选择器，下方为嵌入式选择器"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(embeddedDatePicker.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    /// 模式改变
    @objc private func modeChanged(_ sender: UISegmentedControl) {
        let modes: [UIDatePicker.Mode] = [.dateAndTime, .date, .time, .countDownTimer]
        currentMode = modes[sender.selectedSegmentIndex]
        updateResultLabel()
    }

    /// 显示底部日期选择器
    @objc private func showBottomDatePicker() {
        let bottomSheet = BottomDatePickerViewController()
        bottomSheet.selectedDate = selectedDate
        bottomSheet.datePickerMode = currentMode
        bottomSheet.onDateSelected = { [weak self] date in
            self?.selectedDate = date
            self?.updateResultLabel()
        }

        bottomSheet.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        present(bottomSheet, animated: true)
    }

    /// 显示紧凑样式日期选择器
    @objc private func showCompactDatePicker() {
        let compactSheet = CompactDatePickerViewController()
        compactSheet.selectedDate = selectedDate
        compactSheet.datePickerMode = currentMode
        compactSheet.onDateSelected = { [weak self] date in
            self?.selectedDate = date
            self?.updateResultLabel()
        }

        compactSheet.modalPresentationStyle = .pageSheet
        if let sheet = compactSheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        present(compactSheet, animated: true)
    }

    /// 显示系统样式日期选择器
    @objc private func showSystemDatePicker() {
        let customAlert = CustomAlertDatePickerViewController()
        customAlert.selectedDate = selectedDate
        customAlert.datePickerMode = currentMode
        customAlert.onDateSelected = { [weak self] date in
            self?.selectedDate = date
            self?.updateResultLabel()
        }

        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
    }

    /// 嵌入式DatePicker值改变
    @objc private func embeddedDateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateResultLabel()
    }

    /// 更新结果显示
    private func updateResultLabel() {
        switch currentMode {
        case .dateAndTime:
            resultLabel.text = "选择时间: \(DateFormatter.localizedString(from: selectedDate, dateStyle: .medium, timeStyle: .short))"
        case .date:
            resultLabel.text = "选择日期: \(DateFormatter.localizedString(from: selectedDate, dateStyle: .long, timeStyle: .none))"
        case .time:
            resultLabel.text = "选择时间: \(DateFormatter.localizedString(from: selectedDate, dateStyle: .none, timeStyle: .short))"
        case .countDownTimer:
            let duration = selectedDate.timeIntervalSince1970
            let hours = Int(duration) / 3600
            let minutes = Int(duration) % 3600 / 60
            resultLabel.text = "倒计时: \(hours)小时 \(minutes)分钟"
        @unknown default:
            break
        }
    }
}

// MARK: - 底部弹出日期选择器
class BottomDatePickerViewController: UIViewController {

    var selectedDate = Date()
    var datePickerMode = UIDatePicker.Mode.dateAndTime
    var onDateSelected: ((Date) -> Void)?

    private var datePicker: UIDatePicker!

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
        titleLabel.text = "选择日期时间"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 取消按钮
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        headerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }

        // 确认按钮
        let confirmButton = UIButton(type: .system)
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

        // DatePicker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = selectedDate

        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    /// 取消按钮点击
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    /// 确认按钮点击
    @objc private func confirmTapped() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true)
    }
}

// MARK: - 紧凑样式日期选择器
class CompactDatePickerViewController: UIViewController {

    var selectedDate = Date()
    var datePickerMode = UIDatePicker.Mode.dateAndTime
    var onDateSelected: ((Date) -> Void)?

    private var datePicker: UIDatePicker!

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
        titleLabel.text = "紧凑样式选择器"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center

        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 取消按钮
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        headerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }

        // 确认按钮
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        headerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }

        // DatePicker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = selectedDate
        datePicker.backgroundColor = UIColor.systemGray6
        datePicker.layer.cornerRadius = 12

        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "紧凑样式适合嵌入到界面中\n点击可展开完整的日期选择器"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    /// 取消按钮点击
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    /// 确认按钮点击
    @objc private func confirmTapped() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true)
    }
}

// MARK: - 自定义Alert样式日期选择器
class CustomAlertDatePickerViewController: UIViewController {

    var selectedDate = Date()
    var datePickerMode = UIDatePicker.Mode.dateAndTime
    var onDateSelected: ((Date) -> Void)?

    private var containerView: UIView!
    private var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true

        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(280)
        }

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "选择日期"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }

        // DatePicker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = selectedDate

        containerView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(180)
        }

        // 按钮容器
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor.systemGray6

        containerView.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }

        // 取消按钮
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        buttonContainer.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        // 分割线
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.systemGray4

        buttonContainer.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.top.bottom.equalToSuperview().inset(8)
        }

        // 确认按钮
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(.systemBlue, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        buttonContainer.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        // 点击背景关闭
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }

    /// 背景点击
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }

    /// 取消按钮点击
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    /// 确认按钮点击
    @objc private func confirmTapped() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true)
    }
}