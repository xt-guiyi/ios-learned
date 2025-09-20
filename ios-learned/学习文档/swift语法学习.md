# Swift 语法学习

## 一、基础语法
### 1. 变量声明
变量声明是 Swift 中最基础的语法之一，用于存储和操作数据。Swift 提供了 `var` 和 `let` 两种声明方式，分别用于声明变量和常量。

```swift
var tilte = "张三" // 变量，值可以改变
let description = "描述" // 常量，值不能改变
let age: Int = 10 // 类型注解 : Int，显式指定类型
```

### 2. 数据类型
#### 2.1 基础类型
Swift 提供了丰富的基本数据类型，包括整数、浮点数、布尔值、字符和字符串等。每种类型都有其特定的用途和范围，可以根据需要选择合适的数据类型。

```swift
let minUInt: UInt = UInt.min // UInt，无符号整数，最小值为0
let maxUInt: UInt = UInt.max // UInt，无符号整数，最大值
let value: Int = Int.max // Int，有符号整数，最大值
let pi: Double = 3.1415 // Double，双精度浮点数，精确度很高，至少有15位数字
let arc: Float = 1.1 // Float，单精度浮点数，只有6位数字
let oranges: Bool = true // Bool，布尔值，只有true和false两个值
let char: Character = "s" // Character，字符类型，表示单个字符
let someString: String = "Some string literal value" // String，字符串类型
let quotation: String = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.
"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
""" // 多行字符串，使用三个双引号包裹
```

#### 2.2 可选类型
可选类型是 Swift 的一个特性，用于处理值可能缺失的情况。可选类型表示一个值要么存在，要么为 nil，这种机制可以帮助我们更安全地处理可能为空的值。

```swift
var empty: Int? // 声明一个可选常量或者变量但是没有赋值，它们会自动被设置为 nil
var possibleNumber: String? = "123" // 可选类型可以赋值为具体值
possibleNumber = nil // 可选类型可以赋值为nil
```

#### 2.3 元组类型
元组是 Swift 中一个重要的复合类型，可以将多个值组合成一个复合值。元组可以包含不同类型的值，并且可以通过索引或标签访问其中的元素。

```swift
let person: (String,Int) = ("李四", 18) // 元组，包含姓名和年龄
let http404Error: (Int,String) = (statusCode:404, description: "no Find") // 带标签的元组，可以通过标签访问元素
let (status, message) = http404Error // 解构赋值，将元组的值分别赋给不同的变量
```

#### 2.4 类型别名
类型别名可以为已存在的类型创建一个新的名称，使代码更易读。这对于复杂类型或经常使用的类型特别有用，可以提高代码的可维护性。

```swift
typealias AudioSample = UInt16 // 为UInt16创建一个新的名称
let bigInt: AudioSample = AudioSample.max // 使用新的类型名称
```

#### 2.5 集合类型
##### 2.5.1 数组(array)
数组是 Swift 中最常用的集合类型之一，用于存储有序的数据集合。数组可以存储相同类型的元素，并且提供了丰富的操作方法。

```swift
var someInts = Array<Int>() // 函数方式创建空数组
var someIntsSample = [Int]() // 函数方式创建空数组，简写形式
var shoppingList: [String] = ["Eggs", "Milk"] // 字面量方式创建数组，推荐使用

someInts.append(1) // 添加元素
someInts = [] // 设置为空数组
var threeDoubles = Array(repeating: 0.0, count: 3) // 创建包含重复元素的数组
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles // 数组拼接
```

##### 2.5.2 集合（Sets）
集合是 Swift 中的无序集合类型，用于存储不重复的值。集合提供了高效的查找、插入和删除操作，适合需要快速判断元素是否存在的场景。

```swift
var letters = Set<Character>() // 函数方式创建空集合
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"] // 字面量方式创建集合
letters = [] // 设置为空集合
```

##### 2.5.3 字典(键值对映射)
字典是 Swift 中的键值对集合，用于存储无序的键值对。字典提供了高效的查找和更新操作，适合需要根据键快速访问值的场景。

```swift
var namesOfIntegers = [Int: String]() // 函数方式创建空字典
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"] // 字面量方式创建字典
```

### 3. 运算符
#### 3.1 算术运算符
```swift
// 基本算术运算符
let a = 10
let b = 3
let sum = a + b        // 加法
let difference = a - b // 减法
let product = a * b    // 乘法
let quotient = a / b   // 除法
let remainder = a % b  // 取余

// 复合赋值运算符
var c = 5
c += 3  // 等价于 c = c + 3
c -= 2  // 等价于 c = c - 2
c *= 4  // 等价于 c = c * 4
c /= 2  // 等价于 c = c / 2
c %= 3  // 等价于 c = c % 3
```

#### 3.2 比较运算符
```swift
let x = 5
let y = 10

x == y  // 等于
x != y  // 不等于
x > y   // 大于
x < y   // 小于
x >= y  // 大于等于
x <= y  // 小于等于
```

#### 3.3 逻辑运算符
```swift
let isTrue = true
let isFalse = false

!isTrue     // 逻辑非
isTrue && isFalse  // 逻辑与
isTrue || isFalse  // 逻辑或
```

#### 3.4 区间运算符
```swift
// 闭区间运算符
for i in 1...5 {
    print(i)  // 输出 1, 2, 3, 4, 5
}

// 半开区间运算符
for i in 1..<5 {
    print(i)  // 输出 1, 2, 3, 4
}

// 单侧区间
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names[2...] {
    print(name)  // 输出 Brian, Jack
}
```

### 4. 字符串操作
```swift
// 字符串拼接
let str1 = "Hello"
let str2 = "World"
let greeting = str1 + " " + str2

// 字符串插值
let name = "John"
let age = 30
let message = "\(name) is \(age) years old"

// 字符串方法
let text = "Hello, World!"
text.count           // 获取字符数
text.isEmpty         // 检查是否为空
text.hasPrefix("He") // 检查前缀
text.hasSuffix("ld!") // 检查后缀
text.uppercased()    // 转换为大写
text.lowercased()    // 转换为小写

// 字符串索引
let firstChar = text[text.startIndex]
let lastChar = text[text.index(before: text.endIndex)]
let thirdChar = text[text.index(text.startIndex, offsetBy: 2)]

// 字符串分割
let components = text.components(separatedBy: ", ")
```

### 5. 类型转换
```swift
// 数字类型转换
let intNumber = 100
let doubleNumber = Double(intNumber)
let floatNumber = Float(intNumber)

// 字符串转换
let number = 42
let stringNumber = String(number)
let intFromString = Int("42")

// 类型检查
if number is Int {
    print("number is an Int")
}

// 类型转换
let anyValue: Any = "Hello"
if let stringValue = anyValue as? String {
    print(stringValue)
}
```

## 二、控制流
### 1. 条件语句
#### 1.1 if 语句
if 语句是 Swift 中最基本的条件控制结构，用于根据条件执行不同的代码块。if 语句可以包含 else 子句，用于处理条件不满足的情况。

```swift
if empty != nil {
    print("possibleNumber不为空")
} else {
    print("possibleNumber为空")
}
```

#### 1.2 guard 语句
guard 语句是 Swift 中的一种条件控制结构，用于提前退出函数、方法或循环。guard 语句要求条件必须为 true 才能继续执行，否则会执行 else 子句中的代码。

```swift
// 基本用法
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        print("No name provided")
        return
    }
    print("Hello, \(name)!")
}

// 多个条件
func processUser(user: [String: Any]) {
    guard let name = user["name"] as? String,
          let age = user["age"] as? Int,
          age >= 18 else {
        print("Invalid user data or user is underage")
        return
    }
    print("Processing user: \(name), age: \(age)")
}

// 在循环中使用
func findFirstEvenNumber(in numbers: [Int]) -> Int? {
    for number in numbers {
        guard number % 2 == 0 else {
            continue
        }
        return number
    }
    return nil
}

// 与可选绑定结合
func validateUser(name: String?, age: Int?) -> Bool {
    guard let name = name, !name.isEmpty,
          let age = age, age >= 18 else {
        return false
    }
    return true
}

// 在类中使用
class User {
    var name: String?
    var age: Int?
    
    func updateProfile(name: String?, age: Int?) {
        guard let name = name, !name.isEmpty else {
            print("Invalid name")
            return
        }
        
        guard let age = age, age >= 0 else {
            print("Invalid age")
            return
        }
        
        self.name = name
        self.age = age
    }
}

// 在协议扩展中使用
extension Collection {
    func safeIndex(_ index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

// 在异步函数中使用
func fetchUserData() async throws -> User {
    guard let url = URL(string: "https://api.example.com/user") else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(User.self, from: data)
}
```

guard 语句的主要特点：
1. 提前退出：当条件不满足时，立即退出当前作用域
2. 可选绑定：可以安全地解包可选值
3. 代码清晰：减少嵌套层级，提高代码可读性
4. 错误处理：适合用于参数验证和错误处理
5. 作用域：guard 语句中绑定的变量在后续代码中可用

guard 语句的使用建议：
1. 用于参数验证和错误处理
2. 在需要提前退出的场景使用
3. 与可选绑定结合使用
4. 保持 guard 语句的简洁性
5. 在异步函数中处理错误情况

#### 1.3 可选绑定
可选绑定是 Swift 中安全处理可选值的一种方式，可以避免强制解包可能带来的崩溃。通过 if let 或 guard let 语句，可以安全地解包可选值。

```swift
let phoneConstantName: Int? = 20

if let constantName = phoneConstantName {
    print("\'\(constantName)\' has an integer value of \(phoneConstantName!)") // 非空断言 : phoneConstantName!
} else {
    print("phoneConstantName没有值") 
}

// 多个可选绑定
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
```

#### 1.4 空合运算符
空合运算符是 Swift 中处理可选值的一种简洁方式，用于提供默认值。当可选值为 nil 时，会使用默认值，这可以简化代码并提高可读性。

```swift
let defaultColorName = "red"
var userDefinedColorName: String?   //默认值为 nil
var colorNameToUse = userDefinedColorName ?? defaultColorName // userDefinedColorName 的值为空，所以 colorNameToUse 的值为 "red"
```

### 2. 循环遍历
#### 2.1 区间运算符
Swift 提供了多种区间运算符，用于表示值的范围。这些运算符可以用于循环、数组切片等场景，使代码更加简洁和易读。

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]

//（a...b）定义一个包含从 a 到 b（包括 a 和 b）的所有值的区间
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}

// 半开区间运算符,（a..<b）定义一个从 a 到 b 但不包括 b 的区间
for i in 0 ..< names.count { 
   print("第 \(i + 1) 个人叫 \(names[i])")
}

// 单侧区间,可以表达往一侧无限延伸的区间
for name in names[2...] {
     print(name)
}
for name in names[...2] {
     print(name) 
}
```

#### 2.2 数组遍历
数组提供了多种遍历方式，方便访问数组元素。可以使用 for-in 循环、enumerated() 方法等方式遍历数组，根据需求选择合适的方式。

```swift
// 遍历数组
for item in shoppingList {
    print(item)
}

// 同时获取索引和值
for (index, value) in shoppingList.enumerated() {
    print("Item \(String(index + 1)): \(value)")
}
```

#### 2.3 集合遍历
集合的遍历方式与数组类似，但集合是无序的。可以使用 for-in 循环遍历集合，也可以使用 sorted() 方法获取有序的遍历结果。

```swift
// 无顺序遍历
for genre in favoriteGenres {
    print("无顺序遍历：\(genre)")
}

// 根据排序后的结果遍历
for genre in favoriteGenres.sorted() {
    print("有顺序遍历\(genre)")
}
```

#### 2.4 字典遍历
字典提供了多种遍历方式，可以遍历键、值或键值对。根据需求选择合适的方式，可以方便地访问字典中的元素。

```swift
// 遍历key-value
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}

// 遍历key
for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}

// 根据排序后的结果遍历key
for airportCode in airports.keys.sorted() {
    print("Airport code: \(airportCode)")
}

// 遍历value
for airportName in airports.values {
    print("Airport name: \(airportName)")
}
```

## 三、函数和闭包
### 1. 函数
函数是 Swift 中的基本代码块，用于执行特定任务。Swift 的函数支持多种特性，如参数标签、默认参数值、可变参数等，使函数更加灵活和强大。

#### 1.1 函数参数
Swift 中的函数参数有三种主要类型：

1. 输入参数（默认）
```swift
// 基本输入参数
func greet(person: String) -> String {
    return "Hello, \(person)!"
}

// 多参数
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}

// 参数标签
func greet(to person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}

// 忽略参数标签
func greet(_ person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}
```

2. 默认参数值
```swift
// 带默认值的参数
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 函数体
}

// 多个默认参数
func join(string s1: String, toString s2: String, withJoiner joiner: String = " ") -> String {
    return s1 + joiner + s2
}

// 调用带默认参数的函数
join(string: "hello", toString: "world") // 使用默认的 joiner
join(string: "hello", toString: "world", withJoiner: "-") // 指定 joiner
```

3. 可变参数
```swift
// 基本可变参数
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

// 可变参数与其他参数
func greet(_ names: String..., with greeting: String) {
    for name in names {
        print("\(greeting), \(name)!")
    }
}

// 调用可变参数函数
arithmeticMean(1, 2, 3, 4, 5)
greet("John", "Paul", "George", "Ringo", with: "Hello")
```

4. 输入输出参数
```swift
// 基本输入输出参数
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// 使用输入输出参数
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

// 输入输出参数与默认值
func increment(_ number: inout Int, by amount: Int = 1) {
    number += amount
}

var counter = 0
increment(&counter) // 使用默认值
increment(&counter, by: 5) // 指定值
```

#### 1.2 参数使用注意事项
1. 参数顺序
```swift
// 参数顺序很重要
func greet(name: String, age: Int) -> String {
    return "Hello \(name), you are \(age) years old"
}

// 调用时必须按照定义顺序
greet(name: "John", age: 30) // 正确
greet(age: 30, name: "John") // 错误
```

2. 参数标签
参数标签由两部分组成：
- 外部参数名（参数标签）：在函数调用时使用
- 内部参数名：在函数内部使用

```swift
// 基本参数标签
func greet(to person: String) {
    // person 是内部参数名，在函数内部使用
    print("Hello, \(person)!")
}
greet(to: "John") // to 是外部参数名，在函数调用时使用

// 省略外部参数名
func greet(_ person: String) {
    print("Hello, \(person)!")
}
greet("John") // 调用时不需要参数标签

// 使用不同的外部和内部参数名
func move(from start: Int, to end: Int) {
    // start 和 end 是内部参数名
    print("Moving from \(start) to \(end)")
}
move(from: 1, to: 5) // from 和 to 是外部参数名

// 参数标签的使用场景
func calculateArea(width: Double, height: Double) -> Double {
    return width * height
}
calculateArea(width: 10, height: 20) // 使用参数标签使代码更易读

// 忽略参数标签
func calculateArea(_ width: Double, _ height: Double) -> Double {
    return width * height
}
calculateArea(10, 20) // 不使用参数标签

// 参数标签与默认值
func greet(to person: String, with greeting: String = "Hello") {
    print("\(greeting), \(person)!")
}
greet(to: "John") // 使用默认的 greeting
greet(to: "John", with: "Hi") // 指定 greeting

// 参数标签与可变参数
func greet(_ names: String..., with greeting: String) {
    for name in names {
        print("\(greeting), \(name)!")
    }
}
greet("John", "Paul", "George", "Ringo", with: "Hello")

// 参数标签与输入输出参数
func swap(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}
var x = 1, y = 2
swap(&x, &y) // 输入输出参数通常不使用参数标签
```

参数标签的使用建议：
1. 使用有意义的参数标签，提高代码可读性
2. 对于简单的参数，可以考虑省略参数标签
3. 当参数含义不明确时，使用参数标签
4. 保持参数标签的一致性，使代码风格统一
5. 对于输入输出参数，通常不使用参数标签

```swift
// 好的参数标签使用示例
func calculateDistance(from start: Point, to end: Point) -> Double {
    // 使用 from 和 to 使函数调用更自然
    return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
}

// 不好的参数标签使用示例
func calculateDistance(start: Point, end: Point) -> Double {
    // 不使用参数标签，调用时不够清晰
    return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
}

// 调用示例
let start = Point(x: 0, y: 0)
let end = Point(x: 3, y: 4)
calculateDistance(from: start, to: end) // 更清晰的调用方式
calculateDistance(start: start, end: end) // 不够清晰的调用方式
```

### 2. 闭包
闭包是 Swift 中的自包含函数代码块，可以在代码中被传递和使用。闭包可以捕获和存储其所在上下文中的常量和变量，是 Swift 中强大的编程工具。

#### 2.1 闭包表达式语法
闭包表达式的完整语法格式如下：
```swift
{ (parameters) -> return type in
    statements
}
```

闭包表达式可以使用以下简写形式：
1. 根据上下文推断类型
```swift
{ parameters in
    statements
}
```

2. 单表达式闭包的隐式返回
```swift
{ parameters in expression }
```

3. 参数名称缩写
```swift
{ $0, $1 in statements }
```

4. 运算符方法
```swift
{ > }  // 当闭包只包含一个表达式时
```

5. 尾随闭包
```swift
someFunction { parameters in
    statements
}
```

#### 2.2 闭包示例
```swift
// 完整形式
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// 根据上下文推断类型
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

// 单表达式闭包的隐式返回
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

// 参数名称缩写
reversedNames = names.sorted(by: { $0 > $1 } )

// 运算符方法
reversedNames = names.sorted(by: >)

// 尾随闭包
reversedNames = names.sorted { $0 > $1 }

// 捕获值
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
```

#### 2.3 闭包的使用场景
1. 作为函数参数
```swift
func someFunction(completion: () -> Void) {
    // 执行一些操作
    completion()
}
```

2. 作为函数返回值
```swift
func makeCounter() -> () -> Int {
    var count = 0
    return { count += 1; return count }
}
```

3. 作为变量或常量
```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
```

4. 作为可选类型
```swift
var completionHandler: (() -> Void)?
```

#### 2.4 闭包的注意事项
1. 循环引用
```swift
class SomeClass {
    var completionHandler: (() -> Void)?
    
    func someFunction() {
        // 使用 [weak self] 避免循环引用
        completionHandler = { [weak self] in
            self?.doSomething()
        }
    }
}
```

2. 逃逸闭包
```swift
var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

3. 自动闭包
```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}

serve(customer: customersInLine.remove(at: 0))
```

## 四、面向对象编程
### 1. 枚举
枚举是 Swift 中的一种类型，用于定义一组相关的值。枚举可以包含关联值，也可以定义方法，是 Swift 中强大的类型系统的一部分。

```swift
// 基本枚举
enum CompassPoint {
    case north
    case south
    case east
    case west
}

// 关联值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

// 原始值
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// 递归枚举
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

### 2. 类和结构体
类和结构体是 Swift 中用于创建自定义类型的基本构建块。它们有很多相似之处，但也有一些重要的区别，如继承、引用类型和值类型等。

#### 2.1 基本定义
类和结构体都可以定义属性和方法，但类支持继承，而结构体不支持。选择使用类还是结构体取决于具体的需求。

```swift
// 结构体定义
struct Resolution {
    var width = 0
    var height = 0
}

// 类定义
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
```

#### 2.2 属性
Swift 中的属性包括存储属性、计算属性、属性观察器和类型属性。这些属性提供了不同的功能，可以根据需求选择合适的方式。

```swift
// 存储属性
class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// 计算属性
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}

// 属性观察器
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}

// 类型属性
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
```

#### 2.3 方法
方法包括实例方法和类型方法，用于定义类型的行为。实例方法属于实例，而类型方法属于类型本身。

```swift
// 实例方法
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}

// 类型方法
class Math {
    static func abs(_ number: Int) -> Int {
        return number < 0 ? -number : number
    }
    class func max(_ a: Int, _ b: Int) -> Int {
        return a > b ? a : b
    }
}

// 下标
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
```

#### 2.4 继承
继承是面向对象编程的重要特性，允许子类继承父类的属性和方法。Swift 支持单继承，一个类只能继承一个父类。

```swift
// 基类
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // 什么也不做
    }
}

// 子类
class Bicycle: Vehicle {
    var hasBasket = false
}

// 重写方法
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

// 重写属性
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

// 防止重写
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
```

#### 2.5 初始化
初始化是创建类或结构体实例的过程。Swift 提供了多种初始化方式，包括指定初始化器、便利初始化器、可失败初始化器等。

```swift
// 指定初始化器
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
}

// 便利初始化器
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

// 可失败初始化器
class Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

// 必要初始化器
class SomeClass {
    required init() {
        // 初始化代码
    }
}
```

#### 2.6 析构
析构是清理类实例的过程，用于释放资源。Swift 使用 deinit 关键字定义析构器，在实例被释放时自动调用。

```swift
class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}
```

#### 2.7 类型转换
类型转换是 Swift 中处理不同类型之间转换的机制。可以使用 is 和 as 运算符进行类型检查和转换。

```swift
// 类型检查
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

// 类型检查
for item in library {
    if item is Movie {
        print("Movie: \(item.name)")
    } else if item is Song {
        print("Song: \(item.name)")
    }
}

// 类型转换
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}
```

#### 2.8 嵌套类型
嵌套类型是在类型内部定义的类型，可以访问外部类型的属性和方法。嵌套类型可以提高代码的组织性和可读性。

```swift
struct BlackjackCard {
    // 嵌套的 Suit 枚举
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }
    
    // 嵌套的 Rank 枚举
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}
```

### 3. 协议
协议是 Swift 中定义方法、属性和其他要求的蓝图。协议可以被类、结构体和枚举遵循，是 Swift 中实现多态的重要方式。

```swift
// 协议定义
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    func someMethod()
}

// 协议继承
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // 协议定义
}

// 协议扩展
extension SomeProtocol {
    func someMethod() {
        // 方法实现
    }
}

// 协议作为类型
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
```

## 五、高级特性
### 1. 错误处理
Swift 提供了强大的错误处理机制，用于处理可能发生的错误。使用 try、catch 和 throw 关键字，可以优雅地处理错误情况。

```swift
// 定义错误类型
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// 抛出错误
func vend(itemNamed name: String) throws {
    guard let item = inventory[name] else {
        throw VendingMachineError.invalidSelection
    }
    guard item.count > 0 else {
        throw VendingMachineError.outOfStock
    }
    guard item.price <= coinsDeposited else {
        throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
    }
    // 其他代码
}

// 处理错误
do {
    try vend(itemNamed: "Candy Bar")
    // 其他代码
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch {
    print("Unexpected error: \(error).")
}
```

### 2. 泛型
泛型是 Swift 中的一种特性，允许你编写灵活、可重用的函数和类型。泛型可以用于任何类型，使代码更加通用和可复用。

```swift
// 泛型函数
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// 泛型类型
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// 类型约束
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
```

### 3. 函数类型
```swift
// 函数类型
typealias MathFunction = (Int, Int) -> Int

// 函数作为参数
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func multiply(_ a: Int, _ b: Int) -> Int {
    return a * b
}

func printMathResult(_ mathFunction: MathFunction, _ a: Int, _ b: Int) {
    let result = mathFunction(a, b)
    print("Result: \(result)")
}

// 函数作为返回值
func chooseFunction(_ operation: String) -> MathFunction {
    switch operation {
    case "add":
        return add
    case "multiply":
        return multiply
    default:
        return add
    }
}
```

### 4. 访问控制
```swift
// 访问级别
public class PublicClass { }
internal class InternalClass { }
fileprivate class FilePrivateClass { }
private class PrivateClass { }

// 访问控制示例
public class BankAccount {
    private var balance: Double
    
    public init(initialBalance: Double) {
        balance = initialBalance
    }
    
    public func deposit(amount: Double) {
        balance += amount
    }
    
    public func withdraw(amount: Double) {
        balance -= amount
    }
    
    public func getBalance() -> Double {
        return balance
    }
}
```

### 5. 扩展
```swift
// 扩展类型
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
}

// 扩展方法
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

// 扩展初始化器
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

### 6. 协议扩展
```swift
// 协议扩展
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension TextRepresentable {
    var textualDescription: String {
        return "A \(type(of: self))"
    }
}

// 为协议添加默认实现
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
```
