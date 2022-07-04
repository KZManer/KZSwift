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
let kTemplateCellOneColumnId = "TemplateCellOneColumnId"
let kTemplateCellTwoColumnId = "TemplateCellTwoColumnId"
class TemplateView: UIView {
    
//    let kCellId = "TemplateCellOneColumnId"
    let verSpace = 20.0
    let oneHeight = 40.0
    var delegate: TemplateViewDelegate?
    var titles: [String]?
    var columnn = 1
    private var column: Int {
        return columnn > 4 ? 4 : columnn
    }
    var kCellId: String {
        if column == 2 { return kTemplateCellTwoColumnId }
        return kTemplateCellOneColumnId
    }
    var buttonSpace: (space:Double, width:Double) {
        let frameWidth = self.frame.self.width;
        //默认按一列来计算
        var width:Double = frameWidth * 0.6
        var space = (frameWidth - width) / 2.0
        if column > 1 {
            space = 20.0
            width = (Double(frameWidth) - (space * (Double(column) + 1.0)))/Double(column)
        }
        return (space, width)
    }
    
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        return scrollView
    }()
    
    init(frame: CGRect, titles:[String], column:Int = 1) {
        super.init(frame: frame)
        self.titles = titles
        self.columnn = column
        self.addSubview(scrollView)
//        self.addSubview(tableView)
        doViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doViewUI() {
        self.backgroundColor = .rgbSame(rgb: 240)
        guard let titles = titles else { return }
        var oldBtn = UIButton()
        for (index,name) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.setTitleColor(.randomTupleColor().fgColor, for: .normal)
            button.backgroundColor = .randomTupleColor().bgColor
            button.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            let btnRow = Double(index / column)
            let btnColumn = Double(index % column)
            let btnX = buttonSpace.space + (buttonSpace.space + buttonSpace.width) * btnColumn
            let btnY = verSpace + (verSpace + oneHeight) * btnRow
            
            button.snp.makeConstraints { make in
//                if index == 0 {
//                    make.top.equalTo(verSpace)
//                } else {
//                    make.top.equalTo(oldBtn.snp.bottom).offset(verSpace)
//                }
//                make.top.equalToSuperview().offset(btnX)
//                make.width.equalToSuperview().multipliedBy(0.5)
//                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(btnY)
                make.left.equalTo(btnX)
                make.height.equalTo(oneHeight)
                make.width.equalTo(buttonSpace.width)
            }
            button.layer.cornerRadius = oneHeight / 2
            oldBtn = button
        }
        
        
        scrollView.contentSize = CGSize(width: 0.0, height: doScrollViewHeight())
        
    }
    private func doButtonWidth() {
        
    }
    //计算scrollView的高度
    private func doScrollViewHeight() -> Double {
        
        guard let btnNum = titles?.count else { return 0.0 }
        let unitHeight = verSpace + oneHeight
        var row = btnNum / column
        if btnNum % column != 0 {
            row += 1
        }
        return Double(row) * unitHeight
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
   
    lazy var showLabel: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .randomTupleColor().bgColor
        button.setTitleColor(UIColor.randomTupleColor().fgColor, for: .normal)
        return button
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
//        showLabel.text = title
        showLabel.setTitle(title, for: .normal)
    }
}
