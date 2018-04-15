//
//  ViewController.swift
//  Charts
//
//  Created by gzuser on 12/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var items = Items()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "各种图像"
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "item")
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = ChartViewController()
        viewController.builder = items[indexPath.row].buidlerBlock
        viewController.title = items[indexPath.row].title
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item")
        cell?.textLabel?.text = items[indexPath.row].title
        return cell!
    }

}
