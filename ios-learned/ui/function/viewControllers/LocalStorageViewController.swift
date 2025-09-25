import UIKit
import SnapKit
import SQLite3

/// 本地存储示例页面
/// 展示各种本地存储方法：UserDefaults、Keychain、SQLite、Core Data等
class LocalStorageViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // UserDefaults 相关控件
    private let userDefaultsContainer = UIView()
    private let userDefaultsLabel = UILabel()
    private let saveTextField = UITextField()
    private let saveButton = UIButton()
    private let loadButton = UIButton()
    private let resultLabel = UILabel()

    // Keychain 相关控件
    private let keychainContainer = UIView()
    private let keychainLabel = UILabel()
    private let keychainTextField = UITextField()
    private let keychainSaveButton = UIButton()
    private let keychainLoadButton = UIButton()
    private let keychainDeleteButton = UIButton()
    private let keychainResultLabel = UILabel()

    // 文件存储相关控件
    private let fileContainer = UIView()
    private let fileLabel = UILabel()
    private let fileTextField = UITextField()
    private let fileSaveButton = UIButton()
    private let fileLoadButton = UIButton()
    private let fileDeleteButton = UIButton()
    private let fileResultLabel = UILabel()

    // SQLite 数据库相关控件
    private let sqliteContainer = UIView()
    private let sqliteLabel = UILabel()
    private let nameTextField = UITextField()
    private let ageTextField = UITextField()
    private let emailTextField = UITextField()
    private let sqliteAddButton = UIButton()
    private let sqliteQueryButton = UIButton()
    private let sqliteUpdateButton = UIButton()
    private let sqliteDeleteButton = UIButton()
    private let sqliteResultTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置用户界面
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupScrollView()
        setupUserDefaultsSection()
        setupKeychainSection()
        setupFileStorageSection()
        setupSQLiteSection()

        // 初始化 SQLite 数据库
        SQLiteHelper.shared.createDatabase()

        // 延迟0.1秒后自动加载用户列表
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.queryUsers()
        }
    }

    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "本地存储") { [weak self] in
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

    /// 设置 UserDefaults 部分
    private func setupUserDefaultsSection() {
        userDefaultsContainer.backgroundColor = .systemGray6
        userDefaultsContainer.layer.cornerRadius = 12
        contentView.addSubview(userDefaultsContainer)

        userDefaultsLabel.text = "UserDefaults 存储\n用于存储用户偏好设置和简单数据，如开关状态、用户名等"
        userDefaultsLabel.font = .boldSystemFont(ofSize: 16)
        userDefaultsLabel.textColor = .themeColor
        userDefaultsLabel.numberOfLines = 0

        saveTextField.placeholder = "输入要保存的文本"
        saveTextField.borderStyle = .roundedRect

        saveButton.setTitle("保存到 UserDefaults", for: .normal)
        saveButton.backgroundColor = .themeColor
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveToUserDefaults), for: .touchUpInside)

        loadButton.setTitle("从 UserDefaults 读取", for: .normal)
        loadButton.backgroundColor = .systemBlue
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 8
        loadButton.addTarget(self, action: #selector(loadFromUserDefaults), for: .touchUpInside)

        resultLabel.text = "读取结果: 暂无数据"
        resultLabel.font = .systemFont(ofSize: 14)
        resultLabel.textColor = .systemGray
        resultLabel.numberOfLines = 0

        [userDefaultsLabel, saveTextField, saveButton, loadButton, resultLabel].forEach {
            userDefaultsContainer.addSubview($0)
        }

        userDefaultsContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        userDefaultsLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        saveTextField.snp.makeConstraints { make in
            make.top.equalTo(userDefaultsLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(saveTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(140)
            make.height.equalTo(36)
        }

        loadButton.snp.makeConstraints { make in
            make.top.equalTo(saveTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(140)
            make.height.equalTo(36)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置 Keychain 部分
    private func setupKeychainSection() {
        keychainContainer.backgroundColor = .systemGray6
        keychainContainer.layer.cornerRadius = 12
        contentView.addSubview(keychainContainer)

        keychainLabel.text = "Keychain 安全存储\n用于存储密码、令牌等敏感信息，数据经过加密，即使设备被越狱也相对安全"
        keychainLabel.font = .boldSystemFont(ofSize: 16)
        keychainLabel.textColor = .themeColor
        keychainLabel.numberOfLines = 0

        keychainTextField.placeholder = "输入密码或敏感信息"
        keychainTextField.borderStyle = .roundedRect
        keychainTextField.isSecureTextEntry = true

        keychainSaveButton.setTitle("保存到 Keychain", for: .normal)
        keychainSaveButton.backgroundColor = .themeColor
        keychainSaveButton.setTitleColor(.white, for: .normal)
        keychainSaveButton.layer.cornerRadius = 8
        keychainSaveButton.addTarget(self, action: #selector(saveToKeychain), for: .touchUpInside)

        keychainLoadButton.setTitle("读取", for: .normal)
        keychainLoadButton.backgroundColor = .systemBlue
        keychainLoadButton.setTitleColor(.white, for: .normal)
        keychainLoadButton.layer.cornerRadius = 8
        keychainLoadButton.addTarget(self, action: #selector(loadFromKeychain), for: .touchUpInside)

        keychainDeleteButton.setTitle("删除", for: .normal)
        keychainDeleteButton.backgroundColor = .systemRed
        keychainDeleteButton.setTitleColor(.white, for: .normal)
        keychainDeleteButton.layer.cornerRadius = 8
        keychainDeleteButton.addTarget(self, action: #selector(deleteFromKeychain), for: .touchUpInside)

        keychainResultLabel.text = "读取结果: 暂无数据"
        keychainResultLabel.font = .systemFont(ofSize: 14)
        keychainResultLabel.textColor = .systemGray
        keychainResultLabel.numberOfLines = 0

        [keychainLabel, keychainTextField, keychainSaveButton, keychainLoadButton, keychainDeleteButton, keychainResultLabel].forEach {
            keychainContainer.addSubview($0)
        }

        keychainContainer.snp.makeConstraints { make in
            make.top.equalTo(userDefaultsContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        keychainLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        keychainTextField.snp.makeConstraints { make in
            make.top.equalTo(keychainLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        keychainSaveButton.snp.makeConstraints { make in
            make.top.equalTo(keychainTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(36)
        }

        keychainLoadButton.snp.makeConstraints { make in
            make.top.equalTo(keychainTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        keychainDeleteButton.snp.makeConstraints { make in
            make.top.equalTo(keychainTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        keychainResultLabel.snp.makeConstraints { make in
            make.top.equalTo(keychainSaveButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置文件存储部分
    private func setupFileStorageSection() {
        fileContainer.backgroundColor = .systemGray6
        fileContainer.layer.cornerRadius = 12
        contentView.addSubview(fileContainer)

        fileLabel.text = "文件存储 (Documents)\n用于存储用户生成的文档、图片、音频等大型数据，会被iTunes/iCloud备份"
        fileLabel.font = .boldSystemFont(ofSize: 16)
        fileLabel.textColor = .themeColor
        fileLabel.numberOfLines = 0

        fileTextField.placeholder = "输入要保存的文件内容"
        fileTextField.borderStyle = .roundedRect

        fileSaveButton.setTitle("保存到文件", for: .normal)
        fileSaveButton.backgroundColor = .themeColor
        fileSaveButton.setTitleColor(.white, for: .normal)
        fileSaveButton.layer.cornerRadius = 8
        fileSaveButton.addTarget(self, action: #selector(saveToFile), for: .touchUpInside)

        fileLoadButton.setTitle("读取", for: .normal)
        fileLoadButton.backgroundColor = .systemBlue
        fileLoadButton.setTitleColor(.white, for: .normal)
        fileLoadButton.layer.cornerRadius = 8
        fileLoadButton.addTarget(self, action: #selector(loadFromFile), for: .touchUpInside)

        fileDeleteButton.setTitle("删除", for: .normal)
        fileDeleteButton.backgroundColor = .systemRed
        fileDeleteButton.setTitleColor(.white, for: .normal)
        fileDeleteButton.layer.cornerRadius = 8
        fileDeleteButton.addTarget(self, action: #selector(deleteFile), for: .touchUpInside)

        fileResultLabel.text = "读取结果: 暂无数据"
        fileResultLabel.font = .systemFont(ofSize: 14)
        fileResultLabel.textColor = .systemGray
        fileResultLabel.numberOfLines = 0

        [fileLabel, fileTextField, fileSaveButton, fileLoadButton, fileDeleteButton, fileResultLabel].forEach {
            fileContainer.addSubview($0)
        }

        fileContainer.snp.makeConstraints { make in
            make.top.equalTo(keychainContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }

        fileLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        fileTextField.snp.makeConstraints { make in
            make.top.equalTo(fileLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        fileSaveButton.snp.makeConstraints { make in
            make.top.equalTo(fileTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }

        fileLoadButton.snp.makeConstraints { make in
            make.top.equalTo(fileTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        fileDeleteButton.snp.makeConstraints { make in
            make.top.equalTo(fileTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }

        fileResultLabel.snp.makeConstraints { make in
            make.top.equalTo(fileSaveButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }

    /// 设置 SQLite 数据库部分
    private func setupSQLiteSection() {
        sqliteContainer.backgroundColor = .systemGray6
        sqliteContainer.layer.cornerRadius = 12
        contentView.addSubview(sqliteContainer)

        sqliteLabel.text = "SQLite 数据库存储\n用于存储结构化数据，支持复杂查询和关系型数据管理，适合大量数据存储"
        sqliteLabel.font = .boldSystemFont(ofSize: 16)
        sqliteLabel.textColor = .themeColor
        sqliteLabel.numberOfLines = 0

        nameTextField.placeholder = "姓名"
        nameTextField.borderStyle = .roundedRect

        ageTextField.placeholder = "年龄"
        ageTextField.borderStyle = .roundedRect
        ageTextField.keyboardType = .numberPad

        emailTextField.placeholder = "邮箱"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress

        sqliteAddButton.setTitle("添加", for: .normal)
        sqliteAddButton.backgroundColor = .themeColor
        sqliteAddButton.setTitleColor(.white, for: .normal)
        sqliteAddButton.layer.cornerRadius = 8
        sqliteAddButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)

        sqliteQueryButton.setTitle("查询", for: .normal)
        sqliteQueryButton.backgroundColor = .systemBlue
        sqliteQueryButton.setTitleColor(.white, for: .normal)
        sqliteQueryButton.layer.cornerRadius = 8
        sqliteQueryButton.addTarget(self, action: #selector(queryUsers), for: .touchUpInside)

        sqliteUpdateButton.setTitle("更新", for: .normal)
        sqliteUpdateButton.backgroundColor = .systemOrange
        sqliteUpdateButton.setTitleColor(.white, for: .normal)
        sqliteUpdateButton.layer.cornerRadius = 8
        sqliteUpdateButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)

        sqliteDeleteButton.setTitle("删除", for: .normal)
        sqliteDeleteButton.backgroundColor = .systemRed
        sqliteDeleteButton.setTitleColor(.white, for: .normal)
        sqliteDeleteButton.layer.cornerRadius = 8
        sqliteDeleteButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)

        sqliteResultTextView.text = "用户列表将在这里显示..."
        sqliteResultTextView.font = .systemFont(ofSize: 12)
        sqliteResultTextView.isEditable = false
        sqliteResultTextView.layer.borderColor = UIColor.systemGray4.cgColor
        sqliteResultTextView.layer.borderWidth = 1
        sqliteResultTextView.layer.cornerRadius = 8

        [sqliteLabel, nameTextField, ageTextField, emailTextField,
         sqliteAddButton, sqliteQueryButton, sqliteUpdateButton, sqliteDeleteButton, sqliteResultTextView].forEach {
            sqliteContainer.addSubview($0)
        }

        sqliteContainer.snp.makeConstraints { make in
            make.top.equalTo(fileContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }

        sqliteLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(sqliteLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }

        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(sqliteLabel.snp.bottom).offset(12)
            make.left.equalTo(nameTextField.snp.right).offset(8)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(sqliteLabel.snp.bottom).offset(12)
            make.left.equalTo(ageTextField.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        sqliteAddButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }

        sqliteQueryButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.left.equalTo(sqliteAddButton.snp.right).offset(8)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }

        sqliteUpdateButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.left.equalTo(sqliteQueryButton.snp.right).offset(8)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }

        sqliteDeleteButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.left.equalTo(sqliteUpdateButton.snp.right).offset(8)
            make.width.equalTo(60)
            make.height.equalTo(36)
        }

        sqliteResultTextView.snp.makeConstraints { make in
            make.top.equalTo(sqliteAddButton.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
    }

    // MARK: - UserDefaults 相关方法

    /// 保存到 UserDefaults
    @objc private func saveToUserDefaults() {
        guard let text = saveTextField.text, !text.isEmpty else {
            showAlert(title: "提示", message: "请输入要保存的内容")
            return
        }

        UserDefaults.standard.set(text, forKey: "SavedText")
        showAlert(title: "成功", message: "数据已保存到 UserDefaults")
        saveTextField.text = ""
    }

    /// 从 UserDefaults 读取
    @objc private func loadFromUserDefaults() {
        let savedText = UserDefaults.standard.string(forKey: "SavedText") ?? "暂无数据"
        resultLabel.text = "读取结果: \(savedText)"
    }

    // MARK: - Keychain 相关方法

    /// 保存到 Keychain
    @objc private func saveToKeychain() {
        guard let password = keychainTextField.text, !password.isEmpty else {
            showAlert(title: "提示", message: "请输入要保存的密码")
            return
        }

        let success = KeychainHelper.save(password, service: "com.app.password", account: "user")
        if success {
            showAlert(title: "成功", message: "密码已安全保存到 Keychain")
            keychainTextField.text = ""
        } else {
            showAlert(title: "错误", message: "保存失败")
        }
    }

    /// 从 Keychain 读取
    @objc private func loadFromKeychain() {
        let password = KeychainHelper.load(service: "com.app.password", account: "user")
        keychainResultLabel.text = "读取结果: \(password ?? "暂无数据")"
    }

    /// 从 Keychain 删除
    @objc private func deleteFromKeychain() {
        let success = KeychainHelper.delete(service: "com.app.password", account: "user")
        if success {
            showAlert(title: "成功", message: "数据已从 Keychain 中删除")
            keychainResultLabel.text = "读取结果: 暂无数据"
        } else {
            showAlert(title: "提示", message: "删除失败或数据不存在")
        }
    }

    // MARK: - 文件存储相关方法

    /// 保存到文件
    @objc private func saveToFile() {
        guard let content = fileTextField.text, !content.isEmpty else {
            showAlert(title: "提示", message: "请输入要保存的内容")
            return
        }

        let fileName = "saved_data.txt"
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(fileName)

            do {
                try content.write(to: fileURL, atomically: true, encoding: .utf8)
                showAlert(title: "成功", message: "文件已保存到 Documents 目录")
                fileTextField.text = ""
            } catch {
                showAlert(title: "错误", message: "保存失败: \(error.localizedDescription)")
            }
        }
    }

    /// 从文件读取
    @objc private func loadFromFile() {
        let fileName = "saved_data.txt"
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(fileName)

            do {
                let content = try String(contentsOf: fileURL, encoding: .utf8)
                fileResultLabel.text = "读取结果: \(content)"
            } catch {
                fileResultLabel.text = "读取结果: 文件不存在或读取失败"
            }
        }
    }

    /// 删除文件
    @objc private func deleteFile() {
        let fileName = "saved_data.txt"
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(fileName)

            do {
                try FileManager.default.removeItem(at: fileURL)
                showAlert(title: "成功", message: "文件已删除")
                fileResultLabel.text = "读取结果: 暂无数据"
            } catch {
                showAlert(title: "提示", message: "删除失败或文件不存在")
            }
        }
    }
}

// MARK: - Keychain Helper
class KeychainHelper {

    /// 保存数据到 Keychain
    static func save(_ data: String, service: String, account: String) -> Bool {
        let data = data.data(using: .utf8)!

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)

        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }

    /// 从 Keychain 读取数据
    static func load(service: String, account: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }

        return nil
    }

    /// 从 Keychain 删除数据
    static func delete(service: String, account: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}

// MARK: - SQLite 相关方法
extension LocalStorageViewController {

    /// 添加用户
    @objc private func addUser() {
        guard let name = nameTextField.text, !name.isEmpty,
              let ageText = ageTextField.text, !ageText.isEmpty,
              let age = Int(ageText),
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "提示", message: "请填写完整的用户信息")
            return
        }

        let user = User(name: name, age: age, email: email)
        if SQLiteHelper.shared.insertUser(user) {
            showAlert(title: "成功", message: "用户添加成功")
            clearTextFields()
            queryUsers() // 自动刷新列表
        } else {
            showAlert(title: "错误", message: "用户添加失败")
        }
    }

    /// 查询用户列表
    @objc private func queryUsers() {
        let users = SQLiteHelper.shared.getAllUsers()
        if users.isEmpty {
            sqliteResultTextView.text = "暂无用户数据"
        } else {
            var result = "用户列表：\n\n"
            for (index, user) in users.enumerated() {
                result += "\(index + 1). 姓名: \(user.name), 年龄: \(user.age), 邮箱: \(user.email)\n"
            }
            sqliteResultTextView.text = result
        }
    }

    /// 更新用户（根据姓名更新）
    @objc private func updateUser() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "提示", message: "请输入要更新的用户姓名")
            return
        }

        guard let ageText = ageTextField.text, !ageText.isEmpty,
              let age = Int(ageText),
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "提示", message: "请填写完整的更新信息")
            return
        }

        if SQLiteHelper.shared.updateUser(name: name, newAge: age, newEmail: email) {
            showAlert(title: "成功", message: "用户信息更新成功")
            clearTextFields()
            queryUsers() // 自动刷新列表
        } else {
            showAlert(title: "错误", message: "用户更新失败，可能用户不存在")
        }
    }

    /// 删除用户（根据姓名删除）
    @objc private func deleteUser() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "提示", message: "请输入要删除的用户姓名")
            return
        }

        if SQLiteHelper.shared.deleteUser(name: name) {
            showAlert(title: "成功", message: "用户删除成功")
            clearTextFields()
            queryUsers() // 自动刷新列表
        } else {
            showAlert(title: "错误", message: "用户删除失败，可能用户不存在")
        }
    }

    /// 清空输入框
    private func clearTextFields() {
        nameTextField.text = ""
        ageTextField.text = ""
        emailTextField.text = ""
    }
}

// MARK: - User Model
struct User {
    let name: String
    let age: Int
    let email: String
}

// MARK: - SQLiteHelper
class SQLiteHelper {
    static let shared = SQLiteHelper()
    private var db: OpaquePointer?

    private init() {}

    /// 创建数据库和表
    func createDatabase() {
        // 获取数据库文件路径
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("LocalStorage.sqlite")

        // 打开数据库
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ 无法打开数据库")
            return
        }

        // 创建用户表
        let createTableSQL = """
            CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER NOT NULL,
            email TEXT NOT NULL);
        """

        if sqlite3_exec(db, createTableSQL, nil, nil, nil) != SQLITE_OK {
            print("❌ 无法创建用户表")
        } else {
            print("✅ 数据库和表创建成功")
        }
    }

    /// 插入用户
    func insertUser(_ user: User) -> Bool {
        let insertSQL = "INSERT INTO users (name, age, email) VALUES (?, ?, ?)"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, user.name, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(user.age))
            sqlite3_bind_text(statement, 3, user.email, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
        }

        sqlite3_finalize(statement)
        return false
    }

    /// 获取所有用户
    func getAllUsers() -> [User] {
        let querySQL = "SELECT name, age, email FROM users"
        var statement: OpaquePointer?
        var users: [User] = []

        if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let age = Int(sqlite3_column_int(statement, 1))
                let email = String(describing: String(cString: sqlite3_column_text(statement, 2)))

                users.append(User(name: name, age: age, email: email))
            }
        }

        sqlite3_finalize(statement)
        return users
    }

    /// 更新用户信息
    func updateUser(name: String, newAge: Int, newEmail: String) -> Bool {
        let updateSQL = "UPDATE users SET age = ?, email = ? WHERE name = ?"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, updateSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(newAge))
            sqlite3_bind_text(statement, 2, newEmail, -1, nil)
            sqlite3_bind_text(statement, 3, name, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                let changes = sqlite3_changes(db)
                sqlite3_finalize(statement)
                return changes > 0
            }
        }

        sqlite3_finalize(statement)
        return false
    }

    /// 删除用户
    func deleteUser(name: String) -> Bool {
        let deleteSQL = "DELETE FROM users WHERE name = ?"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, name, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                let changes = sqlite3_changes(db)
                sqlite3_finalize(statement)
                return changes > 0
            }
        }

        sqlite3_finalize(statement)
        return false
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
}