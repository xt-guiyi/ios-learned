//
//  ButtonExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class ButtonExampleViewController: BaseViewController {
    
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
        setupButtonExamples()
    }
    
    private func setupNavigationBar() {
        navigationBar.configure(title: "按钮控件") { [weak self] in
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
    
    private func setupButtonExamples() {
        var previousView: UIView = contentView
        
        // 1. 基础按钮
        let basicButton = createExampleSection(
            title: "基础按钮",
            description: "最基本的按钮样式",
            buttonTitle: "基础按钮",
            buttonStyle: .basic
        )
        contentView.addSubview(basicButton)
        basicButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = basicButton
        
        // 2. 主题色按钮
        let themeButton = createExampleSection(
            title: "主题色按钮",
            description: "使用应用主题色的按钮",
            buttonTitle: "主题色按钮",
            buttonStyle: .theme
        )
        contentView.addSubview(themeButton)
        themeButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = themeButton
        
        // 3. 边框按钮
        let borderButton = createExampleSection(
            title: "边框按钮",
            description: "只有边框的按钮样式",
            buttonTitle: "边框按钮",
            buttonStyle: .border
        )
        contentView.addSubview(borderButton)
        borderButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = borderButton
        
        // 4. 圆形按钮
        let roundButton = createExampleSection(
            title: "圆形按钮",
            description: "圆形设计的按钮",
            buttonTitle: "圆形按钮",
            buttonStyle: .round
        )
        contentView.addSubview(roundButton)
        roundButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = roundButton
        
        // 5. 图标按钮
        let iconButton = createExampleSection(
            title: "图标按钮",
            description: "带图标的按钮",
            buttonTitle: "图标按钮",
            buttonStyle: .icon
        )
        contentView.addSubview(iconButton)
        iconButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = iconButton
        
        // 6. 文本按钮
        let textButton = createExampleSection(
            title: "文本按钮",
            description: "纯文本样式的按钮",
            buttonTitle: "文本按钮",
            buttonStyle: .text
        )
        contentView.addSubview(textButton)
        textButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        previousView = textButton
        
        // 7. 按下效果按钮
        let pressEffectButton = createExampleSection(
            title: "按下效果按钮",
            description: "具有按下缩放效果的按钮",
            buttonTitle: "按下效果",
            buttonStyle: .pressEffect
        )
        contentView.addSubview(pressEffectButton)
        pressEffectButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func createExampleSection(title: String, description: String, buttonTitle: String, buttonStyle: ButtonStyle) -> UIView {
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
        
        let exampleButton = createButton(title: buttonTitle, style: buttonStyle)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(exampleButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalTo(titleLabel)
        }
        
        exampleButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return containerView
    }
    
    private func createButton(title: String, style: ButtonStyle) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        switch style {
        case .basic:
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            button.layer.cornerRadius = 8
            
        case .theme:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
            button.layer.cornerRadius = 8
            
        case .border:
            button.setTitleColor(UIColor.themeColor, for: .normal)
            button.backgroundColor = .clear
            button.layer.borderColor = UIColor.themeColor.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 8
            
        case .round:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
            button.layer.cornerRadius = 22
            
        case .icon:
            button.setTitleColor(UIColor.themeColor, for: .normal)
            button.backgroundColor = .clear
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            button.tintColor = UIColor.themeColor
            button.imageView?.contentMode = .scaleAspectFit
            
        case .text:
            button.setTitleColor(UIColor.themeColor, for: .normal)
            button.backgroundColor = .clear
            
        case .pressEffect:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.themeColor
            button.layer.cornerRadius = 8
            
            // 添加按下和抬起的事件
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        let alert = UIAlertController(title: "按钮点击", message: "你点击了：\(title)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
}

enum ButtonStyle {
    case basic
    case theme
    case border
    case round
    case icon
    case text
    case pressEffect
}
