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
    
    //MARK: - System Method
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
#if DEBUG
        injection()
#endif
        window?.frame = UIScreen.main.bounds
        let tabbarVC = TabBarVC.init()
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        self.monitorNetworkStatus()
        showSplashView()
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
    func applicationWillEnterForeground(_ application: UIApplication) {
        showSplashView()
    }
    
    //MARK: - Custom Method
    func showSplashView() {
        
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "launch_image")
//        imageView.frame = UIScreen.main.bounds
//        self.window?.addSubview(imageView)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            imageView.removeFromSuperview()
//        }
    }
    ///网络状态监听
    private func monitorNetworkStatus() {
        self.networkManager?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { status in
            switch status {
            case .notReachable://没有网络链接
                KLog(message: "没有网络链接")
            case .unknown://网络状态未知
                KLog(message: "网络状态未知")
            case .reachable(.ethernetOrWiFi)://以太网或者wifi
                KLog(message: "以太网或者wifi")
            case .reachable(.cellular)://蜂窝数据
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
    //获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    print("\(fileName)-\(now)-\(line)line:\(message)")
//    print("\(fileName)-\(line)line:\(message)")
    
#endif
}

/**
1、使用injected热重载，在VC里加入以下代码
 @objc func injected() {
     self.viewDidLoad()
 }
 
 
 
 
 */
