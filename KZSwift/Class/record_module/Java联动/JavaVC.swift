//
//  JavaVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/23.
//

import UIKit

class JavaVC: RootHomeVC {
    let ipPort = "http://127.0.0.1:8080"
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .rgbSame(rgb: 240)
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    @objc func injected() {
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let baseView = TemplateView(frame: CGRect(x: 0, y: 0, width: width_screen, height: maxViewFrame.height * 0.7), titles: ["hello java","hello user","get all user", "get user by user id","get user by user name","insert user","update user","delete user"])
        baseView.delegate = self
        self.view.addSubview(baseView)
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
extension JavaVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        var parameters:[String: String] = [:]
        var urlString = ipPort
        switch title {
        case "hello java": break
        case "hello user":
            urlString += "/user/"
        case "get all user":
            urlString += "/user/getAllUser"
        case "get user by user id":
            urlString += "/user/getUserByUserID"
            parameters["userId"] = "1"
        default: break
        }
        KLog(message: index)
        AFNetWork.requestData(urlString: urlString, parameters: parameters) { type, result in
            KLog(message: type)
            if let data = result as? Data,
//               let ress = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
               let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                KLog(message: json)
                self.textView.text = json
            }
        }
    }
}
