//
//  CombineViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/10/01.
//

import UIKit
import SnapKit
import Combine

/**
 * Combine响应式编程框架学习页面
 * 演示Publisher、Subscriber、操作符、UI绑定等核心概念
 */
class CombineViewController: BaseViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    private var cancellables = Set<AnyCancellable>()

    // UI组件
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // Publisher基础示例区域
    private let publisherLabel = UILabel()
    private let justPublisherBtn = UIButton()
    private let futurePublisherBtn = UIButton()
    private let passthroughSubjectBtn = UIButton()
    private let currentValueSubjectBtn = UIButton()

    // Subscriber示例区域
    private let subscriberLabel = UILabel()
    private let sinkSubscriberBtn = UIButton()
    private let assignSubscriberBtn = UIButton()

    // 操作符示例区域
    private let operatorLabel = UILabel()
    private let mapBtn = UIButton()
    private let filterBtn = UIButton()
    private let combineLatestBtn = UIButton()
    private let mergeBtn = UIButton()
    private let debounceBtn = UIButton()
    private let flatMapBtn = UIButton()

    // UI绑定示例区域
    private let bindingLabel = UILabel()
    private let searchTextField = UITextField()
    private let searchResultLabel = UILabel()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let validationLabel = UILabel()
    private let submitButton = UIButton()

    // 网络请求示例
    private let networkLabel = UILabel()
    private let networkRequestBtn = UIButton()

    // 高级特性示例
    private let advancedLabel = UILabel()
    private let cancellableBtn = UIButton()
    private let schedulerBtn = UIButton()
    private let publishedBtn = UIButton()

    // 结果显示区域
    private let resultLabel = UILabel()
    private let resultTextView = UITextView()

    // Subject用于演示
    private let searchSubject = PassthroughSubject<String, Never>()
    private let usernameSubject = CurrentValueSubject<String, Never>("")
    private let passwordSubject = CurrentValueSubject<String, Never>("")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    /**
     * 配置用户界面
     */
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground

        setupNavigationBar()
        setupScrollView()
        setupHeaderSection()
        setupPublisherSection()
        setupSubscriberSection()
        setupOperatorSection()
        setupBindingSection()
        setupNetworkSection()
        setupAdvancedSection()
        setupResultSection()

        layoutSubviews()
    }

    /**
     * 设置导航栏
     */
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "Combine响应式编程") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(customNavigationBar)

        customNavigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /**
     * 设置滚动视图
     */
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }

    /**
     * 设置头部信息
     */
    private func setupHeaderSection() {
        titleLabel.text = "Combine 核心概念"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label

        descriptionLabel.text = "学习 Combine 的 Publisher、Subscriber、操作符、UI 绑定等核心功能"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    /**
     * 设置Publisher基础示例区域
     */
    private func setupPublisherSection() {
        publisherLabel.text = "Publisher 发布者"
        publisherLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        publisherLabel.textColor = UIColor.themeColor

        configureButton(justPublisherBtn, title: "Just Publisher", subtitle: "创建单值发布者")
        justPublisherBtn.addTarget(self, action: #selector(justPublisherExample), for: .touchUpInside)

        configureButton(futurePublisherBtn, title: "Future Publisher", subtitle: "异步操作发布者")
        futurePublisherBtn.addTarget(self, action: #selector(futurePublisherExample), for: .touchUpInside)

        configureButton(passthroughSubjectBtn, title: "PassthroughSubject", subtitle: "手动发送事件")
        passthroughSubjectBtn.addTarget(self, action: #selector(passthroughSubjectExample), for: .touchUpInside)

        configureButton(currentValueSubjectBtn, title: "CurrentValueSubject", subtitle: "保存当前值的Subject")
        currentValueSubjectBtn.addTarget(self, action: #selector(currentValueSubjectExample), for: .touchUpInside)

        contentView.addSubview(publisherLabel)
        contentView.addSubview(justPublisherBtn)
        contentView.addSubview(futurePublisherBtn)
        contentView.addSubview(passthroughSubjectBtn)
        contentView.addSubview(currentValueSubjectBtn)
    }

    /**
     * 设置Subscriber示例区域
     */
    private func setupSubscriberSection() {
        subscriberLabel.text = "Subscriber 订阅者"
        subscriberLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        subscriberLabel.textColor = UIColor.themeColor

        configureButton(sinkSubscriberBtn, title: "Sink 订阅", subtitle: "使用闭包处理值")
        sinkSubscriberBtn.addTarget(self, action: #selector(sinkSubscriberExample), for: .touchUpInside)

        configureButton(assignSubscriberBtn, title: "Assign 赋值", subtitle: "直接赋值给属性")
        assignSubscriberBtn.addTarget(self, action: #selector(assignSubscriberExample), for: .touchUpInside)

        contentView.addSubview(subscriberLabel)
        contentView.addSubview(sinkSubscriberBtn)
        contentView.addSubview(assignSubscriberBtn)
    }

    /**
     * 设置操作符示例区域
     */
    private func setupOperatorSection() {
        operatorLabel.text = "操作符 Operators"
        operatorLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        operatorLabel.textColor = UIColor.themeColor

        configureButton(mapBtn, title: "Map 变换", subtitle: "转换发布的值")
        mapBtn.addTarget(self, action: #selector(mapOperatorExample), for: .touchUpInside)

        configureButton(filterBtn, title: "Filter 过滤", subtitle: "根据条件过滤值")
        filterBtn.addTarget(self, action: #selector(filterOperatorExample), for: .touchUpInside)

        configureButton(combineLatestBtn, title: "CombineLatest", subtitle: "组合多个发布者的最新值")
        combineLatestBtn.addTarget(self, action: #selector(combineLatestExample), for: .touchUpInside)

        configureButton(mergeBtn, title: "Merge 合并", subtitle: "合并多个发布者")
        mergeBtn.addTarget(self, action: #selector(mergeExample), for: .touchUpInside)

        configureButton(debounceBtn, title: "Debounce 防抖", subtitle: "延迟发送值，常用于搜索")
        debounceBtn.addTarget(self, action: #selector(debounceExample), for: .touchUpInside)

        configureButton(flatMapBtn, title: "FlatMap 扁平化", subtitle: "将嵌套发布者扁平化")
        flatMapBtn.addTarget(self, action: #selector(flatMapExample), for: .touchUpInside)

        contentView.addSubview(operatorLabel)
        contentView.addSubview(mapBtn)
        contentView.addSubview(filterBtn)
        contentView.addSubview(combineLatestBtn)
        contentView.addSubview(mergeBtn)
        contentView.addSubview(debounceBtn)
        contentView.addSubview(flatMapBtn)
    }

    /**
     * 设置UI绑定示例区域
     */
    private func setupBindingSection() {
        bindingLabel.text = "UI 数据绑定"
        bindingLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        bindingLabel.textColor = UIColor.themeColor

        // 搜索框
        searchTextField.placeholder = "输入搜索关键词（实时防抖）"
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.systemFont(ofSize: 16)

        // 搜索结果标签
        searchResultLabel.text = "搜索结果将在这里显示"
        searchResultLabel.font = UIFont.systemFont(ofSize: 16)
        searchResultLabel.textColor = .secondaryLabel
        searchResultLabel.numberOfLines = 0

        // 用户名输入框
        usernameTextField.placeholder = "用户名（至少3个字符）"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.font = UIFont.systemFont(ofSize: 16)

        // 密码输入框
        passwordTextField.placeholder = "密码（至少6个字符）"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true

        // 验证结果标签
        validationLabel.text = "表单验证结果"
        validationLabel.font = UIFont.systemFont(ofSize: 14)
        validationLabel.textColor = .systemRed
        validationLabel.numberOfLines = 0

        // 提交按钮
        submitButton.setTitle("提交", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor.systemGray
        submitButton.layer.cornerRadius = 8
        submitButton.isEnabled = false

        contentView.addSubview(bindingLabel)
        contentView.addSubview(searchTextField)
        contentView.addSubview(searchResultLabel)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(validationLabel)
        contentView.addSubview(submitButton)
    }

    /**
     * 设置网络请求示例区域
     */
    private func setupNetworkSection() {
        networkLabel.text = "网络请求 + Combine"
        networkLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        networkLabel.textColor = UIColor.themeColor

        configureButton(networkRequestBtn, title: "DataTask Publisher", subtitle: "使用 Combine 处理网络请求")
        networkRequestBtn.addTarget(self, action: #selector(networkRequestExample), for: .touchUpInside)

        contentView.addSubview(networkLabel)
        contentView.addSubview(networkRequestBtn)
    }

    /**
     * 设置高级特性示例区域
     */
    private func setupAdvancedSection() {
        advancedLabel.text = "高级特性"
        advancedLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        advancedLabel.textColor = UIColor.themeColor

        configureButton(cancellableBtn, title: "Cancellable", subtitle: "取消订阅管理")
        cancellableBtn.addTarget(self, action: #selector(cancellableExample), for: .touchUpInside)

        configureButton(schedulerBtn, title: "Scheduler", subtitle: "线程调度器")
        schedulerBtn.addTarget(self, action: #selector(schedulerExample), for: .touchUpInside)

        configureButton(publishedBtn, title: "@Published", subtitle: "属性包装器")
        publishedBtn.addTarget(self, action: #selector(publishedExample), for: .touchUpInside)

        contentView.addSubview(advancedLabel)
        contentView.addSubview(cancellableBtn)
        contentView.addSubview(schedulerBtn)
        contentView.addSubview(publishedBtn)
    }

    /**
     * 设置结果显示区域
     */
    private func setupResultSection() {
        resultLabel.text = "执行结果"
        resultLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        resultLabel.textColor = .label

        resultTextView.font = UIFont.systemFont(ofSize: 14)
        resultTextView.textColor = .label
        resultTextView.backgroundColor = .systemGray6
        resultTextView.layer.cornerRadius = 8
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.borderColor = UIColor.separator.cgColor
        resultTextView.isEditable = false
        resultTextView.text = "点击上方按钮查看 Combine 示例结果..."

        contentView.addSubview(resultLabel)
        contentView.addSubview(resultTextView)
    }

    /**
     * 配置按钮样式
     */
    private func configureButton(_ button: UIButton, title: String, subtitle: String) {
        button.backgroundColor = UIColor.themeColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4

        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.white
            ]
        ))
        attributedTitle.append(NSAttributedString(string: "\n"))
        attributedTitle.append(NSAttributedString(
            string: subtitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white.withAlphaComponent(0.8)
            ]
        ))

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
    }

    /**
     * 设置数据绑定
     */
    private func setupBindings() {
        // 搜索框防抖绑定
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.searchResultLabel.text = "搜索: \(text)"
            }
            .store(in: &cancellables)

        // 用户名绑定
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: usernameTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                self?.usernameSubject.send(text)
            }
            .store(in: &cancellables)

        // 密码绑定
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                self?.passwordSubject.send(text)
            }
            .store(in: &cancellables)

        // 表单验证
        Publishers.CombineLatest(usernameSubject, passwordSubject)
            .map { username, password -> (isValid: Bool, message: String) in
                if username.count < 3 {
                    return (false, "用户名至少需要3个字符")
                }
                if password.count < 6 {
                    return (false, "密码至少需要6个字符")
                }
                return (true, "表单验证通过 ✓")
            }
            .sink { [weak self] result in
                self?.validationLabel.text = result.message
                self?.validationLabel.textColor = result.isValid ? .systemGreen : .systemRed
                self?.submitButton.isEnabled = result.isValid
                self?.submitButton.backgroundColor = result.isValid ? UIColor.themeColor : UIColor.systemGray
            }
            .store(in: &cancellables)
    }

    /**
     * 布局所有子视图
     */
    private func layoutSubviews() {
        let margin: CGFloat = 20
        let buttonHeight: CGFloat = 60
        let spacing: CGFloat = 15

        // 头部区域
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(margin)
        }

        // Publisher区域
        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }

        justPublisherBtn.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        futurePublisherBtn.snp.makeConstraints { make in
            make.top.equalTo(justPublisherBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        passthroughSubjectBtn.snp.makeConstraints { make in
            make.top.equalTo(futurePublisherBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        currentValueSubjectBtn.snp.makeConstraints { make in
            make.top.equalTo(passthroughSubjectBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // Subscriber区域
        subscriberLabel.snp.makeConstraints { make in
            make.top.equalTo(currentValueSubjectBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        sinkSubscriberBtn.snp.makeConstraints { make in
            make.top.equalTo(subscriberLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        assignSubscriberBtn.snp.makeConstraints { make in
            make.top.equalTo(sinkSubscriberBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 操作符区域
        operatorLabel.snp.makeConstraints { make in
            make.top.equalTo(assignSubscriberBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        mapBtn.snp.makeConstraints { make in
            make.top.equalTo(operatorLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        filterBtn.snp.makeConstraints { make in
            make.top.equalTo(mapBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        combineLatestBtn.snp.makeConstraints { make in
            make.top.equalTo(filterBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        mergeBtn.snp.makeConstraints { make in
            make.top.equalTo(combineLatestBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        debounceBtn.snp.makeConstraints { make in
            make.top.equalTo(mergeBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        flatMapBtn.snp.makeConstraints { make in
            make.top.equalTo(debounceBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // UI绑定区域
        bindingLabel.snp.makeConstraints { make in
            make.top.equalTo(flatMapBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(bindingLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }

        searchResultLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(searchResultLabel.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }

        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }

        // 网络请求区域
        networkLabel.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        networkRequestBtn.snp.makeConstraints { make in
            make.top.equalTo(networkLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 高级特性区域
        advancedLabel.snp.makeConstraints { make in
            make.top.equalTo(networkRequestBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        cancellableBtn.snp.makeConstraints { make in
            make.top.equalTo(advancedLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        schedulerBtn.snp.makeConstraints { make in
            make.top.equalTo(cancellableBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        publishedBtn.snp.makeConstraints { make in
            make.top.equalTo(schedulerBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 结果显示区域
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(publishedBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        resultTextView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-margin)
        }
    }
}

// MARK: - Publisher 基础示例
extension CombineViewController {

    /**
     * Just Publisher 示例
     */
    @objc private func justPublisherExample() {
        showResult("Just Publisher 示例:\n")

        let justPublisher = Just("Hello, Combine!")

        justPublisher
            .sink { completion in
                self.appendToResult("完成: \(completion)")
            } receiveValue: { value in
                self.appendToResult("接收到值: \(value)")
            }
            .store(in: &cancellables)
    }

    /**
     * Future Publisher 示例
     */
    @objc private func futurePublisherExample() {
        showResult("Future Publisher 示例:\n")
        appendToResult("开始异步操作...")

        let futurePublisher = Future<String, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success("异步操作完成"))
            }
        }

        futurePublisher
            .sink { completion in
                switch completion {
                case .finished:
                    self.appendToResult("Future 完成")
                case .failure(let error):
                    self.appendToResult("Future 失败: \(error)")
                }
            } receiveValue: { value in
                self.appendToResult("接收到值: \(value)")
            }
            .store(in: &cancellables)
    }

    /**
     * PassthroughSubject 示例
     */
    @objc private func passthroughSubjectExample() {
        showResult("PassthroughSubject 示例:\n")

        let subject = PassthroughSubject<String, Never>()

        subject
            .sink { value in
                self.appendToResult("订阅者收到: \(value)")
            }
            .store(in: &cancellables)

        appendToResult("发送值: A")
        subject.send("A")

        appendToResult("发送值: B")
        subject.send("B")

        appendToResult("发送值: C")
        subject.send("C")

        appendToResult("发送完成")
        subject.send(completion: .finished)
    }

    /**
     * CurrentValueSubject 示例
     */
    @objc private func currentValueSubjectExample() {
        showResult("CurrentValueSubject 示例:\n")

        let subject = CurrentValueSubject<Int, Never>(0)

        appendToResult("当前值: \(subject.value)")

        subject
            .sink { value in
                self.appendToResult("订阅者收到: \(value)")
            }
            .store(in: &cancellables)

        appendToResult("发送值: 1")
        subject.send(1)

        appendToResult("发送值: 2")
        subject.send(2)

        appendToResult("当前值: \(subject.value)")
    }
}

// MARK: - Subscriber 示例
extension CombineViewController {

    /**
     * Sink 订阅示例
     */
    @objc private func sinkSubscriberExample() {
        showResult("Sink 订阅示例:\n")

        [1, 2, 3, 4, 5].publisher
            .sink { completion in
                self.appendToResult("完成: \(completion)")
            } receiveValue: { value in
                self.appendToResult("接收: \(value)")
            }
            .store(in: &cancellables)
    }

    /**
     * Assign 赋值订阅示例
     */
    @objc private func assignSubscriberExample() {
        showResult("Assign 赋值订阅示例:\n")
        appendToResult("观察 resultTextView 的文本变化")

        ["第一行", "第二行", "第三行"].publisher
            .collect()
            .map { $0.joined(separator: "\n") }
            .assign(to: \.text, on: resultTextView)
            .store(in: &cancellables)
    }
}

// MARK: - 操作符示例
extension CombineViewController {

    /**
     * Map 操作符示例
     */
    @objc private func mapOperatorExample() {
        showResult("Map 操作符示例:\n")

        [1, 2, 3, 4, 5].publisher
            .map { $0 * 2 }
            .sink { value in
                self.appendToResult("原值*2 = \(value)")
            }
            .store(in: &cancellables)
    }

    /**
     * Filter 操作符示例
     */
    @objc private func filterOperatorExample() {
        showResult("Filter 操作符示例:\n")

        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher
            .filter { $0 % 2 == 0 }
            .sink { value in
                self.appendToResult("偶数: \(value)")
            }
            .store(in: &cancellables)
    }

    /**
     * CombineLatest 操作符示例
     */
    @objc private func combineLatestExample() {
        showResult("CombineLatest 操作符示例:\n")

        let subject1 = PassthroughSubject<String, Never>()
        let subject2 = PassthroughSubject<Int, Never>()

        subject1.combineLatest(subject2)
            .map { "\($0): \($1)" }
            .sink { combined in
                self.appendToResult("组合结果: \(combined)")
            }
            .store(in: &cancellables)

        appendToResult("发送: subject1='A'")
        subject1.send("A")

        appendToResult("发送: subject2=1")
        subject2.send(1)

        appendToResult("发送: subject1='B'")
        subject1.send("B")

        appendToResult("发送: subject2=2")
        subject2.send(2)
    }

    /**
     * Merge 操作符示例
     */
    @objc private func mergeExample() {
        showResult("Merge 操作符示例:\n")

        let subject1 = PassthroughSubject<String, Never>()
        let subject2 = PassthroughSubject<String, Never>()

        subject1.merge(with: subject2)
            .sink { value in
                self.appendToResult("合并结果: \(value)")
            }
            .store(in: &cancellables)

        appendToResult("subject1 发送: A")
        subject1.send("A")

        appendToResult("subject2 发送: 1")
        subject2.send("1")

        appendToResult("subject1 发送: B")
        subject1.send("B")

        appendToResult("subject2 发送: 2")
        subject2.send("2")
    }

    /**
     * Debounce 操作符示例
     */
    @objc private func debounceExample() {
        showResult("Debounce 操作符示例:\n")
        appendToResult("模拟快速输入...")

        let subject = PassthroughSubject<String, Never>()

        subject
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { value in
                self.appendToResult("防抖后接收: \(value)")
            }
            .store(in: &cancellables)

        subject.send("A")
        appendToResult("发送: A")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            subject.send("AB")
            self.appendToResult("发送: AB")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            subject.send("ABC")
            self.appendToResult("发送: ABC")
        }

        appendToResult("等待1秒后输出最终值...")
    }

    /**
     * FlatMap 操作符示例
     */
    @objc private func flatMapExample() {
        showResult("FlatMap 操作符示例:\n")

        struct User {
            let name: String
            let postsPublisher: AnyPublisher<[String], Never>
        }

        let user1 = User(name: "张三", postsPublisher: Just(["文章1", "文章2"]).eraseToAnyPublisher())
        let user2 = User(name: "李四", postsPublisher: Just(["文章A", "文章B"]).eraseToAnyPublisher())

        [user1, user2].publisher
            .flatMap { user in
                user.postsPublisher
                    .map { posts in (user.name, posts) }
            }
            .sink { (name, posts) in
                self.appendToResult("\(name) 的文章: \(posts.joined(separator: ", "))")
            }
            .store(in: &cancellables)
    }
}

// MARK: - 网络请求和高级特性示例
extension CombineViewController {

    /**
     * 网络请求示例
     */
    @objc private func networkRequestExample() {
        showResult("网络请求示例:\n")
        appendToResult("发起网络请求...")

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            appendToResult("URL 无效")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Post.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.appendToResult("请求完成")
                case .failure(let error):
                    self.appendToResult("请求失败: \(error.localizedDescription)")
                }
            } receiveValue: { post in
                self.appendToResult("标题: \(post.title)")
                self.appendToResult("内容: \(post.body)")
            }
            .store(in: &cancellables)
    }

    /**
     * Cancellable 示例
     */
    @objc private func cancellableExample() {
        showResult("Cancellable 取消订阅示例:\n")

        var cancellable: AnyCancellable?

        let timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()

        cancellable = timer
            .sink { _ in
                self.appendToResult("定时器触发")
            }

        appendToResult("3秒后取消订阅...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            cancellable?.cancel()
            self.appendToResult("订阅已取消")
        }
    }

    /**
     * Scheduler 线程调度示例
     */
    @objc private func schedulerExample() {
        showResult("Scheduler 线程调度示例:\n")

        appendToResult("主线程: \(Thread.isMainThread)")

        Just("数据")
            .subscribe(on: DispatchQueue.global())
            .map { value -> String in
                self.appendToResult("处理线程(后台): \(Thread.isMainThread ? "主线程" : "后台线程")")
                return value.uppercased()
            }
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.appendToResult("接收线程(主线程): \(Thread.isMainThread ? "主线程" : "后台线程")")
                self.appendToResult("处理后的值: \(value)")
            }
            .store(in: &cancellables)
    }

    /**
     * @Published 属性包装器示例
     */
    @objc private func publishedExample() {
        showResult("@Published 属性包装器示例:\n")

        class ViewModel {
            @Published var count = 0
        }

        let viewModel = ViewModel()

        viewModel.$count
            .sink { value in
                self.appendToResult("count 变化: \(value)")
            }
            .store(in: &cancellables)

        appendToResult("设置 count = 1")
        viewModel.count = 1

        appendToResult("设置 count = 2")
        viewModel.count = 2

        appendToResult("设置 count = 3")
        viewModel.count = 3
    }
}

// MARK: - 辅助方法
extension CombineViewController {

    /**
     * 显示结果
     */
    private func showResult(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.resultTextView.text = text
            self?.resultTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }

    /**
     * 追加内容到结果显示
     */
    private func appendToResult(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.resultTextView.text += text + "\n"
            let bottom = NSRange(location: self.resultTextView.text.count - 1, length: 1)
            self.resultTextView.scrollRangeToVisible(bottom)
        }
    }
}

// MARK: - 数据模型
struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
