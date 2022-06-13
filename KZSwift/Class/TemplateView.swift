//
//  TemplateView.swift
//  KZSwift
//
//  Created by J+ on 2022/6/13.
//

import UIKit

protocol TemplateViewDelegate: NSObjectProtocol {
    func dg_buttonPressed(index:Int, title:String)
}

class TemplateView: UIView {
    
    var delegate: TemplateViewDelegate?
    var titles: [String]?
    
    init(frame: CGRect, titles:[String]) {
        super.init(frame: frame)
        self.titles = titles
        doViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doViewUI() {
        
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
