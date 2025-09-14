//
//  CustomDialogExampleViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class CustomDialogExampleViewController: BaseViewController {
    
    /// 自定义导航栏
    private let navigationBar = CustomNavigationBar()
    
    /// 滚动容器
    private let scrollView = UIScrollView()
    
    /// 内容容器
    private let contentView = UIView()
    
    /// 按钮组
    private let alertButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let inputButton = UIButton(type: .system)
    private let loadingButton = UIButton(type: .system)
    private let styledButton = UIButton(type: .system)
    private let customActionButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    /// 设置用户界面
    private func setupUI() {
        setupNavigationBar()
        setupScrollView()
        setupButtons()
        setupConstraints()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "自定义弹窗") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
       
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }
    
    /// 设置滚动视图
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
    }
    
    /// 设置按钮
    private func setupButtons() {
        let buttons = [alertButton, confirmButton, inputButton, loadingButton, styledButton, customActionButton]
        let titles = ["基础提示弹窗", "确认对话框", "输入对话框", "加载弹窗", "样式化弹窗", "自定义操作弹窗"]
        let colors: [UIColor] = [.systemBlue, .systemOrange, .systemGreen, .systemPurple, .systemRed, .systemTeal]
        
        for (index, button) in buttons.enumerated() {
            setupButtonStyle(button, title: titles[index], backgroundColor: colors[index])
            contentView.addSubview(button)
        }
    }
    
    /// 设置单个按钮样式
    private func setupButtonStyle(_ button: UIButton, title: String, backgroundColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
    }
    
    /// 设置约束
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let buttons = [alertButton, confirmButton, inputButton, loadingButton, styledButton, customActionButton]
        
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(50)
                
                if index == 0 {
                    make.top.equalToSuperview().offset(20)
                } else {
                    make.top.equalTo(buttons[index - 1].snp.bottom).offset(15)
                }
                
                if index == buttons.count - 1 {
                    make.bottom.equalToSuperview().offset(-30)
                }
            }
        }
    }
    
    /// 设置按钮点击事件
    private func setupActions() {
        alertButton.addTarget(self, action: #selector(showAlertDialog), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(showConfirmDialog), for: .touchUpInside)
        inputButton.addTarget(self, action: #selector(showInputDialog), for: .touchUpInside)
        loadingButton.addTarget(self, action: #selector(showLoadingDialog), for: .touchUpInside)
        styledButton.addTarget(self, action: #selector(showStyledDialog), for: .touchUpInside)
        customActionButton.addTarget(self, action: #selector(showCustomActionDialog), for: .touchUpInside)
    }
    
    /// 显示基础提示弹窗
    @objc private func showAlertDialog() {
        let dialog = CustomAlertDialog()
        dialog.show(
            title: "提示",
            message: "这是一个基础的提示弹窗，用于向用户显示重要信息。",
            buttonTitle: "我知道了"
        ) {
            print("用户点击了确认按钮")
        }
    }
    
    /// 显示确认对话框
    @objc private func showConfirmDialog() {
        let dialog = CustomConfirmDialog(
            title: "确认删除",
            message: "确定要删除这个项目吗？此操作不可撤销。",
            confirmAction: ("删除", {
                print("用户确认删除")
                self.showSuccessMessage("删除成功")
            }),
            cancelAction: ("取消", {
                print("用户取消删除")
            })
        )
        dialog.show(on: self)
    }
    
    /// 显示输入对话框
    @objc private func showInputDialog() {
        let dialog = CustomInputDialog(
            title: "输入名称",
            message: "请输入新项目的名称：",
            placeholder: "项目名称",
            inputType: .text,
            confirmAction: { text in
                if !text.isEmpty {
                    print("用户输入：\(text)")
                    self.showSuccessMessage("创建成功：\(text)")
                } else {
                    print("用户输入为空")
                }
            },
            cancelAction: {
                print("用户取消输入")
            }
        )
        dialog.show(on: self)
    }
    
    /// 显示加载弹窗
    @objc private func showLoadingDialog() {
        let dialog = CustomLoadingDialog(message: "正在处理，请稍候...")
        dialog.show(on: self)
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            dialog.dismiss()
            self.showSuccessMessage("处理完成")
        }
    }
    
    /// 显示样式化弹窗
    @objc private func showStyledDialog() {
        let dialog = CustomAnimatedDialog(
            title: "成功",
            message: "操作已成功完成！这是一个带有动画效果的样式化弹窗。",
            animation: .bounce
        )
        dialog.show(on: self)
    }
    
    /// 显示自定义操作弹窗
    @objc private func showCustomActionDialog() {
        let alert = UIAlertController(title: "选择操作", message: "请选择您要执行的操作", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "编辑", style: .default) { _ in
            self.showSuccessMessage("执行编辑操作")
        }
        
        let shareAction = UIAlertAction(title: "分享", style: .default) { _ in
            self.showSuccessMessage("执行分享操作")
        }
        
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
            self.showDeleteConfirmation()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(editAction)
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // iPad 适配
        if let popover = alert.popoverPresentationController {
            popover.sourceView = customActionButton
            popover.sourceRect = customActionButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    /// 显示删除确认
    private func showDeleteConfirmation() {
        let dialog = CustomConfirmDialog(
            title: "危险操作",
            message: "此操作将永久删除数据，确定继续吗？",
            confirmAction: ("确认删除", {
                self.showSuccessMessage("删除操作已执行")
            }),
            cancelAction: ("取消", {})
        )
        dialog.show(on: self)
    }
    
    /// 显示成功消息
    private func showSuccessMessage(_ message: String) {
        let alert = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
