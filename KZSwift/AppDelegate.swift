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
func KZLog<T>(message:T,file:String=#file,method:String=#function,line:Int=#line) {
    //在build setting中搜索swift flag 设置debug模式
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    
    print("\(fileName)-\(line)line:\(message)")
    
    #endif
}
