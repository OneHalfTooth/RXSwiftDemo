//
//  SubjectViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/11/2.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SubjectViewController: UIViewController {

    let subject = PublishSubject<Int>()
    
    /** 补发上一个信号 */
    let replaySubject = ReplaySubject<Int>.create(bufferSize: 1)
    /** 补发所有信号 */
//    let replaySubject = ReplaySubject<Int>.createUnbounded()
    
    let behaviorSubject = BehaviorSubject<Int>.init(value: 99999999)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Subject的使用"
        self.view.backgroundColor = UIColor.white
        
        self.createView()
    }
    
    func createView() -> Void {
        
        self.createShowLable()
        self.createPublishSubjectButton()
        self.createReveseSubject()
        self.createReplaySubjectButton()
        self.createBehaviorSubject()
    }
    
    func createShowLable() -> Void {
        
        let showLabel = UILabel.init()
        showLabel.textAlignment = .center
        self.view.addSubview(showLabel)
        showLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(20)
            make.top.equalTo(150)
        }
        
        self.subject.map { (x) -> String in
            return "发送的信号为\(x)"
        }.bind(to: showLabel.rx.text).disposed(by: disposeBag)
    }
    
    func createBehaviorSubject() -> Void {
        
        let behaviorSubjectButton = UIButton.init(type: .custom)
        behaviorSubjectButton.setTitle("默认信号", for: .normal)
        behaviorSubjectButton.backgroundColor = UIColor.blue
        self.view.addSubview(behaviorSubjectButton)
        behaviorSubjectButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(44)
            make.top.equalTo(320)
        }
        behaviorSubjectButton.rx.tap.subscribe { (x) in
            
            self.behaviorSubject.subscribe({ (e) in
                 print(e.element)
            }).disposed(by: disposeBag)
            
            self.behaviorSubject.on(Event.next(1234))
        }.disposed(by: disposeBag)
    }
    
    /** 信号补发 */
    func createReplaySubjectButton() -> Void{
        let replayButton = UIButton.init(type: .custom)
        replayButton.setTitle("信号补发", for: .normal)
        replayButton.backgroundColor = UIColor.blue
        self.view.addSubview(replayButton)
        replayButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(44)
            make.top.equalTo(320)
        }
        replayButton.rx.tap.subscribe { (x) in
            
            self.replaySubject.onNext(1)
            self.replaySubject.onNext(2)
            self.replaySubject.onNext(3)
            self.replaySubject.onNext(4)
            self.replaySubject.onNext(5)
            self.replaySubject.onNext(6)
            self.replaySubject.onNext(7)
            self.replaySubject.onNext(8)
            
            self.replaySubject.subscribe({ (e) in
                print(e.element)
            }).disposed(by: disposeBag)
            
        }.disposed(by: disposeBag)
    }
    
    /** 信号转发 */
    func createReveseSubject() -> Void {
        
        let button = UIButton.init(type: .custom)
        button.setTitle("信号转发", for: .normal)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(44)
            make.top.equalTo(264)
        }
        button.rx.tap.subscribe { (x) in
            
            let reveseSubject = Observable<Int>.create({ (o) -> Disposable in
                
                o.onNext(Int(arc4random() % 100000))
                return Disposables.create()
            })
            reveseSubject.subscribe(self.subject).disposed(by: disposeBag)
            
        }.disposed(by: disposeBag)
        
        
    }
    
    func createPublishSubjectButton() -> Void {
        
        let button = UIButton.init(type: .custom)
        button.setTitle("PublishSubject发送信号", for: .normal)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(44)
            make.top.equalTo(200)
        }
        var i = 0
        button.rx.tap.subscribe { (x) in
            i += 1
            self.subject.onNext(i)
//            self.subject.onCompleted()
        }.disposed(by: disposeBag)
        
    }
}
