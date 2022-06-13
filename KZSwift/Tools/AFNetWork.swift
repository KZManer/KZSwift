//
//  AFNetWork.swift
//  PeopleStoryI
//
//  Created by J+ on 2021/12/13.
//

import Foundation
import Alamofire
import WebKit

class AFNetWork{
    
    enum HttpResultType: String {
        case success
        case failed
        case nonetwork
    }
    
    static func basicParameters() -> [String : Any] {
        
        let user = DeviceManager.identifier
        let version = DeviceManager.app_version
        let aid = "773013c7d22f2648" // TODO android
        let model = DeviceManager.device_model_name
        let device = DeviceManager.device_system_version
        let time = Date.currentMillistamp
        
        let signb = String(user)+"&"+String(version)+"&"+String(model)+"&"+String(device)+"&"+String(time)+"&"+String(aid)
        let sign = signb.MD5Encrypt(.uppercase32)
        
        let params:[String:Any] = ["aid":aid,// 应用id
                                   "u":user, //加密的uuid
                                   "v": version,//客户端版本号
                                   "m": model,//机型 
                                   "d": device,//IOS版本 
                                   "t":time,//当前毫秒级时间戳
                                   "s":sign//访问凭证MD5(u&v&m&d&t&secret)计算获得。其中&符号需要包含其中，secret=app-id
        ]
        return params
    }
    static var headers: HTTPHeaders = {
        
        let originalUA = "Mozilla/5.0 (iPhone; CPU iPhone OS " + DeviceManager.device_system_version + " like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Id/" + DeviceManager.identifier + " AppName/早闻天下事 PackageName/com.smart.news PackageVersionName/" + DeviceManager.app_version
//        KLog(message: originalUA)
        let head: HTTPHeaders = [
            "User-Agent": originalUA
        ]
        return head
    }()
    
    private static let network = NetworkReachabilityManager()
    
    static func requestJSON(urlString:String,method: HTTPMethod = .get,parameters:[String:Any],
                        resultData: @escaping (_ type: HttpResultType,_ result: Any) -> Void) {
        if network?.isReachable == false {
            resultData(.nonetwork, "no network")
            return
        }
        
        var encoding:ParameterEncoding = URLEncoding.default  // get
        if method == .post {
            encoding = JSONEncoding.default
        }
        var basicParams = basicParameters()
        basicParams.merge(parameters) { newParams, parameters in
            newParams
        }
        
        var paraString = ""
        for (key,value) in basicParams {
            var tvalue = ""
            
            if let cvalue = value as? CLongLong {
                tvalue = String(cvalue)
            }
            if let ivalue = value as? Int {
                tvalue = String(ivalue)
            }
            if let svalue = value as? String {
                tvalue = svalue
            }
            paraString = paraString + key + "=" + tvalue + "&"
        }
        paraString.removeLast()
        KLog(message: "\n完整地址：" + urlString + "?" + paraString + "\n")
        
        AF.request(urlString, method: method, parameters: basicParams, encoding: encoding, headers: headers).responseJSON { response in
            switch response.result {
            case let .success(data):
                resultData(.success,data)
                break
            case let .failure(error):
                KLog(message: error)
                resultData(.failed,error)
                break
            }
        }
    }
    static func requestData(urlString:String,method: HTTPMethod = .get,parameters:[String:Any],
                        resultData: @escaping (_ type: HttpResultType,_ result: Any) -> Void) {
        if network?.isReachable == false {
            resultData(.nonetwork, "no network")
            return
        }
        
        var encoding:ParameterEncoding = URLEncoding.default  // get
        if method == .post {
            encoding = JSONEncoding.default
        }
        var basicParams = basicParameters()
        basicParams.merge(parameters) { newParams, parameters in
            newParams
        }
        
        var paraString = ""
        for (key,value) in basicParams {
            var tvalue = ""
            
            if let cvalue = value as? CLongLong {
                tvalue = String(cvalue)
            }
            if let ivalue = value as? Int {
                tvalue = String(ivalue)
            }
            if let svalue = value as? String {
                tvalue = svalue
            }
            paraString = paraString + key + "=" + tvalue + "&"
        }
        paraString.removeLast()
        KLog(message: "\n完整地址：" + urlString + "?" + paraString + "\n")
        
        AF.request(urlString, method: method, parameters: basicParams, encoding: encoding, headers: headers).responseData { result in
            KLog(message: result)
            switch result.result {
            case let .success(data):
                resultData(.success,data)
            case let .failure(error):
                resultData(.failed,error)
            }
        }
    }
}

