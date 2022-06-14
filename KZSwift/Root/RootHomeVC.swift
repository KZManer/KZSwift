//
//  RootHomeVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/21.
//

import UIKit
import KMNavigationBarTransition

class RootHomeVC: UIViewController {
    let bgColor = UIColor.rgb(r: 20, g: 32, b: 51)
    var minViewFrame: CGRect {
        return CGRect(x: 0, y: 0, width: width_screen, height: KTools.height_active_min())
    }
    var maxViewFrame: CGRect {
        return CGRect(x: 0, y: 0, width: width_screen, height: KTools.height_active_max())
    }
    //MARK: Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        globalSettingNavigationBarStyle()
    }
    //MARK: Custom Method
    func globalSettingNavigationBarStyle() {
        
        self.navigationController?.delegate = self
        navigationController?.navigationBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            if navigationController?.navigationBar.isTranslucent ?? false {
                navigationBarAppearance.configureWithTransparentBackground()
            } else {
                navigationBarAppearance.configureWithOpaqueBackground()
            }
            navigationBarAppearance.backgroundColor = bgColor
            navigationBarAppearance.backgroundImage = UIImage(color: bgColor)
            navigationBarAppearance.shadowImage = nil
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        } else {
            navigationController?.navigationBar.barTintColor = bgColor
            navigationController?.navigationBar.setBackgroundImage(UIImage(color: bgColor), for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
            ]
        }
    }
}
extension RootHomeVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

    }
}
