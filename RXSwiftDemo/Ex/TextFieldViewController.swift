//
//  TextFieldViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/10/19.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift


class TextFieldViewController: UIViewController {

    
    let showLabel = UILabel()
    
    let inputTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "UITextField"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.view.backgroundColor = UIColor.white
        
        self.createView()
        self.createAction()
    }
    
    
    func createAction() -> Void {
        
        self.inputTextField.rx.text.orEmpty.filter({ (x) -> Bool in
            if x.isEmpty {
                return false
            }
            return true
        }).map { (x) -> String in
            
            guard let s = Int(x) else{
                return "不是数字"
            }
            if s % 2 != 0{
                return  "是奇数"
            }
            return "是偶数"
        }.bind(to: self.showLabel.rx.text).disposed(by: disposeBag)
    }
    
    func createView() -> Void {
        
        self.createTextField()
        self.createLabel()
    }
    
    func createLabel() -> Void{
        
        self.view.addSubview(self.showLabel)
        
        self.showLabel.textColor = UIColor.lightGray
        self.showLabel.numberOfLines = 0
        self.showLabel.textAlignment = .center
        self.showLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.inputTextField.snp.top).offset(-100)
            make.left.right.equalTo(self.inputTextField)
            make.height.greaterThanOrEqualTo(5)
        }
    }
    
    func createTextField() -> Void {
        
        self.view.addSubview(self.inputTextField)
        self.inputTextField.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
        self.inputTextField.placeholder = "输入"
        self.inputTextField.textAlignment = .center
        self.inputTextField.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
