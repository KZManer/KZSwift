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
    private let keychain = Keychain(service: "com.ghostshadow.KZSwift")
    private let juliangActiveStatus = "activeStatus"
    private let juliangActiveDate = "activeDate"
    private let juliangNextDayOpenStatus = "nextDayOpenStatus"
    private let AESKey = "abjhkkk34hkij5khslk23juhbvn2323"
    
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
        KLog(message: "更新用户激活状态...")
        self.keychain[self.juliangActiveStatus] = "1"
        KLog(message: "用户激活了...")
        KLog(message: "保存用户激活的时间...")
        let activeTime = self.date_current()
        self.keychain[self.juliangActiveDate] = activeTime
        KLog(message: "用户激活的时间为：\(activeTime)")
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
            KLog(message: "更新次留激活状态...")
            self.keychain[self.juliangNextDayOpenStatus] = "1"
            KLog(message: "次留激活了")
        } else {
            KLog(message: "不满足次留激活条件")
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
