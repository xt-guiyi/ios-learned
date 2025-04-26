# Xcode Interface Builder 属性说明

## ViewController 属性

> 参考：
> - [属性1](https://www.fooval.cn/2016/09/24/storyboard/)


### <span style="color: red">Simulated Metrics</span>（模拟指标）
用于在设计界面时模拟不同的设备状态和环境条件，包括状态栏、导航栏、标签栏、工具栏等的显示/隐藏，以及设备方向、尺寸等设置。

> 参考：[利用 Simulated Metrics 和 Simulated Size 模拟 App 画面的 Top Bar，Bottom Bar 和大小](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-simulated-metrics-%E5%92%8C-simulated-size-%E6%A8%A1%E6%93%AC-app-%E7%95%AB%E9%9D%A2%E7%9A%84-top-bar-bottom-bar-%E5%92%8C%E5%A4%A7%E5%B0%8F-d3c5f17faa83)

1. **设备状态模拟**

   - Size（尺寸）：
     - Inferred：根据父视图控制器自动推断大小
     - Freeform：自由形式，可以自定义大小
     - Page Sheet：页面表单样式，从底部滑入
     - Form Sheet：表单样式，居中显示
     - Secondary：次要视图大小
     - Primary：主要视图大小

   - Top Bar（顶部栏）：
     - Inferred：根据父视图控制器自动推断
     - None：不显示顶部栏
     - Translucent Navigation Bar：半透明导航栏
     - Translucent Navigation Bar with prompt：带提示的半透明导航栏
     - Translucent black Navigation Bar：半透明黑色导航栏
     - Translucent black Navigation Bar with prompt：带提示的半透明黑色导航栏
     - Opaque Navigation Bar：不透明导航栏
     - Opaque Navigation Bar with prompt：带提示的不透明导航栏
     - Opaque black Navigation Bar：不透明黑色导航栏
     - Opaque black Navigation Bar with prompt：带提示的不透明黑色导航栏

   - Bottom Bar（底部栏）：
     - Inferred：根据父视图控制器自动推断
     - None：不显示底部栏
     - Tab Bar：标签栏
     - Toolbar：工具栏
     - Translucent Tab Bar：半透明标签栏
     - Translucent black Tab Bar：半透明黑色标签栏
     - Opaque Tab Bar：不透明标签栏
     - Opaque black Tab Bar：不透明黑色标签栏
     - Translucent Toolbar：半透明工具栏
     - Translucent black Toolbar：半透明黑色工具栏
     - Opaque Toolbar：不透明工具栏
     - Opaque black Toolbar：不透明黑色工具栏

   - Keyboard（键盘）：
     - Off：不显示键盘
     - On：显示默认键盘

### <span style="color: red">Layout</span>（布局）
控制视图控制器的布局行为，包含以下具体属性：




1. **Adjust Scroll View Insets**（调整滚动视图内边距）：
   - 作用：自动调整滚动视图的内边距
   - 影响：状态栏、导航栏、标签栏等系统UI区域
   - 使用场景：当视图控制器包含滚动视图时

2. **Hide Bottom Bar on Push**（推送时隐藏底部栏）：
   - 作用：在视图控制器被推送时隐藏底部栏
   - 影响：标签栏、工具栏等底部栏
   - 使用场景：需要全屏显示内容的页面

3. **Resize View from NIB**（从NIB调整视图大小）：
   - 作用：控制视图是否随父视图大小变化
   - 影响：视图的自动布局行为
   - 使用场景：需要动态调整视图大小的页面

4. **Under Top Bars**（在顶部栏下方）：
   - 作用：控制视图是否显示在顶部栏下方
   - 影响：状态栏、导航栏等顶部栏
   - 使用场景：需要内容延伸到顶部栏下方的页面

5. **Under Bottom Bars**（在底部栏下方）：
   - 作用：控制视图是否显示在底部栏下方
   - 影响：标签栏、工具栏等底部栏
   - 使用场景：需要内容延伸到底部栏下方的页面

6. **Under Opaque Bars**（在不透明栏下方）：
   - 作用：控制视图是否显示在不透明的系统栏下方
   - 影响：不透明的导航栏、标签栏等
   - 使用场景：需要内容延伸到不透明系统栏下方的页面
   - 注意：与 Under Top Bars 和 Under Bottom Bars 的区别在于只影响不透明的系统栏

### <span style="color: red">Transition Style</span>（转场样式）
控制视图控制器切换时的动画效果，主要选项：

1. **Cover Vertical**（垂直覆盖）：
   - 效果：新视图从底部向上滑入
   - 适用：标准的页面切换
   - 特点：最常用的转场方式

2. **Flip Horizontal**（水平翻转）：
   - 效果：视图水平翻转切换
   - 适用：需要特殊效果的页面切换
   - 特点：3D 翻转效果

3. **Cross Dissolve**（交叉溶解）：
   - 效果：两个视图交叉淡入淡出
   - 适用：需要柔和过渡的场景
   - 特点：平滑的过渡效果

4. **Partial Curl**（部分卷曲）：
   - 效果：当前页面向上卷曲
   - 适用：需要特殊效果的页面切换
   - 特点：类似翻书效果

使用场景：
1. **标准页面切换**：
   - 使用 Cover Vertical
   - 符合用户习惯
   - 最常用的转场方式

2. **特殊效果需求**：
   - 使用 Flip Horizontal 或 Partial Curl
   - 增加页面切换的趣味性
   - 突出重要内容

3. **柔和过渡**：
   - 使用 Cross Dissolve
   - 适合内容切换
   - 提供平滑的视觉体验

注意事项：
1. 选择合适的转场样式对用户体验很重要
2. 避免过度使用特殊效果
3. 考虑转场动画的性能影响
4. 保持应用内转场风格的一致性

### <span style="color: red">Presentation</span>（呈现方式）
控制视图控制器的呈现方式，主要选项：

1. **Full Screen**（全屏）：
   - 效果：完全覆盖当前视图
   - 适用：需要全屏显示的页面
   - 特点：最常用的呈现方式

2. **Page Sheet**（页面表单）：
   - 效果：从底部滑入，覆盖部分屏幕
   - 适用：需要用户输入或选择的页面
   - 特点：适合表单类页面

3. **Form Sheet**（表单）：
   - 效果：居中显示，周围有半透明背景
   - 适用：需要用户注意的弹窗
   - 特点：适合 iPad 设备

4. **Current Context**（当前上下文）：
   - 效果：在当前视图控制器的上下文中显示
   - 适用：需要保持当前视图状态的页面
   - 特点：继承当前视图的呈现方式

5. **Over Full Screen**（覆盖全屏）：
   - 效果：覆盖在当前视图上，保持背景可见
   - 适用：需要显示在现有内容上的页面
   - 特点：适合临时性的覆盖层

6. **Over Current Context**（覆盖当前上下文）：
   - 效果：覆盖在当前视图上，保持背景可见
   - 适用：需要显示在特定视图上的页面
   - 特点：适合弹出式界面

使用场景：
1. **标准页面切换**：
   - 使用 Full Screen
   - 符合用户习惯
   - 最常用的呈现方式

2. **表单类页面**：
   - 使用 Page Sheet 或 Form Sheet
   - 适合用户输入
   - 提供清晰的上下文

3. **弹出式界面**：
   - 使用 Over Full Screen 或 Over Current Context
   - 适合临时性内容
   - 保持背景可见

注意事项：
1. 选择合适的呈现方式对用户体验很重要
2. 考虑不同设备的适配
3. 注意呈现方式的性能影响
4. 保持应用内呈现风格的一致性

### <span style="color: red">Defines Context & Provides Context</span>（定义上下文和提供上下文）
控制视图控制器的上下文行为，主要选项：

1. **Defines Context**（定义上下文）：
   - 作用：定义视图控制器的上下文范围
   - 影响：子视图控制器的呈现方式
   - 使用场景：需要控制子视图控制器呈现方式的页面
   - 特点：影响子视图控制器的呈现行为

2. **Provides Context**（提供上下文）：
   - 作用：为子视图控制器提供上下文
   - 影响：子视图控制器的呈现效果
   - 使用场景：需要为子视图控制器提供特定呈现环境的页面
   - 特点：影响子视图控制器的显示效果

使用场景：
1. **嵌套视图控制器**：
   - 使用 Defines Context 控制子视图的呈现
   - 使用 Provides Context 提供显示环境
   - 实现复杂的页面层级关系

   **嵌套视图控制器详解**：
   - 基本概念：
     - 一个视图控制器可以包含其他视图控制器
     - 父视图控制器管理子视图控制器的生命周期
     - 子视图控制器可以独立管理自己的视图层级

   - 使用场景：
     - 分页控制器（Page View Controller）
     - 标签控制器（Tab Bar Controller）
     - 导航控制器（Navigation Controller）
     - 自定义容器控制器

   - 代码示例：
   ```swift
   // 1. 创建容器视图控制器
   class ContainerViewController: UIViewController {
       
       // 子视图控制器
       private var childVC: UIViewController?
       
       // 容器视图
       private let containerView: UIView = {
           let view = UIView()
           view.backgroundColor = .white
           return view
       }()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setupContainerView()
       }
       
       // 设置容器视图
       private func setupContainerView() {
           view.addSubview(containerView)
           containerView.frame = view.bounds
       }
       
       // 添加子视图控制器
       func addChildViewController(_ childVC: UIViewController) {
           // 1. 添加子视图控制器
           addChild(childVC)
           
           // 2. 添加子视图
           containerView.addSubview(childVC.view)
           childVC.view.frame = containerView.bounds
           
           // 3. 通知子视图控制器
           childVC.didMove(toParent: self)
           
           // 4. 保存引用
           self.childVC = childVC
       }
       
       // 移除子视图控制器
       func removeChildViewController() {
           // 1. 通知子视图控制器
           childVC?.willMove(toParent: nil)
           
           // 2. 移除子视图
           childVC?.view.removeFromSuperview()
           
           // 3. 移除子视图控制器
           childVC?.removeFromParent()
           
           // 4. 清除引用
           childVC = nil
       }
   }

   // 2. 使用示例
   class ExampleViewController: UIViewController {
       
       private let containerVC = ContainerViewController()
       private let childVC = UIViewController()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // 添加容器视图控制器
           addChild(containerVC)
           view.addSubview(containerVC.view)
           containerVC.view.frame = view.bounds
           containerVC.didMove(toParent: self)
           
           // 添加子视图控制器
           containerVC.addChildViewController(childVC)
       }
   }
   ```

   - 关键方法：
     - `addChild(_:)`: 添加子视图控制器
     - `removeFromParent()`: 移除子视图控制器
     - `willMove(toParent:)`: 子视图控制器即将被添加或移除
     - `didMove(toParent:)`: 子视图控制器已被添加或移除

   - 注意事项：
     - 必须按照正确的顺序调用方法
     - 注意内存管理，避免循环引用
     - 合理管理子视图控制器的生命周期
     - 考虑转场动画和交互效果

   - 常见问题：
     - 子视图控制器不显示
     - 内存泄漏
     - 转场动画异常
     - 布局问题

   - 最佳实践：
     - 使用专门的容器视图控制器
     - 实现清晰的接口
     - 处理各种生命周期事件
     - 考虑性能和内存使用

   - 调试技巧：
     - 使用视图层级调试器
     - 检查内存使用情况
     - 监控生命周期事件
     - 测试各种场景

2. **自定义转场**：
   - 通过上下文控制转场效果
   - 实现特殊的页面切换效果
   - 提供更好的用户体验

3. **模态展示**：
   - 控制模态视图的呈现方式
   - 提供合适的显示环境
   - 实现特定的交互效果

注意事项：
1. 合理设置上下文对页面层级很重要
2. 注意上下文对性能的影响
3. 考虑不同设备的适配
4. 保持应用内交互的一致性

### <span style="color: red">Content Size & Use Preferred Explicit Size</span>（内容大小和首选显式大小）
控制视图控制器的内容大小，主要选项：

1. **Content Size**（内容大小）：
   - 作用：定义视图控制器的首选内容大小
   - 设置选项：
     - Width：内容宽度
     - Height：内容高度
   - 使用场景：需要固定大小的视图控制器

2. **Use Preferred Explicit Size**（使用首选显式大小）：
   - 作用：是否使用显式设置的内容大小
   - 设置选项：
     - 启用：使用 Content Size 中设置的大小
     - 禁用：使用系统默认大小
   - 使用场景：需要精确控制视图控制器大小的场景

使用场景：
1. **固定大小页面**：
   - 设置具体的 Content Size
   - 启用 Use Preferred Explicit Size
   - 确保页面大小固定

2. **自适应大小页面**：
   - 不设置 Content Size
   - 禁用 Use Preferred Explicit Size
   - 让页面大小自适应内容

3. **特殊布局需求**：
   - 根据需求设置特定大小
   - 控制页面显示范围
   - 实现特殊布局效果

注意事项：
1. 设置的大小要合理，避免内容显示不完整
2. 考虑不同设备的适配
3. 注意与自动布局的配合
4. 考虑性能影响

### <span style="color: red">Key Commands</span>（键盘命令）
控制视图控制器对键盘快捷键的响应，主要选项：

1. **Key Command**（键盘命令）：
   - 作用：定义键盘快捷键
   - 设置选项：
     - Key：按键
     - Modifier Flags：修饰键（Command、Option、Shift、Control）
     - Action：触发的方法
   - 使用场景：需要支持键盘快捷键的页面

2. **常见快捷键组合**：
   - Command + 字母：常用操作
   - Command + Shift + 字母：扩展操作
   - Command + Option + 字母：特殊操作
   - Command + Control + 字母：系统操作

使用场景：
1. **编辑操作**：
   - 复制（Command + C）
   - 粘贴（Command + V）
   - 剪切（Command + X）
   - 撤销（Command + Z）

2. **导航操作**：
   - 返回（Command + [）
   - 前进（Command + ]）
   - 关闭（Command + W）
   - 刷新（Command + R）

3. **特殊功能**：
   - 搜索（Command + F）
   - 保存（Command + S）
   - 打印（Command + P）
   - 帮助（Command + ?）

注意事项：
1. 避免与系统快捷键冲突
2. 保持快捷键的一致性
3. 考虑不同设备的键盘布局
4. 提供快捷键提示

## View 属性

#### <span style="color: red">关于iOS自动布局和frame布局</span>
说明：在xib文件中，可以手动关闭自动布局，打开 "Size Inspector"（右侧面板）， 取消 "Use Auto Layout"
在Storyboard文件中，如果一个view没有添加约束那么他就是frame布局，可以设置frame， 如果添加了约束，就是自动布局，此时再去设置frame就不会生效，如果一定要生效有两个办法，一种就是去除view上面的所有约束，这样就变成了frame布局，一种就是在代码中设置translatesAutoresizingMaskIntoConstraints = true， 这样可以强制使用frame布局

### <span style="color: red">Content Mode</span>（内容模式）
用于控制视图内容的缩放和定位方式，主要分为三类：

1. **Scale 类型**（缩放）：
   - Scale To Fill：拉伸填充整个视图，可能会变形
   - Aspect Fit：保持比例缩放，确保内容完全显示
   - Aspect Fill：保持比例缩放，填满视图，可能会裁剪

2. **Position 类型**（位置）：
   - Center：内容居中显示
   - Top：内容靠上对齐
   - Bottom：内容靠下对齐
   - Left：内容靠左对齐
   - Right：内容靠右对齐
   - TopLeft：内容靠左上对齐
   - TopRight：内容靠右上对齐
   - BottomLeft：内容靠左下对齐
   - BottomRight：内容靠右下对齐

3. **Redraw 类型**（重绘）：
   - Redraw：在视图大小改变时重新绘制内容

常见使用场景：
1. **图片视图**（UIImageView）：
   - Aspect Fit：显示完整图片
   - Aspect Fill：填满视图但可能裁剪
   - Scale To Fill：拉伸填满但可能变形

2. **自定义视图**：
   - Redraw：需要自定义绘制内容时使用
   - Center：内容固定大小居中显示

3. **背景图片**：
   - Scale To Fill：通常用于背景图片填充

#### <span style="color: red">Semantic</span>（语义）
用于支持从右到左（RTL）布局的属性，主要选项：

1. **Unspecified**（未指定）：
   - 使用系统默认的布局方向
   - 根据系统语言自动调整

2. **Force Left-to-Right**（强制从左到右）：
   - 强制使用从左到右的布局
   - 忽略系统语言设置

3. **Force Right-to-Left**（强制从右到左）：
   - 强制使用从右到左的布局
   - 忽略系统语言设置

4. **Match Parent**（匹配父视图）：
   - 使用父视图的布局方向
   - 继承父视图的语义设置

5. **Playback**（播放）：
   - 用于控制视频或音频播放的方向
   - 影响媒体内容的播放方向
   - 适用于视频播放器、音频播放器等控件
   - 会根据系统语言自动调整播放方向

6. **Spatial**（空间）：
   - 用于控制空间布局的方向
   - 影响 3D 或空间相关的界面元素
   - 适用于 AR、VR 等空间应用
   - 控制空间坐标系的方向

使用场景：
1. **国际化应用**：
   - 支持阿拉伯语等从右到左的语言
   - 自动调整界面布局方向

2. **特殊布局需求**：
   - 强制使用特定方向的布局
   - 忽略系统语言设置

3. **嵌套视图**：
   - 子视图继承父视图的布局方向
   - 保持布局方向的一致性

4. **媒体播放**：
   - 控制视频和音频的播放方向
   - 适应不同语言的播放习惯

5. **空间应用**：
   - 控制 AR/VR 应用的空间方向
   - 适应不同语言的用户习惯

注意事项：
1. 选择合适的语义设置对用户体验很重要
2. 需要考虑不同语言的使用习惯
3. 媒体播放和空间布局需要特别注意方向设置
4. 子视图的语义设置会影响整体布局效果

#### <span style="color: red">Tag</span>（标签）
用于标识和区分视图的整数值，主要用途：

1. **视图识别**：
   - 通过 tag 值快速找到特定视图
   - 在代码中通过 `viewWithTag:` 方法获取视图

2. **视图分组**：
   - 使用相同的 tag 值对相关视图进行分组
   - 方便批量处理相同类型的视图

3. **动态操作**：
   - 在运行时通过 tag 值操作视图
   - 不需要创建 IBOutlet 连接

使用示例：
```swift
// 设置 tag
view.tag = 100

// 通过 tag 获取视图
if let targetView = view.viewWithTag(100) {
    // 操作视图
}
```

注意事项：
1. tag 值应该是唯一的，避免冲突
2. 建议使用常量定义 tag 值
3. 不要过度依赖 tag，优先使用 IBOutlet

#### <span style="color: red">User Interaction Enable</span>（用户交互）
控制视图是否响应用户交互的属性，主要用途：

1. **交互控制**：
   - 启用/禁用视图的触摸事件
   - 控制视图是否响应用户操作

2. **事件传递**：
   - 影响触摸事件的传递链
   - 决定子视图是否接收触摸事件

3. **视图状态**：
   - 控制视图是否处于可交互状态
   - 影响视图的视觉反馈

使用场景：
1. **禁用交互**：
   - 临时禁用某个视图的交互
   - 防止用户误操作

2. **视图层级**：
   - 控制触摸事件的传递
   - 管理复杂的交互逻辑

3. **状态管理**：
   - 根据业务逻辑控制交互状态
   - 实现条件性的交互控制

注意事项：
1. 禁用交互会影响所有子视图
2. 需要合理管理交互状态
3. 考虑用户体验的影响

#### <span style="color: red">Multiple Touch</span>（多点触控）
控制视图是否支持多点触控的属性，主要用途：

1. **触控支持**：
   - 启用/禁用多点触控
   - 控制同时接收的触摸点数量

2. **手势识别**：
   - 支持复杂的手势操作
   - 实现多点触控手势

3. **交互体验**：
   - 提供更丰富的交互方式
   - 支持多指操作

使用场景：
1. **手势操作**：
   - 捏合缩放
   - 旋转操作
   - 多指滑动

2. **游戏控制**：
   - 多指触控
   - 复杂操作

3. **特殊交互**：
   - 多指绘图
   - 多指编辑

注意事项：
1. 启用多点触控会增加性能开销
2. 需要合理处理多点触控事件
3. 考虑不同设备的支持情况

#### <span style="color: red">Tint</span>（主题色）
用于设置视图及其子视图的主题色，主要用途：

1. **颜色统一**：
   - 设置整个视图层次结构的主题色
   - 保持界面颜色风格一致

2. **交互元素**：
   - 影响按钮、图标等交互元素的颜色
   - 提供视觉反馈

3. **状态指示**：
   - 表示控件的状态
   - 提供用户反馈

使用场景：
1. **按钮颜色**：
   - 设置按钮的默认颜色
   - 统一按钮样式

2. **图标颜色**：
   - 设置图标的颜色
   - 保持图标风格一致

3. **文本颜色**：
   - 设置文本的默认颜色
   - 统一文本样式

注意事项：
1. Tint 颜色会继承给子视图
2. 子视图可以覆盖父视图的 Tint 颜色
3. 合理使用 Tint 可以保持界面风格统一

#### <span style="color: red">Drawing</span>（绘制）
控制视图绘制行为的属性，主要用途：

1. **绘制控制**：
   - Opaque：视图是否不透明
   - Hidden：视图是否隐藏（完全消失，不占用布局，alpha则是视觉不可见）
   - Clears Graphics Context：是否清除图形上下文
   - Clip To Bounds：是否裁剪超出边界的部分

2. **性能优化**：
   - 控制视图的绘制方式
   - 优化渲染性能

3. **视觉效果**：
   - 控制视图的显示效果
   - 实现特殊的视觉效果

使用场景：
1. **性能优化**：
   - 设置 Opaque 提高渲染性能
   - 使用 Clip To Bounds 控制显示范围

2. **视觉效果**：
   - 使用 Hidden 控制视图显示
   - 通过 Clears Graphics Context 控制绘制

3. **自定义绘制**：
   - 控制绘制行为
   - 实现自定义效果

注意事项：
1. Opaque 设置不当会影响性能
2. Clip To Bounds 会影响子视图显示
3. 需要合理设置绘制属性

#### <span style="color: red">Stretching</span>（拉伸）
控制视图拉伸行为的属性，主要用途：

1. **拉伸控制**：
   - X：水平方向的拉伸比例
   - Y：垂直方向的拉伸比例
   - Width：水平方向的拉伸区域
   - Height：垂直方向的拉伸区域

2. **图片适配**：
   - 控制图片的拉伸方式
   - 实现可伸缩的背景图片
   - 优化图片显示效果

3. **性能优化**：
   - 减少图片资源大小
   - 提高渲染性能
   - 优化内存使用

使用场景：
1. **背景图片**：
   - 创建可伸缩的背景
   - 适配不同尺寸的视图
   - 实现特殊视觉效果

2. **按钮背景**：
   - 创建可伸缩的按钮背景
   - 适配不同大小的按钮
   - 保持按钮样式一致

3. **特殊效果**：
   - 实现渐变效果
   - 创建特殊形状
   - 优化显示效果

注意事项：
1. 合理设置拉伸区域可以避免图片变形
2. 拉伸区域应该选择图片中适合拉伸的部分
3. 过度拉伸可能影响图片质量
4. 需要根据实际需求调整拉伸参数

### <span style="color: red">嵌套视图控制器</span>（Container View Controller）
一个视图控制器可以包含其他视图控制器，父视图控制器管理子视图控制器的生命周期。

1. **基本概念**：
   - 一个视图控制器可以包含其他视图控制器
   - 父视图控制器管理子视图控制器的生命周期
   - 子视图控制器可以独立管理自己的视图层级

2. **使用场景**：
   - 分页控制器（Page View Controller）
   - 标签控制器（Tab Bar Controller）
   - 导航控制器（Navigation Controller）
   - 自定义容器控制器

3. **代码示例**：
```swift
// 1. 创建容器视图控制器
class ContainerViewController: UIViewController {
    
    // 子视图控制器
    private var childVC: UIViewController?
    
    // 容器视图
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    // 设置容器视图
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.frame = view.bounds
    }
    
    // 添加子视图控制器
    func addChildViewController(_ childVC: UIViewController) {
        // 1. 添加子视图控制器
        addChild(childVC)
        
        // 2. 添加子视图
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        
        // 3. 通知子视图控制器
        childVC.didMove(toParent: self)
        
        // 4. 保存引用
        self.childVC = childVC
    }
    
    // 移除子视图控制器
    func removeChildViewController() {
        // 1. 通知子视图控制器
        childVC?.willMove(toParent: nil)
        
        // 2. 移除子视图
        childVC?.view.removeFromSuperview()
        
        // 3. 移除子视图控制器
        childVC?.removeFromParent()
        
        // 4. 清除引用
        childVC = nil
    }
}

// 2. 使用示例
class ExampleViewController: UIViewController {
    
    private let containerVC = ContainerViewController()
    private let childVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加容器视图控制器
        addChild(containerVC)
        view.addSubview(containerVC.view)
        containerVC.view.frame = view.bounds
        containerVC.didMove(toParent: self)
        
        // 添加子视图控制器
        containerVC.addChildViewController(childVC)
    }
}
```

4. **关键方法**：
   - `addChild(_:)`: 添加子视图控制器
   - `removeFromParent()`: 移除子视图控制器
   - `willMove(toParent:)`: 子视图控制器即将被添加或移除
   - `didMove(toParent:)`: 子视图控制器已被添加或移除

5. **注意事项**：
   - 必须按照正确的顺序调用方法
   - 注意内存管理，避免循环引用
   - 合理管理子视图控制器的生命周期
   - 考虑转场动画和交互效果

6. **常见问题**：
   - 子视图控制器不显示
   - 内存泄漏
   - 转场动画异常
   - 布局问题

7. **最佳实践**：
   - 使用专门的容器视图控制器
   - 实现清晰的接口
   - 处理各种生命周期事件
   - 考虑性能和内存使用

8. **调试技巧**：
   - 使用视图层级调试器
   - 检查内存使用情况
   - 监控生命周期事件
   - 测试各种场景