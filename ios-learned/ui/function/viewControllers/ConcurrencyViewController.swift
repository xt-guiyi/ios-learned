import UIKit
import SnapKit

/// 并发、多线程示例页面
/// 展示从传统到现代的各种并发编程方式：Thread、NSOperation、GCD、async/await
class ConcurrencyViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // 传统线程部分
    private let threadContainer = UIView()
    private let threadLabel = UILabel()
    private let threadStartButton = UIButton()
    private let threadStopButton = UIButton()
    private let threadResultLabel = UILabel()
    private var customThread: Thread?

    // NSOperation 部分
    private let operationContainer = UIView()
    private let operationLabel = UILabel()
    private let operationStartButton = UIButton()
    private let operationCancelButton = UIButton()
    private let operationResultLabel = UILabel()
    private let operationQueue = OperationQueue()

    // GCD 部分
    private let gcdContainer = UIView()
    private let gcdLabel = UILabel()
    private let serialQueueButton = UIButton()
    private let concurrentQueueButton = UIButton()
    private let mainQueueButton = UIButton()
    private let delayedTaskButton = UIButton()
    private let barrierTaskButton = UIButton()
    private let gcdResultTextView = UITextView()

    // async/await 部分 (iOS 13+)
    private let asyncContainer = UIView()
    private let asyncLabel = UILabel()
    private let asyncTaskButton = UIButton()
    private let asyncSeriesButton = UIButton()
    private let asyncParallelButton = UIButton()
    private let asyncResultTextView = UITextView()

    // 线程安全演示
    private let threadSafetyContainer = UIView()
    private let threadSafetyLabel = UILabel()
    private let raceConditionButton = UIButton()
    private let lockedTaskButton = UIButton()
    private let threadSafetyResultLabel = UILabel()

    // Objective-C 不支持的特性
    private let objcLimitationsContainer = UIView()
    private let objcLimitationsLabel = UILabel()
    private let objcLimitationsTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupScrollView()
        setupThreadSection()
        setupOperationSection()
        setupGCDSection()
        setupAsyncAwaitSection()
        setupThreadSafetySection()
        setupObjcLimitationsSection()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "并发、多线程") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置滚动视图
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    /// 设置传统线程部分
    private func setupThreadSection() {
        threadContainer.backgroundColor = .systemGray6
        threadContainer.layer.cornerRadius = 12
        contentView.addSubview(threadContainer)

        threadLabel.text = "🧵 传统 Thread (iOS 2.0+)\n最早的多线程实现方式，需要手动管理线程生命周期"
        threadLabel.font = .boldSystemFont(ofSize: 16)
        threadLabel.textColor = .themeColor
        threadLabel.numberOfLines = 0

        threadStartButton.setTitle("启动线程", for: .normal)
        threadStartButton.backgroundColor = .themeColor
        threadStartButton.setTitleColor(.white, for: .normal)
        threadStartButton.layer.cornerRadius = 8
        threadStartButton.addTarget(self, action: #selector(startThread), for: .touchUpInside)

        threadStopButton.setTitle("停止线程", for: .normal)
        threadStopButton.backgroundColor = .systemRed
        threadStopButton.setTitleColor(.white, for: .normal)
        threadStopButton.layer.cornerRadius = 8
        threadStopButton.addTarget(self, action: #selector(stopThread), for: .touchUpInside)

        threadResultLabel.text = "线程状态：未启动"
        threadResultLabel.font = .systemFont(ofSize: 14)
        threadResultLabel.numberOfLines = 0

        [threadLabel, threadStartButton, threadStopButton, threadResultLabel].forEach {
            threadContainer.addSubview($0)
        }

        threadContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        threadLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        threadStartButton.snp.makeConstraints { make in
            make.top.equalTo(threadLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        threadStopButton.snp.makeConstraints { make in
            make.top.equalTo(threadLabel.snp.bottom).offset(12)
            make.left.equalTo(threadStartButton.snp.right).offset(12)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        threadResultLabel.snp.makeConstraints { make in
            make.top.equalTo(threadStartButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置 NSOperation 部分
    private func setupOperationSection() {
        operationContainer.backgroundColor = .systemGray6
        operationContainer.layer.cornerRadius = 12
        contentView.addSubview(operationContainer)

        operationLabel.text = "⚙️ NSOperation & NSOperationQueue (iOS 2.0+)\n基于 Objective-C 的高级抽象，支持任务依赖和取消"
        operationLabel.font = .boldSystemFont(ofSize: 16)
        operationLabel.textColor = .themeColor
        operationLabel.numberOfLines = 0

        operationStartButton.setTitle("执行操作", for: .normal)
        operationStartButton.backgroundColor = .themeColor
        operationStartButton.setTitleColor(.white, for: .normal)
        operationStartButton.layer.cornerRadius = 8
        operationStartButton.addTarget(self, action: #selector(startOperation), for: .touchUpInside)

        operationCancelButton.setTitle("取消所有", for: .normal)
        operationCancelButton.backgroundColor = .systemRed
        operationCancelButton.setTitleColor(.white, for: .normal)
        operationCancelButton.layer.cornerRadius = 8
        operationCancelButton.addTarget(self, action: #selector(cancelOperations), for: .touchUpInside)

        operationResultLabel.text = "操作状态：等待中"
        operationResultLabel.font = .systemFont(ofSize: 14)
        operationResultLabel.numberOfLines = 0

        [operationLabel, operationStartButton, operationCancelButton, operationResultLabel].forEach {
            operationContainer.addSubview($0)
        }

        operationContainer.snp.makeConstraints { make in
            make.top.equalTo(threadContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        operationLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        operationStartButton.snp.makeConstraints { make in
            make.top.equalTo(operationLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        operationCancelButton.snp.makeConstraints { make in
            make.top.equalTo(operationLabel.snp.bottom).offset(12)
            make.left.equalTo(operationStartButton.snp.right).offset(12)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        operationResultLabel.snp.makeConstraints { make in
            make.top.equalTo(operationStartButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置 GCD 部分
    private func setupGCDSection() {
        gcdContainer.backgroundColor = .systemGray6
        gcdContainer.layer.cornerRadius = 12
        contentView.addSubview(gcdContainer)

        gcdLabel.text = "🚀 Grand Central Dispatch (iOS 4.0+)\nApple 推荐的现代并发解决方案，基于 C 语言，性能优异"
        gcdLabel.font = .boldSystemFont(ofSize: 16)
        gcdLabel.textColor = .themeColor
        gcdLabel.numberOfLines = 0

        serialQueueButton.setTitle("串行队列", for: .normal)
        serialQueueButton.backgroundColor = .systemBlue
        serialQueueButton.setTitleColor(.white, for: .normal)
        serialQueueButton.layer.cornerRadius = 6
        serialQueueButton.addTarget(self, action: #selector(testSerialQueue), for: .touchUpInside)

        concurrentQueueButton.setTitle("并发队列", for: .normal)
        concurrentQueueButton.backgroundColor = .systemGreen
        concurrentQueueButton.setTitleColor(.white, for: .normal)
        concurrentQueueButton.layer.cornerRadius = 6
        concurrentQueueButton.addTarget(self, action: #selector(testConcurrentQueue), for: .touchUpInside)

        mainQueueButton.setTitle("主队列", for: .normal)
        mainQueueButton.backgroundColor = .systemOrange
        mainQueueButton.setTitleColor(.white, for: .normal)
        mainQueueButton.layer.cornerRadius = 6
        mainQueueButton.addTarget(self, action: #selector(testMainQueue), for: .touchUpInside)

        delayedTaskButton.setTitle("延时任务", for: .normal)
        delayedTaskButton.backgroundColor = .systemPurple
        delayedTaskButton.setTitleColor(.white, for: .normal)
        delayedTaskButton.layer.cornerRadius = 6
        delayedTaskButton.addTarget(self, action: #selector(testDelayedTask), for: .touchUpInside)

        barrierTaskButton.setTitle("栅栏任务", for: .normal)
        barrierTaskButton.backgroundColor = .systemTeal
        barrierTaskButton.setTitleColor(.white, for: .normal)
        barrierTaskButton.layer.cornerRadius = 6
        barrierTaskButton.addTarget(self, action: #selector(testBarrierTask), for: .touchUpInside)

        gcdResultTextView.text = "GCD 执行结果将在这里显示...\n"
        gcdResultTextView.font = .systemFont(ofSize: 12)
        gcdResultTextView.isEditable = false
        gcdResultTextView.layer.borderColor = UIColor.systemGray4.cgColor
        gcdResultTextView.layer.borderWidth = 1
        gcdResultTextView.layer.cornerRadius = 8

        [gcdLabel, serialQueueButton, concurrentQueueButton, mainQueueButton,
         delayedTaskButton, barrierTaskButton, gcdResultTextView].forEach {
            gcdContainer.addSubview($0)
        }

        gcdContainer.snp.makeConstraints { make in
            make.top.equalTo(operationContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        gcdLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        serialQueueButton.snp.makeConstraints { make in
            make.top.equalTo(gcdLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }

        concurrentQueueButton.snp.makeConstraints { make in
            make.top.equalTo(gcdLabel.snp.bottom).offset(12)
            make.left.equalTo(serialQueueButton.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }

        mainQueueButton.snp.makeConstraints { make in
            make.top.equalTo(gcdLabel.snp.bottom).offset(12)
            make.left.equalTo(concurrentQueueButton.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }

        delayedTaskButton.snp.makeConstraints { make in
            make.top.equalTo(serialQueueButton.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }

        barrierTaskButton.snp.makeConstraints { make in
            make.top.equalTo(serialQueueButton.snp.bottom).offset(8)
            make.left.equalTo(delayedTaskButton.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }

        gcdResultTextView.snp.makeConstraints { make in
            make.top.equalTo(delayedTaskButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }

    /// 设置 async/await 部分
    private func setupAsyncAwaitSection() {
        asyncContainer.backgroundColor = .systemGray6
        asyncContainer.layer.cornerRadius = 12
        contentView.addSubview(asyncContainer)

        asyncLabel.text = "✨ async/await (iOS 13+)\n现代 Swift 并发：结构化并发，更安全、更易读的异步代码"
        asyncLabel.font = .boldSystemFont(ofSize: 16)
        asyncLabel.textColor = .themeColor
        asyncLabel.numberOfLines = 0

        asyncTaskButton.setTitle("异步任务", for: .normal)
        asyncTaskButton.backgroundColor = .systemIndigo
        asyncTaskButton.setTitleColor(.white, for: .normal)
        asyncTaskButton.layer.cornerRadius = 6
        asyncTaskButton.addTarget(self, action: #selector(testAsyncTask), for: .touchUpInside)

        asyncSeriesButton.setTitle("串行执行", for: .normal)
        asyncSeriesButton.backgroundColor = .systemPink
        asyncSeriesButton.setTitleColor(.white, for: .normal)
        asyncSeriesButton.layer.cornerRadius = 6
        asyncSeriesButton.addTarget(self, action: #selector(testAsyncSeries), for: .touchUpInside)

        asyncParallelButton.setTitle("并行执行", for: .normal)
        asyncParallelButton.backgroundColor = .systemCyan
        asyncParallelButton.setTitleColor(.white, for: .normal)
        asyncParallelButton.layer.cornerRadius = 6
        asyncParallelButton.addTarget(self, action: #selector(testAsyncParallel), for: .touchUpInside)

        asyncResultTextView.text = "async/await 执行结果将在这里显示...\n"
        asyncResultTextView.font = .systemFont(ofSize: 12)
        asyncResultTextView.isEditable = false
        asyncResultTextView.layer.borderColor = UIColor.systemGray4.cgColor
        asyncResultTextView.layer.borderWidth = 1
        asyncResultTextView.layer.cornerRadius = 8

        [asyncLabel, asyncTaskButton, asyncSeriesButton, asyncParallelButton, asyncResultTextView].forEach {
            asyncContainer.addSubview($0)
        }

        asyncContainer.snp.makeConstraints { make in
            make.top.equalTo(gcdContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        asyncLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        asyncTaskButton.snp.makeConstraints { make in
            make.top.equalTo(asyncLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(32)
        }

        asyncSeriesButton.snp.makeConstraints { make in
            make.top.equalTo(asyncLabel.snp.bottom).offset(12)
            make.left.equalTo(asyncTaskButton.snp.right).offset(8)
            make.width.equalTo(80)
            make.height.equalTo(32)
        }

        asyncParallelButton.snp.makeConstraints { make in
            make.top.equalTo(asyncLabel.snp.bottom).offset(12)
            make.left.equalTo(asyncSeriesButton.snp.right).offset(8)
            make.width.equalTo(80)
            make.height.equalTo(32)
        }

        asyncResultTextView.snp.makeConstraints { make in
            make.top.equalTo(asyncTaskButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }

    /// 设置线程安全演示部分
    private func setupThreadSafetySection() {
        threadSafetyContainer.backgroundColor = .systemGray6
        threadSafetyContainer.layer.cornerRadius = 12
        contentView.addSubview(threadSafetyContainer)

        threadSafetyLabel.text = "🔒 线程安全演示\n竞态条件 vs 线程同步：展示多线程访问共享资源的问题和解决方案"
        threadSafetyLabel.font = .boldSystemFont(ofSize: 16)
        threadSafetyLabel.textColor = .themeColor
        threadSafetyLabel.numberOfLines = 0

        raceConditionButton.setTitle("竞态条件", for: .normal)
        raceConditionButton.backgroundColor = .systemRed
        raceConditionButton.setTitleColor(.white, for: .normal)
        raceConditionButton.layer.cornerRadius = 8
        raceConditionButton.addTarget(self, action: #selector(demonstrateRaceCondition), for: .touchUpInside)

        lockedTaskButton.setTitle("线程同步", for: .normal)
        lockedTaskButton.backgroundColor = .themeColor
        lockedTaskButton.setTitleColor(.white, for: .normal)
        lockedTaskButton.layer.cornerRadius = 8
        lockedTaskButton.addTarget(self, action: #selector(demonstrateThreadSafety), for: .touchUpInside)

        threadSafetyResultLabel.text = "点击按钮查看线程安全演示结果"
        threadSafetyResultLabel.font = .systemFont(ofSize: 14)
        threadSafetyResultLabel.numberOfLines = 0

        [threadSafetyLabel, raceConditionButton, lockedTaskButton, threadSafetyResultLabel].forEach {
            threadSafetyContainer.addSubview($0)
        }

        threadSafetyContainer.snp.makeConstraints { make in
            make.top.equalTo(asyncContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        threadSafetyLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        raceConditionButton.snp.makeConstraints { make in
            make.top.equalTo(threadSafetyLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        lockedTaskButton.snp.makeConstraints { make in
            make.top.equalTo(threadSafetyLabel.snp.bottom).offset(12)
            make.left.equalTo(raceConditionButton.snp.right).offset(12)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        threadSafetyResultLabel.snp.makeConstraints { make in
            make.top.equalTo(raceConditionButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置 Objective-C 不支持的特性部分
    private func setupObjcLimitationsSection() {
        objcLimitationsContainer.backgroundColor = .systemGray6
        objcLimitationsContainer.layer.cornerRadius = 12
        contentView.addSubview(objcLimitationsContainer)

        objcLimitationsLabel.text = "⚠️ Objective-C 不支持的并发特性\n以下是 Swift 独有的现代并发特性"
        objcLimitationsLabel.font = .boldSystemFont(ofSize: 16)
        objcLimitationsLabel.textColor = .systemOrange
        objcLimitationsLabel.numberOfLines = 0

        let limitationsText = """
Swift 独有的并发特性（Objective-C 不支持）：

1. async/await 语法
   func fetchData() async -> String {
       return await networkCall()
   }

2. Actor 类型（防止数据竞争）
   actor DataManager {
       private var data: [String] = []
       func addData(_ item: String) {
           data.append(item)
       }
   }

3. 结构化并发 (Task)
   Task {
       async let result1 = fetchData1()
       async let result2 = fetchData2()
       let combined = await [result1, result2]
   }

4. TaskGroup 并行处理
   await withTaskGroup(of: String.self) { group in
       for i in 1...5 {
           group.addTask {
               return await processItem(i)
           }
       }
   }

5. @MainActor 标记
   @MainActor
   class ViewController: UIViewController {
       func updateUI() {
           // 自动在主线程执行
       }
   }

6. Sendable 协议（编译时线程安全检查）
   struct SafeData: Sendable {
       let value: Int
   }

7. AsyncSequence 异步序列
   for await item in asyncSequence {
       process(item)
   }

8. 值类型的天然线程安全
   struct ThreadSafeCounter {
       private(set) var count = 0
       mutating func increment() {
           count += 1
       }
   }

9. TaskLocal 任务本地存储
   enum TaskContext {
       @TaskLocal static var userID: String?
   }

10. 编译时并发检查
    Swift 编译器会检查并发安全性
    Objective-C 只能在运行时发现问题

总结：
✅ Swift：编译时安全 + 现代异步语法
❌ Objective-C：只能使用传统多线程技术
"""

        objcLimitationsTextView.text = limitationsText
        objcLimitationsTextView.font = .systemFont(ofSize: 12)
        objcLimitationsTextView.isEditable = false
        objcLimitationsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        objcLimitationsTextView.layer.borderWidth = 1
        objcLimitationsTextView.layer.cornerRadius = 8
        objcLimitationsTextView.backgroundColor = .systemBackground

        [objcLimitationsLabel, objcLimitationsTextView].forEach {
            objcLimitationsContainer.addSubview($0)
        }

        objcLimitationsContainer.snp.makeConstraints { make in
            make.top.equalTo(threadSafetyContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }

        objcLimitationsLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        objcLimitationsTextView.snp.makeConstraints { make in
            make.top.equalTo(objcLimitationsLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(400)
        }
    }

    // MARK: - 传统线程方法

    /// 启动传统线程
    @objc private func startThread() {
        customThread = Thread(target: self, selector: #selector(threadTask), object: nil)
        customThread?.name = "CustomThread"
        customThread?.start()

        DispatchQueue.main.async {
            self.threadResultLabel.text = "线程状态：已启动，正在执行任务..."
        }
    }

    /// 线程执行的任务
    @objc private func threadTask() {
        for i in 1...5 {
            Thread.sleep(forTimeInterval: 1)

            DispatchQueue.main.async {
                self.threadResultLabel.text = "线程状态：执行中 (\(i)/5)\n线程名：\(Thread.current.name ?? "Unknown")"
            }

            if Thread.current.isCancelled {
                DispatchQueue.main.async {
                    self.threadResultLabel.text = "线程状态：已取消"
                }
                return
            }
        }

        DispatchQueue.main.async {
            self.threadResultLabel.text = "线程状态：执行完成\n说明：Thread 需要手动管理生命周期"
        }
    }

    /// 停止线程
    @objc private func stopThread() {
        customThread?.cancel()
        threadResultLabel.text = "线程状态：请求取消（需要线程自行检查）"
    }

    // MARK: - NSOperation 方法

    /// 启动 NSOperation
    @objc private func startOperation() {
        let operation1 = CustomOperation(name: "操作1", duration: 2)
        let operation2 = CustomOperation(name: "操作2", duration: 1)
        let operation3 = CustomOperation(name: "操作3", duration: 3)

        // 设置依赖关系
        operation3.addDependency(operation1)
        operation3.addDependency(operation2)

        operation1.completionBlock = {
            DispatchQueue.main.async {
                self.operationResultLabel.text = "操作1 完成"
            }
        }

        operation2.completionBlock = {
            DispatchQueue.main.async {
                self.operationResultLabel.text = "操作2 完成"
            }
        }

        operation3.completionBlock = {
            DispatchQueue.main.async {
                self.operationResultLabel.text = "所有操作完成！\n说明：NSOperation 支持依赖关系和优先级"
            }
        }

        operationQueue.addOperations([operation1, operation2, operation3], waitUntilFinished: false)
        operationResultLabel.text = "操作状态：已添加到队列，按依赖关系执行"
    }

    /// 取消所有操作
    @objc private func cancelOperations() {
        operationQueue.cancelAllOperations()
        operationResultLabel.text = "操作状态：已取消所有操作"
    }

    // MARK: - GCD 方法

    /// 测试串行队列
    @objc private func testSerialQueue() {
        let serialQueue = DispatchQueue(label: "com.app.serialQueue")
        appendToGCDResult("🔄 串行队列测试开始")

        for i in 1...3 {
            serialQueue.async {
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.appendToGCDResult("串行任务 \(i) 完成 - 线程：\(Thread.current)")
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.appendToGCDResult("串行队列：任务按顺序执行\n")
        }
    }

    /// 测试并发队列
    @objc private func testConcurrentQueue() {
        let concurrentQueue = DispatchQueue(label: "com.app.concurrentQueue", attributes: .concurrent)
        appendToGCDResult("⚡ 并发队列测试开始")

        for i in 1...3 {
            concurrentQueue.async {
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.appendToGCDResult("并发任务 \(i) 完成 - 线程：\(Thread.current)")
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appendToGCDResult("并发队列：任务同时执行\n")
        }
    }

    /// 测试主队列
    @objc private func testMainQueue() {
        appendToGCDResult("🎯 主队列测试开始")

        DispatchQueue.global().async {
            // 后台任务
            Thread.sleep(forTimeInterval: 1)

            DispatchQueue.main.async {
                self.appendToGCDResult("回到主队列更新UI - 线程：\(Thread.current)")
                self.appendToGCDResult("主队列：用于UI更新\n")
            }
        }
    }

    /// 测试延时任务
    @objc private func testDelayedTask() {
        appendToGCDResult("⏰ 延时任务测试开始")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appendToGCDResult("延时任务执行 - 2秒后")
            self.appendToGCDResult("用于延迟执行任务\n")
        }
    }

    /// 测试栅栏任务
    @objc private func testBarrierTask() {
        let concurrentQueue = DispatchQueue(label: "com.app.barrierQueue", attributes: .concurrent)
        appendToGCDResult("🚧 栅栏任务测试开始")

        // 前置任务
        for i in 1...2 {
            concurrentQueue.async {
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.appendToGCDResult("前置任务 \(i) 完成")
                }
            }
        }

        // 栅栏任务
        concurrentQueue.async(flags: .barrier) {
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.appendToGCDResult("栅栏任务完成（等待前面任务）")
            }
        }

        // 后续任务
        for i in 1...2 {
            concurrentQueue.async {
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.appendToGCDResult("后续任务 \(i) 完成")
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.appendToGCDResult("栅栏：确保任务执行顺序\n")
        }
    }

    /// 添加 GCD 结果到文本框
    private func appendToGCDResult(_ text: String) {
        let currentText = gcdResultTextView.text ?? ""
        gcdResultTextView.text = currentText + "\(text)\n"

        // 自动滚动到底部
        let bottom = NSMakeRange(gcdResultTextView.text.count - 1, 1)
        gcdResultTextView.scrollRangeToVisible(bottom)
    }

    // MARK: - async/await 方法

    /// 测试异步任务
    @objc private func testAsyncTask() {
        appendToAsyncResult("✨ 异步任务测试开始")

        Task {
            let result = await performAsyncTask(name: "异步任务", duration: 2)
            await MainActor.run {
                self.appendToAsyncResult("异步任务完成：\(result)")
                self.appendToAsyncResult("async/await：现代异步编程\n")
            }
        }
    }

    /// 测试串行执行
    @objc private func testAsyncSeries() {
        appendToAsyncResult("🔗 串行执行测试开始")

        Task {
            let startTime = Date()

            let result1 = await performAsyncTask(name: "任务1", duration: 1)
            let result2 = await performAsyncTask(name: "任务2", duration: 1)
            let result3 = await performAsyncTask(name: "任务3", duration: 1)

            let duration = Date().timeIntervalSince(startTime)

            await MainActor.run {
                self.appendToAsyncResult("串行结果：\(result1), \(result2), \(result3)")
                self.appendToAsyncResult("总耗时：\(String(format: "%.1f", duration))秒\n")
            }
        }
    }

    /// 测试并行执行
    @objc private func testAsyncParallel() {
        appendToAsyncResult("⚡ 并行执行测试开始")

        Task {
            let startTime = Date()

            async let result1 = performAsyncTask(name: "任务1", duration: 1)
            async let result2 = performAsyncTask(name: "任务2", duration: 1)
            async let result3 = performAsyncTask(name: "任务3", duration: 1)

            let results = await [result1, result2, result3]
            let duration = Date().timeIntervalSince(startTime)

            await MainActor.run {
                self.appendToAsyncResult("并行结果：\(results.joined(separator: ", "))")
                self.appendToAsyncResult("总耗时：\(String(format: "%.1f", duration))秒")
                self.appendToAsyncResult("并行比串行快3倍！\n")
            }
        }
    }

    /// 执行异步任务
    private func performAsyncTask(name: String, duration: TimeInterval) async -> String {
        do {
            try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
        } catch {
            // 处理可能的取消或其他错误
            print("任务被取消或出错: \(error)")
        }
        return "\(name)完成"
    }

    /// 添加 async 结果到文本框
    private func appendToAsyncResult(_ text: String) {
        let currentText = asyncResultTextView.text ?? ""
        asyncResultTextView.text = currentText + "\(text)\n"

        // 自动滚动到底部
        let bottom = NSMakeRange(asyncResultTextView.text.count - 1, 1)
        asyncResultTextView.scrollRangeToVisible(bottom)
    }

    // MARK: - 线程安全演示

    private var unsafeCounter = 0
    private var safeCounter = 0
    private let counterLock = NSLock()

    /// 演示竞态条件
    @objc private func demonstrateRaceCondition() {
        unsafeCounter = 0
        let iterations = 1000

        threadSafetyResultLabel.text = "测试竞态条件中..."

        DispatchQueue.global().async {
            for _ in 0..<iterations {
                self.incrementUnsafeCounter()
            }
        }

        DispatchQueue.global().async {
            for _ in 0..<iterations {
                self.incrementUnsafeCounter()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.threadSafetyResultLabel.text = """
            竞态条件结果：
            期望值：\(iterations * 2)
            实际值：\(self.unsafeCounter)
            数据丢失：\(iterations * 2 - self.unsafeCounter)

            说明：多线程同时访问共享变量导致数据不一致
            """
        }
    }

    /// 演示线程安全
    @objc private func demonstrateThreadSafety() {
        safeCounter = 0
        let iterations = 1000

        threadSafetyResultLabel.text = "测试线程同步中..."

        DispatchQueue.global().async {
            for _ in 0..<iterations {
                self.incrementSafeCounter()
            }
        }

        DispatchQueue.global().async {
            for _ in 0..<iterations {
                self.incrementSafeCounter()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.threadSafetyResultLabel.text = """
            线程同步结果：
            期望值：\(iterations * 2)
            实际值：\(self.safeCounter)
            数据一致：✅

            说明：使用锁确保线程安全访问
            """
        }
    }

    /// 不安全的计数器递增
    private func incrementUnsafeCounter() {
        let temp = unsafeCounter
        Thread.sleep(forTimeInterval: 0.0001) // 模拟处理时间
        unsafeCounter = temp + 1
    }

    /// 安全的计数器递增
    private func incrementSafeCounter() {
        counterLock.lock()
        let temp = safeCounter
        Thread.sleep(forTimeInterval: 0.0001) // 模拟处理时间
        safeCounter = temp + 1
        counterLock.unlock()
    }
}

// MARK: - 自定义 NSOperation
class CustomOperation: Operation {
    private let duration: TimeInterval

    init(name: String, duration: TimeInterval) {
        self.duration = duration
        super.init()
        self.name = name
    }

    override func main() {
        if isCancelled { return }

        Thread.sleep(forTimeInterval: duration)

        if isCancelled { return }

        print("✅ \(name ?? "Unknown") 执行完成")
    }
}