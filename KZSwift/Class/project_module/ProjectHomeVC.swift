//
//  ProjectHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit
import SwiftUI

class ProjectHomeVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.projectInfos()
    }
    var titles: [String] {
        return infos.map(){ $0.kTitle ?? "" }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let mainView = MainView(frame: minViewFrame, source: titles)
        mainView.delegate = self
        mainView.backgroundColor = .lightGray
        self.view.addSubview(mainView)
        
        let x1y0   = CGPoint(x: 1,  y: 0)
        let x1ym1  = CGPoint(x: 1,  y: -1)
        let x0ym1  = CGPoint(x: 0,  y: -1)
        let xm1ym1 = CGPoint(x: -1, y: -1)
        let xm1y0  = CGPoint(x: -1, y: 0)
        let xm1y1  = CGPoint(x: -1, y: 1)
        let x0y1   = CGPoint(x: 0,  y: 1)
        let x1y1   = CGPoint(x: 1,  y: 1)
        
        let arr = [x1y0,x1ym1,x0ym1,xm1ym1,xm1y0,xm1y1,x0y1,x1y1]
        
        
        for item in arr {
            KLog(message: "(\(item.x),\(item.y))")
        }
        
        //atan2值
        for item in arr {
            var value = atan2(item.y, item.x)
            value = value * 180.0 / Double.pi
//            KLog(message: value)
            angleForNorth(endPoint: item)
        }
    }
    
    private func angleForNorth(endPoint: CGPoint) {
        var v = endPoint
        let vmag = sqrt(v.x * v.x + v.y * v.y)
        var result = 0.0
        v.x = v.x / vmag
        v.y = v.y / vmag
        let radians = atan2(v.y, v.x)
        result = 180 * radians / Double.pi
        let a = result >= 0 ? result : result + 360.0
        KLog(message: "\(360.0 - a)")
    }
    
    private func angle(v:Double) {
//        KLog(message: )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nav_navigationBarShow()
    }
    //MARK: Custom Method
    func doNavUI() {
        
        let titleIV = UIImageView(image: UIImage(named: "nav_logo1"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }
}

extension ProjectHomeVC: MainViewDelegate {
    func dg_didSelectRowAt(index: Int) {
        let cellInfo = self.infos[index]
        
        guard let cls = cellInfo.kCls else {
            self.view.makeToast("未找到对应的ViewController")
            return
        }
        let toVC = cls.init()
        toVC.hidesBottomBarWhenPushed = true
        toVC.title = cellInfo.kTitle
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
