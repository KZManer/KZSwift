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
        textField.backgroundColor = .rgbSame(rgb: 240)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let showLabelH = 80.0
        showLabel.frame = CGRect(x: 0, y: 0, width: width_screen, height: showLabelH)
        self.view.addSubview(showLabel)
        
        let templateView = TemplateView(frame: CGRect(x: 0, y: showLabelH, width: width_screen, height: KTools.height_active_max() - showLabelH), titles: ["生成随机IDFA","生成随机imei号","生成随机oaid号","生成随机android id","当前时间戳"])
        templateView.delegate = self
        self.view.addSubview(templateView)
        
    }
}
extension ToolsVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        var value = ""
        if title == "生成随机IDFA" {
            value = String.randomIDFA()
        } else if title == "生成随机imei号" {
            value = String.randomIMEI()
        } else if title == "生成随机oaid号" {
            value = String.randomOAID()
        } else if title == "生成随机android id" {
            value = String.randomAndroidID()
        } else if title == "当前时间戳" {
            value = "\(Date.currentTimestamp)"
        }
        self.view.makeToast("\(value.count)位")
        KLog(message: "value is \(value)")
        self.showLabel.text = value
    }
}
