//
//  ThirdLibVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit

class ThirdLibVC: RootHomeVC {
    
    let kCellId = "ThirdLibCellIdentifier"
    var infos: Array<KCellModel> {
        return KCellModel.thirdLibInfos()
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: mainViewFrame, style: .plain)
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
    }
    
    //MARK: Custom Method
    func doNavUI() {
        let titleIV = UIImageView(image: UIImage(named: "basketball"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }

}

extension ThirdLibVC: UITableViewDataSource,UITableViewDelegate {

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
        case .DZNEmptyDataSet:
            showVC = DZNEmptyDataVC()
        case .KeychainAccess:
            showVC = KeychainVC()
        case .Alamofire:
            showVC = AlamofireVC()
        case .SwiftyJSON:
            showVC = SwiftyJSONVC()
        case .JXSegmentedView:
            showVC = JXSegmentedVC()
        case .SPPageMenu:
            showVC = SPPageMenuVC()
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
