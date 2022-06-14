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
        return KCellModel.dailyInfos()
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

        guard let toVC = cellInfo.kVC else {
            self.view.makeToast("未找到对应的ViewController")
            return
        }
        toVC.hidesBottomBarWhenPushed = true
        toVC.title = cellInfo.kTitle
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
