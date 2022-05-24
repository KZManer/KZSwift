//
//  MethodSwizzlingVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/24.
//

import UIKit
import SnapKit

class MethodSwizzlingVC: RootHomeVC {

    //MARK: Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        doViewUI()
        methodSwizzling()
    }
    
    //MARK: Custom Method
    func doViewUI() {
        let alertBtn1 = UIButton(type: .custom)
        alertBtn1.setTitle("被拦截的Alert", for: .normal)
        alertBtn1.setTitleColor(.red, for: .normal)
        alertBtn1.addTarget(self, action: #selector(alertAction1), for: .touchUpInside)
        self.view.addSubview(alertBtn1)
        alertBtn1.snp.makeConstraints { make in
            make.top.equalTo(width_screen * 0.3)
            make.width.centerX.equalTo(self.view)
            make.height.equalTo(40)
        }
        
        let alertBtn2 = UIButton(type: .custom)
        alertBtn2.setTitle("不被拦截的Alert", for: .normal)
        alertBtn2.setTitleColor(.red, for: .normal)
        alertBtn2.addTarget(self, action: #selector(alertAction2), for: .touchUpInside)
        self.view.addSubview(alertBtn2)
        alertBtn2.snp.makeConstraints { make in
            make.top.equalTo(alertBtn1).offset(100)
            make.width.height.centerX.equalTo(alertBtn1)
        }
    }
    @objc func alertAction1() {
        popupAlert(alertTitle: "系统消息", alertMessage: "位置服务不可用，请先进入设置-隐私中开启定位服务", actionTitle: "确定", handler: nil)
    }
    @objc func alertAction2() {
        popupAlert(alertTitle: "系统消息", alertMessage: "可弹出的Alert", actionTitle: "确定", handler: nil)
    }
    func popupAlert(alertTitle: String,alertMessage: String,actionTitle:String,handler:((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let certainAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alertController.addAction(certainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //这里实现方法交换
    func methodSwizzling() {
        KLog(message: "come in 0")
        let cls: AnyClass = UIViewController.self
        let originalSel = #selector(present(_:animated:completion:))
        let swizzledSel = #selector(swizzled_present(_:animated:completion:))
        let originalMethod = class_getInstanceMethod(cls, originalSel)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSel)
        KLog(message: "come in 1")
        guard let swiMethod = swizzledMethod,let oriMethod = originalMethod else { return }
        KLog(message: "come in 2")
        let didAddMethod = class_addMethod(cls, originalSel, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
        } else {
            method_exchangeImplementations(oriMethod, swiMethod)
        }
        return
    }
}
extension UIViewController {
    @objc func swizzled_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        KLog(message: "come in 3")
        if viewControllerToPresent.isKind(of: UIAlertController.self) {
            KLog(message: "come in 4")
            let vc = viewControllerToPresent as! UIAlertController

            if let message = vc.message {
                KLog(message: "come in 5")
                if message.contains("位置服务不可用") { return }
            }
        }
        swizzled_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
