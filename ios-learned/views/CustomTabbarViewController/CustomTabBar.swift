//
//  CustomTabBar.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/23.
//

import UIKit
import SnapKit

/// 自定义TabBar代理协议
public protocol CustomTabBarDelegate: AnyObject {
    /// TabBar项目选中回调
    /// - Parameter index: 选中的项目索引
    func customTabBar(_ tabBar: CustomTabBar, didSelectItemAt index: Int)
}

/// 自定义TabBar视图
public class CustomTabBar: UIView {

    // MARK: - UI Components

    /// 背景视图
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        return view
    }()

    /// 项目容器视图
    private let itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    /// 顶部分割线
    private let topSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()

    // MARK: - Properties

    /// 代理对象
    public weak var delegate: CustomTabBarDelegate?

    /// TabBar项目数组
    private var tabBarItems: [CustomTabBarItem] = []

    /// 数据模型数组
    private var itemModels: [CustomTabBarItemModel] = []

    /// 当前选中索引
    private var selectedIndex: Int = 0

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    /// 配置TabBar项目
    /// - Parameter models: 项目数据模型数组
    public func configureItems(with models: [CustomTabBarItemModel]) {
        self.itemModels = models

        // 清除现有项目
        tabBarItems.forEach { $0.removeFromSuperview() }
        tabBarItems.removeAll()

        // 创建新的项目
        for (index, model) in models.enumerated() {
            let item = CustomTabBarItem()
            item.configure(with: model)
            item.onTap = { [weak self] in
                self?.selectItem(at: index)
            }

            tabBarItems.append(item)
            itemsStackView.addArrangedSubview(item)
        }

        // 设置默认选中第一个
        if !models.isEmpty {
            selectItem(at: 0)
        }
    }

    /// 选中指定索引的项目
    /// - Parameter index: 项目索引
    public func selectItem(at index: Int) {
        guard index >= 0 && index < tabBarItems.count else { return }

        // 更新选中状态
        for (i, item) in tabBarItems.enumerated() {
            item.isSelected = (i == index)
        }

        let previousIndex = selectedIndex
        selectedIndex = index

        // 添加切换动画（仅在索引变化时）
        if previousIndex != index {
            addSwitchAnimation()
        }

        // 通知代理
        delegate?.customTabBar(self, didSelectItemAt: index)
    }

    /// 获取当前选中索引
    /// - Returns: 当前选中的索引
    public func getCurrentSelectedIndex() -> Int {
        return selectedIndex
    }

    // MARK: - Private Methods

    /// 设置UI界面
    private func setupUI() {
        backgroundColor = .clear

        addSubview(backgroundView)
        addSubview(topSeparatorLine)
        addSubview(itemsStackView)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topSeparatorLine.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }

        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(topSeparatorLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
    }

    /// 添加切换动画效果
    private func addSwitchAnimation() {
        // 移除TabBar整体的缩放动画，保持静态
    }
}