//
//  SystemFontVC.swift
//  JJSwift
//
//  Created by J+ on 2022/4/28.
//

import UIKit

class SystemFontVC: RootHomeVC {
    let CellId = "SystemFontCellId"
    var fontFamilyArr: [String] {
        return UIFont.familyNames
    }
    var fontArr: [[String]] {
        var tempArr: [[String]] = []
        for fontFamily in fontFamilyArr {
            tempArr.append(UIFont.fontNames(forFamilyName: fontFamily))
        }
        return tempArr
    }
    lazy var tableView: UITableView = {
        let view = UITableView(frame: minViewFrame, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "系统测试"
        self.view.addSubview(self.tableView)
    }
}
extension SystemFontVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fontArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fontArr[section].count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "系统测试 \(self.fontFamilyArr[section])"
        label.font = UIFont(name: self.fontFamilyArr[section], size: 20)
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.fontFamilyArr[section]
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        let fontName = self.fontArr[indexPath.section][indexPath.row]
        cell.textLabel?.text = "系统测试 abc 123 + \(fontName)"
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = UIFont(name: fontName, size: 20)
        cell.detailTextLabel?.text = fontName
        return cell
    }
}
