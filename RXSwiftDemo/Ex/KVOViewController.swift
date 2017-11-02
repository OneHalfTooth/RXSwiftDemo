//
//  KVOViewController.swift
//  RXSwiftDemo
//
//  Created by 马扬 on 2017/10/20.
//  Copyright © 2017年 mayang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class KVOViewController: UIViewController {

    
    @objc dynamic var racNumber = ""
    
    @objc dynamic let racView = UIView()
    
    var timer : DispatchSourceTimer? = nil
    
    let showLabel = UILabel()
    
    let frameShowLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "KVO"
        self.view.backgroundColor = UIColor.white
        
        
        
        self.createView()
        self.createAction()
        self.racChange()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.cancel()
    }
    
    func createAction() -> Void {
        
        self.rx.observe(String.self, "racNumber").filter({ (x) -> Bool in
            if x == nil {
                return false
            }
            return true
        }).map({ (x) -> String in
            return "变量的随机值为:\(x!)"
        }).bind(to: self.showLabel.rx.text).disposed(by: disposeBag)
        
        
        
        /** 因为swift对runtime支持不够友好，所以racView 添加 @objc dynamic  也无法让frame 成为动态属性，所以观察者无效 */
        self.rx.observe(CGRect.self, "racView.frame").map({ (x) -> String in
            return "view的frame为 width:\(String(describing: x?.size.width)),height:\(String(describing: x?.size.height))String(describing: x?.origin.x)String(describing: x?.origin.y)"
        }).bind(to: self.frameShowLabel.rx.text).disposed(by: disposeBag)
    }
    
    func createView() -> Void {
        self.view.addSubview(self.racView)
        self.racView.backgroundColor = UIColor.red
        self.racView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        self.view.addSubview(self.showLabel)
        self.showLabel.textAlignment = .center
        self.showLabel.numberOfLines = 0
        self.showLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(2)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(104)
        }
        
        
        self.view.addSubview(self.frameShowLabel)
        self.frameShowLabel.textAlignment = .center
        self.frameShowLabel.numberOfLines = 0
        self.frameShowLabel.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(2)
            make.left.equalTo(self.showLabel)
            make.right.equalTo(self.showLabel)
            make.top.equalTo(self.showLabel.snp.bottom).offset(30)
        }
    }
    
    func racChange() -> Void {
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: 1)
        
        timer.setEventHandler {
            self.racNumber = String(arc4random() % 100000000)
            
            let height = CGFloat(arc4random() % 200)
            let width = CGFloat(arc4random() % 200)
            self.racView.snp.updateConstraints({ (make) in
                make.height.equalTo(height)
                make.width.equalTo(width)
            })
        }
        
        timer.resume()
        self.timer = timer
    }
}
