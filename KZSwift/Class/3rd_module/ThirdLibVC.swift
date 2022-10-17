//
//  ThirdLibVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit
import CoreTelephony

class ThirdLibVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.thirdLibInfos()
    }
    var titles: [String] {
        return infos.map() { $0.kTitle ?? "" }
    }
    //MARK: Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let mainView = MainView(frame: minViewFrame, source: titles)
        mainView.delegate = self
        self.view.addSubview(mainView)
        
        
        let info = CTTelephonyNetworkInfo()
        if let dic = info.serviceSubscriberCellularProviders,
           let key = dic.keys.first,
           let carrier = dic[key] {
            //运营商是否可用
            let use = carrier.allowsVOIP
            //运营商名称 ex:中国移动
            let name = carrier.carrierName
            //ISO国家代码 ex:cn
            let code = carrier.isoCountryCode
            //移动国家代码 ex:460
            let mcc = carrier.mobileCountryCode
            //移动网络代码 ex:02
            let mnc = carrier.mobileNetworkCode
            KLog(message: "\(use) - \(name) - \(code) - \(mcc) - \(mnc)")
        }
        
        
    }
    
    //MARK: Custom Method
    func doNavUI() {
        let titleIV = UIImageView(image: UIImage(named: "nav_logo2"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }

}
extension ThirdLibVC: MainViewDelegate {
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
