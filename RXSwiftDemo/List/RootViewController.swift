//
//  RootViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/10/19.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import RxSwift

public var disposeBag = DisposeBag()

class RootViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSourceArray = ["UITextField 绑定",
                           "Observable",
                           "自定义操作符、变量的使用",
                           "KVO",
                           "Subject的使用",
                           "操作符"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        
        self.title = "RXSwiftDemo -- 深入学习"
//        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}


extension RootViewController:UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(TextFieldViewController(), animated: true)
            break

        case 1:
            self.navigationController?.pushViewController(ObservableViewController(), animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(CustomOperatorsViewController(), animated: true)
            break
        case 3:
            self.navigationController?.pushViewController(KVOViewController(), animated: true)
            break
        case 4:
            self.navigationController?.pushViewController(SubjectViewController(), animated: true)
            break
        case 5:
            self.navigationController?.pushViewController(OperatorsViewController(), animated: true)
            break
        default: break
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        cell?.textLabel?.text = self.dataSourceArray[indexPath.row]
        
        return cell!
    }
}
