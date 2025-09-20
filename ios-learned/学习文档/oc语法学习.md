# Objective-C 语法学习

## 一、基础语法
### 1. 变量声明
变量声明是 Objective-C 中最基础的语法之一，用于存储和操作数据。Objective-C 是 C 语言的超集，因此支持 C 语言的所有基本类型，同时添加了面向对象的特性。在 Objective-C 中，变量声明需要指定类型，对于对象类型还需要使用指针。

```objc
// 基本类型声明
int number = 10;                    // 整数
float floatNumber = 3.14f;          // 单精度浮点数
double doubleNumber = 3.1415926;    // 双精度浮点数
char character = 'A';               // 字符
BOOL isTrue = YES;                  // 布尔值（YES/NO）

// 指针类型
NSString *string = @"Hello";        // 字符串对象，@符号将C字符串转换为NSString对象
NSNumber *number = @42;             // 数字对象
NSArray *array = @[@"A", @"B"];     // 数组对象
NSDictionary *dict = @{@"key": @"value"}; // 字典对象
```

### 1.1 @符号说明
在 Objective-C 中，`@` 符号是一个特殊的语法标记，主要用于创建 Objective-C 对象字面量。这个符号是 Objective-C 区别于 C 语言的重要特征之一，它使得代码更加简洁和易读。通过使用 `@` 符号，我们可以直接创建各种 Objective-C 对象，而不需要使用传统的 alloc/init 方法。

1. 字符串：`@"Hello"` 将 C 字符串转换为 `NSString` 对象
2. 数字：`@42` 创建 `NSNumber` 对象
3. 数组：`@[@"A", @"B"]` 创建 `NSArray` 对象
4. 字典：`@{@"key": @"value"}` 创建 `NSDictionary` 对象
5. 布尔值：`@YES` 和 `@NO` 创建 `NSNumber` 对象

使用 `@` 符号的好处：
- 区分 C 语言和 Objective-C 的类型
- 提供更简洁的语法
- 自动进行类型转换
- 支持 Unicode 和更多字符串操作

### 1.2 指针说明
在 Objective-C 中，指针（`*`）是一个重要的概念。由于 Objective-C 是面向对象的语言，所有的对象都是通过指针来访问的。指针不仅用于内存管理，还用于实现多态和动态绑定等面向对象的特性。

1. 对象指针：
   - 所有 Objective-C 对象都是通过指针访问的
   - 例如：`NSString *string` 表示 string 是一个指向 NSString 对象的指针

2. 指针的作用：
   - 动态内存管理：对象在堆上分配内存
   - 引用传递：通过指针传递对象，避免复制
   - 多态：通过指针实现运行时多态

3. 指针的使用：
   - 声明：`Class *object`
   - 创建：`object = [[Class alloc] init]`
   - 访问：`[object method]` 或 `object.property`

4. 指针的注意事项：
   - 空指针：`nil` 表示空指针
   - 野指针：指向已释放内存的指针
   - 循环引用：两个对象互相持有对方的指针

5. 指针修饰符：
   - `__strong`：强引用（默认）
   - `__weak`：弱引用，避免循环引用
   - `__unsafe_unretained`：不安全引用
   - `__autoreleasing`：自动释放引用

### 1.3 指针变量与非指针变量的区别
在 Objective-C 中，指针变量和非指针变量有着本质的区别。理解这些区别对于正确使用 Objective-C 的面向对象特性至关重要。指针变量用于处理对象，而非指针变量用于处理基本数据类型。

1. 内存分配：
   - 非指针变量：在栈上分配内存，生命周期由作用域决定
   - 指针变量：在堆上分配内存，生命周期由引用计数决定

2. 内存管理：
   - 非指针变量：自动管理，超出作用域自动释放
   - 指针变量：需要手动管理（MRC）或自动管理（ARC）

3. 传递方式：
   - 非指针变量：值传递，复制整个值
   - 指针变量：引用传递，只复制指针地址

4. 使用场景：
   - 非指针变量：基本数据类型（int、float、double等）
   - 指针变量：对象类型（NSString、NSArray、NSDictionary等）

5. 访问方式：
   - 非指针变量：直接访问值
   - 指针变量：通过指针间接访问对象

6. 示例对比：
```objc
// 非指针变量
int number = 10;                    // 直接存储值
float floatNumber = 3.14f;          // 直接存储值
BOOL isTrue = YES;                  // 直接存储值

// 指针变量
NSString *string = @"Hello";        // 存储对象地址
NSArray *array = @[@"A", @"B"];     // 存储对象地址
NSDictionary *dict = @{@"key": @"value"}; // 存储对象地址
```

7. 内存占用：
   - 非指针变量：占用固定大小的内存
   - 指针变量：占用指针大小的内存（32位系统4字节，64位系统8字节）

8. 性能影响：
   - 非指针变量：访问速度快，但传递大对象时效率低
   - 指针变量：访问速度相对较慢，但传递大对象时效率高

### 2. 数据类型
数据类型是编程语言的基础，Objective-C 提供了丰富的数据类型系统，包括基本类型和对象类型。这些类型可以满足不同的编程需求，从简单的数值计算到复杂的对象操作。

#### 2.1 基本类型
基本类型是 Objective-C 中最基础的数据类型，它们直接存储值，不需要使用指针。这些类型包括数值类型、布尔类型和字符类型等。

```objc
// 数值类型
NSInteger integer = 100;            // 整数
NSUInteger unsignedInteger = 100;   // 无符号整数
CGFloat floatValue = 3.14;          // 浮点数

// 布尔类型
BOOL isTrue = YES;                  // 布尔值
Boolean isFalse = false;            // 另一种布尔值

// 字符类型
char character = 'A';               // 字符
unichar unicodeChar = '中';         // Unicode字符
```

#### 2.2 对象类型
对象类型是 Objective-C 中用于处理复杂数据的数据类型，它们都是通过指针来访问的。这些类型包括字符串、数组、字典和集合等。

```objc
// 字符串
NSString *string = @"Hello";        // 不可变字符串
NSMutableString *mutableString = [NSMutableString stringWithString:@"Hello"]; // 可变字符串

// 数组
NSArray *array = @[@"A", @"B"];     // 不可变数组
NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array]; // 可变数组

// 字典
NSDictionary *dict = @{@"key": @"value"}; // 不可变字典
NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict]; // 可变字典

// 集合
NSSet *set = [NSSet setWithObjects:@"A", @"B", nil]; // 不可变集合
NSMutableSet *mutableSet = [NSMutableSet setWithSet:set]; // 可变集合
```

### 3. 运算符
运算符是用于执行各种操作的符号，Objective-C 支持丰富的运算符，包括算术运算符、比较运算符和逻辑运算符等。这些运算符可以用于处理各种数据类型，从基本类型到对象类型。

#### 3.1 算术运算符
算术运算符用于执行基本的数学运算，如加法、减法、乘法和除法等。这些运算符可以用于处理数值类型的数据。

```objc
int a = 10;
int b = 3;

int sum = a + b;        // 加法
int difference = a - b; // 减法
int product = a * b;    // 乘法
int quotient = a / b;   // 除法
int remainder = a % b;  // 取余

// 复合赋值运算符
a += b;  // 等价于 a = a + b
a -= b;  // 等价于 a = a - b
a *= b;  // 等价于 a = a * b
a /= b;  // 等价于 a = a / b
a %= b;  // 等价于 a = a % b
```

#### 3.2 比较运算符
比较运算符用于比较两个值的大小关系，如等于、不等于、大于和小于等。这些运算符返回布尔值，表示比较的结果。

```objc
BOOL isEqual = (a == b);      // 等于
BOOL isNotEqual = (a != b);   // 不等于
BOOL isGreater = (a > b);     // 大于
BOOL isLess = (a < b);        // 小于
BOOL isGreaterOrEqual = (a >= b); // 大于等于
BOOL isLessOrEqual = (a <= b);    // 小于等于
```

#### 3.3 逻辑运算符
逻辑运算符用于组合多个条件，如逻辑与、逻辑或和逻辑非等。这些运算符用于构建复杂的条件表达式。

```objc
BOOL isTrue = YES;
BOOL isFalse = NO;

BOOL notTrue = !isTrue;           // 逻辑非
BOOL andResult = isTrue && isFalse; // 逻辑与
BOOL orResult = isTrue || isFalse;  // 逻辑或
```

### 4. 字符串操作
字符串操作是 Objective-C 中常见的操作之一，Objective-C 提供了丰富的字符串操作方法，包括字符串创建、拼接、分割和比较等。这些方法可以用于处理各种字符串操作需求。

```objc
// 字符串创建
NSString *str1 = @"Hello";
NSString *str2 = [NSString stringWithFormat:@"Hello %@", @"World"];

// 字符串拼接
NSString *greeting = [str1 stringByAppendingString:@" World"];
NSString *formatted = [NSString stringWithFormat:@"%@ %@", str1, str2];

// 字符串方法
NSUInteger length = [str1 length];                    // 获取长度
BOOL isEmpty = [str1 length] == 0;                    // 检查是否为空
BOOL hasPrefix = [str1 hasPrefix:@"He"];              // 检查前缀
BOOL hasSuffix = [str1 hasSuffix:@"lo"];              // 检查后缀
NSString *upper = [str1 uppercaseString];             // 转换为大写
NSString *lower = [str1 lowercaseString];             // 转换为小写

// 字符串分割
NSArray *components = [str1 componentsSeparatedByString:@","];

// 字符串比较
NSComparisonResult result = [str1 compare:str2];
BOOL isEqual = [str1 isEqualToString:str2];
```

### 5. 类型转换
类型转换是 Objective-C 中常见的操作之一，用于将一种类型转换为另一种类型。Objective-C 支持多种类型转换方式，包括显式转换和隐式转换。

```objc
// 数字类型转换
int intNumber = 100;
float floatNumber = (float)intNumber;
double doubleNumber = (double)intNumber;

// 字符串转换
NSString *stringNumber = [NSString stringWithFormat:@"%d", intNumber];
int intFromString = [stringNumber intValue];

// 类型检查
if ([object isKindOfClass:[NSString class]]) {
    // 对象是字符串类型
}

// 类型转换
NSString *string = (NSString *)object;
```

## 二、控制流
控制流是编程语言中用于控制程序执行流程的语句，Objective-C 支持多种控制流语句，包括条件语句和循环语句等。这些语句可以用于构建复杂的程序逻辑。

### 1. 条件语句
条件语句用于根据条件执行不同的代码块，Objective-C 支持 if 语句和 switch 语句等条件语句。这些语句可以用于处理各种条件判断需求。

#### 1.1 if 语句
if 语句是 Objective-C 中最基本的条件语句，用于根据条件执行不同的代码块。if 语句可以包含 else 子句，用于处理条件不满足的情况。

```objc
if (condition) {
    // 代码块
} else if (anotherCondition) {
    // 代码块
} else {
    // 代码块
}
```

#### 1.2 switch 语句
switch 语句是 Objective-C 中用于处理多个条件分支的语句，它根据表达式的值选择执行不同的代码块。switch 语句通常用于处理枚举类型或整数类型的条件判断。

```objc
switch (value) {
    case 1:
        // 代码块
        break;
    case 2:
        // 代码块
        break;
    default:
        // 代码块
        break;
}
```

### 2. 循环语句
循环语句用于重复执行代码块，Objective-C 支持多种循环语句，包括 for 循环、while 循环和 do-while 循环等。这些语句可以用于处理各种循环需求。

#### 2.1 for 循环
for 循环是 Objective-C 中最常用的循环语句，用于重复执行代码块。for 循环通常用于处理数组遍历和计数器等场景。

```objc
// 基本for循环
for (int i = 0; i < 10; i++) {
    // 代码块
}

// 快速枚举
NSArray *array = @[@"A", @"B", @"C"];
for (NSString *item in array) {
    // 代码块
}
```

#### 2.2 while 循环
while 循环是 Objective-C 中用于重复执行代码块的语句，它根据条件决定是否继续执行循环。while 循环通常用于处理不确定次数的循环。

```objc
// while循环
int i = 0;
while (i < 10) {
    // 代码块
    i++;
}

// do-while循环
int j = 0;
do {
    // 代码块
    j++;
} while (j < 10);
```

## 三、面向对象编程
面向对象编程是 Objective-C 的核心特性，它通过类、对象、继承、多态等概念来组织代码。Objective-C 的面向对象特性使得代码更加模块化、可重用和可维护。

### 1. 类定义
类是面向对象编程的基本构建块，它定义了对象的属性和方法。在 Objective-C 中，类定义包括接口部分和实现部分，分别定义在 .h 和 .m 文件中。

```objc
// 头文件 (.h)
@interface Person : NSObject

// 属性声明
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;

// 方法声明
- (void)sayHello;
+ (Person *)personWithName:(NSString *)name age:(NSInteger)age;

@end

// 实现文件 (.m)
@implementation Person

// 方法实现
- (void)sayHello {
    NSLog(@"Hello, my name is %@", self.name);
}

+ (Person *)personWithName:(NSString *)name age:(NSInteger)age {
    Person *person = [[Person alloc] init];
    person.name = name;
    person.age = age;
    return person;
}

@end
```

### 1.1 类的生命周期
类的生命周期包括创建、初始化和销毁等阶段。在 Objective-C 中，类的生命周期由初始化方法和析构方法来管理。理解类的生命周期对于正确使用面向对象编程至关重要。

```objc
@interface MyClass : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation MyClass

// 1. 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化代码
        _name = @"Default";
        _items = [NSMutableArray array];
    }
    return self;
}

// 2. 指定初始化方法
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _items = [NSMutableArray array];
    }
    return self;
}

// 3. 便利初始化方法
+ (instancetype)myClassWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

// 4. 析构方法
- (void)dealloc {
    // 清理资源
    [_items removeAllObjects];
    _items = nil;
    
    // 移除通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 移除 KVO 观察者
    [self removeObserver:self forKeyPath:@"name"];
    
    // 关闭文件
    [self closeFile];
    
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
    
    // 断开代理
    self.delegate = nil;
    
    // 清理其他资源
    [self cleanup];
}

// 5. 类方法
+ (void)initialize {
    // 类初始化时调用，只调用一次
    if (self == [MyClass class]) {
        // 初始化类级别的资源
    }
}

+ (void)load {
    // 类加载时调用，在 main 函数之前
    // 用于方法交换等操作
}

// 6. 实例方法
- (void)doSomething {
    // 实例方法实现
}

// 7. 私有方法（在 .m 文件中实现，不在 .h 中声明）
- (void)privateMethod {
    // 私有方法实现
}

// 8. 属性访问器方法
- (void)setName:(NSString *)name {
    _name = name;
    // 可以在这里添加额外的逻辑
}

- (NSString *)name {
    return _name;
}

// 9. 响应选择器方法
- (BOOL)respondsToSelector:(SEL)aSelector {
    // 自定义响应选择器的行为
    return [super respondsToSelector:aSelector];
}

// 10. 消息转发方法
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // 处理未实现的方法调用
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    // 返回方法签名
    return [super methodSignatureForSelector:aSelector];
}

// 11. 键值观察方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // 处理属性变化
}

// 12. 通知处理方法
- (void)handleNotification:(NSNotification *)notification {
    // 处理通知
}

// 13. 定时器方法
- (void)timerFired:(NSTimer *)timer {
    // 处理定时器事件
}

// 14. 文件操作方法
- (void)closeFile {
    // 关闭文件
}

// 15. 清理方法
- (void)cleanup {
    // 清理资源
}

@end
```

### 1.2 类的继承
继承是面向对象编程的重要特性，它允许子类继承父类的属性和方法。在 Objective-C 中，继承通过 `:` 符号来实现，子类可以重写父类的方法。

```objc
// 基类
@interface Animal : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (void)makeSound;
- (void)move;

@end

@implementation Animal

- (void)makeSound {
    NSLog(@"Some sound");
}

- (void)move {
    NSLog(@"Moving");
}

@end

// 子类
@interface Dog : Animal

@property (nonatomic, strong) NSString *breed;

- (void)bark;
- (void)wagTail;

@end

@implementation Dog

- (void)makeSound {
    [super makeSound]; // 调用父类方法
    NSLog(@"Woof!");
}

- (void)bark {
    NSLog(@"Barking");
}

- (void)wagTail {
    NSLog(@"Wagging tail");
}

@end
```

### 1.3 类的多态
多态是面向对象编程的核心特性，它允许不同类的对象对同一消息做出不同的响应。在 Objective-C 中，多态通过动态绑定来实现，使得代码更加灵活和可扩展。

```objc
// 使用多态
Animal *animal = [[Dog alloc] init];
[animal makeSound]; // 调用 Dog 的 makeSound 方法

// 类型检查
if ([animal isKindOfClass:[Dog class]]) {
    Dog *dog = (Dog *)animal;
    [dog bark];
}

// 协议多态
@protocol SoundMaker <NSObject>
- (void)makeSound;
@end

@interface Cat : NSObject <SoundMaker>
@end

@implementation Cat
- (void)makeSound {
    NSLog(@"Meow!");
}
@end

// 使用协议多态
id<SoundMaker> soundMaker = [[Cat alloc] init];
[soundMaker makeSound];
```

### 1.4 类的类别和扩展
类别和扩展是 Objective-C 中用于扩展现有类的机制，它们允许在不修改原始类的情况下添加新的功能。类别和扩展是 Objective-C 动态特性的重要体现。

```objc
// 类别（Category）
@interface NSString (MyCategory)
- (void)myMethod;
@end

@implementation NSString (MyCategory)
- (void)myMethod {
    // 方法实现
}
@end

// 扩展（Extension）
@interface MyClass ()
@property (nonatomic, strong) NSString *privateProperty;
- (void)privateMethod;
@end

@implementation MyClass
- (void)privateMethod {
    // 方法实现
}
@end
```

### 1.4.1 类别（Category）与扩展（Extension）的区别
类别和扩展虽然都是用于扩展现有类的机制，但它们有着本质的区别。理解这些区别对于正确使用类别和扩展至关重要。

1. 语法区别：
   - 类别：使用 `@interface 类名 (类别名)` 的形式
   - 扩展：使用 `@interface 类名 ()` 的形式，括号内为空

2. 文件位置：
   - 类别：通常定义在单独的文件中（.h 和 .m）
   - 扩展：通常定义在类的实现文件（.m）中

3. 功能范围：
   - 类别：
     - 可以为现有类添加新方法
     - 不能添加实例变量
     - 可以添加属性（但需要实现 getter/setter）
     - 可以覆盖现有方法（不推荐）
   - 扩展：
     - 可以添加实例变量
     - 可以添加属性
     - 可以添加方法
     - 不能覆盖现有方法

4. 使用场景：
   - 类别：
     - 为现有类添加新功能
     - 将类的实现分散到多个文件中
     - 为系统类添加方法
   - 扩展：
     - 用于声明私有属性和方法
     - 将实现细节隐藏在实现文件中
     - 在实现文件中组织代码

5. 访问权限：
   - 类别：
     - 添加的方法默认是公开的
     - 可以被其他类访问
   - 扩展：
     - 添加的属性和方法默认是私有的
     - 只能在类的实现文件中访问

6. 继承关系：
   - 类别：
     - 子类可以继承类别添加的方法
     - 可以被子类重写
   - 扩展：
     - 子类不能继承扩展添加的私有属性和方法
     - 不能被子类重写

7. 示例对比：
```objc
// 类别示例
// MyClass+Category.h
@interface MyClass (Category)
- (void)publicMethod;
@end

// MyClass+Category.m
@implementation MyClass (Category)
- (void)publicMethod {
    // 实现方法
}
@end

// 扩展示例
// MyClass.m
@interface MyClass ()
@property (nonatomic, strong) NSString *privateProperty;
- (void)privateMethod;
@end

@implementation MyClass
- (void)privateMethod {
    // 实现方法
}
@end
```

8. 最佳实践：
   - 类别：
     - 用于添加功能，而不是修改现有功能
     - 保持类别的方法名唯一，避免冲突
     - 在类别中添加的方法应该有明确的前缀
   - 扩展：
     - 用于声明私有属性和方法
     - 将实现细节隐藏在实现文件中
     - 保持扩展的简洁性

9. 注意事项：
   - 类别：
     - 避免覆盖现有方法
     - 注意方法名冲突
     - 不能添加实例变量
   - 扩展：
     - 必须在类的实现文件中定义
     - 不能添加新的实例变量
     - 不能覆盖现有方法

10. 使用建议：
    - 类别：
      - 当需要为现有类添加新功能时使用
      - 当需要将类的实现分散到多个文件时使用
      - 当需要为系统类添加方法时使用
    - 扩展：
      - 当需要声明私有属性和方法时使用
      - 当需要隐藏类的实现细节时使用
      - 当需要在实现文件中组织代码时使用

### 1.5 类的运行时特性
运行时特性是 Objective-C 的重要特性之一，它允许在运行时动态地修改类的行为。这些特性使得 Objective-C 具有强大的灵活性和可扩展性。

```objc
// 动态添加方法
class_addMethod([MyClass class], 
                @selector(newMethod), 
                (IMP)newMethodImplementation, 
                "v@:");

// 方法交换
Method originalMethod = class_getInstanceMethod([MyClass class], @selector(originalMethod));
Method swizzledMethod = class_getInstanceMethod([MyClass class], @selector(swizzledMethod));
method_exchangeImplementations(originalMethod, swizzledMethod);

// 动态添加属性
objc_setAssociatedObject(self, 
                        &AssociatedKey, 
                        value, 
                        OBJC_ASSOCIATION_RETAIN_NONATOMIC);

// 获取属性
id value = objc_getAssociatedObject(self, &AssociatedKey);
```

### 1.6 类的内存管理
内存管理是 Objective-C 编程中的重要问题，Objective-C 提供了手动引用计数（MRC）和自动引用计数（ARC）两种内存管理方式。理解内存管理对于编写稳定和高效的 Objective-C 程序至关重要。

```objc
// 手动引用计数（MRC）
- (void)manualMemoryManagement {
    id object = [[NSObject alloc] init]; // 引用计数 +1
    [object retain];                     // 引用计数 +1
    [object release];                    // 引用计数 -1
    [object autorelease];                // 延迟释放
}

// 自动引用计数（ARC）
- (void)automaticMemoryManagement {
    // 不需要手动管理内存
    id object = [[NSObject alloc] init];
    // 使用对象
    // 超出作用域自动释放
}

// 循环引用处理
- (void)handleCircularReference {
    __weak typeof(self) weakSelf = self;
    [self.someObject doSomethingWithCompletion:^{
        [weakSelf doSomethingElse];
    }];
}
```

### 1.7 类的性能优化
性能优化是 Objective-C 编程中的重要问题，Objective-C 提供了多种性能优化技术，包括延迟加载、缓存和后台线程处理等。这些技术可以提高程序的运行效率和响应速度。

```objc
// 延迟加载
- (NSArray *)items {
    if (!_items) {
        _items = [NSArray array];
    }
    return _items;
}

// 缓存
- (void)useCache {
    NSCache *cache = [[NSCache alloc] init];
    [cache setObject:object forKey:key];
    id cachedObject = [cache objectForKey:key];
}

// 后台线程处理
- (void)processInBackground {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新 UI
        });
    });
}
```

## 四、内存管理
### 1. 引用计数
```objc
// 手动引用计数
id object = [[NSObject alloc] init];  // 引用计数 +1
[object retain];                      // 引用计数 +1
[object release];                     // 引用计数 -1
[object autorelease];                 // 延迟释放

// ARC（自动引用计数）
// 不需要手动管理内存
```

### 2. 属性修饰符
```objc
// 内存管理修饰符
@property (nonatomic, strong) id strongProperty;    // 强引用
@property (nonatomic, weak) id weakProperty;        // 弱引用
@property (nonatomic, copy) id copyProperty;        // 复制
@property (nonatomic, unsafe_unretained) id unsafeProperty; // 不安全引用
```

## 五、高级特性
### 1. 块（Block）
```objc
// 块定义
void (^simpleBlock)(void) = ^{
    NSLog(@"This is a block");
};

// 带参数的块
void (^blockWithParam)(NSString *) = ^(NSString *param) {
    NSLog(@"%@", param);
};

// 带返回值的块
NSString * (^blockWithReturn)(NSString *) = ^(NSString *param) {
    return [param uppercaseString];
};

// 块作为参数
- (void)methodWithBlock:(void (^)(void))completion {
    // 执行一些操作
    completion();
}
```

### 2. 通知
```objc
// 发送通知
[[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotification" object:nil];

// 注册通知
[[NSNotificationCenter defaultCenter] addObserver:self
                                       selector:@selector(handleNotification:)
                                           name:@"MyNotification"
                                         object:nil];

// 处理通知
- (void)handleNotification:(NSNotification *)notification {
    // 处理通知
}

// 移除观察者
[[NSNotificationCenter defaultCenter] removeObserver:self];
```

### 3. KVO（键值观察）
```objc
// 添加观察者
[object addObserver:self
         forKeyPath:@"property"
            options:NSKeyValueObservingOptionNew
            context:nil];

// 实现观察方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // 处理属性变化
}

// 移除观察者
[object removeObserver:self forKeyPath:@"property"];
```

### 4. 运行时
```objc
// 获取类
Class class = [object class];

// 获取方法
Method method = class_getInstanceMethod(class, @selector(methodName));

// 获取属性
objc_property_t property = class_getProperty(class, "propertyName");

// 动态添加方法
class_addMethod(class, @selector(newMethod), (IMP)newMethodImplementation, "v@:");

// 方法交换
method_exchangeImplementations(method1, method2);
```

## 六、文件操作
### 1. 文件管理
```objc
// 获取文件管理器
NSFileManager *fileManager = [NSFileManager defaultManager];

// 创建目录
NSError *error;
[fileManager createDirectoryAtPath:@"/path/to/directory" 
      withIntermediateDirectories:YES 
                       attributes:nil 
                            error:&error];

// 创建文件
[fileManager createFileAtPath:@"/path/to/file" 
                    contents:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding] 
                  attributes:nil];

// 删除文件
[fileManager removeItemAtPath:@"/path/to/file" error:&error];

// 移动文件
[fileManager moveItemAtPath:@"/path/to/source" 
                    toPath:@"/path/to/destination" 
                     error:&error];

// 复制文件
[fileManager copyItemAtPath:@"/path/to/source" 
                    toPath:@"/path/to/destination" 
                     error:&error];
```

### 2. 文件读写
```objc
// 读取文件
NSString *content = [NSString stringWithContentsOfFile:@"/path/to/file" 
                                            encoding:NSUTF8StringEncoding 
                                               error:&error];

// 写入文件
[content writeToFile:@"/path/to/file" 
          atomically:YES 
            encoding:NSUTF8StringEncoding 
               error:&error];

// 读取二进制文件
NSData *data = [NSData dataWithContentsOfFile:@"/path/to/file"];

// 写入二进制文件
[data writeToFile:@"/path/to/file" atomically:YES];
```

## 七、网络编程
### 1. URL 请求
```objc
// 创建 URL
NSURL *url = [NSURL URLWithString:@"https://api.example.com/data"];

// 创建请求
NSURLRequest *request = [NSURLRequest requestWithURL:url];

// 发送请求
NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *task = [session dataTaskWithRequest:request 
                                       completionHandler:^(NSData *data, 
                                                         NSURLResponse *response, 
                                                         NSError *error) {
    // 处理响应
}];
[task resume];
```

### 2. JSON 处理
```objc
// 解析 JSON
NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData 
                                                    options:0 
                                                      error:&error];

// 创建 JSON
NSDictionary *dict = @{@"key": @"value"};
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict 
                                                  options:0 
                                                    error:&error];
NSString *jsonString = [[NSString alloc] initWithData:jsonData 
                                            encoding:NSUTF8StringEncoding];
```

## 八、多线程编程
### 1. GCD（Grand Central Dispatch）
```objc
// 主队列
dispatch_async(dispatch_get_main_queue(), ^{
    // 在主线程执行
});

// 全局队列
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 在后台线程执行
});

// 自定义队列
dispatch_queue_t queue = dispatch_queue_create("com.example.queue", DISPATCH_QUEUE_SERIAL);
dispatch_async(queue, ^{
    // 在自定义队列执行
});

// 延迟执行
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), 
              dispatch_get_main_queue(), ^{
    // 2秒后执行
});

// 组
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{
    // 任务1
});
dispatch_group_async(group, queue, ^{
    // 任务2
});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    // 所有任务完成后执行
});
```

### 2. NSOperation
```objc
// 创建操作
NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    // 操作内容
}];

// 设置完成回调
[operation setCompletionBlock:^{
    // 操作完成后的回调
}];

// 创建队列
NSOperationQueue *queue = [[NSOperationQueue alloc] init];

// 添加操作到队列
[queue addOperation:operation];

// 设置依赖
NSOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
    // 操作1
}];
NSOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
    // 操作2
}];
[operation2 addDependency:operation1];
[queue addOperations:@[operation1, operation2] waitUntilFinished:NO];
```

## 九、错误处理
### 1. NSError
```objc
// 创建错误
NSError *error = [NSError errorWithDomain:@"com.example.error" 
                                    code:1 
                                userInfo:@{NSLocalizedDescriptionKey: @"Error message"}];

// 处理错误
if (error) {
    NSLog(@"Error: %@", error.localizedDescription);
}

// 抛出错误
@throw [NSException exceptionWithName:@"CustomException" 
                             reason:@"Error reason" 
                           userInfo:nil];
```

### 2. 异常处理
```objc
@try {
    // 可能抛出异常的代码
} @catch (NSException *exception) {
    // 处理异常
    NSLog(@"Exception: %@", exception);
} @finally {
    // 无论是否发生异常都会执行的代码
}
```