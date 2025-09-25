//
//  ModalPresentationViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/9/21.
//

import UIKit
import SnapKit

class ModalPresentationViewController: BaseViewController {

    private let navigationBar = CustomNavigationBar()
    private var listViewController: CardListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// 设置UI界面
    private func setupUI() {
        setupNavigationBar()
        setupListViewController()
    }

    /// 设置自定义导航栏
    private func setupNavigationBar() {
        navigationBar.configure(title: "模态弹出") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    /// 设置模态弹出示例列表
    private func setupListViewController() {
        let controller = CardListViewController()
        self.listViewController = controller

        let modalData = [
            ListItemModel(title: "Alert弹窗", subtitle: "系统Alert弹窗示例") { [weak self] in
                self?.showAlertExample()
            },
            ListItemModel(title: "ActionSheet弹窗", subtitle: "底部操作选择弹窗") { [weak self] in
                self?.showActionSheetExample()
            },
            ListItemModel(title: "FullScreen模态", subtitle: "全屏模态弹出") { [weak self] in
                self?.showFullScreenModal()
            },
            ListItemModel(title: "PageSheet模态", subtitle: "页面Sheet模态弹出") { [weak self] in
                self?.showPageSheetModal()
            },
            ListItemModel(title: "FormSheet模态", subtitle: "表单Sheet模态弹出") { [weak self] in
                self?.showFormSheetModal()
            },
            ListItemModel(title: "Popover弹出", subtitle: "iPad气泡弹出框") { [weak self] in
                self?.showPopoverExample()
            },
            ListItemModel(title: "自定义弹窗", subtitle: "自定义样式弹窗") { [weak self] in
                self?.showCustomModal()
            }
        ]

        controller.updateData(modalData)

        addChildController(controller) { childView in
            childView.snp.makeConstraints { make in
                make.top.equalTo(self.navigationBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }

    // MARK: - 模态弹出方法

    /// Alert弹窗示例
    private func showAlertExample() {
        let alert = UIAlertController(title: "Alert示例", message: "这是一个标准的Alert弹窗，可以显示标题、消息和多个操作按钮。", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            self.showSuccessAlert("你点击了确定按钮")
        })

        alert.addAction(UIAlertAction(title: "删除", style: .destructive) { _ in
            self.showSuccessAlert("你点击了删除按钮")
        })

        alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
            self.showSuccessAlert("你点击了取消按钮")
        })

        present(alert, animated: true)
    }

    /// ActionSheet弹窗示例
    private func showActionSheetExample() {
        let actionSheet = UIAlertController(title: "选择操作", message: "请选择你要执行的操作", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            self.showSuccessAlert("你选择了拍照")
        })

        actionSheet.addAction(UIAlertAction(title: "从相册选择", style: .default) { _ in
            self.showSuccessAlert("你选择了从相册选择")
        })

        actionSheet.addAction(UIAlertAction(title: "删除照片", style: .destructive) { _ in
            self.showSuccessAlert("你选择了删除照片")
        })

        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))

        // iPad上需要设置popover
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        present(actionSheet, animated: true)
    }

    /// 全屏模态示例
    private func showFullScreenModal() {
        let modalVc = createModalViewController(
            title: "FullScreen模态",
            backgroundColor: UIColor.systemBlue,
            description: "这是一个全屏模态页面\n完全覆盖当前界面\n适用于重要的操作流程"
        )
        modalVc.modalPresentationStyle = .fullScreen
        present(modalVc, animated: true)
    }

    /// PageSheet模态示例
    private func showPageSheetModal() {
        let modalVc = createModalViewController(
            title: "PageSheet模态",
            backgroundColor: UIColor.systemGreen,
            description: "这是一个PageSheet模态页面\n从底部弹出，保留部分背景\n可以通过下拉手势关闭"
        )
        modalVc.modalPresentationStyle = .pageSheet

        // iOS 15+支持可调整高度
        if #available(iOS 15.0, *) {
            if let sheet = modalVc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        }

        present(modalVc, animated: true)
    }

    /// FormSheet模态示例
    private func showFormSheetModal() {
        let modalVc = createModalViewController(
            title: "FormSheet模态",
            backgroundColor: UIColor.systemPurple,
            description: "这是一个FormSheet模态页面\n在iPad上显示为中央浮动窗口\n在iPhone上类似PageSheet"
        )
        modalVc.modalPresentationStyle = .formSheet
        present(modalVc, animated: true)
    }

    /// Popover弹出示例
    private func showPopoverExample() {
        let popoverVc = createModalViewController(
            title: "Popover弹出",
            backgroundColor: UIColor.systemOrange,
            description: "这是一个Popover弹出框\n主要用于iPad上的上下文菜单\n在iPhone上会显示为ActionSheet"
        )
        popoverVc.modalPresentationStyle = .popover

        if let popover = popoverVc.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = [.up, .down, .left, .right]
        }

        present(popoverVc, animated: true)
    }

    /// 自定义弹窗示例
    private func showCustomModal() {
        let customModal = CustomModalViewController()
        customModal.modalPresentationStyle = .overCurrentContext
        customModal.modalTransitionStyle = .crossDissolve
        present(customModal, animated: true)
    }

    // MARK: - 辅助方法

    /// 创建模态ViewController
    private func createModalViewController(title: String, backgroundColor: UIColor, description: String) -> UIViewController {
        let modalVc = UIViewController()
        modalVc.view.backgroundColor = backgroundColor

        // 添加标题
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        modalVc.view.addSubview(titleLabel)

        // 添加描述
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        modalVc.view.addSubview(descriptionLabel)

        // 添加关闭按钮
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 25
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        modalVc.view.addSubview(closeButton)

        // 设置约束
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(modalVc.view.safeAreaLayoutGuide.snp.top).offset(50)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(40)
        }

        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(modalVc.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }

        // 关闭按钮事件
        closeButton.addTarget(self, action: #selector(dismissModalViewController(_:)), for: .touchUpInside)

        return modalVc
    }

    /// 显示成功提示
    private func showSuccessAlert(_ message: String) {
        let alert = UIAlertController(title: "操作结果", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }

    /// 关闭模态页面
    @objc private func dismissModalViewController(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - 自定义模态弹窗
class CustomModalViewController: UIViewController {

    private let containerView = UIView()
    private let backgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }

    /// 设置UI
    private func setupUI() {
        view.backgroundColor = UIColor.clear

        // 背景蒙层
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.alpha = 0
        view.addSubview(backgroundView)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 容器视图
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowRadius = 10
        containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(400)
        }

        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "自定义弹窗"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        // 内容
        let contentLabel = UILabel()
        contentLabel.text = "这是一个完全自定义的弹窗\n\n• 自定义背景蒙层\n• 自定义动画效果\n• 自定义样式和布局\n• 支持手势操作"
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        containerView.addSubview(contentLabel)

        // 关闭按钮
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.backgroundColor = UIColor.themeColor
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 8
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        containerView.addSubview(closeButton)

        // 设置约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.right.equalToSuperview().inset(20)
        }

        contentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }

        // 添加点击背景关闭手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    /// 弹出动画
    private func animateIn() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.backgroundView.alpha = 1
            self.containerView.transform = CGAffineTransform.identity
        }
    }

    /// 关闭动画
    private func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            completion()
        }
    }

    /// 关闭弹窗
    @objc private func closeModal() {
        animateOut {
            self.dismiss(animated: false)
        }
    }

    /// 点击背景关闭
    @objc private func backgroundTapped() {
        closeModal()
    }
}