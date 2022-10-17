//
//  FMDBVC.swift
//  KZSwift
//
//  Created by J+ on 2022/10/9.
//

import UIKit
import FMDB

class FMDBVC: RootHomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        doViewUI()
        createDatabase()
    }
    
    private func doViewUI() {
        let templateView = TemplateView(frame: self.view.frame, titles: ["创建数据库","创建表"], column: 2)
        templateView.delegate = self
        self.view.addSubview(templateView)
    }
    
    //创建数据库
    private func createDatabase() {
        guard var dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        KLog(message: dbPath)
        dbPath = dbPath + "/test.sqlite"
        KLog(message: dbPath)
        let db = FMDatabase(path: dbPath)
        if db.open() {
            KLog(message: "open")
        } else {
            KLog(message: "close")
        }
    }
}
extension FMDBVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        KLog(message: index)
        KLog(message: title)
    }
}
