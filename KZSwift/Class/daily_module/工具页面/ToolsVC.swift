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
    
    //MARK: - Custom Method
    /**模拟idfa，随机生成一个*/
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
extension ToolsVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        if title == "生成随机IDFA" {
            let idfa = generateRandomString()
            self.view.makeToast(idfa)
            KLog(message: "IDFA：\(idfa)")
            self.showLabel.text = idfa
        }
    }
}
