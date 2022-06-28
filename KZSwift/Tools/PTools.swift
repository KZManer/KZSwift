//
//  PTools.swift
//  KZSwift
//
//  Created by J+ on 2022/6/27.
//  该项目中用到的工具类，有一定特殊性

import Foundation

class PTools {
    
}
extension String {
    /**模拟idfa位数，随机生成一个*/
    static func randomIDFA() -> String {
        let arr = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        var string = ""
        //FD16D423-FCE2-4902-8B8D-F273BA155473
        for i in 0...35 {
            if [8,13,18,23].contains(i) {
                string += "-"
            } else {
                let randomIndex = Int(arc4random_uniform(36))
                let ch = arr[randomIndex]
                string += ch
            }
        }
        return string
    }
}
