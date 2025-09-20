//
//  WebViewExampleViewController.swift
//  ios-learned
//
//  Created by Claude on 2025/8/24.
//
import UIKit
import WebKit
import SnapKit

/// WebView控件示例页面
class WebViewExampleViewController: BaseViewController {
    
    private var segmentedControl: UISegmentedControl?
    private var containerView: UIView?
    private var currentViewController: UIViewController?
    private let navigationBar = CustomNavigationBar()
    
    private var viewControllers: [UIViewController] = []
    private let titles = ["基础WebView", "带导航WebView", "进度条WebView", "JavaScriptWebView", "自定义WebView"]
    
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
        navigationBar.configure(title: "WebView控件示例") { [weak self] in
            self?.popViewController()
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
        let segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        self.segmentedControl = segmentedControl

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
            BasicWebViewController(),
            NavigationWebViewController(),
            ProgressWebViewController(),
            JavaScriptWebViewController(),
            CustomWebViewController()
        ]
        
        // 添加所有子控制器
        for controller in viewControllers {
            addChild(controller)
            controller.didMove(toParent: self)
        }
    }
    
    /// 分段控制器改变事件
    @objc private func segmentChanged() {
        guard let segmentedControl = segmentedControl else { return }
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

// MARK: - 基础WebView
class BasicWebViewController: UIViewController {
    
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebsite()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 创建WebView
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        self.webView = webView

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        // 添加标题
        let titleLabel = UILabel()
        titleLabel.text = "基础WebView - 加载苹果官网"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.systemGray6
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        // 调整WebView约束
        webView.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 加载网站
    private func loadWebsite() {
        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
}

// MARK: - 带导航的WebView
class NavigationWebViewController: UIViewController {
    
    private var webView: WKWebView?
    private var backButton: UIButton?
    private var forwardButton: UIButton?
    private var refreshButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebsite()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 创建工具栏
        let toolbar = UIView()
        toolbar.backgroundColor = UIColor.systemGray6
        
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // 创建导航按钮
        let backButton = createToolbarButton(title: "◀", action: #selector(goBack))
        let forwardButton = createToolbarButton(title: "▶", action: #selector(goForward))
        let refreshButton = createToolbarButton(title: "🔄", action: #selector(refresh))

        self.backButton = backButton
        self.forwardButton = forwardButton
        self.refreshButton = refreshButton
        
        let stackView = UIStackView(arrangedSubviews: [backButton, forwardButton, refreshButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        
        toolbar.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 创建WebView
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        self.webView = webView

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(toolbar.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 创建工具栏按钮
    private func createToolbarButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    /// 加载网站
    private func loadWebsite() {
        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
    
    /// 后退
    @objc private func goBack() {
        webView?.goBack()
    }

    /// 前进
    @objc private func goForward() {
        webView?.goForward()
    }

    /// 刷新
    @objc private func refresh() {
        webView?.reload()
    }

    /// 更新按钮状态
    private func updateButtonStates() {
        guard let webView = webView,
              let backButton = backButton,
              let forwardButton = forwardButton else { return }

        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        backButton.alpha = webView.canGoBack ? 1.0 : 0.5
        forwardButton.alpha = webView.canGoForward ? 1.0 : 0.5
    }
}

// MARK: - WKNavigationDelegate for NavigationWebViewController
extension NavigationWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateButtonStates()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateButtonStates()
    }
}

// MARK: - 带进度条的WebView
class ProgressWebViewController: UIViewController {
    
    private var webView: WKWebView?
    private var progressView: UIProgressView?
    private var urlLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebsite()
        setupObservers()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 创建URL标签
        let urlLabel = UILabel()
        urlLabel.text = "正在加载..."
        urlLabel.font = UIFont.systemFont(ofSize: 14)
        urlLabel.textColor = UIColor.systemBlue
        urlLabel.textAlignment = .center
        self.urlLabel = urlLabel

        view.addSubview(urlLabel)
        urlLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        // 创建进度条
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.themeColor
        self.progressView = progressView

        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(urlLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(4)
        }
        
        // 创建WebView
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        self.webView = webView

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 设置KVO观察者
    private func setupObservers() {
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView?.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
    
    /// 移除观察者
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        webView?.removeObserver(self, forKeyPath: "URL")
    }
    
    /// KVO观察
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            guard let webView = webView, let progressView = progressView else { return }
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        } else if keyPath == "URL" {
            guard let webView = webView, let urlLabel = urlLabel else { return }
            urlLabel.text = webView.url?.absoluteString ?? "正在加载..."
        }
    }
    
    /// 加载网站
    private func loadWebsite() {
        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
}

// MARK: - WKNavigationDelegate for ProgressWebViewController
extension ProgressWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let progressView = progressView else { return }
        progressView.setProgress(0.0, animated: false)
        UIView.animate(withDuration: 0.3) {
            progressView.alpha = 0
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let progressView = progressView else { return }
        progressView.alpha = 1.0
        progressView.setProgress(0.0, animated: false)
    }
}

// MARK: - JavaScript交互WebView
class JavaScriptWebViewController: UIViewController {
    
    private var webView: WKWebView?
    private var messageLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadLocalHTML()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 创建消息标签
        let messageLabel = UILabel()
        messageLabel.text = "JavaScript消息将显示在这里"
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = UIColor.systemGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.backgroundColor = UIColor.systemGray6
        self.messageLabel = messageLabel

        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        // 创建WebView配置
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "iosHandler")
        config.userContentController = userContentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        self.webView = webView

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 加载本地HTML
    private func loadLocalHTML() {
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>JavaScript交互示例</title>
            <style>
                body { font-family: -apple-system; padding: 20px; background: #f8f9fa; }
                .container { background: white; padding: 20px; border-radius: 10px; }
                button { 
                    background: #007AFF; 
                    color: white; 
                    border: none; 
                    padding: 15px 20px; 
                    border-radius: 8px; 
                    margin: 10px 0; 
                    display: block; 
                    width: 100%;
                    font-size: 16px;
                }
                input { 
                    width: 100%; 
                    padding: 15px; 
                    border: 1px solid #ddd; 
                    border-radius: 8px; 
                    margin: 10px 0;
                    font-size: 16px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h2>JavaScript与iOS交互</h2>
                <p>这个页面演示了WebView中JavaScript与iOS原生代码的交互。</p>
                
                <input type="text" id="messageInput" placeholder="输入消息...">
                
                <button onclick="sendMessage()">发送消息到iOS</button>
                <button onclick="showAlert()">显示JavaScript Alert</button>
                <button onclick="getCurrentTime()">获取当前时间</button>
                
                <div id="result" style="margin-top: 20px; padding: 10px; background: #e9ecef; border-radius: 5px;">
                    点击按钮查看结果...
                </div>
            </div>
            
            <script>
                function sendMessage() {
                    var input = document.getElementById('messageInput');
                    var message = input.value || '你好，iOS！';
                    window.webkit.messageHandlers.iosHandler.postMessage({
                        action: 'message',
                        data: message
                    });
                }
                
                function showAlert() {
                    alert('这是一个JavaScript Alert！');
                }
                
                function getCurrentTime() {
                    var now = new Date();
                    var result = document.getElementById('result');
                    result.innerHTML = '当前时间：' + now.toLocaleString();
                }
                
                // 接收来自iOS的消息
                function receiveMessageFromiOS(message) {
                    var result = document.getElementById('result');
                    result.innerHTML = 'iOS消息：' + message;
                }
            </script>
        </body>
        </html>
        """
        
        webView?.loadHTMLString(htmlString, baseURL: nil)
    }
}

// MARK: - WKScriptMessageHandler for JavaScriptWebViewController
extension JavaScriptWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iosHandler" {
            if let body = message.body as? [String: Any],
               let action = body["action"] as? String,
               let data = body["data"] as? String {
                
                messageLabel?.text = "收到JS消息: \(data)"

                // 发送消息回JavaScript
                let script = "receiveMessageFromiOS('Hello from iOS!');"
                webView?.evaluateJavaScript(script, completionHandler: nil)
            }
        }
    }
}

// MARK: - WKNavigationDelegate for JavaScriptWebViewController
extension JavaScriptWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "JavaScript Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            completionHandler()
        })
        present(alert, animated: true)
    }
}

// MARK: - 自定义WebView
class CustomWebViewController: UIViewController {
    
    private var webView: WKWebView?
    private var toolbarView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebsite()
    }
    
    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // 创建自定义工具栏
        let toolbarView = UIView()
        toolbarView.backgroundColor = UIColor.themeColor
        self.toolbarView = toolbarView

        view.addSubview(toolbarView)
        toolbarView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        // 工具栏按钮
        let homeButton = createCustomButton(title: "🏠", action: #selector(goHome))
        let shareButton = createCustomButton(title: "📤", action: #selector(shareURL))
        let bookmarkButton = createCustomButton(title: "⭐", action: #selector(bookmark))
        let settingsButton = createCustomButton(title: "⚙️", action: #selector(showSettings))
        
        let stackView = UIStackView(arrangedSubviews: [homeButton, shareButton, bookmarkButton, settingsButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        toolbarView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        // 创建WebView
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        self.webView = webView

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(toolbarView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
    
    /// 创建自定义按钮
    private func createCustomButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    /// 加载网站
    private func loadWebsite() {
        if let url = URL(string: "https://www.apple.com/cn/") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
    
    /// 回到首页
    @objc private func goHome() {
        loadWebsite()
        if let parentVC = parent?.parent as? WebViewExampleViewController {
            parentVC.view.makeToast("回到苹果官网首页")
        }
    }
    
    /// 分享链接
    @objc private func shareURL() {
        guard let url = webView?.url else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    /// 添加书签
    @objc private func bookmark() {
        if let parentVC = parent?.parent as? WebViewExampleViewController {
            parentVC.view.makeToast("已添加到书签 ⭐")
        }
    }
    
    /// 显示设置
    @objc private func showSettings() {
        let alert = UIAlertController(title: "WebView设置", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "清除缓存", style: .default) { _ in
            let dataStore = WKWebsiteDataStore.default()
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
                if let parentVC = self.parent?.parent as? WebViewExampleViewController {
                    parentVC.view.makeToast("缓存已清除")
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "查看页面信息", style: .default) { _ in
            let title = self.webView?.title ?? "无标题"
            let url = self.webView?.url?.absoluteString ?? "无URL"
            if let parentVC = self.parent?.parent as? WebViewExampleViewController {
                parentVC.view.makeToast("标题: \(title)\nURL: \(url)", duration: 3.0)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
}
