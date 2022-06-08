//
//  KCellModel.swift
//  KZSwift
//
//  Created by KZ on 2022/5/23.
//

import UIKit

class KCellModel: NSObject {
    var kTitle: String!
    var kId   : String!
    
    init(title: String,id: String) {
        super.init()
        self.kTitle = title
        self.kId    = id
    }
    
    static func dailyInfos() -> Array<KCellModel> {
        return [
            .init(title: "导航栏", id: "navigationBar"),
            .init(title: "加载动画", id: "loadingAnimation"),
            .init(title: "空白页面占位", id: "placeholder"),
            .init(title: "WKWebView", id: "wkwebview"),
            .init(title: "黑魔法之方法交换", id:"methodSwizzling"),
            .init(title: "不规则图形", id: "shape"),
            .init(title: "日期判断", id: "date"),
            .init(title: "3rd-DZNEmptyDataSet", id: "DZNEmptyDataSet"),
            .init(title: "3rd-KeychainAccess", id: "KeychainAccess"),
        ]
    }
    
    static func projectInfos() -> Array<KCellModel> {
        return [
            .init(title: "激活逻辑", id: "active"),
        ]
    }
}
