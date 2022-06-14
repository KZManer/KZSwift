//
//  KeychainVC.swift
//  KZSwift
//
//  Created by KZ on 2022/6/6.
//

import UIKit
import KeychainAccess

class KeychainVC: RootHomeVC {
    let keychain = Keychain(service: "com.smart.story.zaowen")
    let jliangActiveStatus = "jliangActiveStatus"
    let jliangNextDayOpenStatus = "jliangNextDayOpenStatus"
    @objc func injected() {
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        doViewUI()
    }
    private func doNavUI() {
        let rightItem = UIBarButtonItem(title: "随机数", style: .plain, target: self, action: #selector(pressedRightItem))
        let clearItem = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clearItemAction))
        self.navigationItem.rightBarButtonItems = [rightItem,clearItem]
    }
    private func doViewUI() {
        let userActiveBtn = UIButton(type: .custom)
        userActiveBtn.setTitle("用户激活", for: .normal)
        userActiveBtn.setTitleColor(.white, for: .normal)
        userActiveBtn.backgroundColor = .darkGray
        userActiveBtn.addTarget(self, action: #selector(pressedUserActiveBtn), for: .touchUpInside)
        self.view.addSubview(userActiveBtn)
        userActiveBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.left.equalToSuperview().offset(width_screen * 0.15)
        }
        
        let nextDayOpenBtn = UIButton(type: .custom)
        nextDayOpenBtn.setTitle("次留激活", for: .normal)
        nextDayOpenBtn.setTitleColor(.white, for: .normal)
        nextDayOpenBtn.backgroundColor = .darkGray
        nextDayOpenBtn.addTarget(self, action: #selector(pressedNextDayOpenBtn), for: .touchUpInside)
        self.view.addSubview(nextDayOpenBtn)
        nextDayOpenBtn.snp.makeConstraints { make in
            make.top.height.width.equalTo(userActiveBtn)
            make.right.equalToSuperview().offset(-width_screen * 0.15)
        }
        
        let printBtn = UIButton(type: .custom)
        printBtn.setTitle("打印", for: .normal)
        printBtn.setTitleColor(.white, for: .normal)
        printBtn.backgroundColor = .darkGray
        printBtn.addTarget(self, action: #selector(pressedPrintBtn), for: .touchUpInside)
        self.view.addSubview(printBtn)
        printBtn.snp.makeConstraints { make in
            make.top.equalTo(userActiveBtn.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(userActiveBtn)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
    }
    //清空
    @objc func clearItemAction() {
        do {
            try keychain.remove(jliangActiveStatus)
            KLog(message: "清空用户激活-成功")
        } catch let error {
            KLog(message: "清空用户激活-失败：\(error)")
        }
        do {
            try keychain.remove(jliangNextDayOpenStatus)
            KLog(message: "清空次留激活-成功")
        } catch let error {
            KLog(message: "清空次留激活-失败：\(error)")
        }
    }
    //随机数
    @objc func pressedRightItem() {
        KLog(message: generateRandomString())
    }
    //点击用户激活按钮
    @objc func pressedUserActiveBtn() {
        keychain[jliangActiveStatus] = "1"
        KLog(message: "用户激活了")
    }
    //点击次留激活按钮
    @objc func pressedNextDayOpenBtn() {
        keychain[jliangNextDayOpenStatus] = "1"
        KLog(message: "次留激活了")
    }
    //点击打印按钮
    @objc func pressedPrintBtn() {
        if let value = keychain[jliangActiveStatus] {
            KLog(message: "用户已激活：\(value)")
        } else {
            KLog(message: "用户未激活")
        }
        if let value = keychain[jliangNextDayOpenStatus] {
            KLog(message: "次留已激活：\(value)")
        } else {
            KLog(message: "次留未激活")
        }
    }
    
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
