//
//  CardListViewController.swift
//  ios-learned
//
//  Created by 熊涛 on 2025/8/24.
//

import UIKit
import SnapKit

class CardListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var listItems: [ListItemModel] = []
    
    var onItemSelected: ((ListItemModel, Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CardListCell.self, forCellReuseIdentifier: CardListCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateData(_ items: [ListItemModel]) {
        self.listItems = items
        tableView.reloadData()
    }
    
    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}

extension CardListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardListCell.identifier, for: indexPath) as! CardListCell
        let model = listItems[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = listItems[indexPath.row]
        
        // 先调用模型中的 action
        model.action?()
        
        // 再调用外部设置的回调
        onItemSelected?(model, indexPath.row)
    }
}