//
//  OptionDelegateVC.swift
//  KZSwift
//
//  Created by J+ on 2022/10/12.
//

import UIKit

class OptionDelegateVC: RootHomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        doViewUI()
    }
    private func doViewUI() {
        let homeView = ODHomeView(frame: self.view.frame)
        homeView.delegate = self
        self.view = homeView
    }
}
extension OptionDelegateVC: ODHomeViewDelegate {
    func dg_button1Pressed() {
        KLog(message: "button1 pressed")
    }
    
    func dg_button2Pressed() {
        KLog(message: "button2 pressed")
    }
    
    func dg_button3Pressed() {
        KLog(message: "button3 pressed")
    }
    
}
