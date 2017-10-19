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
        /*
         * 多个订阅者，share(replay: 10)：后订阅的订阅者接收，后订阅者订阅之前错过的信号，数量为10
        self.requestButton?.rx.tap.subscribe(onNext:{() in
            
            let observable = self.createObservable(p: "开始请求网络").share(replay: 10)
            
            observable.subscribe(onNext: { (x) in
                print(x + "1111111")
            }, onError: { (e) in
                print("error")
            }, onCompleted: {
                print("请求完成" + "1111111")
            }).disposed(by: disposeBag)
            
             observable.subscribe(onNext: { (x) in
             print(x + "222222222")
             }, onError: { (e) in
             print("error")
             }, onCompleted: {
             print("请求完成" + "222222222")
             }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)*/
        
        
        /*
         * 接受信号，5S后停止
        self.requestButton?.rx.tap.subscribe(onNext:{() in
            let observable = self.createObservable(p: "开始请求网络")
            let s = observable.subscribe(onNext: { (x) in
                print(x + "1111111")
            }, onError: { (e) in
                print("error")
            }, onCompleted: {
                print("请求完成" + "1111111")
            })
            
            Thread.sleep(forTimeInterval: 5)
            
            s.dispose()
            
        }).disposed(by: disposeBag) */
        
        
        /** 将信号绑定至label上 */
        self.requestButton?.rx.tap.subscribe(onNext:{() in
            DispatchQueue.main.async {
                let observable = self.createObservable(p: "开始请求网络")
                
                let s = observable.bind(to: self.showLabel.rx.text)
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 10, execute: {
                  
                    s.dispose()
                    
                })
            }
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
            make.top.equalToSuperview().offset(100)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(5)
        }
    }
}

extension ObservableViewController{
    
    func createObservable(p:String) -> Observable<String> {
        return Observable.create { (observer) -> Disposable in
            
            var i = 10000
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: .now(), repeating: 0.5)
//            timer.scheduleRepeating(deadline: .now(), interval: .seconds(0.5))
            let cancel = Disposables.create {
                timer.cancel()
            }
            timer.setEventHandler {
                i += 1
               observer.onNext(String(i))
                print(String(i))
            }
            timer.resume()
            return cancel
        }
    }
}
