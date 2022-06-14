//
//  MainView.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit
protocol MainViewDelegate {
    func dg_didSelectRowAt(index:Int)
}
class MainView: UIView {
    var delegate: MainViewDelegate?
    let kCellId = "MainCellId"
    var source: [String]?
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.backgroundColor = .rgbSame(rgb: 240)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellId)
        return tableView
    }()
    
    init(frame: CGRect, source: [String]) {
        super.init(frame: frame)
        self.source = source
        doViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doViewUI() {
        self.addSubview(self.tableView)
    }
}
extension MainView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as UITableViewCell
        cell.selectionStyle = .default
        cell.contentView.backgroundColor = .randomColor(alpha: 0.4)
        cell.textLabel?.backgroundColor = .clear
        if let title = self.source?[indexPath.row] {
            cell.textLabel?.text = title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.dg_didSelectRowAt(index: indexPath.row)
    }
}
