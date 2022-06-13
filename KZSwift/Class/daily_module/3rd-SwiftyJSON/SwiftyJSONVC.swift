//
//  SwiftyJSONVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/13.
//

import UIKit

class SwiftyJSONVC: RootHomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let templateView = TemplateView(frame: self.view.bounds, titles: ["空"])
        templateView.delegate = self
        self.view.addSubview(templateView)
    }
    
    func action0() {
        
    }
}

extension SwiftyJSONVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        switch index {
        case 0:
            action0()
        default:
            break
        }
    }
}
