//
//  KCellModel.swift
//  KZSwift
//
//  Created by KZ on 2022/5/23.
//

import UIKit

class KCellModel: NSObject {
    
    enum ModelId {
        case navigationBar,loadingAnimation,placeholder,wkwebview,methodSwizzling,shape,date,systemFont
        case DZNEmptyDataSet,KeychainAccess,Alamofire,SwiftyJSON,JXSegmentedView,SPPageMenu
        case active
        case direction,cycle,timer
    }
    
    var kTitle: String!
    var kId   : ModelId!
    var kStrId: String!
    var kCls  : RootHomeVC.Type?
    
    init(_ title: String,_ id: ModelId,_ cls: RootHomeVC.Type?) {
        super.init()
        self.kTitle = title
        self.kId    = id
        self.kCls   = cls
    }
    init(title: String, strId: String) {
        super.init()
        self.kTitle = title
        self.kStrId = strId
    }
    //daily module source
    static func dailyInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("导航栏", .navigationBar, DNavigationBarVC.self),
            .init("加载动画", .loadingAnimation, ShimmerVC.self),
            .init("空白页面占位", .placeholder, HintVC.self),
            .init("WKWebView", .wkwebview, WebViewVC.self),
            .init("黑魔法之方法交换", .methodSwizzling, MethodSwizzlingVC.self),
            .init("不规则图形", .shape, ShapeVC.self),
            .init("日期判断", .date, nil),
            .init("系统字体", .systemFont, SystemFontVC.self),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
    //3rd library source
    static func thirdLibInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("3rd-DZNEmptyDataSet", .DZNEmptyDataSet, DZNEmptyDataVC.self),
            .init("3rd-KeychainAccess", .KeychainAccess, KeychainVC.self),
            .init("3rd-Alamofire", .Alamofire, AlamofireVC.self),
            .init("3rd-SwiftyJSON", .SwiftyJSON, SwiftyJSONVC.self),
            .init("3rd-JXSegmentedView", .JXSegmentedView, JXSegmentedVC.self),
            .init("3rd-SPPageMenu", .SPPageMenu, SPPageMenuVC.self),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
    //per-writing module source
    static func projectInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("激活逻辑", .active, ActiveVC.self),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
    //record module source
    static func testInfos() -> Array<KCellModel> {
        
        let arr:[KCellModel] = [
            .init("手机方向", .direction, DirectionVC.self),
            .init("循环引用问题", .cycle, CycleVC.self),
            .init("定时器", .timer, TimerVC.self),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
}
