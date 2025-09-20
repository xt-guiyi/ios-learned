<!--
 * @Author: xt-guiyi 1661219752@qq.com
 * @Date: 2025-04-26 17:20:47
 * @LastEditors: xt-guiyi 1661219752@qq.com
 * @LastEditTime: 2025-04-26 17:35:01
-->
# Frame和约束布局学习

## Constrain to Margins（边距约束）

### 1. 基本概念
- Margins是视图的内边距，默认为8点
- 它决定了自动布局约束是相对于视图的边距还是边界
- 可以理解为视图内容的"安全区域"

### 2. 两种模式对比

#### 勾选"Constrain to margins"时（默认）：
- 约束是相对于视图的margins（内边距）
- 会自动在视图边界内留出默认间距（通常8点）
- 更符合iOS的设计规范
- 适合大多数常规布局场景

#### 取消勾选时：
- 约束直接相对于视图的实际边界
- 内容可以紧贴视图边界
- 没有默认的内边距
- 适合需要精确控制或特殊布局的场景

### 3. 代码实现示例
```swift
// 使用margins的约束
view.leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor)

// 不使用margins的约束
view.leadingAnchor.constraint(equalTo: superview.leadingAnchor)

// 设置自定义margins
view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

// 是否保留父视图的margins
view.preservesSuperviewLayoutMargins = true
```

### 4. 使用建议
- 普通UI元素建议使用margins（保持勾选）
- 背景图片、全屏视图等可以取消margins
- 需要精确控制边距时可以取消margins
- 考虑iOS的设计规范和用户体验

### 5. 注意事项
- margins的值可能随系统版本变化
- Safe Area和margins是不同的概念
- 横竖屏切换时margins可能会改变
- 子视图可以选择是否继承父视图的margins

### 6. 使用场景举例

#### 应该使用margins的情况：
- 普通的文本标签
- 按钮
- 输入框
- 列表单元格的内容

#### 可以取消margins的情况：
- 背景图片
- 分割线
- 全屏视图
- 需要精确对齐的元素

### 7. 最佳实践
- 使用系统默认margins来保持界面一致性
- 需要特殊布局时再取消margins
- 合理使用layoutMargins属性自定义边距
- 注意视图层级中margins的继承关系

> 参考：
> - [iOS Auto Layout Margins](https://developer.apple.com/documentation/uikit/uiview/1622566-layoutmargins)
> - [Understanding Layout Margins](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithConstraints.html)

## 2. 约束布局属性

### 2.1 约束类型
1. **尺寸约束**
   - Width（宽度）
   - Height（高度）
   - Aspect Ratio（宽高比）

2. **位置约束**
   - Leading（左）
   - Trailing（右）
   - Top（上）
   - Bottom（下）
   - Center X（水平中心）
   - Center Y（垂直中心）
   - Baseline（基线）

3. **边距约束**
   - Leading Margin（左边距）
   - Trailing Margin（右边距）
   - Top Margin（上边距）
   - Bottom Margin（下边距）

### 2.2 约束关系
1. **等于关系**
   - Equal To（等于）
   - Greater Than or Equal To（大于等于）
   - Less Than or Equal To（小于等于）

2. **倍数关系**
   - Multiplier（倍数）
   - Constant（常量）

### 2.3 约束优先级
1. **系统预设优先级**
   - Required（必需）：1000
   - Default High（默认高）：750
   - Default Low（默认低）：250
   - Fitting Size Level（适应大小）：50

2. **自定义优先级**
   - 范围：1-1000
   - 值越大优先级越高
   - 值越小优先级越低

### 2.4 约束更新
1. **更新方法**
   - `setNeedsUpdateConstraints()`：标记需要更新约束
   - `updateConstraintsIfNeeded()`：立即更新约束
   - `layoutIfNeeded()`：立即布局

2. **动画更新**
```swift
// 更新约束并添加动画
UIView.animate(withDuration: 0.3) {
    self.view.layoutIfNeeded()
}
```

### 2.6 代码示例

#### 2.6.1 使用NSLayoutConstraint
```swift
// 创建约束
let constraint = NSLayoutConstraint(
    item: view1,
    attribute: .leading,
    relatedBy: .equal,
    toItem: view2,
    attribute: .trailing,
    multiplier: 1.0,
    constant: 20
)

// 激活约束
constraint.isActive = true

// 设置优先级
constraint.priority = .defaultHigh

// 更新约束
view.setNeedsUpdateConstraints()
view.updateConstraintsIfNeeded()
view.layoutIfNeeded()
```

#### 2.6.2 使用Anchor API
```swift
// 基本约束
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
    view.widthAnchor.constraint(equalToConstant: 100),
    view.heightAnchor.constraint(equalToConstant: 100)
])

// 相对约束
NSLayoutConstraint.activate([
    view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
    view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
])

// 比例约束
NSLayoutConstraint.activate([
    view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2.0)
])
```

#### 2.6.3 使用VFL（Visual Format Language）
```swift
// 水平约束
let hConstraints = NSLayoutConstraint.constraints(
    withVisualFormat: "H:|-20-[view1]-20-[view2]-20-|",
    options: [],
    metrics: nil,
    views: ["view1": view1, "view2": view2]
)

// 垂直约束
let vConstraints = NSLayoutConstraint.constraints(
    withVisualFormat: "V:|-20-[view1]-20-[view3]-20-|",
    options: [],
    metrics: nil,
    views: ["view1": view1, "view3": view3]
)

// 激活约束
NSLayoutConstraint.activate(hConstraints + vConstraints)
```

#### 2.6.4 使用Masonry
```swift
// 基本约束
view.mas_makeConstraints { make in
    make.top.equalTo(superview).offset(20)
    make.left.equalTo(superview).offset(20)
    make.width.equalTo(100)
    make.height.equalTo(100)
}

// 链式约束
view.mas_makeConstraints { make in
    make.edges.equalTo(superview).insets(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
}

// 相对约束
view.mas_makeConstraints { make in
    make.center.equalTo(superview)
    make.size.equalTo(CGSize(width: 100, height: 100))
}
```

#### 2.6.5 使用SnapKit
```swift
// 基本约束
view.snp.makeConstraints { make in
    make.top.equalTo(superview).offset(20)
    make.left.equalTo(superview).offset(20)
    make.width.equalTo(100)
    make.height.equalTo(100)
}

// 链式约束
view.snp.makeConstraints { make in
    make.edges.equalTo(superview).inset(20)
}

// 相对约束
view.snp.makeConstraints { make in
    make.center.equalTo(superview)
    make.size.equalTo(CGSize(width: 100, height: 100))
}
```

#### 2.6.6 动态更新约束
```swift
// 保存约束引用
var widthConstraint: NSLayoutConstraint?

// 创建约束
widthConstraint = view.widthAnchor.constraint(equalToConstant: 100)
widthConstraint?.isActive = true

// 更新约束
widthConstraint?.constant = 200
UIView.animate(withDuration: 0.3) {
    self.view.layoutIfNeeded()
}
```

#### 2.6.7 约束优先级
```swift
// 设置优先级
let constraint = view.widthAnchor.constraint(equalToConstant: 100)
constraint.priority = .defaultHigh
constraint.isActive = true

// 使用系统预设优先级
view.widthAnchor.constraint(equalToConstant: 100).priority = .required
view.heightAnchor.constraint(equalToConstant: 100).priority = .defaultHigh
view.leadingAnchor.constraint(equalTo: superview.leadingAnchor).priority = .defaultLow
```

#### 2.6.8 约束动画
```swift
// 更新约束并添加动画
UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
    self.view.layoutIfNeeded()
} completion: { _ in
    // 动画完成后的操作
}

// 使用Spring动画
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
    self.view.layoutIfNeeded()
}
```

### 2.7 各种约束布局写法的优劣

#### 2.7.1 NSLayoutConstraint
- 优点：
  - 原生API，无需额外依赖
  - 完全控制约束的创建和修改
  - 适合简单的约束场景
  - 性能较好

- 缺点：
  - 代码冗长，可读性差
  - 需要手动设置translatesAutoresizingMaskIntoConstraints
  - 不适合复杂的约束场景
  - 维护成本高

- 适用场景：
  - 简单的固定布局
  - 需要精确控制约束
  - 对性能要求高的场景

#### 2.7.2 Anchor API
- 优点：
  - 代码简洁，可读性好
  - 类型安全，编译时检查
  - 支持链式调用
  - 适合大多数布局场景

- 缺点：
  - 需要iOS 9.0以上
  - 某些复杂布局可能不够直观
  - 需要手动设置translatesAutoresizingMaskIntoConstraints

- 适用场景：
  - 大多数常规布局
  - 需要类型安全的场景
  - 现代iOS应用开发

#### 2.7.3 VFL（Visual Format Language）
- 优点：
  - 直观的字符串描述
  - 适合描述复杂的布局关系
  - 可以一次性创建多个约束
  - 适合描述水平和垂直布局

- 缺点：
  - 字符串容易出错
  - 调试困难
  - 不支持所有约束类型
  - 学习曲线较陡

- 适用场景：
  - 复杂的网格布局
  - 需要描述多个视图关系的场景
  - 水平或垂直的线性布局

#### 2.7.4 Masonry
- 优点：
  - 链式语法，代码简洁
  - 支持复杂的约束关系
  - 有丰富的辅助方法
  - 社区活跃，文档完善

- 缺点：
  - 需要引入第三方库
  - 性能略低于原生API
  - 某些特殊场景可能不够灵活
  - 需要手动设置translatesAutoresizingMaskIntoConstraints

- 适用场景：
  - 复杂的自适应布局
  - 需要快速开发的场景
  - 团队统一使用Masonry的项目

#### 2.7.5 SnapKit
- 优点：
  - 现代化的Swift语法
  - 类型安全，编译时检查
  - 支持链式调用
  - 文档完善，社区活跃

- 缺点：
  - 需要引入第三方库
  - 性能略低于原生API
  - 某些特殊场景可能不够灵活
  - 需要手动设置translatesAutoresizingMaskIntoConstraints

- 适用场景：
  - 现代Swift项目
  - 需要类型安全的场景
  - 团队统一使用SnapKit的项目

#### 2.7.6 选择建议
1. **简单项目**：
   - 使用Anchor API
   - 无需额外依赖
   - 代码简洁清晰

2. **复杂项目**：
   - 使用Masonry或SnapKit
   - 提高开发效率
   - 减少代码量

3. **性能敏感**：
   - 使用NSLayoutConstraint
   - 避免第三方库开销
   - 完全控制约束

4. **团队协作**：
   - 统一使用一种方式
   - 保持代码风格一致
   - 便于维护和调试

5. **特殊需求**：
   - 根据具体需求选择
   - 考虑项目特点
   - 权衡利弊

> 参考：
> - [iOS开发-自动布局篇：史上最全的自动布局教学！](https://juejin.cn/post/7019106172502278157)
> - [iOS中的Auto Layout和Frame](https://juejin.cn/post/6844903902802870286)
> - [系统理解 iOS 自动布局](https://chuquan.me/2019/09/25/systematic-understand-ios-autolayout/)
> - [iOS-UI布局是约束(Masonry)还是frame？虽各有优缺点，但使用frame真心没前途](https://chuquan.me/2019/09/25/systematic-understand-ios-autolayout/)