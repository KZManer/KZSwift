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
        
        let templateView = TemplateView(frame: CGRect(x: 0, y: showLabelH, width: width_screen, height: KTools.height_active_max() - showLabelH), titles: ["生成随机IDFA"])
        templateView.delegate = self
        self.view.addSubview(templateView)
        
    }
}
extension ToolsVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        if title == "生成随机IDFA" {
            let idfa = String.randomIDFA()
            self.view.makeToast(idfa)
            KLog(message: "IDFA：\(idfa)")
            self.showLabel.text = idfa
        }
    }
}
