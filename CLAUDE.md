# CLAUDE.md

这个文件为 Claude Code (claude.ai/code) 在这个代码库中工作时提供指导。

## 项目概述

这是一个 iOS 学习项目，主要用于学习 iOS 开发的基础概念和实践。项目使用 Swift 语言和 UIKit 框架开发，采用 Storyboard 进行界面布局。

## 构建和运行

使用 Xcode 打开项目：
```bash
open ios-learned.xcodeproj
```

或者在 Finder 中双击 `ios-learned.xcodeproj` 文件。

项目需要在 Xcode 中运行，主要构建命令：
- 构建项目：Command + B
- 运行项目：Command + R
- 清理构建：Command + Shift + K

## 项目架构

### 目录结构
- `ios-learned/` - 主要源代码目录
  - `AppDelegate.swift` - 应用程序生命周期管理
  - `SceneDelegate.swift` - 场景生命周期管理
  - `Info.plist` - 应用配置信息
  - `Assets.xcassets/` - 图像资源（包含 AppIcon、avatar、dahe 等图片）
  - `Base.lproj/` - 本地化资源
    - `LaunchScreen.storyboard` - 启动画面
  - `ui/` - UI 相关代码
    - `Base.lproj/Main.storyboard` - 主界面布局
    - `tabbar/HomeViewController.swift` - 首页视图控制器
- `学习文档/` - iOS 学习文档
  - 包含 Xcode 快捷键、Swift 语法、OC 语法、界面布局等学习资料

### 技术栈
- **语言**: Swift
- **UI框架**: UIKit
- **界面布局**: Storyboard + Auto Layout
- **架构模式**: MVC (Model-View-Controller)

### 核心组件
- **AppDelegate**: 应用程序启动和生命周期管理
- **SceneDelegate**: iOS 13+ 多场景支持的场景管理
- **HomeViewController**: 主页面控制器，实现了 UITableView 的基本功能
  - 使用 UITableViewDataSource 和 UITableViewDelegate 协议
  - 显示 200 行数据的列表
  - 支持点击导航到详情页面

## 开发注意事项

### 代码规范
- 使用 Swift 语言开发
- 遵循 iOS 开发最佳实践
- 使用 UIKit 框架进行界面开发
- 采用 MVC 架构模式组织代码

### 界面开发
- 主要使用 Storyboard 进行界面设计
- 使用 @IBOutlet 连接界面元素
- 通过 Auto Layout 进行约束布局
- 图片资源存放在 Assets.xcassets 中

### 学习资源
项目包含完整的学习文档，涵盖：
- iOS 开发基础概念
- Swift 和 Objective-C 语法
- Xcode 使用技巧和快捷键
- 界面布局和约束系统
- Interface Builder 属性说明

## 项目特点

这是一个教学项目，专注于：
1. iOS 基础开发概念的实践
2. UIKit 组件的使用（特别是 UITableView）
3. 导航控制器的使用
4. 图像资源的管理和使用
5. MVC 架构模式的应用

项目结构简单清晰，适合 iOS 开发初学者理解和学习基本概念。