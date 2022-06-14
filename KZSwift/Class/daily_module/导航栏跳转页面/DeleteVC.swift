//
//  DeleteVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit

class DeleteVC: RootHomeVC {
    
    var callBack:((String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        //循环引用导致无法释放
        printString { text in
            self.view.backgroundColor = .orange
        }
    }
    
    func printString(callback: @escaping (String)->()) {
        callback("this closure back some words")
        self.callBack = callback
    }
    deinit {
        KLog(message: "DeleteVC 释放了")
    }
}
