//
//  TemplateView.swift
//  KZSwift
//
//  Created by J+ on 2022/6/13.
//  多按钮view

import UIKit

protocol TemplateViewDelegate: NSObjectProtocol {
    func dg_buttonPressed(index:Int, title:String)
}

class TemplateView: UIView {
    
    let kCellId = "TemplateCellId"
    var delegate: TemplateViewDelegate?
    var titles: [String]?
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TemplateCell.self, forCellReuseIdentifier: kCellId)
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(frame: CGRect, titles:[String]) {
        super.init(frame: frame)
        self.titles = titles
        self.addSubview(tableView)
//        doViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doViewUI() {
        self.backgroundColor = .rgbSame(rgb: 240)
        guard let titles = titles else { return }
        var oldBtn = UIButton()
        let btnHeight = 40.0
        let btnTop = 50.0
        for (index,name) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.setTitleColor(.randomTupleColor().fgColor, for: .normal)
            button.backgroundColor = .randomTupleColor().bgColor
            button.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
            self.addSubview(button)
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(btnTop)
                } else {
                    make.top.equalTo(oldBtn.snp.bottom).offset(btnTop)
                }
                make.height.equalTo(btnHeight)
                make.width.equalToSuperview().multipliedBy(0.5)
                make.centerX.equalToSuperview()
            }
            button.layer.cornerRadius = btnHeight / 2
            oldBtn = button
        }
    }
    @objc func pressedButton(sender: UIButton) {
        var index = -1
        if let btnTitle = sender.currentTitle {
            index = titles?.firstIndex(of: btnTitle) ?? index
            self.delegate?.dg_buttonPressed(index: index, title: btnTitle)
        }
        
    }
}
extension TemplateView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as! TemplateCell
        cell.selectionStyle = .blue
        if let arr = titles {
            let title = arr[indexPath.row]
            cell.echoContent(title: title)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let arr = titles {
            self.delegate?.dg_buttonPressed(index: indexPath.row, title: arr[indexPath.row])
        }
    }
}

class TemplateCell: UITableViewCell {
   
    lazy var showLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .randomTupleColor().bgColor
        label.textColor = .randomTupleColor().fgColor
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(showLabel)
        showLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        showLabel.layer.cornerRadius = 20
        showLabel.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func echoContent(title: String) {
        showLabel.text = title
    }
}
