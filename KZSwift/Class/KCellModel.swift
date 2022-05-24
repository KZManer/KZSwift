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
            .init(title: "WKWebView", id: "wkwebview"),
            .init(title: "黑魔法之方法交换", id:"methodSwizzling"),
        ]
    }
}
