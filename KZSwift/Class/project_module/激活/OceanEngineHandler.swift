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
import AdSupport

class OceanEngineHandler {
    //网络返回类型
    enum HttpBackType: String {
        case success
        case failure
        case nonetwork
    }
    //事件类型
    enum EventType: String {
        case userActive  = "1"//自定义新增激活
        case nextDayOpen = "2"//自定义次留激活
    }
    //埋点元组类型（成功的话根据后台返回数据拼接进元组，其他情况自定义code和message）
    enum EventTuple {
        case unknown
        case failure
        case nonetwork
        var tuple: (code: String, message: String) {
            switch self {
            case .unknown:
                return ("-3","未知错误")
            case .failure:
                return ("-1","请求失败")
            case .nonetwork:
                return ("-2","无网络")
            }
        }
    }
    //注册钥匙串服务
    private let keychain = Keychain(service: "com.ghostshadow.KZSwift")
    //钥匙串中用户激活状态的key
    private let juliangActiveStatus = "juliangActiveStatus"
    //钥匙串中用户激活的日期（年-月-日）
    private let juliangActiveDate = "juliangActiveDate"
    //钥匙串中次流激活状态的key
    private let juliangNextDayOpenStatus = "juliangNextDayOpenStatus"
    private var idfa: String  {
        let value = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if value != "00000000-0000-0000-0000-000000000000" {
            return value
        } else {
//            return ""//未获取到idfa
            return String.randomIDFA()
        }
    }
    
    static let shared = OceanEngineHandler()
    private init() {}
    
    //触发激活事件
    func triggerActiveAction() {
        KLog(message: "触发激活事件")
        if idfa.isEmpty {
            KLog(message: "未获取到idfa")
            return
        }
        KLog(message: idfa)
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
    func clearKeychainItem() -> Bool {
        var isClear = true
        do {
            try keychain.remove(juliangActiveStatus)
            KLog(message: "用户激活状态-清空成功")
        } catch let error {
            KLog(message: "用户激活状态-清空失败：\(error)")
            isClear = false
        }
        do {
            try keychain.remove(juliangNextDayOpenStatus)
            KLog(message: "次留激活状态-清空成功")
        } catch let error {
            KLog(message: "次留激活状态-清空失败：\(error)")
            isClear = false
        }
        do {
            try keychain.remove(juliangActiveDate)
            KLog(message: "用户激活时间-清空成功")
        } catch let error {
            KLog(message: "用户激活时间-清空失败：\(error)")
            isClear = false
        }
        return isClear
    }
    //MARK: - Private Method
    //用户激活事件
    private func userActiveAction() {
        KLog(message: "请求用户激活接口...")
        request(eventType: .userActive) { type, result in
            KLog(message: type)
            KLog(message: type.rawValue)
            KLog(message: result)
            var tuple = EventTuple.unknown.tuple
            if type == .success {
                guard let dic = result as? Dictionary<String, Any>,
                      let code = dic["code"] as? Int else { return }
                if code == 0 {
                    KLog(message: "更新用户激活状态...")
                    self.keychain[self.juliangActiveStatus] = "1"
                    KLog(message: "用户激活了...")
                    KLog(message: "保存用户激活的时间...")
                    let activeTime = self.date_current()
                    self.keychain[self.juliangActiveDate] = activeTime
                    KLog(message: "用户激活的时间为：\(activeTime)")
                } else {
                    KLog(message: "用户激活失败")
                }
                tuple = ("\(code)",dic["message"] as? String ?? "no message")
            } else if type == .failure {
                tuple = EventTuple.failure.tuple
            } else if type == .nonetwork {
                tuple = EventTuple.nonetwork.tuple
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
            var tuple = EventTuple.unknown.tuple
            request(eventType: .nextDayOpen) { type, result in
                if type == .success {
                    guard let dic = result as? Dictionary<String, Any>,
                          let code = dic["code"] as? Int else { return }
                    if code == 0 {
                        KLog(message: "更新次留激活状态...")
                        self.keychain[self.juliangNextDayOpenStatus] = "1"
                        KLog(message: "次留激活了")
                    } else {
                        KLog(message: "次留激活失败")
                    }
                    tuple = ("\(code)",dic["message"] as? String ?? "no message")
                } else if type == .failure {
                    tuple = EventTuple.failure.tuple
                } else if type == .nonetwork {
                    tuple = EventTuple.nonetwork.tuple
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
        //时间戳
        let timestamp = "\(Date.currentTimestamp)"
        //获取idfa
        let idfa = self.idfa
        //AES256加密idfa
        guard let idfaAES = idfa.aesEncode() else {
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
        guard let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
              let bodyJson = String(data: bodyData, encoding: .utf8) else { return }
        let signatureJson = "\(bodyJson)\(timestamp)"
        let signatureMD5 = signatureJson.MD5Encrypt()
        /**设置请求头**/
        let headers: HTTPHeaders = [
            "signature":signatureMD5,
            "timestamp":timestamp
        ]
        KLog(message: signatureMD5)
        KLog(message: timestamp)
        KLog(message: bodyJson)
        let urlString = "http://localhost/api/nav/transform/data"
        guard var request = try? URLRequest(url: urlString, method: .post, headers: headers) else { return }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = bodyData
        
        AF.request(request).responseJSON { response in
            KLog(message: response)
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
}



////
////  JuliangActiveHandler.swift
////  KZSwift
////
////  Created by KZ on 2022/6/7.
////
//
//import Foundation
//import KeychainAccess
//import CryptoSwift
//import Alamofire
//
//class OceanEngineHandler {
//    //网络返回类型
//    enum HttpBackType: String {
//        case success
//        case failure
//        case nonetwork
//    }
//    //事件类型
//    enum EventType: String {
//        case userActive = "1"//自定义新增激活
//        case nextDayOpen = "2"//自定义次留激活
//    }
//    private let keychain = Keychain(service: "com.ghostshadow.KZSwift")
//    private let juliangActiveStatus = "activeStatus"
//    private let juliangActiveDate = "activeDate"
//    private let juliangNextDayOpenStatus = "nextDayOpenStatus"
//    private let AESKey = "abjhkkk34hkij5khslk23juhbvn2323"
//
//    static let shared = OceanEngineHandler()
//    private init() {}
//
//    //触发激活事件
//    func triggerActiveAction() {
//        if let value = keychain[juliangActiveStatus] {
//            KLog(message: "用户已经激活过了：\(value)")
//            KLog(message: "将判断是否触发次留激活...")
//            if let value2 = keychain[juliangNextDayOpenStatus] {
//                KLog(message: "次留已经激活过了：\(value2)")
//            } else {
//                //次留激活事件
//                nextDayOpenAction()
//            }
//        } else {
//            //用户激活事件
//            userActiveAction()
//        }
//    }
//    //清除钥匙串内容
//    func clearKeychainItem() {
//        do {
//            try keychain.remove(juliangActiveStatus)
//            KLog(message: "用户激活状态-清空成功")
//        } catch let error {
//            KLog(message: "用户激活状态-清空失败：\(error)")
//        }
//        do {
//            try keychain.remove(juliangNextDayOpenStatus)
//            KLog(message: "次留激活状态-清空成功")
//        } catch let error {
//            KLog(message: "次留激活状态-清空失败：\(error)")
//        }
//        do {
//            try keychain.remove(juliangActiveDate)
//            KLog(message: "用户激活时间-清空成功")
//        } catch let error {
//            KLog(message: "用户激活时间-清空失败：\(error)")
//        }
//    }
//    //MARK: - Private Method
//    //用户激活事件
//    private func userActiveAction() {
//        KLog(message: "请求用户激活接口...")
//        KLog(message: "更新用户激活状态...")
//        self.keychain[self.juliangActiveStatus] = "1"
//        KLog(message: "用户激活了...")
//        KLog(message: "保存用户激活的时间...")
//        let activeTime = self.date_current()
//        self.keychain[self.juliangActiveDate] = activeTime
//        KLog(message: "用户激活的时间为：\(activeTime)")
//    }
//    //次留激活事件
//    private func nextDayOpenAction() {
//        guard let userActiveTime = keychain[juliangActiveDate] else {
//            KLog(message: "未获取到用户激活时间，无法判断是否满足次留激活")
//            return
//        }
//        let nowTime = date_current()
//        KLog(message: "用户激活时间为：\(userActiveTime)")
//        KLog(message: "触发激活的时间：\(nowTime)")
//        KLog(message: "判断次留是否满足激活条件...")
//        let interval = date_interval(start: userActiveTime, end: nowTime)
//        if interval == 1 {
//            KLog(message: "满足次留激活条件")
//            KLog(message: "请求次留激活接口...")
//            KLog(message: "更新次留激活状态...")
//            self.keychain[self.juliangNextDayOpenStatus] = "1"
//            KLog(message: "次留激活了")
//        } else {
//            KLog(message: "不满足次留激活条件")
//        }
//    }
//
//    //当前日期（年-月-日）
//    private func date_current() -> String {
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let string = formatter.string(from: now)
//        return string
//    }
//    //两个日期间隔天数
//    private func date_interval(start:String,end:String) -> Int {
//        let dateFormatter = DateFormatter()
//        KLog(message: TimeZone.current)
//        //设置为本地时间
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        KLog(message: dateFormatter.date(from: start))
//        KLog(message: dateFormatter.date(from: end))
//        guard let startDate = dateFormatter.date(from: start),
//                let endDate = dateFormatter.date(from: end) else { return -1 }
//        let components = NSCalendar.current.dateComponents([.day], from: startDate,to: endDate)
//        return components.day!
//    }
//    //string + AES加密 => base64
//    func data_encode(original value: String) -> String? {
//
//        guard let aes = try? AES(key: Array(AESKey.utf8), blockMode: ECB(), padding: .pkcs5) else {
//            return nil
//        }
//        guard let encrypted = try? aes.encrypt(value.bytes) else {
//            return nil
//        }
//        let encryptedBase64 = encrypted.toBase64()
//        return encryptedBase64
//    }
//}
