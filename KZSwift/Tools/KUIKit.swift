//
//  KUIKit.swift
//  KZSwift
//
//  Created by KZ on 2022/5/21.
//

import Foundation
import UIKit

//MARK: 颜色扩展
extension UIColor {
    /// 十六进制字符串颜色转为UIColor
    /// - Parameter alpha: 透明度
    public static func hex(_ value: String,alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hexStr = value
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hexStr.hasPrefix("0x") || hexStr.hasPrefix("0X") {
            hexStr = String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 2)...])
        } else if hexStr.hasPrefix("#") {
            hexStr = String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hexStr.count < 6 {
            for _ in 0..<6-hexStr.count {
                hexStr += "0"
            }
        }
        
        // 分别进行转换
        // 红
        Scanner(string: String(hexStr[..<hexStr.index(hexStr.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 2)..<hexStr.index(hexStr.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hexStr[hexStr.index(hexStr.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    ///RGB
    public static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    ///RGB same
    public static func rgbSame(rgb: CGFloat,alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.rgb(r: rgb, g: rgb, b: rgb, alpha: alpha)
    }
    
    ///随机色
    public static func randomColor(alpha: CGFloat = 1.0) -> UIColor{
        let r = arc4random_uniform(256)
        let g = arc4random_uniform(256)
        let b = arc4random_uniform(256)
        return UIColor.rgb(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
    ///返回随机色元组（前景色+背景色）
    public static func randomTupleColor(alpha: CGFloat = 1.0) -> (bgColor: UIColor,fgColor: UIColor) {
        let r = Double(arc4random_uniform(256))
        let g = Double(arc4random_uniform(256))
        let b = Double(arc4random_uniform(256))
        //背景色
        let bg = UIColor.rgb(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
        //前景色
        var fg = UIColor.white
        if(r * 0.299 + g * 0.578 + b * 0.114 >= 192){
            //浅⾊
            fg = .black
        } else { /*深⾊*/ }
        return (bg,fg)
    }
}
public extension UIImage {
    
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
    
}
//MARK: 导航栏
extension UIViewController: UIGestureRecognizerDelegate {
    ///配置导航栏返回按钮
    func nav_backItemConfig(tintColor: UIColor = .white, selector: Selector?) {
        
        var sel = selector
        if sel == nil {
            sel = #selector(pressedBackItem)
        }
        
        //侧滑返回手势（自定义返回item的时候侧滑手势会失效，加上下面这句代码即可,在extension后加上代理方法）
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "c_arrow_left")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: sel)
        backItem.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = backItem
    }
    @objc private func pressedBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
    ///配置导航栏
    func nav_navigationBarConfig(translucent: Bool = false,showLine: Bool = false,bgColor: UIColor = .red,fgColor: UIColor = .white) {
        self.navigationController?.navigationBar.isHidden = false
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance.init()
            if translucent {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithDefaultBackground()
            }
            //是否半透明
            self.navigationController?.navigationBar.isTranslucent = translucent
            //导航栏背景色
            appearance.backgroundColor = bgColor
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: fgColor,
            ]
            //是否有底部线
            if showLine {
                //有线
                appearance.shadowColor = .lightGray
            } else {
                //没有线
                appearance.shadowColor = .clear
            }
            self.navigationController?.navigationBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
        } else {
            
            self.navigationController?.navigationBar.isTranslucent = translucent
            //是否有底部线
            if showLine {
                //有线
                self.navigationController?.navigationBar.shadowImage = nil
            } else {
                //没有线
                self.navigationController?.navigationBar.shadowImage = UIImage.init()
            }
            if translucent {
                //设置导航栏背景图片为一个空的image，这样就透明了
                self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
            } else {
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            }
            //设置导航栏背景色
            self.navigationController?.navigationBar.barTintColor = bgColor
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: fgColor,
            ]
        }
    }
    ///隐藏导航栏
    func nav_navigationBarHide() {
        self.navigationController?.navigationBar.isHidden = true
    }
    ///展示导航栏
    func nav_navigationBarShow() {
        self.navigationController?.navigationBar.isHidden = false
    }
}

//MARK: UIView扩展
extension UIView {
    ///设置任意位置的圆角 roundingCorners => [.topLeft,.bottomRight]
    func view_setCornerRadius(value: CGFloat, roundingCorners:UIRectCorner) {
        self.layoutIfNeeded()
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: value, height: value))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
}

//MARK: UIButton扩展
extension UIButton {
    ///上图片 下文字
    func topImageBottomText(space: CGFloat) {
        let image_W = self.imageView?.frame.size.width
        let image_H = self.imageView?.frame.size.height
        let tit_W = self.titleLabel?.frame.size.width
        let tit_H = self.titleLabel?.frame.size.height
        guard let iw = image_W,let ih = image_H,let tw = tit_W,let th = tit_H else {
            return
        }
        self.titleEdgeInsets = UIEdgeInsets(
            top    : th/2 + space/2,
            left   : -(iw/2),
            bottom : -(th/2 + space/2),
            right  : iw/2
        )
        self.imageEdgeInsets = UIEdgeInsets(
            top    : -(ih/2 + space/2),
            left   : tw/2,
            bottom : ih/2 + space/2,
            right  : -tw/2
        )
    }
    ///上文字 下图片
    func topTextBottomImage(space: CGFloat) {
        let img_W = self.imageView?.frame.size.width
        let img_H = self.imageView?.frame.size.height
        let tit_W = self.titleLabel?.frame.size.width
        let tit_H = self.titleLabel?.frame.size.height
        
        guard let iw = img_W,let ih = img_H,let tw = tit_W,let th = tit_H else {
            return
        }
        
        self.titleEdgeInsets = UIEdgeInsets(
            top    : -(th/2 + space/2),
            left   : -(iw/2),
            bottom : (th/2 + space/2),
            right  : (iw/2)
        )
        self.imageEdgeInsets = UIEdgeInsets(
            top    : (ih/2 + space/2),
            left   : (tw/2),
            bottom : -(ih/2 + space/2),
            right  : -(tw/2)
        )
    }
    ///左图片 右文字
    func leftImageRightText(space: CGFloat) {
        self.titleEdgeInsets = UIEdgeInsets(
            top    : 0,
            left   : space/2,
            bottom : 0,
            right  : -space/2
        )
        self.imageEdgeInsets = UIEdgeInsets(
            top    : 0,
            left   : -space/2,
            bottom : 0,
            right  : space/2
        )
    }
    ///左文字 右图片
    func leftTextRightImage(space: CGFloat) {
        let img_W = self.imageView?.frame.size.width
        let tit_W = self.titleLabel?.frame.size.width
        guard let iw = img_W,let tw = tit_W else {
            return
        }
        self.titleEdgeInsets = (UIEdgeInsets)(
            top    : 0,
            left   : -(iw + space/2),
            bottom : 0,
            right  : (iw + space/2)
        )
        
        self.imageEdgeInsets = (UIEdgeInsets)(
            top    : 0,
            left   : (tw + space/2),
            bottom : 0,
            right  : -(tw + space/2)
        )
    }
}

//MARK: UILabel 扩展
//MARK: UIFont 扩展
///早闻天下事项目有个全局设置字体大小的功能，用到了方法交换，将systemFontOfSize设置的字体大小进行了方法转换，使得字体按照设置的比例进行放大缩小了，这里用自定义的字体，不会受设置的比例的影响，此字体比较接近系统默认的字体
extension UIFont {
    ///自定义字体：PingFangSC-Regular
    public static func pingFangRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
    ///自定义字体：PingFangSC-Medium
    public static func pingFangMedium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }
    ///自定义字体：PingFangSC-Semibold
    public static func pingFangBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Semibold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
//    public static func jjFont(contentType type: JJFont_ContentType) -> UIFont {
//        let hasCSJChannel = Defaults[\.systemExistCSJChannel]//是否有穿山甲频道
//        let fontSizeScale = Defaults[\.fontsizeScale]//字体大小比例
//        switch type {
//        case .title:
//            return hasCSJChannel
//            ? .pingFangRegular(size: JJFont_CSJFont.title.rawValue)
//            : .systemFont(ofSize: JJFont_NoCSJFont.title.rawValue * fontSizeScale)
//        case .source:
//            return hasCSJChannel
//            ? .pingFangRegular(size: JJFont_CSJFont.source.rawValue)
//            : .systemFont(ofSize: JJFont_NoCSJFont.source.rawValue * fontSizeScale)
//        case .subhead:
//            return hasCSJChannel
//            ? .pingFangRegular(size: JJFont_CSJFont.subhead.rawValue)
//            : .systemFont(ofSize: JJFont_NoCSJFont.subhead.rawValue * fontSizeScale)
//        case .segmentTitle:
//            if hasCSJChannel {
//                return .pingFangRegular(size: JJFont_CSJFont.title.rawValue)
//            } else {
//                let type = JJFontScale(rawValue: Defaults[\.fontsizeScale])
//                guard let scaleType = type else {
//                    return .systemFont(ofSize: JJFont_NoCSJFont.title.rawValue * JJFontScale.normal.rawValue)
//                }
//                var fontSize = JJFont_NoCSJFont.title.rawValue * fontSizeScale
//                switch scaleType {
//                case .small:
//                    break
//                case .normal,.large,.huge:
//                    fontSize = JJFont_NoCSJFont.title.rawValue * JJFontScale.normal.rawValue
//                }
//                return .systemFont(ofSize: fontSize)
//            }
//        }
//    }
}

