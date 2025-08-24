# CLAUDE.md

这个文件为 Claude Code (claude.ai/code) 在这个代码库中工作时提供指导。

## 项目概述

这是一个 iOS 学习项目，主要用于学习 iOS 开发的基础概念和实践。项目使用 Swift 语言和 UIKit 框架开发，采用纯代码 + SnapKit 进行界面布局，实现了完整的 TabBar 架构和可复用的 UI 组件系统。

## 构建和运行

使用 Xcode 打开项目：
```bash
open ios-learned.xcodeproj
```

或者在 Finder 中双击 `ios-learned.xcodeproj` 文件。

项目使用 CocoaPods 管理依赖，首次运行前需要：
```bash
pod install
```

之后使用 `.xcworkspace` 文件打开项目：
```bash
open ios-learned.xcworkspace
```

主要构建命令：
- 构建项目：Command + B
- 运行项目：Command + R
- 清理构建：Command + Shift + K

## 项目架构

### 目录结构
```
ios-learned/
├── AppDelegate.swift              - 应用程序生命周期管理
├── SceneDelegate.swift             - 场景生命周期管理
├── Info.plist                     - 应用配置信息
├── Assets.xcassets/               - 图像资源
│   ├── AppIcon.imageset/          - 应用图标
│   ├── home.imageset/             - 首页Tab图标
│   ├── home-select.imageset/      - 首页Tab选中图标
│   ├── function.imageset/         - 功能Tab图标
│   ├── function-select.imageset/  - 功能Tab选中图标
│   ├── third.imageset/            - 第三方Tab图标
│   ├── third-select.imageset/     - 第三方Tab选中图标
│   └── arrow-left.imageset/       - 返回箭头图标
├── extensions/                    - 扩展方法
│   ├── UIColor+Extension.swift    - 颜色扩展（主题色定义）
│   ├── UIImage+Extension.swift    - 图片扩展（便捷访问）
│   └── UIViewController+Extension.swift - 视图控制器扩展
└── ui/                           - UI 相关代码
    ├── components/               - 可复用UI组件
    │   ├── headerView/
    │   │   └── PageHeaderView.swift      - 页面头部组件
    │   ├── listView/
    │   │   ├── CardListViewController.swift - 卡片列表控制器
    │   │   ├── CardListCell.swift        - 卡片列表单元格
    │   │   └── ListItemModel.swift       - 列表项数据模型
    │   └── navigationBar/
    │       └── CustomNavigationBar.swift - 自定义导航栏组件
    ├── tabbar/
    │   └── viewControllers/
    │       └── TabbarViewController.swift - TabBar主控制器
    ├── home/                     - 首页模块（控件学习）
    │   └── viewControllers/
    │       ├── HomeRootViewController.swift    - 首页根控制器
    │       └── ButtonExampleViewController.swift - 按钮示例页
    ├── function/                 - 功能模块（进阶内容）
    │   └── viewControllers/
    │       └── FunctionRootViewController.swift - 功能根控制器
    └── third/                    - 第三方模块（案例库）
        └── viewControllers/
            └── ThirdRootViewController.swift   - 第三方根控制器
```

### 依赖管理
- `Podfile` - CocoaPods 依赖配置
- `Podfile.lock` - 锁定的依赖版本
- 主要依赖：SnapKit（Auto Layout 约束库）

### 技术栈
- **语言**: Swift
- **UI框架**: UIKit
- **界面布局**: 纯代码 + SnapKit
- **架构模式**: MVC + 组件化
- **依赖管理**: CocoaPods
- **约束布局**: SnapKit

### 应用架构
```
SceneDelegate
    ↓
NavigationController (根控制器)
    ↓
TabBarController (主界面)
    ├── NavigationController (控件模块)
    │   └── HomeRootViewController
    │       └── ButtonExampleViewController (详情页)
    ├── NavigationController (进阶模块)
    │   └── FunctionRootViewController
    └── NavigationController (案例库模块)
        └── ThirdRootViewController
```

### 核心组件

#### 1. 应用入口
- **SceneDelegate**: 场景管理，创建根NavigationController包含TabBarController
- **TabbarViewController**: 继承UITabBarController，管理三个主要模块

#### 2. 可复用UI组件
- **PageHeaderView**: 页面头部组件，支持标题和副标题
- **CardListViewController**: 卡片样式的列表控制器
- **CardListCell**: 自定义表格单元格，卡片设计风格
- **CustomNavigationBar**: 自定义导航栏，支持标题和返回按钮
- **ListItemModel**: 列表项数据模型，支持点击回调

#### 3. 主要模块
- **HomeRootViewController**: 控件学习模块，展示各种UI控件示例
- **ButtonExampleViewController**: 按钮控件详情页，包含6种按钮样式
- **FunctionRootViewController**: 进阶功能模块（待扩展）
- **ThirdRootViewController**: 案例库模块（待扩展）

#### 4. 扩展工具
- **UIColor+Extension**: 主题色定义 (#1CC787)
- **UIImage+Extension**: 图片资源便捷访问
- **UIViewController+Extension**: 子控制器管理扩展

## 功能模块

### 1. 控件学习模块 (HomeRootViewController)
展示各种 iOS 基础控件的使用方法：
- **按钮控件**: 6种按钮样式（基础、主题色、边框、圆形、图标、文本）
- **文本控件**: UILabel 的各种使用方式（待实现）
- **图片控件**: UIImageView 的各种使用方式（待实现）
- **输入控件**: UITextField/UITextView 的使用（待实现）
- **选择控件**: 单选、多选、开关按钮（待实现）

### 2. 进阶功能模块 (FunctionRootViewController)
iOS 进阶开发技巧（待扩展）

### 3. 案例库模块 (ThirdRootViewController)
实际应用案例展示（待扩展）

## 开发指南

### 代码规范
- 使用 Swift 语言开发
- 采用纯代码 + SnapKit 进行界面布局
- 使用组件化开发思想，创建可复用的UI组件
- 遵循 MVC 架构模式
- 统一使用主题色系统 `UIColor.themeColor`

### 添加新控件示例
1. 在对应模块的 `ListItemModel` 数组中添加新项
2. 创建新的详情 ViewController
3. 使用 `CustomNavigationBar` 组件创建导航栏
4. 实现具体的控件示例和交互逻辑

### 界面布局
- 全部使用 SnapKit 进行约束布局
- 遵循组件化设计原则，优先使用现有组件
- 图片资源统一存放在 Assets.xcassets 中
- 使用扩展方法便捷访问资源 (`UIImage.home`, `UIColor.themeColor`)

### 导航流程
- 使用 NavigationController 进行页面跳转
- DetailViewController 使用 `navigationController?.pushViewController` 进行导航
- 返回使用 `navigationController?.popViewController` 

### 主题色配置
项目使用统一的绿色主题：
```swift
UIColor.themeColor // #1CC787
```

## 项目特点

这是一个现代化的 iOS 学习项目，特点包括：

1. **组件化架构**: 可复用的UI组件，便于维护和扩展
2. **纯代码布局**: 使用 SnapKit 进行约束，告别 Storyboard
3. **模块化设计**: 清晰的模块划分，便于学习和理解
4. **统一设计语言**: 主题色系统和一致的视觉风格
5. **现代开发实践**: CocoaPods 依赖管理，扩展方法等
6. **完整导航体验**: 多层级导航，支持深层页面跳转

适合 iOS 开发初学者和中级开发者学习现代 iOS 开发技术和最佳实践。
- 写的每个方法都要写方法注释