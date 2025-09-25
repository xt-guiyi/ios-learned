//
//  DataPassingViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

protocol DataPassingDelegate: AnyObject {
    func didReceiveData(_ data: String)
}

class DataPassingViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var listViewController: CardListViewController?
    private let receivedDataLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置UI界面
    private func setupUI() {
        setupNavigationBar()
        setupReceivedDataLabel()
        setupListViewController()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "数据传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置接收数据显示标签
    private func setupReceivedDataLabel() {
        receivedDataLabel.text = "接收到的数据将显示在这里"
        receivedDataLabel.font = UIFont.systemFont(ofSize: 16)
        receivedDataLabel.textColor = UIColor.themeColor
        receivedDataLabel.textAlignment = .center
        receivedDataLabel.numberOfLines = 0
        receivedDataLabel.backgroundColor = UIColor.themeColor.withAlphaComponent(0.1)
        receivedDataLabel.layer.cornerRadius = 8
        receivedDataLabel.layer.masksToBounds = true

        view.addSubview(receivedDataLabel)
        receivedDataLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }

    /// 设置数据传值示例列表
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller

        let dataPassingData = [
            ListItemModel(title: "属性传值", subtitle: "通过属性直接传递数据") { [weak self] in
                self?.showPropertyPassing()
            },
            ListItemModel(title: "构造器传值", subtitle: "通过初始化方法传递数据") { [weak self] in
                self?.showInitializerPassing()
            },
            ListItemModel(title: "代理传值", subtitle: "通过Delegate模式传递数据") { [weak self] in
                self?.showDelegatePassing()
            },
            ListItemModel(title: "闭包传值", subtitle: "通过Closure回调传递数据") { [weak self] in
                self?.showClosurePassing()
            },
            ListItemModel(title: "通知传值", subtitle: "通过NotificationCenter传递数据") { [weak self] in
                self?.showNotificationPassing()
            },
            ListItemModel(title: "单例传值", subtitle: "通过Singleton模式传递数据") { [weak self] in
                self?.showSingletonPassing()
            }
        ]

        controller.updateData(dataPassingData)

        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.receivedDataLabel.snp.bottom).offset(20)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - 数据传值方法

    /// 属性传值示例
    private func showPropertyPassing() {
        let detailVc = PropertyPassingViewController()
        detailVc.passedData = "通过属性传递的数据：当前时间 \(Date())"
        navigationController?.pushViewController(detailVc, animated: true)
    }

    /// 构造器传值示例
    private func showInitializerPassing() {
        let detailVc = InitializerPassingViewController(data: "通过构造器传递的数据：随机数 \(Int.random(in: 1...100))")
        navigationController?.pushViewController(detailVc, animated: true)
    }

    /// 代理传值示例
    private func showDelegatePassing() {
        let detailVc = DelegatePassingViewController()
        detailVc.delegate = self
        navigationController?.pushViewController(detailVc, animated: true)
    }

    /// 闭包传值示例
    private func showClosurePassing() {
        let detailVc = ClosurePassingViewController()
        detailVc.dataCallback = { [weak self] data in
            DispatchQueue.main.async {
                self?.receivedDataLabel.text = "闭包回调接收到的数据：\(data)"
            }
        }
        navigationController?.pushViewController(detailVc, animated: true)
    }

    /// 通知传值示例
    private func showNotificationPassing() {
        // 监听通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveNotificationData(_:)),
            name: NSNotification.Name("DataPassingNotification"),
            object: nil
        )

        let detailVc = NotificationPassingViewController()
        navigationController?.pushViewController(detailVc, animated: true)
    }

    /// 单例传值示例
    private func showSingletonPassing() {
        let detailVc = SingletonPassingViewController()
        detailVc.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                let data = DataManager.shared.getData()
                self?.receivedDataLabel.text = "单例传递的数据：\(data)"
            }
        }
        navigationController?.pushViewController(detailVc, animated: true)
    }

    // MARK: - 回调方法

    /// 接收通知数据
    @objc private func didReceiveNotificationData(_ notification: Notification) {
        if let data = notification.userInfo?["data"] as? String {
            receivedDataLabel.text = "通知传递的数据：\(data)"
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - DataPassingDelegate
extension DataPassingViewController: DataPassingDelegate {
    func didReceiveData(_ data: String) {
        receivedDataLabel.text = "代理传递的数据：\(data)"
    }
}

// MARK: - 数据管理单例
class DataManager {
    static let shared = DataManager()
    private init() {}

    private var data: String = "初始数据"

    /// 设置数据
    func setData(_ newData: String) {
        data = newData
    }

    /// 获取数据
    func getData() -> String {
        return data
    }
}

// MARK: - 各种传值方式的详情页面

/// 属性传值页面
class PropertyPassingViewController: BaseViewController {
    var passedData: String = ""
    private let navigationBar = CustomNavigationBar()
    private let dataLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayData()
    }

    private func setupUI() {
        navigationBar.configure(title: "属性传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        dataLabel.font = UIFont.systemFont(ofSize: 16)
        dataLabel.textAlignment = .center
        dataLabel.numberOfLines = 0
        view.addSubview(dataLabel)

        dataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }

    private func displayData() {
        dataLabel.text = passedData
    }
}

/// 构造器传值页面
class InitializerPassingViewController: BaseViewController {
    private let passedData: String
    private let navigationBar = CustomNavigationBar()
    private let dataLabel = UILabel()

    init(data: String) {
        self.passedData = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayData()
    }

    private func setupUI() {
        navigationBar.configure(title: "构造器传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        dataLabel.font = UIFont.systemFont(ofSize: 16)
        dataLabel.textAlignment = .center
        dataLabel.numberOfLines = 0
        view.addSubview(dataLabel)

        dataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }

    private func displayData() {
        dataLabel.text = passedData
    }
}

/// 代理传值页面
class DelegatePassingViewController: BaseViewController {
    weak var delegate: DataPassingDelegate?
    private let navigationBar = CustomNavigationBar()
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.configure(title: "代理传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        sendButton.setTitle("发送数据给代理", for: .normal)
        sendButton.backgroundColor = UIColor.themeColor
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendDataToDelegate), for: .touchUpInside)
        view.addSubview(sendButton)

        sendButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func sendDataToDelegate() {
        let data = "代理数据：\(Date())"
        delegate?.didReceiveData(data)
        navigationController?.popViewController(animated: true)
    }
}

/// 闭包传值页面
class ClosurePassingViewController: BaseViewController {
    var dataCallback: ((String) -> Void)?
    private let navigationBar = CustomNavigationBar()
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.configure(title: "闭包传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        sendButton.setTitle("通过闭包发送数据", for: .normal)
        sendButton.backgroundColor = UIColor.themeColor
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendDataThroughClosure), for: .touchUpInside)
        view.addSubview(sendButton)

        sendButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func sendDataThroughClosure() {
        let data = "闭包数据：\(Date())"
        dataCallback?(data)
        navigationController?.popViewController(animated: true)
    }
}

/// 通知传值页面
class NotificationPassingViewController: BaseViewController {
    private let navigationBar = CustomNavigationBar()
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.configure(title: "通知传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        sendButton.setTitle("通过通知发送数据", for: .normal)
        sendButton.backgroundColor = UIColor.themeColor
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendDataThroughNotification), for: .touchUpInside)
        view.addSubview(sendButton)

        sendButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func sendDataThroughNotification() {
        let data = "通知数据：\(Date())"
        NotificationCenter.default.post(
            name: NSNotification.Name("DataPassingNotification"),
            object: nil,
            userInfo: ["data": data]
        )
        navigationController?.popViewController(animated: true)
    }
}

/// 单例传值页面
class SingletonPassingViewController: BaseViewController {
    var onDataUpdated: (() -> Void)?
    private let navigationBar = CustomNavigationBar()
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.configure(title: "单例传值") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        sendButton.setTitle("通过单例发送数据", for: .normal)
        sendButton.backgroundColor = UIColor.themeColor
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendDataThroughSingleton), for: .touchUpInside)
        view.addSubview(sendButton)

        sendButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc private func sendDataThroughSingleton() {
        let data = "单例数据：\(Date())"
        DataManager.shared.setData(data)
        onDataUpdated?()
        navigationController?.popViewController(animated: true)
    }
}