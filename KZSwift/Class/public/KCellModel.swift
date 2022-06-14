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
        case direction
    }
    
    var kTitle: String!
    var kId   : ModelId!
    var kStrId: String!
    var kVC   : RootHomeVC?
    
    init(_ title: String,_ id: ModelId,_ toVC: RootHomeVC?) {
        super.init()
        self.kTitle = title
        self.kId    = id
        self.kVC    = toVC
    }
    init(title: String, strId: String) {
        super.init()
        self.kTitle = title
        self.kStrId = strId
    }
    //daily module source
    static func dailyInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("导航栏", .navigationBar, DNavigationBarVC()),
            .init("加载动画", .loadingAnimation, ShimmerVC()),
            .init("空白页面占位", .placeholder, HintVC()),
            .init("WKWebView", .wkwebview, WebViewVC()),
            .init("黑魔法之方法交换", .methodSwizzling, MethodSwizzlingVC()),
            .init("不规则图形", .shape, ShapeVC()),
            .init("日期判断", .date, nil),
            .init("系统字体", .systemFont, SystemFontVC()),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
    //3rd library source
    static func thirdLibInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("3rd-DZNEmptyDataSet", .DZNEmptyDataSet, DZNEmptyDataVC()),
            .init("3rd-KeychainAccess", .KeychainAccess, KeychainVC()),
            .init("3rd-Alamofire", .Alamofire, AlamofireVC()),
            .init("3rd-SwiftyJSON", .SwiftyJSON, SwiftyJSONVC()),
            .init("3rd-JXSegmentedView", .JXSegmentedView, JXSegmentedVC()),
            .init("3rd-SPPageMenu", .SPPageMenu, SPPageMenuVC()),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
    //per-writing module source
    static func projectInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("激活逻辑", .active, ActiveVC()),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
    //test module source
    static func testInfos() -> Array<KCellModel> {
        let arr:[KCellModel] = [
            .init("手机方向", .direction, DirectionVC()),
        ]
        return arr.sorted(){$0.kTitle < $1.kTitle}
    }
}
