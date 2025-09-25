//
//  NetworkRequestViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/09/25.
//

import UIKit
import SnapKit
import Alamofire

/**
 * 网络请求库学习页面
 * 演示URLSession和Alamofire的各种网络请求方式
 */
class NetworkRequestViewController: BaseViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNavigationBar = CustomNavigationBar()

    // UI组件
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let separatorView = UIView()

    // URLSession区域
    private let urlSessionLabel = UILabel()
    private let getRequestBtn = UIButton()
    private let postRequestBtn = UIButton()
    private let downloadBtn = UIButton()
    private let uploadBtn = UIButton()

    // Alamofire区域
    private let alamofireLabel = UILabel()
    private let afGetRequestBtn = UIButton()
    private let afPostRequestBtn = UIButton()
    private let afDownloadBtn = UIButton()
    private let afUploadBtn = UIButton()

    // 结果显示区域
    private let resultLabel = UILabel()
    private let resultTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /**
     * 配置用户界面
     */
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground

        setupNavigationBar()
        setupScrollView()
        setupHeaderSection()
        setupURLSessionSection()
        setupAlamofireSection()
        setupResultSection()

        layoutSubviews()
    }

    /**
     * 设置导航栏
     */
    private func setupNavigationBar() {
        customNavigationBar.configure(title: "网络请求库") { [weak self] in
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
        // 标题
        titleLabel.text = "网络请求对比"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label

        // 描述
        descriptionLabel.text = "演示原生URLSession和第三方库Alamofire的网络请求功能"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        // 分隔线
        separatorView.backgroundColor = .separator

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(separatorView)
    }

    /**
     * 设置URLSession区域
     */
    private func setupURLSessionSection() {
        // 标题
        urlSessionLabel.text = "URLSession (系统原生)"
        urlSessionLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        urlSessionLabel.textColor = UIColor.themeColor

        // GET请求按钮
        configureButton(getRequestBtn, title: "GET请求", subtitle: "获取JSON数据")
        getRequestBtn.addTarget(self, action: #selector(urlSessionGetRequest), for: .touchUpInside)

        // POST请求按钮
        configureButton(postRequestBtn, title: "POST请求", subtitle: "提交表单数据")
        postRequestBtn.addTarget(self, action: #selector(urlSessionPostRequest), for: .touchUpInside)

        // 下载按钮
        configureButton(downloadBtn, title: "文件下载", subtitle: "下载图片文件")
        downloadBtn.addTarget(self, action: #selector(urlSessionDownload), for: .touchUpInside)

        // 上传按钮
        configureButton(uploadBtn, title: "文件上传", subtitle: "上传数据到服务器")
        uploadBtn.addTarget(self, action: #selector(urlSessionUpload), for: .touchUpInside)

        contentView.addSubview(urlSessionLabel)
        contentView.addSubview(getRequestBtn)
        contentView.addSubview(postRequestBtn)
        contentView.addSubview(downloadBtn)
        contentView.addSubview(uploadBtn)
    }

    /**
     * 设置Alamofire区域
     */
    private func setupAlamofireSection() {
        // 标题
        alamofireLabel.text = "Alamofire (第三方库)"
        alamofireLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        alamofireLabel.textColor = UIColor.themeColor

        // GET请求按钮
        configureButton(afGetRequestBtn, title: "AF GET请求", subtitle: "使用Alamofire获取数据")
        afGetRequestBtn.addTarget(self, action: #selector(alamofireGetRequest), for: .touchUpInside)

        // POST请求按钮
        configureButton(afPostRequestBtn, title: "AF POST请求", subtitle: "使用Alamofire提交数据")
        afPostRequestBtn.addTarget(self, action: #selector(alamofirePostRequest), for: .touchUpInside)

        // 下载按钮
        configureButton(afDownloadBtn, title: "AF 文件下载", subtitle: "使用Alamofire下载文件")
        afDownloadBtn.addTarget(self, action: #selector(alamofireDownload), for: .touchUpInside)

        // 上传按钮
        configureButton(afUploadBtn, title: "AF 文件上传", subtitle: "使用Alamofire上传文件")
        afUploadBtn.addTarget(self, action: #selector(alamofireUpload), for: .touchUpInside)

        contentView.addSubview(alamofireLabel)
        contentView.addSubview(afGetRequestBtn)
        contentView.addSubview(afPostRequestBtn)
        contentView.addSubview(afDownloadBtn)
        contentView.addSubview(afUploadBtn)
    }

    /**
     * 设置结果显示区域
     */
    private func setupResultSection() {
        // 结果标题
        resultLabel.text = "请求结果"
        resultLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        resultLabel.textColor = .label

        // 结果文本框
        resultTextView.font = UIFont.systemFont(ofSize: 14)
        resultTextView.textColor = .label
        resultTextView.backgroundColor = .systemGray6
        resultTextView.layer.cornerRadius = 8
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.borderColor = UIColor.separator.cgColor
        resultTextView.isEditable = false
        resultTextView.text = "点击上方按钮查看请求结果..."

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

        // 设置标题和副标题
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

        separatorView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(1)
        }

        // URLSession区域
        urlSessionLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(margin)
            make.left.right.equalToSuperview().inset(margin)
        }

        getRequestBtn.snp.makeConstraints { make in
            make.top.equalTo(urlSessionLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        postRequestBtn.snp.makeConstraints { make in
            make.top.equalTo(getRequestBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        downloadBtn.snp.makeConstraints { make in
            make.top.equalTo(postRequestBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        uploadBtn.snp.makeConstraints { make in
            make.top.equalTo(downloadBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // Alamofire区域
        alamofireLabel.snp.makeConstraints { make in
            make.top.equalTo(uploadBtn.snp.bottom).offset(margin * 1.5)
            make.left.right.equalToSuperview().inset(margin)
        }

        afGetRequestBtn.snp.makeConstraints { make in
            make.top.equalTo(alamofireLabel.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        afPostRequestBtn.snp.makeConstraints { make in
            make.top.equalTo(afGetRequestBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        afDownloadBtn.snp.makeConstraints { make in
            make.top.equalTo(afPostRequestBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        afUploadBtn.snp.makeConstraints { make in
            make.top.equalTo(afDownloadBtn.snp.bottom).offset(spacing)
            make.left.right.equalToSuperview().inset(margin)
            make.height.equalTo(buttonHeight)
        }

        // 结果显示区域
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(afUploadBtn.snp.bottom).offset(margin * 1.5)
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

// MARK: - URLSession 网络请求方法
extension NetworkRequestViewController {

    /**
     * URLSession GET请求示例
     */
    @objc private func urlSessionGetRequest() {
        showResult("URLSession GET请求开始...\n")

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            showResult("URL无效")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showResult("请求失败: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showResult("响应格式错误")
                    return
                }

                guard let data = data else {
                    self?.showResult("数据为空")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8) ?? "解析失败"

                    let result = """
                    URLSession GET请求成功
                    状态码: \(httpResponse.statusCode)
                    响应数据:
                    \(jsonString)
                    """
                    self?.showResult(result)
                } catch {
                    self?.showResult("JSON解析失败: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    /**
     * URLSession POST请求示例
     */
    @objc private func urlSessionPostRequest() {
        showResult("URLSession POST请求开始...\n")

        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            showResult("URL无效")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let postData: [String: Any] = [
            "title": "iOS网络请求测试",
            "body": "这是一个URLSession POST请求示例",
            "userId": 1
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData)
        } catch {
            showResult("数据序列化失败: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showResult("请求失败: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    self?.showResult("响应无效")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8) ?? "解析失败"

                    let result = """
                    URLSession POST请求成功
                    状态码: \(httpResponse.statusCode)
                    响应数据:
                    \(jsonString)
                    """
                    self?.showResult(result)
                } catch {
                    self?.showResult("JSON解析失败: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    /**
     * URLSession 文件下载示例
     */
    @objc private func urlSessionDownload() {
        showResult("URLSession 文件下载开始...\n")

        guard let url = URL(string: "https://picsum.photos/200/300") else {
            showResult("URL无效")
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { [weak self] localURL, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showResult("下载失败: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showResult("HTTP响应无效")
                    return
                }

                guard let localURL = localURL else {
                    self?.showResult("临时文件URL为空")
                    return
                }

                // 检查临时文件是否存在
                if !FileManager.default.fileExists(atPath: localURL.path) {
                    self?.showResult("临时文件不存在: \(localURL.path)")
                    return
                }

                do {
                    // 确保Documents目录存在
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    try FileManager.default.createDirectory(at: documentsPath, withIntermediateDirectories: true, attributes: nil)

                    let destinationURL = documentsPath.appendingPathComponent("downloaded_image.jpg")

                    // 如果文件已存在，先删除
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }

                    // 复制下载的文件到目标位置
                    try FileManager.default.copyItem(at: localURL, to: destinationURL)

                    // 获取文件属性
                    let fileAttributes = try FileManager.default.attributesOfItem(atPath: destinationURL.path)
                    let fileSize = fileAttributes[.size] as? Int ?? 0

                    let result = """
                    URLSession 文件下载成功
                    状态码: \(httpResponse.statusCode)
                    文件大小: \(fileSize) bytes
                    保存路径: \(destinationURL.path)
                    文件确实存在: \(FileManager.default.fileExists(atPath: destinationURL.path))
                    """
                    self?.showResult(result)
                } catch {
                    self?.showResult("文件保存失败: \(error.localizedDescription)\n临时文件路径: \(localURL.path)")
                }
            }
        }
        task.resume()
    }

    /**
     * URLSession 文件上传示例
     */
    @objc private func urlSessionUpload() {
        showResult("URLSession 文件上传开始...\n")

        guard let url = URL(string: "https://httpbin.org/post") else {
            showResult("URL无效")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // 创建multipart/form-data数据
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        let fileData = "这是一个测试文件的内容".data(using: .utf8)!

        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"test.txt\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        let task = URLSession.shared.uploadTask(with: request, from: data) { [weak self] responseData, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showResult("上传失败: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      let responseData = responseData else {
                    self?.showResult("上传响应无效")
                    return
                }

                let responseString = String(data: responseData, encoding: .utf8) ?? "响应解析失败"

                let result = """
                URLSession 文件上传成功
                状态码: \(httpResponse.statusCode)
                上传大小: \(data.count) bytes
                服务器响应: \(responseString.prefix(500))
                """
                self?.showResult(result)
            }
        }
        task.resume()
    }
}

// MARK: - Alamofire 网络请求方法
extension NetworkRequestViewController {

    /**
     * Alamofire GET请求示例
     */
    @objc private func alamofireGetRequest() {
        showResult("Alamofire GET请求开始...\n")

        AF.request("https://jsonplaceholder.typicode.com/posts/1")
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let value):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8) ?? "解析失败"

                        let result = """
                        Alamofire GET请求成功
                        状态码: \(response.response?.statusCode ?? 0)
                        响应时间: \(response.metrics?.taskInterval.duration ?? 0)s
                        响应数据:
                        \(jsonString)
                        """
                        self?.showResult(result)
                    } catch {
                        self?.showResult("JSON解析失败: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self?.showResult("Alamofire GET请求失败: \(error.localizedDescription)")
                }
            }
    }

    /**
     * Alamofire POST请求示例
     */
    @objc private func alamofirePostRequest() {
        showResult("Alamofire POST请求开始...\n")

        let parameters: [String: Any] = [
            "title": "iOS网络请求测试",
            "body": "这是一个Alamofire POST请求示例",
            "userId": 1
        ]

        AF.request("https://jsonplaceholder.typicode.com/posts",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let value):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8) ?? "解析失败"

                        let result = """
                        Alamofire POST请求成功
                        状态码: \(response.response?.statusCode ?? 0)
                        响应时间: \(response.metrics?.taskInterval.duration ?? 0)s
                        响应数据:
                        \(jsonString)
                        """
                        self?.showResult(result)
                    } catch {
                        self?.showResult("JSON解析失败: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self?.showResult("Alamofire POST请求失败: \(error.localizedDescription)")
                }
            }
    }

    /**
     * Alamofire 文件下载示例
     */
    @objc private func alamofireDownload() {
        showResult("Alamofire 文件下载开始...\n")

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent("alamofire_downloaded_image.jpg")

        let destination: DownloadRequest.Destination = { _, _ in
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download("https://picsum.photos/300/400", to: destination)
            .downloadProgress { [weak self] progress in
                let progressString = String(format: "下载进度: %.1f%%", progress.fractionCompleted * 100)
                self?.appendToResult(progressString)
            }
            .response { [weak self] response in
                if let error = response.error {
                    self?.showResult("Alamofire 下载失败: \(error.localizedDescription)")
                    return
                }

                do {
                    let fileAttributes = try FileManager.default.attributesOfItem(atPath: destinationURL.path)
                    let fileSize = fileAttributes[.size] as? Int ?? 0

                    let result = """

                    Alamofire 文件下载成功
                    状态码: \(response.response?.statusCode ?? 0)
                    文件大小: \(fileSize) bytes
                    保存路径: \(destinationURL.path)
                    """
                    self?.appendToResult(result)
                } catch {
                    self?.appendToResult("\n文件信息获取失败: \(error.localizedDescription)")
                }
            }
    }

    /**
     * Alamofire 文件上传示例
     */
    @objc private func alamofireUpload() {
        showResult("Alamofire 文件上传开始...\n")

        let fileData = "这是一个使用Alamofire上传的测试文件内容".data(using: .utf8)!

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "file", fileName: "alamofire_test.txt", mimeType: "text/plain")
            multipartFormData.append("test_value".data(using: .utf8)!, withName: "field")
        }, to: "https://httpbin.org/post")
        .uploadProgress { [weak self] progress in
            let progressString = String(format: "上传进度: %.1f%%", progress.fractionCompleted * 100)
            self?.appendToResult(progressString)
        }
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8) ?? "解析失败"

                    let result = """

                    Alamofire 文件上传成功
                    状态码: \(response.response?.statusCode ?? 0)
                    响应时间: \(response.metrics?.taskInterval.duration ?? 0)s
                    上传大小: \(fileData.count) bytes
                    服务器响应: \(jsonString.prefix(800))
                    """
                    self?.appendToResult(result)
                } catch {
                    self?.appendToResult("\nJSON解析失败: \(error.localizedDescription)")
                }
            case .failure(let error):
                self?.appendToResult("\nAlamofire 文件上传失败: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 辅助方法
extension NetworkRequestViewController {

    /**
     * 显示请求结果
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
            self.resultTextView.text += text
            let bottom = NSRange(location: self.resultTextView.text.count - 1, length: 1)
            self.resultTextView.scrollRangeToVisible(bottom)
        }
    }
}
