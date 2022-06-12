//
//  TemplateVC.swift
//  KZSwift
//
//  Created by KZ on 2022/6/12.
//

import UIKit
import SwiftyJSON

class TemplateVC: RootHomeVC {
    
    @objc func injected() {
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        doViewUI()
    }
    private func doNavUI() {
        let actionItem = UIBarButtonItem(title: "action", style: .plain, target: self, action: #selector(actionItemAction))
        self.navigationItem.rightBarButtonItems = [actionItem]
    }
    private func doViewUI() {
        
        let button1 = UIButton(type: .system)
        button1.setTitle("button1", for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.backgroundColor = .darkGray
        button1.addTarget(self, action: #selector(pressedButton1), for: .touchUpInside)
        self.view.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
        
        let button2 = UIButton(type: .custom)
        button2.setTitle("button2", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = .darkGray
        button2.addTarget(self, action: #selector(pressedButton2), for: .touchUpInside)
        self.view.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(50)
            make.height.equalTo(40)
            make.width.equalTo(button1)
            make.centerX.equalToSuperview()
        }
        
        let button3 = UIButton(type: .custom)
        button3.setTitle("button3", for: .normal)
        button3.setTitleColor(.white, for: .normal)
        button3.backgroundColor = .darkGray
        button3.addTarget(self, action: #selector(pressedButton3), for: .touchUpInside)
        self.view.addSubview(button3)
        button3.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom).offset(50)
            make.centerX.width.height.equalTo(button2)
        }
        
        let button4 = UIButton(type: .custom)
        button4.setTitle("button4", for: .normal)
        button4.setTitleColor(.white, for: .normal)
        button4.backgroundColor = .darkGray
        button4.addTarget(self, action: #selector(pressedButton4), for: .touchUpInside)
        self.view.addSubview(button4)
        button4.snp.makeConstraints { make in
            make.top.equalTo(button3.snp.bottom).offset(50)
            make.centerX.width.height.equalTo(button2)
        }
        
        let button5 = UIButton(type: .custom)
        button5.setTitle("button5", for: .normal)
        button5.setTitleColor(.white, for: .normal)
        button5.backgroundColor = .darkGray
        button5.addTarget(self, action: #selector(pressedButton5), for: .touchUpInside)
        self.view.addSubview(button5)
        button5.snp.makeConstraints { make in
            make.top.equalTo(button4.snp.bottom).offset(50)
            make.centerX.width.height.equalTo(button2)
        }
    }
    //item
    @objc func actionItemAction() {

    }
    //点击button1
    @objc func pressedButton1() {
        
    }
    //点击button2
    @objc func pressedButton2() {
        
    }
    //点击button3
    @objc func pressedButton3() {
        
    }
    //点击button4
    @objc func pressedButton4() {

    }
    //点击button5
    @objc func pressedButton5() {

    }
}

