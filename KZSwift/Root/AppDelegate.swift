//
//  AppDelegate.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit
import AdSupport
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
#if DEBUG
        injection()
#endif
        
        window?.frame = UIScreen.main.bounds
        let tabbarVC = TabBarVC.init()
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .denied://用户拒绝
                    KLog(message: "广告标识：用户拒绝 - \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
                case .authorized://用户允许
                    KLog(message: "广告标识：用户允许 - \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
                case .notDetermined://用户没有选择
                    KLog(message: "广告标识：用户没有选择 - \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
                case .restricted:
                    KLog(message: "广告标识：用户受限制IDFA - \(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
                }
            }
        } else {
            
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                KLog(message:"广告标识：用户允许 -\(ASIdentifierManager.shared().advertisingIdentifier.uuidString)")
            } else {
                KLog(message:"广告标识：用户未打开IDFA开关")
            }
        }
    }
    
    func injection() {
        do {
            let injectionBundle = Bundle.init(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
            if let bundle = injectionBundle {
                try bundle.loadAndReturnError()
            } else {
                debugPrint("Injection注入失败,未能检测到Injection")
            }
            
        } catch {
            debugPrint("Injection注入失败\(error)")
        }
    }
}
func KLog<T>(message:T,file:String=#file,method:String=#function,line:Int=#line) {
    //在build setting中搜索swift flag 设置debug模式
#if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    
    print("\(fileName)-\(line)line:\(message)")
    
#endif
}
