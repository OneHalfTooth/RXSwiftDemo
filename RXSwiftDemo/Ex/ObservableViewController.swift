//
//  ObservableViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/10/19.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ObservableViewController: UIViewController {

    
    let showLabel = UILabel()
    
    var requestButton : UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(named: "Back")
        self.createView()
        self.createAction()
    }
    
    func createAction() -> Void {
        self.requestButton?.rx.tap.subscribe(onNext:{() in
            
            let observable = self.createObservable(p: "开始请求网络")
            
            observable.subscribe(onNext: { (x) in
                print(x)
            }, onError: { (e) in
                print("error")
            }, onCompleted: {
                print("请求完成")
            }).dispose()
            
        }).disposed(by: disposeBag)
    }
    
    
    
    
    
    func createView() -> Void {
        
        self.createShowLabel()
        self.createRequestButton()
        
    }
    
    func createRequestButton() -> Void {
        self.requestButton = UIButton.init(type: .custom)
        self.requestButton?.setTitle("开始请求", for: .normal)
        self.requestButton?.setTitleColor(UIColor.white, for: .normal)
        self.requestButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.requestButton?.backgroundColor = UIColor.blue
        
        self.view.addSubview(self.requestButton!)
        self.requestButton?.snp.makeConstraints({ (make) in
            make.height.equalTo(44)
            make.left.right.equalTo(self.showLabel)
            make.top.equalTo(self.showLabel.snp.bottom).offset(40)
        })
    }
    
    func createShowLabel() -> Void {
        
        self.showLabel.textColor = UIColor.darkText
        
        self.showLabel.textAlignment = .center
        
        self.view.addSubview(self.showLabel)
        
        self.showLabel.numberOfLines = 0
        self.showLabel.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(5)
        }
    }
}

extension ObservableViewController{
    
    func createObservable(p:String) -> Observable<Any> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext("正在请求1")
            observer.onNext("正在请求2")
            observer.onNext("正在请求3")
            observer.onNext("正在请求4")
            observer.onCompleted()
            observer.onNext("正在请求5")
            return Disposables.create()
        }
    }
}
