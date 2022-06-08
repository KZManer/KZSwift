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
        doViewUI()
    }
    private func doNavUI() {
        let clearItem = UIBarButtonItem(title: "清空激活状态", style: .plain, target: self, action: #selector(clearItemAction))
        self.navigationItem.rightBarButtonItems = [clearItem]
    }
    private func doViewUI() {
        
        let activeBtn = UIButton(type: .custom)
        activeBtn.setTitle("触发激活事件", for: .normal)
        activeBtn.setTitleColor(.white, for: .normal)
        activeBtn.backgroundColor = .darkGray
        activeBtn.addTarget(self, action: #selector(pressedActiveBtn), for: .touchUpInside)
        self.view.addSubview(activeBtn)
        activeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
        let intervalBtn = UIButton(type: .custom)
        intervalBtn.setTitle("打印日期间隔天数", for: .normal)
        intervalBtn.setTitleColor(.white, for: .normal)
        intervalBtn.backgroundColor = .darkGray
        intervalBtn.addTarget(self, action: #selector(pressedIntervalBtn), for: .touchUpInside)
        self.view.addSubview(intervalBtn)
        intervalBtn.snp.makeConstraints { make in
            make.top.equalTo(activeBtn.snp.bottom).offset(50)
            make.height.equalTo(40)
            make.width.equalTo(activeBtn)
            make.centerX.equalToSuperview()
        }
        
        let printBtn = UIButton(type: .custom)
        printBtn.setTitle("打印当前日期", for: .normal)
        printBtn.setTitleColor(.white, for: .normal)
        printBtn.backgroundColor = .darkGray
        printBtn.addTarget(self, action: #selector(pressedPrintBtn), for: .touchUpInside)
        self.view.addSubview(printBtn)
        printBtn.snp.makeConstraints { make in
            make.top.equalTo(intervalBtn.snp.bottom).offset(50)
            make.centerX.width.height.equalTo(intervalBtn)
        }
        
        let paramBtn = UIButton(type: .custom)
        paramBtn.setTitle("参数拼接1", for: .normal)
        paramBtn.setTitleColor(.white, for: .normal)
        paramBtn.backgroundColor = .darkGray
        paramBtn.addTarget(self, action: #selector(pressedParamBtn), for: .touchUpInside)
        self.view.addSubview(paramBtn)
        paramBtn.snp.makeConstraints { make in
            make.top.equalTo(printBtn.snp.bottom).offset(50)
            make.centerX.width.height.equalTo(intervalBtn)
        }
        
        let paramBtn2 = UIButton(type: .custom)
        paramBtn2.setTitle("参数拼接2", for: .normal)
        paramBtn2.setTitleColor(.white, for: .normal)
        paramBtn2.backgroundColor = .darkGray
        paramBtn2.addTarget(self, action: #selector(pressedParamBtn2), for: .touchUpInside)
        self.view.addSubview(paramBtn2)
        paramBtn2.snp.makeConstraints { make in
            make.top.equalTo(paramBtn.snp.bottom).offset(50)
            make.centerX.width.height.equalTo(intervalBtn)
        }
    }
    //清空keychain item
    @objc func clearItemAction() {
        OceanEngineHandler.shared.clearKeychainItem()
    }
    //点击触发激活事件按钮
    @objc func pressedActiveBtn() {
        OceanEngineHandler.shared.triggerActiveAction()
    }
    //点击保存按钮
    @objc func pressedIntervalBtn() {
        let a = dateInterval(start: "2022-06-07", end: "2022-06-07")
        KLog(message: a)
    }
    //点击打印按钮
    @objc func pressedPrintBtn() {
        KLog(message: date_current())
    }
    //点击拼接参数1按钮
    @objc func pressedParamBtn() {
//        let idfa = generateRandomString()
        let idfa = "KZZB1SOD-JFJE-5UIK-OX29-58QFG4Y33QO1"
//        KLog(message: idfa)
        guard let idfaAES = OceanEngineHandler.shared.data_encode(original: idfa) else {
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
        KLog(message: parameters)
        
//        let sortArr = ["dataType","idfa","os","pkg","ts","version"]
        let sortArr = ["ts","dataType","idfa","version","os","pkg"]
        let jsona = customJson(sortArr: sortArr, sortDic: parameters)
        KLog(message: jsona)
        KLog(message: jsona.MD5Encrypt())
        
        let signatureDic = [
            "body": jsona,
            "timestamp":timestamp
        ] as [String : Any]
        //signature
        //timestamp
        let signatureJson = customJson(sortArr: ["signature","timestamp"], sortDic: signatureDic)
        let sigJson =  """
                {"body":\(jsona),"timestamp":"\(timestamp)"}
                """
        KLog(message: sigJson)
        
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.init(rawValue: 0))
//        let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
        let jsonStr2 = String(data: data!, encoding: .utf8) ?? ""
        KLog(message: jsonStr)
        KLog(message: jsonStr2)
        KLog(message: jsonStr.MD5Encrypt())
        KLog(message: jsonStr2.MD5Encrypt())
        let test = """
                        {"ts":"1654594021","dataType":"1","idfa":"kqKM8XaHA36s42N/VIXcJE23WIDlOY5/O9SXsqYSsZdno5OhLkdk0g1AbEZ8AwZ/","version":"1.0.0","os":"1","pkg":"com.ghostshadow.KZSwift"}
                """
        KLog(message: test)
        KLog(message: test.MD5Encrypt())
        let keyk = """
                        {"ts":"1654594021","dataType":"1","idfa":"kqKM8XaHA36s42N/VIXcJE23WIDlOY5/O9SXsqYSsZdno5OhLkdk0g1AbEZ8AwZ/","version":"1.0.0","os":"1","pkg":"com.ghostshadow.KZSwift"}
                """
        KLog(message: keyk.MD5Encrypt())
        //{"ts":"1654594021","dataType":"1","idfa":"kqKM8XaHA36s42N\/VIXcJE23WIDlOY5\/O9SXsqYSsZdno5OhLkdk0g1AbEZ8AwZ\/","version":"1.0.0","os":"1","pkg":"com.ghostshadow.KZSwift"}
//6f06d85e031f7133bf177579deefa5dd
    }

    func customJson(sortArr: [String],sortDic: [String : Any]) -> String {
        var json = "{"
        for item in sortArr {
            if let value = sortDic[item] as? String {
                json += """
                "\(item)":"\(value)",
                """
            }
        }
        json.removeLast()
        json += "}"
        
        return json
    }
    
    //点击拼接参数2按钮
    @objc func pressedParamBtn2() {
////        let idfa = generateRandomString()
//        let idfa = "KZZB1SOD-JFJE-5UIK-OX29-58QFG4Y33QO1"
////        KLog(message: idfa)
//        guard let idfaAES = OceanEngineHandler.shared.data_encode(original: idfa) else {
//            KLog(message: "idfa加密失败")
//            return }
//        let timestamp = "1654594021"
//        let param = [
//            "idfa":idfaAES,
//            "ts":timestamp,
//            "os":"1",
//            "pkg":Bundle.main.bundleIdentifier ?? "com.aa",
//            "version":DeviceManager.app_version,
//            "dataType":"1"
//        ] as [String: Any]
//
//        signature(parameters: param, timestamp: timestamp)
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
    //模拟idfa，随机生成一个
    func generateRandomString() -> String {
        let arr = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        var string = ""
        //FD16D423-FCE2-4902-8B8D-F273BA155473
        for i in 0...35 {
            if [8,13,18,23].contains(i) {
                string += "-"
            } else {
                let randomIndex = Int(arc4random_uniform(36))
                let ch = arr[randomIndex]
                string += ch
            }
        }
        return string
    }
}

