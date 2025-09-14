//
//  AdvancedControlsViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//
import UIKit
import SnapKit

/// 高级控件示例页面
class AdvancedControlsViewController: BaseViewController {
    
    private var segmentedControl: UISegmentedControl!
    private var containerView: UIView?
    private var currentViewController: UIViewController?
    private let navigationBar = CustomNavigationBar()
    
    private var viewControllers: [UIViewController] = []
    private let titles = ["PickerView", "DatePicker", "Slider", "Stepper", "PageControl", "ActivityIndicator"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
        showViewController(at: 0)
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        setupNavigationBar()
        setupContent()
    }
    
    private func setupNavigationBar() {
        navigationBar.configure(title: "高级控件示例") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
    }
    
    private func setupContent() {
        
        // 创建分段控制器
        segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        // 创建容器视图
        containerView = UIView()
        containerView?.backgroundColor = UIColor.systemBackground
        
        if let containerView = containerView {
            view.addSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.top.equalTo(segmentedControl.snp.bottom).offset(20)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    /// 设置子控制器
    private func setupViewControllers() {
        viewControllers = [
            PickerViewViewController(),
            DatePickerViewController(),
            SliderViewController(),
            StepperViewController(),
            PageControlViewController(),
            ActivityIndicatorViewController()
        ]
        
        // 添加所有子控制器
        for controller in viewControllers {
            addChild(controller)
            controller.didMove(toParent: self)
        }
    }
    
    /// 分段控制器改变事件
    @objc private func segmentChanged() {
        showViewController(at: segmentedControl.selectedSegmentIndex)
    }
    
    /// 显示指定索引的控制器
    private func showViewController(at index: Int) {
        guard index < viewControllers.count,
              let containerView = containerView else { return }
        
        // 移除当前控制器视图
        currentViewController?.view.removeFromSuperview()
        
        // 添加新的控制器视图
        let newController = viewControllers[index]
        containerView.addSubview(newController.view)
        newController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentViewController = newController
    }
}

// MARK: - UIPickerView示例
class PickerViewViewController: UIViewController {
    
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
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UIPickerView - 选择器控件"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource for PickerViewViewController
extension PickerViewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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


// MARK: - UIDatePicker示例
class DatePickerViewController: UIViewController {
    
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
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UIDatePicker - 日期选择器"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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

// MARK: - UISlider示例
class SliderViewController: UIViewController {
    
    private var volumeSlider: UISlider!
    private var brightnessSlider: UISlider!
    private var customSlider: UISlider!
    private var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UISlider - 滑块控件"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
        
        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "UISlider支持自定义颜色、图标和范围值"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(customSlider.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    /// 滑块值改变
    @objc private func sliderValueChanged() {
        let volume = Int(volumeSlider.value)
        let brightness = Int(brightnessSlider.value)
        let custom = Int(customSlider.value)
        resultLabel.text = "音量: \(volume)% | 亮度: \(brightness)% | 自定义: \(custom)%"
    }
}

// MARK: - UIStepper示例
class StepperViewController: UIViewController {
    
    private var quantityStepper: UIStepper!
    private var speedStepper: UIStepper!
    private var customStepper: UIStepper!
    private var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UIStepper - 步进器控件"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
        let quantityLabel = UILabel()
        quantityLabel.text = "📦 商品数量"
        quantityLabel.font = UIFont.systemFont(ofSize: 16)
        
        quantityStepper = UIStepper()
        quantityStepper.minimumValue = 1
        quantityStepper.maximumValue = 99
        quantityStepper.stepValue = 1
        quantityStepper.value = 1
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        view.addSubview(quantityLabel)
        view.addSubview(quantityStepper)
        
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        quantityStepper.snp.makeConstraints { make in
            make.centerY.equalTo(quantityLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 播放速度步进器
        let speedLabel = UILabel()
        speedLabel.text = "🎵 播放速度"
        speedLabel.font = UIFont.systemFont(ofSize: 16)
        
        speedStepper = UIStepper()
        speedStepper.minimumValue = 0.5
        speedStepper.maximumValue = 3.0
        speedStepper.stepValue = 0.25
        speedStepper.value = 1.0
        speedStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        view.addSubview(speedLabel)
        view.addSubview(speedStepper)
        
        speedLabel.snp.makeConstraints { make in
            make.top.equalTo(quantityLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        speedStepper.snp.makeConstraints { make in
            make.centerY.equalTo(speedLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 自定义步进器
        let customLabel = UILabel()
        customLabel.text = "⚙️ 自定义值"
        customLabel.font = UIFont.systemFont(ofSize: 16)
        
        customStepper = UIStepper()
        customStepper.minimumValue = 0
        customStepper.maximumValue = 100
        customStepper.stepValue = 5
        customStepper.value = 50
        customStepper.wraps = true  // 循环模式
        customStepper.autorepeat = true  // 长按连续变化
        customStepper.tintColor = UIColor.themeColor
        customStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        
        view.addSubview(customLabel)
        view.addSubview(customStepper)
        
        customLabel.snp.makeConstraints { make in
            make.top.equalTo(speedLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        customStepper.snp.makeConstraints { make in
            make.centerY.equalTo(customLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "UIStepper支持自定义步长、范围、循环模式和长按连续变化"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(customLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    /// 步进器值改变
    @objc private func stepperValueChanged() {
        let quantity = Int(quantityStepper.value)
        let speed = speedStepper.value
        let custom = Int(customStepper.value)
        resultLabel.text = "数量: \(quantity) | 速度: \(String(format: "%.2f", speed))x | 自定义: \(custom)"
    }
}

// MARK: - UIPageControl示例
class PageControlViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var customPageControl: UIPageControl!
    private var resultLabel: UILabel!
    
    private let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPages()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UIPageControl - 页面指示器"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        // 结果显示
        resultLabel = UILabel()
        resultLabel.text = "当前页面: 第1页 / 共5页"
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
        
        // ScrollView
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        // 默认PageControl
        pageControl = UIPageControl()
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.systemGray4
        pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // 自定义PageControl
        customPageControl = UIPageControl()
        customPageControl.numberOfPages = colors.count
        customPageControl.currentPage = 0
        customPageControl.pageIndicatorTintColor = UIColor.systemGray5
        customPageControl.currentPageIndicatorTintColor = UIColor.themeColor
        customPageControl.backgroundStyle = .prominent
        customPageControl.addTarget(self, action: #selector(customPageControlValueChanged), for: .valueChanged)
        
        view.addSubview(customPageControl)
        customPageControl.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "滑动页面或点击指示器切换页面\n上方为默认样式，下方为自定义样式"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.systemGray
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(customPageControl.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    /// 设置页面
    private func setupPages() {
        let scrollViewWidth = view.bounds.width - 40  // 减去左右边距
        scrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(colors.count), height: 200)
        
        for (index, color) in colors.enumerated() {
            let pageView = UIView()
            pageView.backgroundColor = color
            pageView.layer.cornerRadius = 12
            
            let label = UILabel()
            label.text = "第\(index + 1)页"
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            
            pageView.addSubview(label)
            scrollView.addSubview(pageView)
            
            let x = scrollViewWidth * CGFloat(index)
            pageView.frame = CGRect(x: x, y: 0, width: scrollViewWidth, height: 200)
            
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    /// PageControl值改变
    @objc private func pageControlValueChanged() {
        let page = pageControl.currentPage
        let scrollViewWidth = view.bounds.width - 40
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth * CGFloat(page), y: 0), animated: true)
        customPageControl.currentPage = page
        updateResultLabel()
    }
    
    /// 自定义PageControl值改变
    @objc private func customPageControlValueChanged() {
        let page = customPageControl.currentPage
        let scrollViewWidth = view.bounds.width - 40
        scrollView.setContentOffset(CGPoint(x: scrollViewWidth * CGFloat(page), y: 0), animated: true)
        pageControl.currentPage = page
        updateResultLabel()
    }
    
    /// 更新结果标签
    private func updateResultLabel() {
        let currentPage = pageControl.currentPage + 1
        resultLabel.text = "当前页面: 第\(currentPage)页 / 共\(colors.count)页"
    }
}

// MARK: - UIScrollViewDelegate for PageControlViewController
extension PageControlViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = view.bounds.width - 40
        guard scrollViewWidth > 0 else { return }
        let page = Int(scrollView.contentOffset.x / scrollViewWidth)
        if page != pageControl.currentPage && page >= 0 && page < colors.count {
            pageControl.currentPage = page
            customPageControl.currentPage = page
            updateResultLabel()
        }
    }
}

// MARK: - UIActivityIndicatorView示例
class ActivityIndicatorViewController: UIViewController {
    
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
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "UIActivityIndicatorView - 活动指示器"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
        
        // 说明文字
        let descLabel = UILabel()
        descLabel.text = "UIActivityIndicatorView用于显示加载状态\n支持不同样式和自定义颜色"
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
    
    /// 创建指示器容器
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
    }
    
    /// 停止加载
    @objc private func stopLoading() {
        [defaultIndicator, largeIndicator, customIndicator].forEach { $0?.stopAnimating() }
        resultLabel.text = "加载已停止"
        timer?.invalidate()
        timer = nil
        progress = 0
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
            }
        }
    }
}
