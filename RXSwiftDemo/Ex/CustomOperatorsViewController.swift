//
//  CustomOperatorsViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/10/19.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomOperatorsViewController: UIViewController {

    
    let showLabel = UILabel()
    let inputText = UITextField()
    var p : Variable<String> = Variable("")
    
    let studyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义操作符、变量的使用"
        self.view.backgroundColor = UIColor.white
        self.createView()
        self.createAction()
    }
    
    func createAction() -> Void {
        
        self.inputText.rx.text.orEmpty.map { (s) -> String in
            return s
        }.bind(to: self.p).disposed(by: disposeBag)
        
        self.p.asObservable().bind(to: self.showLabel.rx.text).disposed(by: disposeBag)
        
        
    }
    
    func createView() -> Void {
        
        self.createStudyLabel()
        
        self.createCustomOperButton()
        
        
        self.createShowLable()
        
        self.createInputText()
        
    }
    
    func createInputText() -> Void {
        self.view.addSubview(self.inputText)
        
        self.inputText.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
        self.inputText.textAlignment = .center
        self.inputText.placeholder = "请输入变量"
        self.inputText.snp.makeConstraints { (make) in
            make.top.equalTo(self.showLabel.snp.bottom).offset(20)
            make.left.right.equalTo(self.showLabel)
            make.height.equalTo(44)
        }
    }
    
    func createShowLable() -> Void {
        
        self.view.addSubview(self.showLabel)
        self.showLabel.textAlignment = .center
        self.showLabel.numberOfLines = 0
        self.showLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(2)
            make.left.right.equalTo(self.studyLabel)
            make.top.equalTo(self.studyLabel.snp.bottom).offset(104)
        }
    }
    
    func createCustomOperButton() -> Void {
        
        let button = UIButton.init(type: .custom)
        
        button.setTitle("自定义操作符使用", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor.blue
        
        self.view.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.height.equalTo(44)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(studyLabel.snp.bottom).offset(20)
        })
        
        button.rx.tap.subscribe(onNext: { () in
            
            self.createObservable(a: [1,2,3,4,5,6,7,8,9,10]).customMap(tranfrom: { (x) -> [Int] in
                return x.reversed()
            }).subscribe(onNext: { (x) in
                print(x)
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
    }
    
    func createStudyLabel() -> Void {
        
        studyLabel.numberOfLines = 0
        studyLabel.text = "自定义操作符\n 操作符：map、filter之类叫做操作符,自定义操作符，个人理解就是 拓展ObservableType，就是OC的分类"
        
        studyLabel.textColor = UIColor.darkText
        
        self.view.addSubview(studyLabel)
        
        studyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(2)
            make.top.equalToSuperview().offset(100)
        }
    }
    
    
    
    /** 创建Observable */
    func  createObservable(a:[Int]) -> Observable<[Int]> {
        
        return Observable.create({ (observe) -> Disposable in
            observe.onNext(a)
            
            return Disposables.create()
        })
    }
}


extension ObservableType{
    
    /** 自定义map */
    func customMap(tranfrom:@escaping ((E) -> Any)) -> Observable<Any> {
        return Observable.create({ (observe) -> Disposable in
            return self.subscribe(onNext: { (e) in
                observe.onNext(tranfrom(e))
            }, onError: { (e) in
                observe.onError(e)
            }, onCompleted: {
                observe.onCompleted()
            })
        })
    }
}
