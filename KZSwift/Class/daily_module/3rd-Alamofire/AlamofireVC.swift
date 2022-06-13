//
//  AlamofireVC.swift
//  KZSwift
//
//  Created by KZ on 2022/6/12.
//

import UIKit
import Toast_Swift

class AlamofireVC: RootHomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let baseView = TemplateView(frame: self.view.bounds, titles: ["请求1-JSON返回","请求2-Data返回","Data转字典"])
        baseView.delegate = self
        self.view.addSubview(baseView)
    }
    
    func action0() {
        let parameters: [String: Any] =
        ["f":8010000,
         "lan":"zh",
         "mcc":460,
         "n":1,
         "ch":"mytest"]
        //获取配置 接口
        AFNetWork.requestJSON(urlString:JJ_Host + "feed/config.do" ,method: .get,parameters:parameters) {
            type,result in
            KLog(message: type)
            KLog(message: result)
            self.view.makeToast("success")
            if type == .success {
                self.view.makeToast("success")
                if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
                   let config = try? JSONDecoder().decode(JJConfigModel.self, from: data) {
                    KLog(message: config.description)
                }
            }
        }
    }
    func action1() {
        let parameters: [String: Any] =
        ["f":8010000,
         "lan":"zh",
         "mcc":460,
         "n":1,
         "ch":"mytest"]
        //获取配置 接口
        AFNetWork.requestData(urlString:JJ_Host + "feed/config.do" ,method: .get,parameters:parameters) {
            type,result in
            KLog(message: type)
            KLog(message: result)
            if type == .success {
                self.view.makeToast("success")
                if let data = result as? Data,
                   let config = try? JSONDecoder().decode(JJConfigModel.self, from: data) {
                    KLog(message: config.description)
                }
            }
        }
    }
    func action2() {
        let parameters: [String: Any] =
        ["f":8010000,
         "lan":"zh",
         "mcc":460,
         "n":1,
         "ch":"mytest"]
        //获取配置 接口
        AFNetWork.requestData(urlString:JJ_Host + "feed/config.do" ,method: .get,parameters:parameters) {
            type,result in
            KLog(message: type)
            KLog(message: result)
            if type == .success {
                self.view.makeToast("success")
                if let data = result as? Data,
                   let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    KLog(message: dic)
                }
            }
        }
    }
}

extension AlamofireVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        if index == 0 { action0() }
        else if index == 1 { action1() }
        else if index == 2 { action2() }
    }
}
