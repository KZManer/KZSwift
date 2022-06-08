//
//  JuliangActiveHandler.swift
//  KZSwift
//
//  Created by KZ on 2022/6/7.
//

import Foundation
import KeychainAccess
import CryptoSwift
import Alamofire

class OceanEngineHandler {
    //网络返回类型
    enum HttpBackType: String {
        case success
        case failure
        case nonetwork
    }
    //事件类型
    enum EventType: String {
        case userActive = "1"//自定义新增激活
        case nextDayOpen = "2"//自定义次留激活
    }
    private let keychain = Keychain(service: "com.smart.story.zaowen")
    private let juliangActiveStatus = "juliangActiveStatus"
    private let juliangActiveDate = "juliangActiveDate"
    private let juliangNextDayOpenStatus = "juliangNextDayOpenStatus"
    private let AESKey = "6dd3e6ed9053adfa8c4744b0f65a419f"
    
    static let shared = OceanEngineHandler()
    private init() {}
    
    //触发激活事件
    func triggerActiveAction() {
        if let value = keychain[juliangActiveStatus] {
            KLog(message: "用户已经激活过了：\(value)")
            KLog(message: "将判断是否触发次留激活...")
            if let value2 = keychain[juliangNextDayOpenStatus] {
                KLog(message: "次留已经激活过了：\(value2)")
            } else {
                //次留激活事件
                nextDayOpenAction()
            }
        } else {
            //用户激活事件
            userActiveAction()
        }
    }
    //清除钥匙串内容
    func clearKeychainItem() {
        do {
            try keychain.remove(juliangActiveStatus)
            KLog(message: "用户激活状态-清空成功")
        } catch let error {
            KLog(message: "用户激活状态-清空失败：\(error)")
        }
        do {
            try keychain.remove(juliangNextDayOpenStatus)
            KLog(message: "次留激活状态-清空成功")
        } catch let error {
            KLog(message: "次留激活状态-清空失败：\(error)")
        }
        do {
            try keychain.remove(juliangActiveDate)
            KLog(message: "用户激活时间-清空成功")
        } catch let error {
            KLog(message: "用户激活时间-清空失败：\(error)")
        }
    }
    //MARK: - Private Method
    //用户激活事件
    private func userActiveAction() {
        KLog(message: "请求用户激活接口...")
        request(eventType: .userActive) { type, result in
            KLog(message: type)
            KLog(message: type.rawValue)
            KLog(message: result)
            if type == .success {
                KLog(message: "更新用户激活状态...")
                self.keychain[self.juliangActiveStatus] = "1"
                KLog(message: "用户激活了...")
                KLog(message: "保存用户激活的时间...")
                let activeTime = self.date_current()
                self.keychain[self.juliangActiveDate] = activeTime
                KLog(message: "用户激活的时间为：\(activeTime)")
            }
        }
    }
    //次留激活事件
    private func nextDayOpenAction() {
        guard let userActiveTime = keychain[juliangActiveDate] else {
            KLog(message: "未获取到用户激活时间，无法判断是否满足次留激活")
            return
        }
        let nowTime = date_current()
        KLog(message: "用户激活时间为：\(userActiveTime)")
        KLog(message: "触发激活的时间：\(nowTime)")
        KLog(message: "判断次留是否满足激活条件...")
        let interval = date_interval(start: userActiveTime, end: nowTime)
        if interval == 1 {
            KLog(message: "满足次留激活条件")
            KLog(message: "请求次留激活接口...")
            request(eventType: .nextDayOpen) { type, result in
                if type == .success {
                    KLog(message: "更新次留激活状态...")
                    self.keychain[self.juliangNextDayOpenStatus] = "1"
                    KLog(message: "次留激活了")
                }
            }
        } else {
            KLog(message: "不满足次留激活条件")
        }
    }
    //请求激活接口
    private func request(eventType: EventType, handler: @escaping (_ type: HttpBackType,_ result: Any) -> Void) {
        let networkManager = NetworkReachabilityManager()
        if networkManager?.isReachable == false {
            //没有网络
            handler(.nonetwork,"no network")
            return
        }
        let encoding: ParameterEncoding = JSONEncoding.default
        //时间戳
//        let timestamp = "\(Date.currentTimestamp)"
        let timestamp = "1654594021"
        
        //获取idfa
        let idfa = "KZZB1SOD-JFJE-5UIK-OX29-58QFG4Y33QO1"
        //AES256加密idfa
        guard let idfaAES = data_encode(original: idfa) else {
            KLog(message: "idfa加密失败")
            return
        }
        /**请求参数**/
        let parameters = [
            "idfa":idfaAES,//AES加密过的idfa
            "ts":timestamp,//时间戳
            "os":"1",//0:android 1:iPhone
            "pkg":Bundle.main.bundleIdentifier ?? "com.smart.story.zaowen",//bundle id
            "version":DeviceManager.app_version,//版本号
            "dataType":eventType.rawValue,//转化类型
        ] as [String : Any]
        
        /**签名**/
        let sortArr = ["idfa","ts","os","pkg","version","dataType"]
        let signatureBodyJson = customJson(sortArr: sortArr, sortDic: parameters)
        let signatureJson = """
                {"body":\(signatureBodyJson),"timestamp":"\(timestamp)"}
                """
        KLog(message: signatureJson)
        
//        let signatureDic = [
//            "body":parameters,
//            "timestamp":timestamp
//        ] as [String : Any]
//        guard let signatureData = try? JSONSerialization.data(withJSONObject: signatureDic, options: JSONSerialization.WritingOptions.init(rawValue: 0)) else {
//            KLog(message: "签名转data失败")
//            return
//        }
//        guard let signatureJson = String(data: signatureData, encoding: .utf8) else {
//            KLog(message: "签名-data转json失败")
//            return
//        }
//        KLog(message: "签名-json：\(signatureJson)")
//        let signatureMD5 = signatureJson.MD5Encrypt()
//        KLog(message: "签名-MD5：\(signatureMD5)")
        
        let signatureMD5 = signatureJson.MD5Encrypt()
        let headers: HTTPHeaders = [
            "signature":signatureMD5,
            "timestamp":timestamp
        ]
        KLog(message: parameters)
        KLog(message: headers)
        let urlString = "https://nav.jijia-co.com/api/nav/transform/data"
//        let urlString = JJ_Host + "api/nav/transform/data"
        AF.request(urlString,
                   method: .post,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers).responseJSON {
            response in
            switch response.result {
            case let .success(data):
                handler(.success,data)
                break
            case let .failure(error):
                KLog(message: error)
                handler(.failure,error)
                break
            }
        }
    }
    //拼接字符串
    private func customJson(sortArr: [String],sortDic: [String : Any]) -> String {
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
    //当前日期（年-月-日）
    private func date_current() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let string = formatter.string(from: now)
        return string
    }
    //两个日期间隔天数
    private func date_interval(start:String,end:String) -> Int {
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
    //string + AES加密 => base64
    func data_encode(original value: String) -> String? {
        
        guard let aes = try? AES(key: Array(AESKey.utf8), blockMode: ECB(), padding: .pkcs5) else {
            return nil
        }
        guard let encrypted = try? aes.encrypt(value.bytes) else {
            return nil
        }
        let encryptedBase64 = encrypted.toBase64()
        return encryptedBase64
    }
}
