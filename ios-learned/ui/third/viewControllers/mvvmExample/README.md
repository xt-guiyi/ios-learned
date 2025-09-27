# MVVM 架构示例

这是一个完整的 MVVM (Model-View-ViewModel) 架构实现，展示了现代 iOS 开发的最佳实践。

## 🏗️ 架构概览

```
mvvmExample/
├── models/               # 数据模型层
│   └── User.swift       # 用户数据模型
├── services/            # 网络服务层
│   ├── APIError.swift   # 错误处理
│   ├── UserAPI.swift    # Moya API 定义
│   ├── UserService.swift # 服务实现
│   └── NetworkTest.swift # 网络测试
├── viewModels/          # 视图模型层
│   └── UserListViewModel.swift # 用户列表 ViewModel
└── views/               # 视图层
    ├── UserTableViewCell.swift # 用户单元格
    └── UserListViewController.swift # 用户列表控制器
```

## 🔧 技术栈

### 核心框架
- **Moya** - 类型安全的网络抽象层
- **RxSwift** - 响应式编程框架
- **Alamofire** - HTTP 网络库（Moya 的底层）
- **Kingfisher** - 图片加载和缓存
- **SnapKit** - Auto Layout 约束库
- **Toast-Swift** - 消息提示

### 架构模式
- **MVVM** - Model-View-ViewModel 分离
- **响应式编程** - RxSwift 数据绑定
- **依赖注入** - 服务层解耦
- **协议导向** - 面向协议编程

## 📱 功能特性

### 用户界面
- ✅ 卡片式用户列表
- ✅ 下拉刷新
- ✅ 实时搜索
- ✅ 滑动操作（编辑/删除）
- ✅ 空状态处理
- ✅ 加载状态管理
- ✅ 错误提示

### 数据操作
- ✅ 获取用户列表
- ✅ 创建新用户
- ✅ 更新用户信息
- ✅ 删除用户
- ✅ 搜索过滤

## 🌐 网络层架构

### Moya API 定义
```swift
enum UserAPI {
    case getAllUsers
    case getUser(id: Int)
    case createUser(user: User)
    case updateUser(user: User)
    case deleteUser(id: Int)
}
```

### 服务层实现
- **真实 API**: JSONPlaceholder REST API
- **Mock API**: 本地模拟数据
- **错误处理**: 统一错误映射
- **日志记录**: 网络请求日志

### 响应式数据流
```swift
// ViewModel 输入/输出分离
struct Inputs {
    let loadTrigger: PublishRelay<Void>
    let refreshTrigger: PublishRelay<Void>
    let selectUserTrigger: PublishRelay<User>
}

struct Outputs {
    let users: Driver<[User]>
    let isLoading: Driver<Bool>
    let error: Driver<APIError?>
}
```

## 🎯 核心类说明

### User (Model)
- 完整的用户数据模型
- 支持 JSON 序列化/反序列化
- 包含地址、公司等嵌套结构
- 便捷的计算属性和扩展方法

### UserService (Service)
- 网络请求封装
- 支持真实/Mock 两种模式
- RxSwift 响应式接口
- 统一错误处理

### UserListViewModel (ViewModel)
- 标准 MVVM 模式
- 输入/输出清晰分离
- 状态管理 (加载/刷新/错误)
- 业务逻辑封装

### UserListViewController (View)
- 纯 UI 逻辑
- RxSwift 数据绑定
- 用户交互处理
- 生命周期管理

### UserTableViewCell (View)
- 自定义单元格设计
- 支持头像显示
- 状态指示器
- 动画效果

## 🚀 使用方式

### 1. 基本使用
```swift
// 使用 Mock 数据
let viewModel = UserListViewModel(userService: UserService(useMock: true))

// 使用真实 API
let viewModel = UserListViewModel(userService: UserService(useMock: false))
```

### 2. 数据绑定
```swift
// 绑定用户列表
viewModel.users
    .bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.identifier))
    .disposed(by: disposeBag)

// 绑定加载状态
viewModel.isLoading
    .drive(loadingIndicator.rx.isAnimating)
    .disposed(by: disposeBag)
```

### 3. 用户交互
```swift
// 触发加载
viewModel.loadTrigger.accept(())

// 触发刷新
viewModel.refreshTrigger.accept(())

// 选择用户
viewModel.selectUserTrigger.accept(user)
```

## 🧪 测试

### 网络层测试
- 自动化网络请求测试
- Mock 数据验证
- CRUD 操作测试
- 错误处理测试

### 开发模式
在 DEBUG 模式下会自动运行网络测试，输出详细日志。

## 📖 设计模式

### 1. MVVM 分离
- **Model**: 纯数据结构
- **View**: 纯 UI 展示
- **ViewModel**: 业务逻辑和状态管理

### 2. 响应式编程
- **数据流**: 单向数据流
- **事件驱动**: 用户交互响应
- **异步处理**: RxSwift Observable

### 3. 依赖注入
- **协议抽象**: UserServiceProtocol
- **实现分离**: 真实/Mock 服务
- **测试友好**: 易于单元测试

## 🔍 最佳实践

### 代码结构
- 清晰的文件夹组织
- 职责单一原则
- 接口隔离原则
- 依赖倒置原则

### 错误处理
- 统一错误类型
- 用户友好提示
- 网络错误重试
- 状态恢复机制

### 性能优化
- 图片缓存 (Kingfisher)
- 数据缓存 (内存)
- 懒加载和复用
- 防抖搜索

### 用户体验
- 加载状态反馈
- 空状态提示
- 错误状态处理
- 流畅的动画效果

这个 MVVM 实现展示了现代 iOS 开发的完整技术栈和最佳实践，是学习和参考的优秀案例！ 🎉