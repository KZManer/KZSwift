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
        let templateView = TemplateView(frame: self.view.bounds, titles: ["button1","button2","","button4"])
        templateView.delegate = self
        self.view.addSubview(templateView)
    }
    private func doNavUI() {
        let actionItem = UIBarButtonItem(title: "action", style: .plain, target: self, action: #selector(actionItemAction))
        self.navigationItem.rightBarButtonItems = [actionItem]
    }
    //item
    @objc func actionItemAction() {

    }
}
extension TemplateVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        KLog(message: "\(index) - \(title)")
    }
}

