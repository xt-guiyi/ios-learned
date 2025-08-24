//
//  TextExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import SnapKit
import UIKit

class TextExampleViewController: BaseViewController {

  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let navigationBar = CustomNavigationBar()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
    setupNavigationBar()
    setupScrollView()
    setupTextExamples()
  }

  private func setupNavigationBar() {
    navigationBar.configure(title: "文本控件") { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }

    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
    }
  }

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

  private func setupTextExamples() {
    var previousView: UIView = contentView

    // 1. 基础文本
    let basicText = createTextExampleSection(
      title: "基础文本",
      description: "最基本的文本展示",
      textStyle: .basic
    )
    contentView.addSubview(basicText)
    basicText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.top).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = basicText

    // 2. 标题文本
    let titleText = createTextExampleSection(
      title: "标题文本",
      description: "用于标题显示的大字体文本",
      textStyle: .title
    )
    contentView.addSubview(titleText)
    titleText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = titleText

    // 3. 副标题文本
    let subtitleText = createTextExampleSection(
      title: "副标题文本",
      description: "用于副标题显示的中等字体文本",
      textStyle: .subtitle
    )
    contentView.addSubview(subtitleText)
    subtitleText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = subtitleText

    // 4. 多行文本
    let multilineText = createTextExampleSection(
      title: "多行文本",
      description: "支持多行显示的文本",
      textStyle: .multiline
    )
    contentView.addSubview(multilineText)
    multilineText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = multilineText

    // 5. 彩色文本
    let colorText = createTextExampleSection(
      title: "彩色文本",
      description: "使用主题色的文本",
      textStyle: .colored
    )
    contentView.addSubview(colorText)
    colorText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = colorText

    // 6. 粗体文本
    let boldText = createTextExampleSection(
      title: "粗体文本",
      description: "加粗显示的文本",
      textStyle: .bold
    )
    contentView.addSubview(boldText)
    boldText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = boldText

    // 7. 斜体文本
    let italicText = createTextExampleSection(
      title: "斜体文本",
      description: "斜体显示的文本",
      textStyle: .italic
    )
    contentView.addSubview(italicText)
    italicText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = italicText

    // 8. 划线文本
    let strikethroughText = createTextExampleSection(
      title: "划线文本",
      description: "带删除线的文本",
      textStyle: .strikethrough
    )
    contentView.addSubview(strikethroughText)
    strikethroughText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = strikethroughText

    // 9. 下划线文本
    let underlineText = createTextExampleSection(
      title: "下划线文本",
      description: "带下划线的文本",
      textStyle: .underline
    )
    contentView.addSubview(underlineText)
    underlineText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = underlineText

    // 10. 富文本（可点击、高亮、加粗）
    let richText = createTextExampleSection(
      title: "富文本",
      description: "支持部分文字高亮、点击、加粗和网址点击",
      textStyle: .richText
    )
    contentView.addSubview(richText)
    richText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = richText

    // 11. 单行省略文本
    let singleLineEllipsisText = createTextExampleSection(
      title: "单行省略文本",
      description: "超出长度时在尾部显示省略号",
      textStyle: .singleLineEllipsis
    )
    contentView.addSubview(singleLineEllipsisText)
    singleLineEllipsisText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = singleLineEllipsisText

    // 12. 多行省略文本
    let multiLineEllipsisText = createTextExampleSection(
      title: "多行省略文本",
      description: "限制行数，超出时显示省略号",
      textStyle: .multiLineEllipsis
    )
    contentView.addSubview(multiLineEllipsisText)
    multiLineEllipsisText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
    }
    previousView = multiLineEllipsisText

    // 13. 可展开收起文本
    let expandableText = createTextExampleSection(
      title: "可展开收起文本",
      description: "点击文本可以展开/收起长文本内容",
      textStyle: .expandable
    )
    contentView.addSubview(expandableText)
    expandableText.snp.makeConstraints { make in
      make.top.equalTo(previousView.snp.bottom).offset(20)
      make.left.right.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().offset(-20)
    }
  }

  private func createTextExampleSection(title: String, description: String, textStyle: TextStyle)
    -> UIView
  {
    let containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 12
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
    containerView.layer.shadowOpacity = 0.1
    containerView.layer.shadowRadius = 3

    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.textColor = .black

    let descLabel = UILabel()
    descLabel.text = description
    descLabel.font = UIFont.systemFont(ofSize: 14)
    descLabel.textColor = .gray
    descLabel.numberOfLines = 0

    let exampleLabel = createTextLabel(style: textStyle)

    containerView.addSubview(titleLabel)
    containerView.addSubview(descLabel)
    containerView.addSubview(exampleLabel)

    titleLabel.snp.makeConstraints { make in
      make.top.left.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(-16)
    }

    descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.left.right.equalTo(titleLabel)
    }

    exampleLabel.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom).offset(16)
      make.left.right.equalTo(titleLabel)
      make.bottom.equalToSuperview().offset(-16)
    }

    return containerView
  }

  private func createTextLabel(style: TextStyle) -> UIView {
    let label = UILabel()
    label.numberOfLines = 0

    switch style {
    case .basic:
      label.text = "这是基础文本示例"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = .black

    case .title:
      label.text = "这是标题文本"
      label.font = UIFont.boldSystemFont(ofSize: 24)
      label.textColor = .black

    case .subtitle:
      label.text = "这是副标题文本"
      label.font = UIFont.systemFont(ofSize: 18)
      label.textColor = .darkGray

    case .multiline:
      label.text = "这是多行文本示例，可以显示很长的内容。当文本内容超过一行时，会自动换行显示，非常适合展示详细的描述信息。"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = .black

    case .colored:
      label.text = "这是彩色文本示例"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = UIColor.themeColor

    case .bold:
      label.text = "这是粗体文本示例"
      label.font = UIFont.boldSystemFont(ofSize: 16)
      label.textColor = .black

    case .italic:
      label.text = "这是斜体文本示例"
      label.font = UIFont.italicSystemFont(ofSize: 16)
      label.textColor = .black

    case .strikethrough:
      label.text = "这是划线文本示例"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = .black
      let attributedString = NSMutableAttributedString(string: label.text ?? "")
      attributedString.addAttribute(
        NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue,
        range: NSMakeRange(0, attributedString.length))
      label.attributedText = attributedString

    case .underline:
      label.text = "这是下划线文本示例"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = .black
      let attributedString = NSMutableAttributedString(string: label.text ?? "")
      attributedString.addAttribute(
        NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue,
        range: NSMakeRange(0, attributedString.length))
      label.attributedText = attributedString

    case .richText:
      return createRichTextLabel()

    case .singleLineEllipsis:
      label.text = "这是一个很长很长的单行文本示例，当文本内容超过容器宽度时会自动在末尾显示省略号来表示内容被截断了"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = .black
      label.numberOfLines = 1
      label.lineBreakMode = .byTruncatingTail

    case .multiLineEllipsis:
      label.text =
        "这是一个多行省略文本示例。这段文本内容比较长，会占用多行空间。当设置了最大行数限制后，如果文本内容超过了设定的行数，就会在最后一行的末尾显示省略号，让用户知道还有更多内容没有显示出来。这种处理方式在移动端应用中非常常见，特别是在列表、卡片等布局中使用。"
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = .black
      label.numberOfLines = 3
      label.lineBreakMode = .byTruncatingTail

    case .expandable:
      return createExpandableTextView()
    }

    return label
  }

  private func createExpandableTextView() -> ExpandableTextView {
    let expandableText = ExpandableTextView()
    expandableText.font = UIFont.systemFont(ofSize: 16)
    expandableText.textColor = .black
    expandableText.buttonColor = UIColor.themeColor
    expandableText.numberOfLines = 2
    expandableText.expandText = "展开"
    expandableText.collapseText = "收起"
    expandableText.setText(
      "这是一个很长的文本内容示例，用于演示可展开和收起的功能。点击文本可以切换显示状态。当文本内容较长时，这种交互方式能够节省页面空间，同时允许用户按需查看完整内容。在实际应用中，这种设计常用于常见问题解答、产品描述、用户协议等需要显示大量文字的场景中。通过这种渐进式信息披露的方式，既保持了界面的简洁性，又确保了信息的完整性和可访问性。"
    )
    return expandableText
  }

  private func createRichTextLabel() -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0

    let fullText: String = "这是富文本示例：点击这里有交互，加粗文字很醒目，高亮显示效果，访问网站 https://www.apple.com 了解更多信息。"
    let attributedString = NSMutableAttributedString(string: fullText)

    // 设置基础样式
    attributedString.addAttribute(
      .font, value: UIFont.systemFont(ofSize: 16), range: NSMakeRange(0, attributedString.length))
    attributedString.addAttribute(
      .foregroundColor, value: UIColor.black, range: NSMakeRange(0, attributedString.length))

    // 可点击文字 - 蓝色
    if let range = fullText.range(of: "点击这里有交互") {
      let nsRange = NSRange(range, in: fullText)
      attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: nsRange)
      attributedString.addAttribute(
        .underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
      // 添加自定义属性用于标识可点击区域
      attributedString.addAttribute(
        NSAttributedString.Key(rawValue: "ClickableText"), value: "interaction", range: nsRange)
    }

    // 加粗文字
    if let range = fullText.range(of: "加粗文字很醒目") {
      let nsRange = NSRange(range, in: fullText)
      attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: nsRange)
    }

    // 高亮文字 - 背景色
    if let range = fullText.range(of: "高亮显示效果") {
      let nsRange = NSRange(range, in: fullText)
      attributedString.addAttribute(
        .backgroundColor, value: UIColor.systemYellow.withAlphaComponent(0.3), range: nsRange)
      attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: nsRange)
    }

    // 网址链接
    if let range = fullText.range(of: "https://www.apple.com") {
      let nsRange = NSRange(range, in: fullText)
      attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: nsRange)
      attributedString.addAttribute(
        .underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
      attributedString.addAttribute(.link, value: "https://www.apple.com", range: nsRange)
    }

    label.attributedText = attributedString

    // 启用用户交互
    label.isUserInteractionEnabled = true

    // 添加点击手势
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRichTextTap(_:)))
    label.addGestureRecognizer(tapGesture)

    return label
  }

  @objc private func handleRichTextTap(_ gesture: UITapGestureRecognizer) {
    guard let label = gesture.view as? UILabel,
      let attributedText = label.attributedText
    else { return }

    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    let textStorage = NSTextStorage(attributedString: attributedText)

    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)

    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize

    let locationOfTouchInLabel = gesture.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)

    let textContainerOffset = CGPoint(
      x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
      y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

    let locationOfTouchInTextContainer = CGPoint(
      x: locationOfTouchInLabel.x - textContainerOffset.x,
      y: locationOfTouchInLabel.y - textContainerOffset.y)

    let indexOfCharacter = layoutManager.characterIndex(
      for: locationOfTouchInTextContainer, in: textContainer,
      fractionOfDistanceBetweenInsertionPoints: nil)

    // 检查点击的是否是链接
    if let link = attributedText.attribute(.link, at: indexOfCharacter, effectiveRange: nil)
      as? String
    {
      if let url = URL(string: link) {
        UIApplication.shared.open(url)
        return
      }
    }

    // 检查点击的是否是自定义可点击文字
    if let clickableText = attributedText.attribute(
      NSAttributedString.Key(rawValue: "ClickableText"), at: indexOfCharacter, effectiveRange: nil)
      as? String
    {
      let alert = UIAlertController(title: "交互提示", message: "你点击了可交互的文字！", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "确定", style: .default))
      present(alert, animated: true)
    }
  }

}

enum TextStyle {
  case basic
  case title
  case subtitle
  case multiline
  case colored
  case bold
  case italic
  case strikethrough
  case underline
  case richText
  case singleLineEllipsis
  case multiLineEllipsis
  case expandable
}
