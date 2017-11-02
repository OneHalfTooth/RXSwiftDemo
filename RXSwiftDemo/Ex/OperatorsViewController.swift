//
//  OperatorsViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/11/2.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OperatorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "操作符"
        self.view.backgroundColor = UIColor.white
        
        
        
        print("----------------只处理满足条件的事件-------------")
        Observable.of(1,2,3).asObservable().filter { (x) -> Bool in
            if x > 2  {
                return false
            }
            return true
            }.subscribe { (x) in
                print(x.element as Any)
        }.disposed(by: disposeBag)
        Observable.of(1,2,3,4,5).takeWhile{$0 < 3}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------过滤发出的连续相同事件-------------")
        /** 过去发出的相同事件 */
        Observable.of(1,2,3,3,3,2,2,3,2,5,4).distinctUntilChanged().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------只发出指定位置的事件-------------")
        Observable.of(1,2,3,5,4).elementAt(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        print("----------------检测是否只发送了一个元素-------------")
        Observable.of(1,2,3).single().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        Observable.of(1).single().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------检测是否唯一并发送元素-------------")
        /** 发送一个 $0 == "🐸" 的信号，如果有并且唯一 就发送，如果不唯一 或者没有  不发送 */
        Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
            .single { $0 == "🐸" }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
            .single { $0 == "🐒" }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.of("🐱", "🐰", "🐶", "🐶","🐸")
            .single { $0 == "🐶" }
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        
        print("----------------只处理  前take（4）个元素-------------")
        Observable.of(1,2,3).take(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------只处理  后take（3）个元素-------------")
        Observable.of(1,2,3,4,5,6).takeLast(3).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------orinSubject在refreSubject发出信号之后不再发送信号 -------------")
        let orinSubject = PublishSubject<Int>()
        let refreSubject = PublishSubject<Int>()
        
        orinSubject.takeUntil(refreSubject).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        orinSubject.onNext(1)
        orinSubject.onNext(2)
        refreSubject.onNext(10)
        orinSubject.onNext(3)
        
        
        
        
        print("----------------跳过前两个信号-------------")
        Observable.of(1,2,3,4,5,6).skip(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------跳过满足条件的信号-------------")
        Observable.of(1,2,3,4,5,6,7,8).skipWhile { (x) -> Bool in
            if x == 3 || x == 4 {
                return true
            }
            return false
            }.subscribe { (e) in
                print(e.element)
        }.disposed(by: disposeBag)
        
        print("----------------跳过索引满足条件的信号-------------")
        Observable.of(1,2,3,4,5,6).skipWhileWithIndex({ (element, index) -> Bool in
            index < 3
        }).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        print("----------------跳过另一个refreSubject1序列发出事件之前的所有事件。与takeUntil相反。-------------")
        let oriSubject1 = PublishSubject<Int>()
        let refreSubject1 = PublishSubject<Int>()
        
        oriSubject1.skipUntil(refreSubject1).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        oriSubject1.onNext(1)
        oriSubject1.onNext(2)
        
        refreSubject1.onNext(10)
        oriSubject1.onNext(3)
        oriSubject1.onNext(4)
        
        print("----------------将序列转化成一个数组-------------")
        Observable.of(1,2,3,4,5).toArray().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        print("----------------使用一个初始值，对序列进行累计计算，map不累计-------------")
        Observable.of(1,10,100).reduce(2, accumulator: *).subscribe(onNext: {print($0)}).addDisposableTo(disposeBag)
    }
    
    
    
}
