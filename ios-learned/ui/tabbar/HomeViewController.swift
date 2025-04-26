//
//  ViewController.swift
//  ios-learned
//
//  Created by 小星星滚呀滚 on 2025/4/25.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }
    
    func initTableView() {
        // UITableViewDataSource 提供数据
        tableView.dataSource = self
        //UITableViewDelegate 提供 事件 消失的时机 header、footer 设置
           tableView.delegate = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = tableView.dequeueReusableCell(withIdentifier: "id")
        if (tableViewCell == nil) {
            tableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "id")
        }
       
        tableViewCell!.textLabel?.text = "主标题-\(indexPath.row)"
        tableViewCell!.detailTextLabel?.text = "副标题"
        tableViewCell!.imageView?.image = UIImage(named: "avatar")
        
        return (tableViewCell)!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.green
        vc.title = "首页详情页"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

