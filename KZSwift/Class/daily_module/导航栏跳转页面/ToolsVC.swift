//
//  ToolsVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit

class ToolsVC: RootHomeVC {
    lazy var showLabel: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .rgbSame(rgb: 220)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 12)
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let showLabelH = 80.0
        showLabel.frame = CGRect(x: 0, y: 0, width: width_screen, height: showLabelH)
        self.view.addSubview(showLabel)
        
        let readmeLabel = UILabel(frame: CGRect(x: 0, y: showLabelH, width: width_screen, height: 60))
        readmeLabel.backgroundColor = .rgbSame(rgb: 240)
        readmeLabel.numberOfLines = 0
        readmeLabel.textColor = .gray
        readmeLabel.font = .systemFont(ofSize: 14)
        readmeLabel.text = "以下功能为独立功能，比如生成随机idfa和idfa-AES加密这两个功能的idfa是不一致的，都是随机的"
        self.view.addSubview(readmeLabel)
        
        let templateView = TemplateView(frame: CGRect(x: 0, y: showLabelH + readmeLabel.frame.size.height, width: width_screen, height: KTools.height_active_max() - showLabelH), titles: ["生成随机idfa","idfa-AES加密","生成随机imei号","imei-AES加密","生成随机oaid号","oaid-AES加密","生成随机android id","android id-AES加密","当前时间戳(精度:秒)","当前时间戳(精度:毫秒)"],column: 2)
        templateView.delegate = self
        self.view.addSubview(templateView)
        
    }
}
extension ToolsVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        var value: String?
        if title == "生成随机idfa" {
            value = String.randomIDFA()
        } else if title == "idfa-AES加密" {
            let idfa = String.randomIDFA()
            KLog(message: "idfa:\(idfa)")
            value = idfa.aesEncode()
        } else if title == "生成随机imei号" {
            value = String.randomIMEI()
        } else if title == "imei-AES加密" {
            let imei = String.randomIMEI()
            KLog(message: "imei:\(imei)")
            value = imei.aesEncode()
        } else if title == "生成随机oaid号" {
            value = String.randomOAID()
        } else if title == "oaid-AES加密" {
            let oaid = String.randomOAID()
            KLog(message: "oaid:\(oaid)")
            value = oaid.aesEncode()
        } else if title == "生成随机android id" {
            value = String.randomAndroidID()
        } else if title == "android id-AES加密" {
            let androidID = String.randomAndroidID()
            KLog(message: "android id:\(androidID)")
            value = androidID.aesEncode()
        } else if title == "当前时间戳(精度:秒)" {
            value = "\(Date.currentTimestamp)"
        } else if title == "当前时间戳(精度:毫秒)" {
            
//            let string = "2022-06-29 13:33:33"
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let date = dateFormatter.date(from: string)
//            let timeInterval: TimeInterval = date!.timeIntervalSince1970
//            let millisecond = CLongLong(round(timeInterval*1000))
//            KLog(message: "\(millisecond)")
            
            value = "\(Date.currentMillistamp)"
        }
        guard let string = value else {
            self.view.makeToast("生成失败")
            return
        }
        self.view.makeToast("\(string.count)位")
        KLog(message: "value is \(string)")
        self.showLabel.text = string
    }
}
