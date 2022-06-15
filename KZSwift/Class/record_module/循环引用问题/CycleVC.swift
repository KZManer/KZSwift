//
//  CycleVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/15.
//

import UIKit

class CycleVC: RootHomeVC {
    var callBack:((String) -> ())?
    
    deinit {
        KLog(message: "CycleVC 释放了")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "看代码"
        //1、循环引用导致无法释放
        printString { text in
            self.view.backgroundColor = .orange
        }
        //2、解决循环引用-A
//        weak var wself = self
//        printString { text in
//            wself?.view.backgroundColor = .lightGray
//        }
        //2、解决循环引用-B
//        printString { [weak self] text in
//            self?.view.backgroundColor = .purple
//        }
    }
    
    func printString(callback: @escaping (String)->()) {
        callback("this closure back some words")
        self.callBack = callback
    }
    
}
