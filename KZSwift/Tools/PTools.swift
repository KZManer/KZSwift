//
//  PTools.swift
//  KZSwift
//
//  Created by J+ on 2022/6/27.
//  该项目中用到的工具类，有一定特殊性

import Foundation
import CryptoSwift

class PTools {
    
}
extension String {
    /**模拟idfa位数，随机生成一个 36位*/
    static func randomIDFA() -> String {
        let arr = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        var string = ""
        //FD16D423-FCE2-4902-8B8D-F273BA155473
        for i in 0...35 {
            if [8,13,18,23].contains(i) {
                string += "-"
            } else {
                let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))
                let ch = arr[randomIndex]
                string += ch
            }
        }
        return string
    }
    /**生成一个随机的imei号 15位**/
    static func randomIMEI() -> String {
        let arr = ["0","1","2","3","4","5","6","7","8","9"]
        var string = ""
        for _ in 0..<15 {
            let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))
            let ch = arr[randomIndex]
            string += ch
        }
        return string
    }
    /**生成一个随机的imei号 36位*/
    static func randomOAID() -> String {
        let arr = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var string = ""
        for i in 0...35 {
            if [8,13,18,23].contains(i) {
                string += "-"
            } else {
                let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))
                let ch = arr[randomIndex]
                string += ch
            }
        }
        return string
    }
    
    /**生成一个随机的android id号 16位*/
    static func randomAndroidID() -> String {
        let arr = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var string = ""
        for _ in 0..<16 {
            let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))
            let ch = arr[randomIndex]
            string += ch
        }
        return string
    }
    
    //string + AES加密 => base64
    func aesEncode() -> String? {
        let AESKey = "6dd3e6ed9053adfa8c4744b0f65a419f"
        guard let aes = try? AES(key: Array(AESKey.utf8), blockMode: ECB(), padding: .pkcs5) else {
            return nil
        }
        guard let encrypted = try? aes.encrypt(self.bytes) else {
            return nil
        }
        let encryptedBase64 = encrypted.toBase64()
        return encryptedBase64
    }
    
    /**随机返回一个网络视频地址**/
    static func randomNetworkVideoPath() -> String {
        let videoPaths = [
            "http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
            "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
            "https://media.w3.org/2010/05/sintel/trailer.mp4",
            "http://mvvideo2.meitudata.com/576bc2fc91ef22121.mp4",
            "http://mvvideo10.meitudata.com/5a92ee2fa975d9739_H264_3.mp4",
            "http://mvvideo11.meitudata.com/5a44d13c362a23002_H264_11_5.mp4",
            "http://mvvideo10.meitudata.com/572ff691113842657.mp4"
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(videoPaths.count)))
        return videoPaths[randomIndex]
    }
    
}
