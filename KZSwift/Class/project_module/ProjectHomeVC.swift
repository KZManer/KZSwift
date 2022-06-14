//
//  ProjectHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit

class ProjectHomeVC: RootHomeVC {
    
    let kCellId = "DailyCellIdentifier"
    var infos: Array<KCellModel> {
        return KCellModel.projectInfos()
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellId)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        
    }
}

extension ProjectHomeVC: UITableViewDataSource,UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        KLog(message: velocity)
        if velocity < -5 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as UITableViewCell
        cell.selectionStyle = .default
        cell.contentView.backgroundColor = .randomColor(alpha: 0.4)
        let cellInfo = infos[indexPath.row]
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.text = cellInfo.kTitle
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellInfo = self.infos[indexPath.row]
        var showVC: UIViewController?
        switch cellInfo.kId {
        case .active:
            showVC = ActiveVC()
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

