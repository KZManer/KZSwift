//
//  DZNEmptyDataVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/26.
//

import UIKit
import SwiftUI
import DZNEmptyDataSet

class DZNEmptyDataVC: RootHomeVC {
    let CellId = "DZNEmptyDataCellIdentifier"
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width_screen, height: KTools.height_active_max()), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
}
extension DZNEmptyDataVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        return cell
    }
}
extension DZNEmptyDataVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let attrString = NSAttributedString(string: "该频道暂无数据\n去其他频道逛逛吧", attributes: [
//            NSAttributedString.Key.foregroundColor : UIColor.darkGray,
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
//        ])
//        return attrString
//    }
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "hint_emptyData")
//    }
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let baseView = UIView()
        baseView.snp.makeConstraints { make in
            make.width.equalTo(width_screen)
            make.height.equalTo(height_screen * 0.4)
        }
        baseView.backgroundColor = .orange
        
        let showView = UIView()
        showView.backgroundColor = .white
        baseView.addSubview(showView)
        showView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalTo(0)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hint_emptyData")
        imageView.contentMode = .scaleAspectFill
        showView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(showView)
            make.width.height.equalTo(width_screen * 0.25)
            make.top.equalToSuperview()
        }
        
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .pingFangRegular(size: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "该频道暂无数据\n去其他频道逛逛吧"
        showView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalTo(showView)
        }
        
        showView.snp.makeConstraints { make in
            make.bottom.equalTo(label)
        }
      
        return baseView
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
