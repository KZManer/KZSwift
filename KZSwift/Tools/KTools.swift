//
//  KTools.swift
//  KZSwift
//
//  Created by KZ on 2022/5/21.
//  工具类

import Foundation
import UIKit

//MARK: 尺寸相关
let width_screen = UIScreen.main.bounds.size.width
let height_screen = UIScreen.main.bounds.size.height

@objcMembers
class KTools: NSObject {
    ///状态栏高度
    public static func height_status() -> CGFloat {
        if #available(iOS 13, *) {
            let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            guard let height = statusBarManager?.statusBarFrame.size.height else {
                return 20
            }
            return height
        } else {
            let statusBarRectFrame = UIApplication.shared.statusBarFrame
            return statusBarRectFrame.size.height
        }
    }
    ///导航栏高度
    public static func height_navigation() -> CGFloat {
        return 44;
    }
    ///状态栏+导航栏高度
    public static func height_status_navigation() -> CGFloat {
        return height_status() + height_navigation()
    }
    ///菜单栏高度
    public static func height_tabbar() -> CGFloat {
        if isIPhoneX() {
            return 49.0 + 34.0
        }
        return 49.0
    }
    ///主屏幕高度1（设备高度-状态栏高度-导航栏高度-菜单栏高度）
    public static func height_active_min() -> CGFloat {
        return height_screen - height_status() - height_navigation() - height_tabbar()
    }
    ///主屏幕高度2（设备高度-状态栏高度-导航栏高度）
    public static func height_active_max() -> CGFloat {
        return height_screen - height_status() - height_navigation()
    }
    ///底部区域,具有刘海儿的屏幕底部为34,其他手机为0,目前适配到iPhone13，之后的机型还没出
    public static func height_bottom_space() -> CGFloat {
        if isIPhoneX() {
            return 34.0
        }
        return 0
    }
    
}

//MARK: 手机判断
extension KTools {
    ///判断设备是否为手机&&刘海屏幕
    public static func isIPhoneX() -> Bool {
        var isPhone = false
        if #available(iOS 13, *) {
            isPhone = UIDevice.current.userInterfaceIdiom == .phone
        } else {
            isPhone = UI_USER_INTERFACE_IDIOM() == .phone
        }
        
        let sysVer = (UIDevice.current.systemVersion as NSString).floatValue
        let isIOS11 = sysVer >= 11.0
        let screenSize = UIScreen.main.bounds.size
        let minBool = min(screenSize.width, screenSize.height) >= 375.0
        let maxBool = max(screenSize.width, screenSize.height) >= 812.0
        if isPhone && isIOS11 && minBool && maxBool {
            return true
        }
        return false
    }
}
//MARK: 正则表达式
extension KTools {
    ///正则表达式是否匹配
    public static func regexIsMatching(originalString: String,pattern: String) -> Bool{
        do {
            //".*cpu.baidu.com\\/.*video?.*"
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let number = regex.numberOfMatches(in: originalString, options: [], range: NSRange(location: 0, length: originalString.count))
            if number > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }
}

//MARK: 字符串扩展
extension String {
    ///获取缓存 单位:M
    public static func cacheGetSize() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        var size = 0
        for file in fileArr! {
            let path = cachePath! + "/\(file)"
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            for (key, fileSize) in floder {
                if key == FileAttributeKey.size {
                    size += (fileSize as AnyObject).integerValue
                }
                
            }
        }
        let totalCache = Double(size) / 1024.00 / 1024.00
        return String(format: "%.1f", totalCache)
    }
    ///删除缓存
    public static func cacheClear() {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        for file in fileArr! {
            let path = cachePath! + "/\(file)"
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                }catch {
                    
                }
            }
        }
    }
}

//MARK: 时间扩展
extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    public static var currentTimestamp: Int {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return Int(timeInterval)
    }
    /// 获取当前 毫秒级 时间戳 - 13位
    public static var currentMillistamp: CLongLong {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
}
extension KTools {
    public static func date_current() {
//        var date = 
    }
}
//MARK: UserDefaults
extension UserDefaults {
    
    func setItem<T: Encodable>(_ object: T, forKey key: String) {
        
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
    
        self.set(encoded, forKey: key)
    }
    
    func getItem<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        
        guard let data = self.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            return nil
        }
        
        return object
    }
}
