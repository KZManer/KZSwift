//
//  AppDelegate.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.frame = UIScreen.main.bounds
        let tabbarVC = TabBarVC.init()
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        return true
    }

}

