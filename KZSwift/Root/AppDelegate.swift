//
//  AppDelegate.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var networkManager = NetworkReachabilityManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
#if DEBUG
        injection()
#endif
        
        window?.frame = UIScreen.main.bounds
        let tabbarVC = TabBarVC.init()
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        
        self.monitorNetworkStatus()
        
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
    
    ///网络状态监听
    private func monitorNetworkStatus() {
        self.networkManager?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { status in
            switch status {
            case .notReachable://没有网络链接
//                self.hasNetwork = false
//                self.networkStatus = .noNetwork
                KLog(message: "没有网络链接")
            case .unknown://网络状态未知
//                self.hasNetwork = true
//                self.networkStatus = .unknown
                KLog(message: "网络状态未知")
            case .reachable(.ethernetOrWiFi)://以太网或者wifi
//                self.hasNetwork = true
//                self.networkStatus = .wifi
                KLog(message: "以太网或者wifi")
            case .reachable(.cellular)://蜂窝数据
//                self.hasNetwork = true
//                self.networkStatus = .cellular
                KLog(message: "蜂窝数据")
            }
        })
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
