//
//  DirectionVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/13.
//

import UIKit
import CoreMotion

class DirectionVC: RootHomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(directionChanged(_noti:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        //CMRotationRate
        let manager = CMMotionManager()
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { motion, error in
            KLog(message: motion?.attitude.rotationMatrix)
        }
//        let a = CMDeviceMotion()
        
        
    }
    
    @objc func directionChanged(_noti: Notification) {
        let device = UIDevice.current
        var message = "unknow"
        switch device.orientation {
        case .portrait:
            message = "面向设备保持垂直，home键位于下部"
        case .portraitUpsideDown:
            message = "面向设备保持垂直，home键位于上部"
        case .landscapeLeft:
            message = "面向设备保持水平，home键位于右侧"
        case .landscapeRight:
            message = "面向设备保持水平，home键位于左侧"
        case .faceUp:
            message = "设备平放，home键朝上"
        case .faceDown:
            message = "设备平放，home键朝下"
        case .unknown:
            message = "方向未知"
        @unknown default:
            break
        }
        KLog(message: message)
        self.view.makeToast(message)
    }
    
}
