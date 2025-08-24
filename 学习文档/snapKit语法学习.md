# SnapKit 语法学习

SnapKit 是一个用于iOS和macOS的Swift Auto Layout库，提供了简洁易用的DSL语法来创建约束。

## 基础语法

### 1. 基本约束设置

```swift
view.snp.makeConstraints { make in
    make.top.equalToSuperview()
    make.left.right.equalToSuperview()
    make.height.equalTo(50)
}
```

### 2. 约束的类型

#### 位置约束
```swift
// 顶部
make.top.equalToSuperview()
make.top.equalTo(otherView.snp.bottom)

// 底部
make.bottom.equalToSuperview()
make.bottom.equalTo(otherView.snp.top)

// 左边
make.left.equalToSuperview()
make.leading.equalToSuperview()

// 右边
make.right.equalToSuperview()
make.trailing.equalToSuperview()

// 中心
make.center.equalToSuperview()
make.centerX.equalToSuperview()
make.centerY.equalToSuperview()
```

#### 尺寸约束
```swift
// 宽度
make.width.equalTo(100)
make.width.equalToSuperview()
make.width.equalTo(otherView)

// 高度
make.height.equalTo(50)
make.height.equalToSuperview()
make.height.equalTo(otherView)

// 尺寸
make.size.equalTo(CGSize(width: 100, height: 50))
make.size.equalToSuperview()
```

### 3. 边距和偏移

```swift
// 边距 inset（向内缩进）
make.edges.equalToSuperview().inset(16)
make.left.right.equalToSuperview().inset(20)
make.top.bottom.equalToSuperview().inset(10)

// 偏移 offset（位置偏移）
make.top.equalToSuperview().offset(20)
make.bottom.equalToSuperview().offset(-20)
make.left.equalToSuperview().offset(16)
make.right.equalToSuperview().offset(-16)
```

### 4. 安全区域

```swift
// 安全区域约束
make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
make.right.equalTo(view.safeAreaLayoutGuide.snp.right)

// 简写
make.edges.equalTo(view.safeAreaLayoutGuide)
```

### 5. 相对于其他视图的约束

```swift
// 相对于其他视图
make.top.equalTo(headerView.snp.bottom).offset(20)
make.left.equalTo(titleLabel.snp.right).offset(10)
make.centerY.equalTo(otherView)
make.width.equalTo(otherView).multipliedBy(0.5)
```

## 高级用法

### 1. 优先级设置

```swift
make.height.equalTo(50).priority(.high)
make.width.lessThanOrEqualToSuperview().priority(.medium)
make.top.equalToSuperview().priority(.low)

// 使用数字优先级
make.height.equalTo(50).priority(999)
```

### 2. 条件约束

```swift
make.width.equalTo(100).priority(isSmallScreen ? .high : .low)
make.height.equalTo(isLandscape ? 50 : 100)
```

### 3. 更新约束

```swift
// 更新已有约束
view.snp.updateConstraints { make in
    make.height.equalTo(newHeight)
}

// 重新设置所有约束
view.snp.remakeConstraints { make in
    make.center.equalToSuperview()
    make.width.height.equalTo(100)
}
```

### 4. 比例约束

```swift
// 宽度是父视图的一半
make.width.equalToSuperview().multipliedBy(0.5)

// 高度是宽度的比例
make.height.equalTo(view.snp.width).multipliedBy(0.6)

// 宽高比
make.width.equalTo(view.snp.height).multipliedBy(16.0/9.0)
```

### 5. 最大最小约束

```swift
// 最小约束
make.height.greaterThanOrEqualTo(50)
make.width.greaterThanOrEqualToSuperview().multipliedBy(0.3)

// 最大约束
make.height.lessThanOrEqualTo(200)
make.width.lessThanOrEqualToSuperview().offset(-40)
```

## 常用布局模式

### 1. 填充父视图
```swift
view.snp.makeConstraints { make in
    make.edges.equalToSuperview()
}
```

### 2. 居中显示
```swift
view.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.height.equalTo(100)
}
```

### 3. 顶部对齐，左右边距
```swift
view.snp.makeConstraints { make in
    make.top.equalToSuperview().offset(20)
    make.left.right.equalToSuperview().inset(16)
    make.height.equalTo(44)
}
```

### 4. 底部对齐，安全区域
```swift
view.snp.makeConstraints { make in
    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
    make.left.right.equalToSuperview().inset(16)
    make.height.equalTo(50)
}
```

### 5. 垂直堆叠
```swift
// 第一个视图
firstView.snp.makeConstraints { make in
    make.top.equalToSuperview().offset(20)
    make.left.right.equalToSuperview().inset(16)
    make.height.equalTo(44)
}

// 第二个视图
secondView.snp.makeConstraints { make in
    make.top.equalTo(firstView.snp.bottom).offset(10)
    make.left.right.equalToSuperview().inset(16)
    make.height.equalTo(44)
}
```

### 6. 水平排列
```swift
// 左侧视图
leftView.snp.makeConstraints { make in
    make.left.equalToSuperview().offset(16)
    make.top.bottom.equalToSuperview()
    make.width.equalTo(100)
}

// 右侧视图
rightView.snp.makeConstraints { make in
    make.left.equalTo(leftView.snp.right).offset(10)
    make.right.equalToSuperview().offset(-16)
    make.top.bottom.equalToSuperview()
}
```

## 实用技巧

### 1. 链式调用
```swift
make.top.left.right.equalToSuperview()
make.width.height.equalTo(50)
```

### 2. 使用变量存储约束
```swift
var heightConstraint: Constraint?

view.snp.makeConstraints { make in
    heightConstraint = make.height.equalTo(50).constraint
}

// 后续更新
heightConstraint?.update(offset: 100)
```

### 3. 动画约束变化
```swift
// 更新约束
view.snp.updateConstraints { make in
    make.height.equalTo(200)
}

// 执行动画
UIView.animate(withDuration: 0.3) {
    self.view.layoutIfNeeded()
}
```

### 4. ScrollView约束
```swift
scrollView.snp.makeConstraints { make in
    make.edges.equalToSuperview()
}

contentView.snp.makeConstraints { make in
    make.edges.equalToSuperview()
    make.width.equalToSuperview()
    // 高度由内容决定，或设置固定高度
}
```

### 5. 调试约束
```swift
#if DEBUG
make.height.equalTo(50).labeled("view height")
#endif
```

## 注意事项

1. **避免约束冲突**: 确保约束逻辑正确，避免相互冲突的约束
2. **性能考虑**: 频繁更新约束可能影响性能，考虑使用transform代替
3. **安全区域**: 在适当的地方使用安全区域约束
4. **优先级**: 合理设置约束优先级，解决约束冲突
5. **内存管理**: 适当时机移除不需要的约束

## 项目中的实际应用

### NavigationBar 约束示例
```swift
navigationBar.snp.makeConstraints { make in
    make.top.equalToSuperview()
    make.left.right.equalToSuperview()
    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
}
```

### ScrollView + ContentView 约束示例
```swift
// ScrollView 填充整个区域
scrollView.snp.makeConstraints { make in
    make.top.equalTo(navigationBar.snp.bottom)
    make.left.right.bottom.equalToSuperview()
}

// ContentView 约束
contentView.snp.makeConstraints { make in
    make.edges.equalToSuperview()
    make.width.equalToSuperview()
}
```

### 卡片容器约束示例
```swift
containerView.snp.makeConstraints { make in
    make.top.equalTo(previousView.snp.bottom).offset(20)
    make.left.right.equalToSuperview().inset(16)
}
```

### 按钮约束示例
```swift
button.snp.makeConstraints { make in
    make.centerX.equalToSuperview()
    make.height.equalTo(44)
    make.width.equalTo(120)
    make.bottom.equalToSuperview().offset(-16)
}
```

### 文本标签约束示例
```swift
titleLabel.snp.makeConstraints { make in
    make.top.left.equalToSuperview().offset(16)
    make.right.equalToSuperview().offset(-16)
}

descLabel.snp.makeConstraints { make in
    make.top.equalTo(titleLabel.snp.bottom).offset(4)
    make.left.right.equalTo(titleLabel)
}
```