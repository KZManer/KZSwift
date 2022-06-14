//
//  Config.swift
//  KZSwift
//
//  Created by J+ on 2022/6/13.
//

import UIKit

//MARK: - APP配置接口模型(feed/config.do)
struct JJConfigModel: Codable,CustomStringConvertible {
    var data = JJConfigDataModel()
    var ver  = JJConfigVerModel()
    var description: String {
        return "\nucsc:\(data.ucsc)\nrnl:\(data.rnl)\nrn:\(data.rn)\nric:\(data.ric)\ncn:\(data.cn)\nrci:\(data.rci)\nrt:\(data.rt)\nhdv:\(ver.hdv ?? -1)\n"
    }
}
struct JJConfigDataModel: Codable {
    ///非默认频道是否缓存（0否1是）外部使用这个值
    var ucscBool: Bool {
        return self.ucsc != 0
    }
    ///非默认频道是否缓存（0否1是）
    var ucsc: Int = 0
    ///N条自动加载新内容（默认10条）
    var rnl : Int = 10
    ///刷新请求条数（默认10条）
    var rn  : Int = 10
    ///切换频道自动刷新间隔（default:5min unit:msec）
    var ric : Int = 5*60*1000
    ///各频道缓存条数（默认30条）
    var cn  : Int = 30
    ///获取配置时间间隔（default:1day unit:msec)
    var rci : Int = 24*60*60*1000
    ///自动刷新时间间隔（default:5min unit:msec)
    var rt  : Int = 5*60*1000
}
struct JJConfigVerModel: Codable {
    ///频道数据版本号
    var hdv: Int64?
//    var adv: Int?
//    ///配置数据版本号
//    var cdv: Int?
}
