//
//  DeleteVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit

class DeleteVC: RootHomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titles = [String]()
        for i in 0...49 {
            titles.append("第\(i)个")
        }
        
        let templateView = TemplateView(frame: CGRect(x: 0, y: 0, width: width_screen, height: KTools.height_active_max()), titles: titles, column: 4)
        templateView.delegate = self
        self.view.addSubview(templateView)
    }
}
extension DeleteVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        KLog(message: title)
    }
}
