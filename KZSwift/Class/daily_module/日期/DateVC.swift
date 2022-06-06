//
//  DateVC.swift
//  KZSwift
//
//  Created by KZ on 2022/6/6.
//

import UIKit
import SwiftyUserDefaults
import KeychainAccess

class DateVC: RootHomeVC {
    let keychain = Keychain(service: "com.smart.story.zaowen")
    let juliangActiveStatus = "juliangActiveStatus"
    let juliangNextDayOpenStatus = "juliangNextDayOpenStatus"
    
    @objc func injected() {
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        doViewUI()
    }
    private func doNavUI() {
        let clearItem = UIBarButtonItem(title: "清空状态", style: .plain, target: self, action: #selector(clearItemAction))
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
    }
    //清空UserDefaults保存的日期
    @objc func clearItemAction() {
        do {
            try keychain.remove(juliangActiveStatus)
            KLog(message: "用户激活状态清空成功")
        } catch let error {
            KLog(message: "用户激活状态清空失败：\(error)")
        }
        do {
            try keychain.remove(juliangNextDayOpenStatus)
            KLog(message: "次留激活状态清空成功")
        } catch let error {
            KLog(message: "次留激活状态清空失败：\(error)")
        }
        Defaults[\.activateDate] = nil
    }
    
    //点击用户激活按钮
    @objc func pressedActiveBtn() {
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
    //用户激活事件
    func userActiveAction() {
        KLog(message: "请求用户激活接口...")
        KLog(message: "更新用户激活状态...")
        keychain[juliangActiveStatus] = "1"
        KLog(message: "用户激活了...")
        KLog(message: "保存用户激活的时间...")
        let activeTime = date_current()
        Defaults[\.activateDate] = activeTime
        KLog(message: "用户激活的时间为：\(activeTime)")
    }
    //次留激活事件
    func nextDayOpenAction() {
        guard let userActiveTime = Defaults[\.activateDate] else { return }
        let nowTime = date_current()
        KLog(message: "用户激活时间为：\(userActiveTime)")
        KLog(message: "触发激活的时间：\(nowTime)")
        KLog(message: "判断次留是否满足激活条件...")
        let interval = dateInterval(start: userActiveTime, end: nowTime)
        if interval == 1 {
            KLog(message: "满足次留激活条件")
            KLog(message: "请求次留激活接口...")
            KLog(message: "更新次留激活状态...")
            keychain[juliangNextDayOpenStatus] = "1"
            KLog(message: "次留激活了")
        } else {
            KLog(message: "不满足次留激活条件")
        }
        
    }
    //点击保存按钮
    @objc func pressedIntervalBtn() {
        let a = dateInterval(start: "2022-06-06 15:46:13", end: "2022-06-07 15:46:20")
        KLog(message: a)
    }
    //点击打印按钮
    @objc func pressedPrintBtn() {
        KLog(message: date_current())
    }
}
extension DateVC {
    func date_current() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let string = formatter.string(from: now)
        return string
    }
    func dateInterval(start:String,end:String) -> Int {
        let dateFormatter = DateFormatter()
        KLog(message: TimeZone.current)
        //设置为本地时间
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        KLog(message: dateFormatter.date(from: start))
        KLog(message: dateFormatter.date(from: end))
        guard let startDate = dateFormatter.date(from: start),
                let endDate = dateFormatter.date(from: end) else { return -1 }
        let components = NSCalendar.current.dateComponents([.day], from: startDate,to: endDate)
        return components.day!
    }
}

