//
//  DailyHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit
import Alamofire
import WebKit

class DailyHomeVC: RootHomeVC {
    
    let kCellId = "DailyCellIdentifier"
    var infos: Array<KCellModel> {
        get {
            return KCellModel.dailyInfos()
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellId)
        return tableView
    }()
    //MARK: Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        self.view.addSubview(self.tableView)
        KLog(message: "34:D7:12:9B:3A:89".md5)
    }
    
    //MARK: Custom Method
    func doNavUI() {
        let titleIV = UIImageView(image: UIImage(named: "nav_logo"))
        self.navigationItem.titleView = titleIV
    }

}
import CommonCrypto
public extension String {
    /* ################################################################## */
    /**
     - returns: the String, as an MD5 hash.
     */
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()
        return hash as String
    }
}
extension DailyHomeVC: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as UITableViewCell
        cell.selectionStyle = .default
        cell.contentView.backgroundColor = .randomColor(alpha: 0.4)
        let cellInfo = self.infos[indexPath.row]
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.text = cellInfo.kTitle
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellInfo = self.infos[indexPath.row]
        var showVC: UIViewController?
        switch cellInfo.kId {
        case "navigationBar":
            showVC = DNavigationBarVC()
        case "loadingAnimation":
            showVC = ShimmerVC()
        case "wkwebview":
            showVC = WebViewVC()
        case "methodSwizzling":
            showVC = MethodSwizzlingVC()
        case "shape":
            showVC = ShapeVC()
        case "placeholder":
            showVC = HintVC()
        case "DZNEmptyDataSet":
            showVC = DZNEmptyDataVC()
        case "date":
            showVC = DateVC()
        case "KeychainAccess":
            showVC = KeychainVC()
        case .none:
            break
        case .some(_):
            break
        }
        if let vc = showVC {
            vc.hidesBottomBarWhenPushed = true
            vc.title = cellInfo.kTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
