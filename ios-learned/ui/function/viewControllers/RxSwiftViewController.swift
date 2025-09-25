//
//  RxSwiftViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/09/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 * RxSwift响应式编程框架学习页面
 * 演示Observable、Subject、操作符、UI绑定等核心概念
 */
class RxSwiftViewController: BaseViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()
    private let disposeBag = DisposeBag()

    // UI组件
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    // Observable基础示例区域
    private let observableLabel = UILabel()
    private let createObservableBtn = UIButton()
    private let fromArrayBtn = UIButton()
    private let intervalBtn = UIButton()
    private let errorBtn = UIButton()

    // Subject示例区域
    private let subjectLabel = UILabel()
    private let publishSubjectBtn = UIButton()
    private let behaviorSubjectBtn = UIButton()
    private let replaySubjectBtn = UIButton()

    // 操作符示例区域
    private let operatorLabel = UILabel()
    private let mapBtn = UIButton()
    private let filterBtn = UIButton()
    private let combineLatestBtn = UIButton()
    private let mergeBtn = UIButton()

    // UI绑定示例区域
    private let bindingLabel = UILabel()
    private let inputTextField = UITextField()
    private let bindingOutputLabel = UILabel()
    private let countLabel = UILabel()
    private let incrementBtn = UIButton()
    private let decrementBtn = UIButton()

    // 网络请求示例
    private let networkLabel = UILabel()
    private let rxNetworkBtn = UIButton()

    // 生态库示例
    private let ecosystemLabel = UILabel()
    private let ecosystemBtn = UIButton()

    // 结果显示区域
    private let resultLabel = UILabel()
    private let resultTextView = UITextView()

    // 计数器Subject
    private let counterSubject = BehaviorSubject<Int>(value: 0)

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
        setupObservableSection()
        setupSubjectSection()
        setupOperatorSection()
        setupBindingSection()
        setupNetworkSection()
        setupEcosystemSection()
        setupResultSection()

        layoutSubviews()
    }

    /**
     * 设置导航栏
     */
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "RxSwift响应式编程") { [weak self] in
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
        titleLabel.text = "响应式编程核心概念"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label

        descriptionLabel.text = "学习RxSwift的Observable、Subject、操作符、UI绑定等核心功能"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    /**
     * 设置Observable基础示例区域
     */
    private func setupObservableSection() {
        observableLabel.text = "Observable 基础"
        observableLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        observableLabel.textColor = UIColor.themeColor

        configureButton(createObservableBtn, title: "创建Observable", subtitle: "手动创建可观察序列")
        createObservableBtn.addTarget(self, action: #selector(createObservableExample), for: .touchUpInside)

        configureButton(fromArrayBtn, title: "从数组创建", subtitle: "Observable.from(array)")
        fromArrayBtn.addTarget(self, action: #selector(fromArrayExample), for: .touchUpInside)

        configureButton(intervalBtn, title: "定时器序列", subtitle: "Observable.interval")
        intervalBtn.addTarget(self, action: #selector(intervalExample), for: .touchUpInside)

        configureButton(errorBtn, title: "错误处理", subtitle: "onError和catch操作符")
        errorBtn.addTarget(self, action: #selector(errorHandlingExample), for: .touchUpInside)

        contentView.addSubview(observableLabel)
        contentView.addSubview(createObservableBtn)
        contentView.addSubview(fromArrayBtn)
        contentView.addSubview(intervalBtn)
        contentView.addSubview(errorBtn)
    }

    /**
     * 设置Subject示例区域
     */
    private func setupSubjectSection() {
        subjectLabel.text = "Subject 类型"
        subjectLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        subjectLabel.textColor = UIColor.themeColor

        configureButton(publishSubjectBtn, title: "PublishSubject", subtitle: "只发送订阅后的事件")
        publishSubjectBtn.addTarget(self, action: #selector(publishSubjectExample), for: .touchUpInside)

        configureButton(behaviorSubjectBtn, title: "BehaviorSubject", subtitle: "保存最新值并发送给新订阅者")
        behaviorSubjectBtn.addTarget(self, action: #selector(behaviorSubjectExample), for: .touchUpInside)

        configureButton(replaySubjectBtn, title: "ReplaySubject", subtitle: "保存指定数量的值")
        replaySubjectBtn.addTarget(self, action: #selector(replaySubjectExample), for: .touchUpInside)

        contentView.addSubview(subjectLabel)
        contentView.addSubview(publishSubjectBtn)
        contentView.addSubview(behaviorSubjectBtn)
        contentView.addSubview(replaySubjectBtn)
    }

    /**
     * 设置操作符示例区域
     */
    private func setupOperatorSection() {
        operatorLabel.text = "操作符 Operators"
        operatorLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        operatorLabel.textColor = UIColor.themeColor

        configureButton(mapBtn, title: "Map变换", subtitle: "将每个元素转换为新值")
        mapBtn.addTarget(self, action: #selector(mapOperatorExample), for: .touchUpInside)

        configureButton(filterBtn, title: "Filter过滤", subtitle: "根据条件过滤元素")
        filterBtn.addTarget(self, action: #selector(filterOperatorExample), for: .touchUpInside)

        configureButton(combineLatestBtn, title: "CombineLatest", subtitle: "组合多个Observable的最新值")
        combineLatestBtn.addTarget(self, action: #selector(combineLatestExample), for: .touchUpInside)

        configureButton(mergeBtn, title: "Merge合并", subtitle: "将多个Observable合并为一个")
        mergeBtn.addTarget(self, action: #selector(mergeExample), for: .touchUpInside)

        contentView.addSubview(operatorLabel)
        contentView.addSubview(mapBtn)
        contentView.addSubview(filterBtn)
        contentView.addSubview(combineLatestBtn)
        contentView.addSubview(mergeBtn)
    }

    /**
     * 设置UI绑定示例区域
     */
    private func setupBindingSection() {
        bindingLabel.text = "UI 数据绑定"
        bindingLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        bindingLabel.textColor = UIColor.themeColor

        // 输入框
        inputTextField.placeholder = "输入文本查看响应式绑定"
        inputTextField.borderStyle = .roundedRect
        inputTextField.font = UIFont.systemFont(ofSize: 16)

        // 绑定输出标签
        bindingOutputLabel.text = "输入内容将在这里显示"
        bindingOutputLabel.font = UIFont.systemFont(ofSize: 16)
        bindingOutputLabel.textColor = .secondaryLabel
        bindingOutputLabel.numberOfLines = 0

        // 计数器标签
        countLabel.text = "计数: 0"
        countLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        countLabel.textColor = .label
        countLabel.textAlignment = .center

        // 计数器按钮
        configureButton(incrementBtn, title: "+1", subtitle: "增加计数")
        incrementBtn.addTarget(self, action: #selector(incrementCounter), for: .touchUpInside)

        configureButton(decrementBtn, title: "-1", subtitle: "减少计数")
        decrementBtn.addTarget(self, action: #selector(decrementCounter), for: .touchUpInside)

        contentView.addSubview(bindingLabel)
        contentView.addSubview(inputTextField)
        contentView.addSubview(bindingOutputLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(incrementBtn)
        contentView.addSubview(decrementBtn)
    }

    /**
     * 设置网络请求示例区域
     */
    private func setupNetworkSection() {
        networkLabel.text = "网络请求 + RxSwift"
        networkLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        networkLabel.textColor = UIColor.themeColor

        configureButton(rxNetworkBtn, title: "响应式网络请求", subtitle: "使用RxSwift处理网络请求")
        rxNetworkBtn.addTarget(self, action: #selector(rxNetworkExample), for: .touchUpInside)

        contentView.addSubview(networkLabel)
        contentView.addSubview(rxNetworkBtn)
    }

    /**
     * 设置生态库示例区域
     */
    private func setupEcosystemSection() {
        ecosystemLabel.text = "RxSwift 生态库"
        ecosystemLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        ecosystemLabel.textColor = UIColor.themeColor

        configureButton(ecosystemBtn, title: "生态库演示", subtitle: "RxDataSources、RxKeyboard等")
        ecosystemBtn.addTarget(self, action: #selector(showEcosystemExample), for: .touchUpInside)

        contentView.addSubview(ecosystemLabel)
        contentView.addSubview(ecosystemBtn)
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
        resultTextView.text = "点击上方按钮查看RxSwift示例结果..."

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
        // 输入框文本绑定
        inputTextField.rx.text.orEmpty
            .map { "输入内容: \($0)" }
            .bind(to: bindingOutputLabel.rx.text)
            .disposed(by: disposeBag)

        // 计数器绑定
        counterSubject
            .map { "计数: \($0)" }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
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

        // Observable基础区域
        observableLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }

        createObservableBtn.snp.makeConstraints { make in
            make.top.equalTo(observableLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        fromArrayBtn.snp.makeConstraints { make in
            make.top.equalTo(createObservableBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        intervalBtn.snp.makeConstraints { make in
            make.top.equalTo(fromArrayBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        errorBtn.snp.makeConstraints { make in
            make.top.equalTo(intervalBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // Subject区域
        subjectLabel.snp.makeConstraints { make in
            make.top.equalTo(errorBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        publishSubjectBtn.snp.makeConstraints { make in
            make.top.equalTo(subjectLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        behaviorSubjectBtn.snp.makeConstraints { make in
            make.top.equalTo(publishSubjectBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        replaySubjectBtn.snp.makeConstraints { make in
            make.top.equalTo(behaviorSubjectBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 操作符区域
        operatorLabel.snp.makeConstraints { make in
            make.top.equalTo(replaySubjectBtn.snp.bottom).offset(margin * 1.5)
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

        // UI绑定区域
        bindingLabel.snp.makeConstraints { make in
            make.top.equalTo(mergeBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(bindingLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }

        bindingOutputLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
        }

        countLabel.snp.makeConstraints { make in
            make.top.equalTo(bindingOutputLabel.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(44)
        }

        incrementBtn.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(spacing)
            make.left.equalToSuperview().offset(margin)
            make.right.equalTo(contentView.snp.centerX).offset(-8)
            make.height.equalTo(buttonHeight)
        }

        decrementBtn.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(spacing)
            make.left.equalTo(contentView.snp.centerX).offset(8)
            make.right.equalToSuperview().offset(-margin)
            make.height.equalTo(buttonHeight)
        }

        // 网络请求区域
        networkLabel.snp.makeConstraints { make in
            make.top.equalTo(incrementBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        rxNetworkBtn.snp.makeConstraints { make in
            make.top.equalTo(networkLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 生态库区域
        ecosystemLabel.snp.makeConstraints { make in
            make.top.equalTo(rxNetworkBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        ecosystemBtn.snp.makeConstraints { make in
            make.top.equalTo(ecosystemLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 结果显示区域
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(ecosystemBtn.snp.bottom).offset(margin * 1.5)
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

// MARK: - Observable 基础示例
extension RxSwiftViewController {

    /**
     * 手动创建Observable示例
     */
    @objc private func createObservableExample() {
        showResult("创建Observable示例:\n")

        let observable = Observable<String>.create { observer in
            observer.onNext("第一个元素")
            observer.onNext("第二个元素")
            observer.onNext("第三个元素")
            observer.onCompleted()
            return Disposables.create()
        }

        observable
            .subscribe(
                onNext: { value in
                    self.appendToResult("接收到值: \(value)")
                },
                onError: { error in
                    self.appendToResult("发生错误: \(error)")
                },
                onCompleted: {
                    self.appendToResult("序列完成")
                }
            )
            .disposed(by: disposeBag)
    }

    /**
     * 从数组创建Observable示例
     */
    @objc private func fromArrayExample() {
        showResult("从数组创建Observable:\n")

        let numbers = [1, 2, 3, 4, 5]

        Observable.from(numbers)
            .subscribe(onNext: { number in
                self.appendToResult("数组元素: \(number)")
            })
            .disposed(by: disposeBag)
    }

    /**
     * 定时器Observable示例
     */
    @objc private func intervalExample() {
        showResult("定时器Observable (5秒):\n")

        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(5)
            .subscribe(onNext: { count in
                self.appendToResult("定时器: \(count)")
            }, onCompleted: {
                self.appendToResult("定时器完成")
            })
            .disposed(by: disposeBag)
    }

    /**
     * 错误处理示例
     */
    @objc private func errorHandlingExample() {
        showResult("错误处理示例:\n")

        enum CustomError: Error {
            case sampleError
        }

        let observable = Observable<String>.create { observer in
            observer.onNext("正常数据")
            observer.onError(CustomError.sampleError)
            return Disposables.create()
        }

        observable
            .catch { error in
                self.appendToResult("捕获到错误: \(error)")
                return Observable.just("错误恢复数据")
            }
            .subscribe(onNext: { value in
                self.appendToResult("接收: \(value)")
            })
            .disposed(by: disposeBag)
    }

    /**
     * 显示生态库示例页面
     */
    @objc private func showEcosystemExample() {
        let ecosystemVc = RxEcosystemViewController()
        navigationController?.pushViewController(ecosystemVc, animated: true)
    }
}

// MARK: - Subject 示例
extension RxSwiftViewController {

    /**
     * PublishSubject示例
     */
    @objc private func publishSubjectExample() {
        showResult("PublishSubject示例:\n")

        let subject = PublishSubject<String>()

        appendToResult("发送值: A")
        subject.onNext("A")

        subject
            .subscribe(onNext: { value in
                self.appendToResult("订阅者1收到: \(value)")
            })
            .disposed(by: disposeBag)

        appendToResult("发送值: B")
        subject.onNext("B")

        subject
            .subscribe(onNext: { value in
                self.appendToResult("订阅者2收到: \(value)")
            })
            .disposed(by: disposeBag)

        appendToResult("发送值: C")
        subject.onNext("C")
    }

    /**
     * BehaviorSubject示例
     */
    @objc private func behaviorSubjectExample() {
        showResult("BehaviorSubject示例:\n")

        let subject = BehaviorSubject<String>(value: "初始值")

        subject
            .subscribe(onNext: { value in
                self.appendToResult("订阅者1收到: \(value)")
            })
            .disposed(by: disposeBag)

        appendToResult("发送值: 新值1")
        subject.onNext("新值1")

        subject
            .subscribe(onNext: { value in
                self.appendToResult("订阅者2收到: \(value)")
            })
            .disposed(by: disposeBag)

        appendToResult("发送值: 新值2")
        subject.onNext("新值2")
    }

    /**
     * ReplaySubject示例
     */
    @objc private func replaySubjectExample() {
        showResult("ReplaySubject示例 (缓存2个值):\n")

        let subject = ReplaySubject<String>.create(bufferSize: 2)

        appendToResult("发送值: A, B, C")
        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")

        subject
            .subscribe(onNext: { value in
                self.appendToResult("新订阅者收到: \(value)")
            })
            .disposed(by: disposeBag)

        appendToResult("发送值: D")
        subject.onNext("D")
    }
}

// MARK: - 操作符示例
extension RxSwiftViewController {

    /**
     * Map操作符示例
     */
    @objc private func mapOperatorExample() {
        showResult("Map操作符示例:\n")

        Observable.from([1, 2, 3, 4, 5])
            .map { $0 * 2 }
            .subscribe(onNext: { value in
                self.appendToResult("原值*2 = \(value)")
            })
            .disposed(by: disposeBag)
    }

    /**
     * Filter操作符示例
     */
    @objc private func filterOperatorExample() {
        showResult("Filter操作符示例:\n")

        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { value in
                self.appendToResult("偶数: \(value)")
            })
            .disposed(by: disposeBag)
    }

    /**
     * CombineLatest操作符示例
     */
    @objc private func combineLatestExample() {
        showResult("CombineLatest操作符示例:\n")

        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<Int>()

        Observable.combineLatest(subject1, subject2) { string, number in
            return "\(string): \(number)"
        }
        .subscribe(onNext: { combined in
            self.appendToResult("组合结果: \(combined)")
        })
        .disposed(by: disposeBag)

        appendToResult("发送: subject1='A'")
        subject1.onNext("A")

        appendToResult("发送: subject2=1")
        subject2.onNext(1)

        appendToResult("发送: subject1='B'")
        subject1.onNext("B")

        appendToResult("发送: subject2=2")
        subject2.onNext(2)
    }

    /**
     * Merge操作符示例
     */
    @objc private func mergeExample() {
        showResult("Merge操作符示例:\n")

        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()

        Observable.merge(subject1, subject2)
            .subscribe(onNext: { value in
                self.appendToResult("合并结果: \(value)")
            })
            .disposed(by: disposeBag)

        appendToResult("subject1发送: A")
        subject1.onNext("A")

        appendToResult("subject2发送: 1")
        subject2.onNext("1")

        appendToResult("subject1发送: B")
        subject1.onNext("B")

        appendToResult("subject2发送: 2")
        subject2.onNext("2")
    }
}

// MARK: - UI绑定和网络示例
extension RxSwiftViewController {

    /**
     * 增加计数器
     */
    @objc private func incrementCounter() {
        if let currentValue = try? counterSubject.value() {
            counterSubject.onNext(currentValue + 1)
        }
    }

    /**
     * 减少计数器
     */
    @objc private func decrementCounter() {
        if let currentValue = try? counterSubject.value() {
            counterSubject.onNext(currentValue - 1)
        }
    }

    /**
     * RxSwift网络请求示例
     */
    @objc private func rxNetworkExample() {
        showResult("RxSwift网络请求示例:\n")

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            appendToResult("URL无效")
            return
        }

        URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data -> String in
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    return String(data: jsonData, encoding: .utf8) ?? "解析失败"
                }
                return "数据解析失败"
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { jsonString in
                    self.appendToResult("网络请求成功:")
                    self.appendToResult(jsonString)
                },
                onError: { error in
                    self.appendToResult("网络请求失败: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - 辅助方法
extension RxSwiftViewController {

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