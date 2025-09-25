import UIKit
import SnapKit

/// 沙盒管理和文件操作示例页面
/// 展示iOS沙盒结构、文件目录操作、文件增删改查等功能
class SandboxFileViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // 沙盒路径展示
    private let pathContainer = UIView()
    private let pathLabel = UILabel()
    private let documentsPathLabel = UILabel()
    private let libraryPathLabel = UILabel()
    private let cachePathLabel = UILabel()
    private let tmpPathLabel = UILabel()

    // 文件操作区域
    private let fileOperationContainer = UIView()
    private let fileOperationLabel = UILabel()
    private let fileNameTextField = UITextField()
    private let fileContentTextView = UITextView()
    private let createFileButton = UIButton()
    private let readFileButton = UIButton()
    private let updateFileButton = UIButton()
    private let deleteFileButton = UIButton()

    // 目录操作区域
    private let directoryContainer = UIView()
    private let directoryLabel = UILabel()
    private let directoryNameTextField = UITextField()
    private let createDirButton = UIButton()
    private let listDirButton = UIButton()
    private let deleteDirButton = UIButton()

    // 结果显示
    private let resultContainer = UIView()
    private let resultLabel = UILabel()
    private let resultTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displaySandboxPaths()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupScrollView()
        setupPathSection()
        setupFileOperationSection()
        setupDirectorySection()
        setupResultSection()
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "沙盒管理、文件操作") { [weak self] in
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

    /// 设置沙盒路径展示部分
    private func setupPathSection() {
        pathContainer.backgroundColor = .systemGray6
        pathContainer.layer.cornerRadius = 12
        contentView.addSubview(pathContainer)

        pathLabel.text = "📁 沙盒目录结构"
        pathLabel.font = .boldSystemFont(ofSize: 18)
        pathLabel.textColor = .themeColor

        documentsPathLabel.font = .systemFont(ofSize: 12)
        documentsPathLabel.textColor = .label
        documentsPathLabel.numberOfLines = 0

        libraryPathLabel.font = .systemFont(ofSize: 12)
        libraryPathLabel.textColor = .label
        libraryPathLabel.numberOfLines = 0

        cachePathLabel.font = .systemFont(ofSize: 12)
        cachePathLabel.textColor = .label
        cachePathLabel.numberOfLines = 0

        tmpPathLabel.font = .systemFont(ofSize: 12)
        tmpPathLabel.textColor = .label
        tmpPathLabel.numberOfLines = 0

        [pathLabel, documentsPathLabel, libraryPathLabel, cachePathLabel, tmpPathLabel].forEach {
            pathContainer.addSubview($0)
        }

        pathContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        pathLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        documentsPathLabel.snp.makeConstraints { make in
            make.top.equalTo(pathLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }

        libraryPathLabel.snp.makeConstraints { make in
            make.top.equalTo(documentsPathLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        cachePathLabel.snp.makeConstraints { make in
            make.top.equalTo(libraryPathLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        tmpPathLabel.snp.makeConstraints { make in
            make.top.equalTo(cachePathLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置文件操作部分
    private func setupFileOperationSection() {
        fileOperationContainer.backgroundColor = .systemGray6
        fileOperationContainer.layer.cornerRadius = 12
        contentView.addSubview(fileOperationContainer)

        fileOperationLabel.text = "📄 文件操作 (CRUD)"
        fileOperationLabel.font = .boldSystemFont(ofSize: 18)
        fileOperationLabel.textColor = .themeColor

        fileNameTextField.placeholder = "输入文件名 (例: test.txt)"
        fileNameTextField.borderStyle = .roundedRect

        fileContentTextView.text = "在这里输入文件内容..."
        fileContentTextView.font = .systemFont(ofSize: 14)
        fileContentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        fileContentTextView.layer.borderWidth = 1
        fileContentTextView.layer.cornerRadius = 8

        createFileButton.setTitle("创建文件", for: .normal)
        createFileButton.backgroundColor = .themeColor
        createFileButton.setTitleColor(.white, for: .normal)
        createFileButton.layer.cornerRadius = 8
        createFileButton.addTarget(self, action: #selector(createFile), for: .touchUpInside)

        readFileButton.setTitle("读取文件", for: .normal)
        readFileButton.backgroundColor = .systemBlue
        readFileButton.setTitleColor(.white, for: .normal)
        readFileButton.layer.cornerRadius = 8
        readFileButton.addTarget(self, action: #selector(readFile), for: .touchUpInside)

        updateFileButton.setTitle("更新文件", for: .normal)
        updateFileButton.backgroundColor = .systemOrange
        updateFileButton.setTitleColor(.white, for: .normal)
        updateFileButton.layer.cornerRadius = 8
        updateFileButton.addTarget(self, action: #selector(updateFile), for: .touchUpInside)

        deleteFileButton.setTitle("删除文件", for: .normal)
        deleteFileButton.backgroundColor = .systemRed
        deleteFileButton.setTitleColor(.white, for: .normal)
        deleteFileButton.layer.cornerRadius = 8
        deleteFileButton.addTarget(self, action: #selector(deleteFile), for: .touchUpInside)

        [fileOperationLabel, fileNameTextField, fileContentTextView,
         createFileButton, readFileButton, updateFileButton, deleteFileButton].forEach {
            fileOperationContainer.addSubview($0)
        }

        fileOperationContainer.snp.makeConstraints { make in
            make.top.equalTo(pathContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        fileOperationLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        fileNameTextField.snp.makeConstraints { make in
            make.top.equalTo(fileOperationLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        fileContentTextView.snp.makeConstraints { make in
            make.top.equalTo(fileNameTextField.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }

        createFileButton.snp.makeConstraints { make in
            make.top.equalTo(fileContentTextView.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(70)
            make.height.equalTo(36)
        }

        readFileButton.snp.makeConstraints { make in
            make.top.equalTo(fileContentTextView.snp.bottom).offset(12)
            make.left.equalTo(createFileButton.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(36)
        }

        updateFileButton.snp.makeConstraints { make in
            make.top.equalTo(fileContentTextView.snp.bottom).offset(12)
            make.left.equalTo(readFileButton.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(36)
        }

        deleteFileButton.snp.makeConstraints { make in
            make.top.equalTo(fileContentTextView.snp.bottom).offset(12)
            make.left.equalTo(updateFileButton.snp.right).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置目录操作部分
    private func setupDirectorySection() {
        directoryContainer.backgroundColor = .systemGray6
        directoryContainer.layer.cornerRadius = 12
        contentView.addSubview(directoryContainer)

        directoryLabel.text = "📂 目录操作"
        directoryLabel.font = .boldSystemFont(ofSize: 18)
        directoryLabel.textColor = .themeColor

        directoryNameTextField.placeholder = "输入目录名 (例: TestFolder)"
        directoryNameTextField.borderStyle = .roundedRect

        createDirButton.setTitle("创建目录", for: .normal)
        createDirButton.backgroundColor = .themeColor
        createDirButton.setTitleColor(.white, for: .normal)
        createDirButton.layer.cornerRadius = 8
        createDirButton.addTarget(self, action: #selector(createDirectory), for: .touchUpInside)

        listDirButton.setTitle("列出文件", for: .normal)
        listDirButton.backgroundColor = .systemBlue
        listDirButton.setTitleColor(.white, for: .normal)
        listDirButton.layer.cornerRadius = 8
        listDirButton.addTarget(self, action: #selector(listDirectory), for: .touchUpInside)

        deleteDirButton.setTitle("删除目录", for: .normal)
        deleteDirButton.backgroundColor = .systemRed
        deleteDirButton.setTitleColor(.white, for: .normal)
        deleteDirButton.layer.cornerRadius = 8
        deleteDirButton.addTarget(self, action: #selector(deleteDirectory), for: .touchUpInside)

        [directoryLabel, directoryNameTextField, createDirButton, listDirButton, deleteDirButton].forEach {
            directoryContainer.addSubview($0)
        }

        directoryContainer.snp.makeConstraints { make in
            make.top.equalTo(fileOperationContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        directoryLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        directoryNameTextField.snp.makeConstraints { make in
            make.top.equalTo(directoryLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        createDirButton.snp.makeConstraints { make in
            make.top.equalTo(directoryNameTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        listDirButton.snp.makeConstraints { make in
            make.top.equalTo(directoryNameTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        deleteDirButton.snp.makeConstraints { make in
            make.top.equalTo(directoryNameTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置结果显示部分
    private func setupResultSection() {
        resultContainer.backgroundColor = .systemGray6
        resultContainer.layer.cornerRadius = 12
        contentView.addSubview(resultContainer)

        resultLabel.text = "📊 操作结果"
        resultLabel.font = .boldSystemFont(ofSize: 18)
        resultLabel.textColor = .themeColor

        resultTextView.text = "操作结果将在这里显示..."
        resultTextView.font = .systemFont(ofSize: 12)
        resultTextView.isEditable = false
        resultTextView.layer.borderColor = UIColor.systemGray4.cgColor
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.cornerRadius = 8

        [resultLabel, resultTextView].forEach {
            resultContainer.addSubview($0)
        }

        resultContainer.snp.makeConstraints { make in
            make.top.equalTo(directoryContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        resultTextView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
    }

    /// 显示沙盒路径信息
    private func displaySandboxPaths() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "无法获取"
        let libraryPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.path ?? "无法获取"
        let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.path ?? "无法获取"
        let tmpPath = NSTemporaryDirectory()

        documentsPathLabel.text = "📄 Documents: 用户文档目录，存储用户生成的数据，会被iTunes备份\n路径: \(documentsPath)"

        libraryPathLabel.text = "📚 Library: 应用程序库目录，存储应用配置文件和数据\n路径: \(libraryPath)"

        cachePathLabel.text = "💾 Caches: 缓存目录，存储临时数据，不会被iTunes备份，系统空间不足时可能被清理\n路径: \(cachePath)"

        tmpPathLabel.text = "⏰ tmp: 临时目录，存储临时文件，应用退出后可能被系统清理\n路径: \(tmpPath)"
    }

    // MARK: - 文件操作方法

    /// 创建文件
    @objc private func createFile() {
        guard let fileName = fileNameTextField.text, !fileName.isEmpty else {
            showAlert(title: "提示", message: "请输入文件名")
            return
        }

        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)
        let content = fileContentTextView.text ?? ""

        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            resultTextView.text = "✅ 成功：文件 '\(fileName)' 创建成功\n路径：\(fileURL.path)"
        } catch {
            resultTextView.text = "❌ 错误：文件创建失败\n\(error.localizedDescription)"
        }
    }

    /// 读取文件
    @objc private func readFile() {
        guard let fileName = fileNameTextField.text, !fileName.isEmpty else {
            showAlert(title: "提示", message: "请输入文件名")
            return
        }

        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            resultTextView.text = "✅ 读取文件 '\(fileName)' 成功:\n\n\(content)"
            fileContentTextView.text = content
        } catch {
            resultTextView.text = "❌ 错误：文件读取失败\n\(error.localizedDescription)"
        }
    }

    /// 更新文件
    @objc private func updateFile() {
        guard let fileName = fileNameTextField.text, !fileName.isEmpty else {
            showAlert(title: "提示", message: "请输入文件名")
            return
        }

        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)
        let content = fileContentTextView.text ?? ""

        // 检查文件是否存在
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            resultTextView.text = "❌ 错误：文件 '\(fileName)' 不存在，请先创建文件"
            return
        }

        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            resultTextView.text = "✅ 成功：文件 '\(fileName)' 更新成功"
        } catch {
            resultTextView.text = "❌ 错误：文件更新失败\n\(error.localizedDescription)"
        }
    }

    /// 删除文件
    @objc private func deleteFile() {
        guard let fileName = fileNameTextField.text, !fileName.isEmpty else {
            showAlert(title: "提示", message: "请输入文件名")
            return
        }

        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            try FileManager.default.removeItem(at: fileURL)
            resultTextView.text = "✅ 成功：文件 '\(fileName)' 删除成功"
            fileContentTextView.text = "在这里输入文件内容..."
        } catch {
            resultTextView.text = "❌ 错误：文件删除失败\n\(error.localizedDescription)"
        }
    }

    // MARK: - 目录操作方法

    /// 创建目录
    @objc private func createDirectory() {
        guard let dirName = directoryNameTextField.text, !dirName.isEmpty else {
            showAlert(title: "提示", message: "请输入目录名")
            return
        }

        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        let dirURL = documentsURL.appendingPathComponent(dirName)

        do {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            resultTextView.text = "✅ 成功：目录 '\(dirName)' 创建成功\n路径：\(dirURL.path)"
        } catch {
            resultTextView.text = "❌ 错误：目录创建失败\n\(error.localizedDescription)"
        }
    }

    /// 列出目录内容
    @objc private func listDirectory() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
            if contents.isEmpty {
                resultTextView.text = "📁 Documents目录为空"
            } else {
                var result = "📁 Documents目录内容：\n\n"
                for (index, item) in contents.enumerated() {
                    let itemURL = documentsURL.appendingPathComponent(item)
                    var isDirectory: ObjCBool = false
                    FileManager.default.fileExists(atPath: itemURL.path, isDirectory: &isDirectory)

                    let icon = isDirectory.boolValue ? "📂" : "📄"
                    result += "\(index + 1). \(icon) \(item)\n"
                }
                resultTextView.text = result
            }
        } catch {
            resultTextView.text = "❌ 错误：无法读取目录内容\n\(error.localizedDescription)"
        }
    }

    /// 删除目录
    @objc private func deleteDirectory() {
        guard let dirName = directoryNameTextField.text, !dirName.isEmpty else {
            showAlert(title: "提示", message: "请输入目录名")
            return
        }

        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            resultTextView.text = "❌ 错误：无法获取Documents目录"
            return
        }

        let dirURL = documentsURL.appendingPathComponent(dirName)

        do {
            try FileManager.default.removeItem(at: dirURL)
            resultTextView.text = "✅ 成功：目录 '\(dirName)' 删除成功"
        } catch {
            resultTextView.text = "❌ 错误：目录删除失败\n\(error.localizedDescription)"
        }
    }
}