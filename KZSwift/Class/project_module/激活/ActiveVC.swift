//
//  ActiveVC.swift
//  KZSwift
//
//  Created by KZ on 2022/6/6.
//

import UIKit
import CryptoSwift
import SwiftyJSON

class ActiveVC: RootHomeVC {
    
    @objc func injected() {
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let templateView = TemplateView(frame: maxViewFrame, titles: [
            "触发激活事件","打印日期间隔天数","打印当前日期","参数拼接1"
        ])
        templateView.delegate = self
        self.view.addSubview(templateView)
    }
    private func doNavUI() {
        let clearItem = UIBarButtonItem(title: "清空激活状态", style: .plain, target: self, action: #selector(clearItemAction))
        self.navigationItem.rightBarButtonItems = [clearItem]
    }
    //清空keychain item
    @objc func clearItemAction() {
        OceanEngineHandler.shared.clearKeychainItem()
    }
    //button1 action
    func button1Action() {
        OceanEngineHandler.shared.triggerActiveAction()
    }
    //button2 action
    func button2Action() {
        let a = dateInterval(start: "2022-06-07", end: "2022-06-07")
        KLog(message: a)
    }
    //button3 action
    func button3Action() {
        KLog(message: date_current())
    }
    //button4 action
    func button4Action() {
        let idfa = "KZZB1SOD-JFJE-5UIK-OX29-58QFG4Y33QO1"
        guard let idfaAES = idfa.aesEncode() else {
            KLog(message: "idfa加密失败")
            return }
        
        let timestamp = "1654594021"
        let param = [
            "idfa":idfaAES,
            "ts":timestamp,
            "os":"1",
            "pkg":Bundle.main.bundleIdentifier ?? "com.aa",
            "version":DeviceManager.app_version,
            "dataType":"1"
        ] as [String: Any]
        
        signature(parameters: param, timestamp: timestamp)
    }
    
    func signature(parameters: [String: Any], timestamp: String) {
        
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
        let jsonStr2 = String(data: data!, encoding: .utf8) ?? ""
        KLog(message: jsonStr)
        KLog(message: jsonStr2)
    }
    
    func convertDictionaryToJSONString(dict:[String: Any]?)->String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
}
extension ActiveVC {
    func date_current() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let string = formatter.string(from: now)
        return string
    }
    func dateInterval(start:String,end:String) -> Int {
        let dateFormatter = DateFormatter()
        KLog(message: TimeZone.current)
        //设置为本地时间
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        KLog(message: dateFormatter.date(from: start))
        KLog(message: dateFormatter.date(from: end))
        guard let startDate = dateFormatter.date(from: start),
                let endDate = dateFormatter.date(from: end) else { return -1 }
        let components = NSCalendar.current.dateComponents([.day], from: startDate,to: endDate)
        return components.day!
    }
}

extension ActiveVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        switch index {
        case 0:
            self.button1Action()
        case 1:
            self.button2Action()
        case 2:
            self.button3Action()
        case 3:
            self.button4Action()
        default: break
        }
    }
}
