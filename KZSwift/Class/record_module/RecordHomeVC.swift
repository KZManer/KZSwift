//
//  RecordHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit

class YLDConfigInfo: NSObject {
    var videoId: String? //视频id(未用）
    var listAdId: String? //列表插入广告位id
    var listAdInsertRules: [Int]? //列表插入广告的插入规则
    var videoInterstitialAdId: String? //视频插屏广告
    var videoBottomAdId: String? //视频底部广告id
    
    var floatFeedAdId: String? //底部悬浮Feed广告位id
    var floatBannerAdId: String? //底部悬浮Banner广告id
    var floatAdType: String? //底部悬浮广告类型，取值“feed”或“banner”
    var floatAdDelay: Int = 0 //底部悬浮延迟时间 单位秒（延迟多少秒之后再请求底部悬浮广告）
    var floatAdAutoHide: Bool = false //底部悬浮广告上滑消失开关，1开 0关
    
    var size: Int = 20 //一次请求推荐条数，不配默认20
}

class RecordHomeVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.testInfos()
    }
    var titles: [String] {
        return infos.map() { $0.kTitle ?? "" }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let mainView = MainView(frame: minViewFrame, source: titles)
        mainView.delegate = self
        self.view.addSubview(mainView)
        
        let string = "smartapp://smartinfo/customdetail?video_id=W5ZbQO3nLr5O&float_banner_ad_id=F718&float_ad_type=banner&list_ad_id=E717&list_ad_pos=%5B0%2C1%2C2%2C3%2C4%2C5%2C6%2C7%2C8%2C9%2C10%2C11%2C12%2C13%2C14%2C15%2C16%2C17%2C18%2C19%2C20%5D&v_middle_ad_id=E715&v_bottom_ad_id=E716&size=20&float_ad_delay=3&ad_auto_hide_show=0"
        
        
        var string1 = "[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]"
        string1.removeFirst()
        string1.removeLast()
        KLog(message: string1)
        
        if let url = URL(string: string) {
            if let parameters = url.parametersFromQueryString {
                let configInfo = YLDConfigInfo()
                configInfo.videoId = parameters["video_id"]
                configInfo.listAdId = parameters["list_ad_id"]
                let adInsertRules = parameters["list_ad_pos"]
                if var value = adInsertRules, value.count > 1 {
                    value.removeFirst()
                    value.removeLast()
                    configInfo.listAdInsertRules = value.components(separatedBy: ",").map{ Int($0) ?? -1 }
                }
                configInfo.videoInterstitialAdId = parameters["v_middle_ad_id"]
                configInfo.videoBottomAdId = parameters["v_bottom_ad_id"]
                configInfo.floatFeedAdId = parameters["float_ad_id"]
                configInfo.floatBannerAdId = parameters["float_banner_ad_id"]
                configInfo.floatAdType = parameters["float_ad_type"]
                if let fad = parameters["float_ad_delay"], let fadInt = Int(fad) {
                    configInfo.floatAdDelay = fadInt
                }
                if let aahs = parameters["ad_auto_hide_show"], aahs == "1" {
                    configInfo.floatAdAutoHide = true
                }
                if let size = parameters["size"], let sizeInt = Int(size) {
                    configInfo.size = sizeInt
                }
                KLog(message: parameters)
                KLog(message: "")
            }
        }
        
        
        
        
    }
    //MARK: Custom Method
    func doNavUI() {
        let titleIV = UIImageView(image: UIImage(named: "nav_logo3"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }
}
extension RecordHomeVC: MainViewDelegate {
    func dg_didSelectRowAt(index: Int) {
        let cellInfo = self.infos[index]
        
        guard let cls = cellInfo.kCls else {
            self.view.makeToast("未找到对应的ViewController")
            return
        }
        let toVC = cls.init()
        toVC.hidesBottomBarWhenPushed = true
        toVC.title = cellInfo.kTitle
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
