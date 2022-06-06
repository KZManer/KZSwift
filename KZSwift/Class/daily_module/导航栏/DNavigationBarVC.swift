//
//  DNavigationBarVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/23.
//

import UIKit

class DNavigationBarVC: RootHomeVC {
    let kCellId = "DNavigationBarVCCellIdentifier"
    var infos: [KCellModel] {
        get {
            return [
                KCellModel.init(title: "导航栏跟随默认设置", id: "one"),
                KCellModel.init(title: "自定义导航栏颜色", id: "two"),
                KCellModel.init(title: "隐藏导航栏", id: "three")
            ]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "导航栏"
        self.view.addSubview(self.tableView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension DNavigationBarVC: UITableViewDataSource,UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let pen = scrollView.panGestureRecognizer
//        let velocity = pen.velocity(in: scrollView).y
//        if velocity < 0 {
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        } else if velocity > 0 {
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
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
        var showVC: UIViewController?
        let cellInfo = infos[indexPath.row]
        switch cellInfo.kId {
        case "one":
            showVC = DNavigationBarVC1()
        case "two":
            showVC = DNavigationBarVC2()
        case "three":
            showVC = DNavigationBarVC3()
        case .none:
            break
        case .some(_):
            break
        }
        if let vc = showVC {
            vc.title = cellInfo.kTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
