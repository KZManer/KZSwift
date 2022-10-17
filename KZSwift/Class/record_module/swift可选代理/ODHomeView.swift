//
//  ODHomeView.swift
//  KZSwift
//
//  Created by J+ on 2022/10/12.
//

import UIKit

@objc public protocol ODHomeViewDelegate: NSObjectProtocol {
    func dg_button1Pressed()
    func dg_button2Pressed()
    @objc optional func dg_button3Pressed()
}
class ODHomeView: UIView {

    weak var delegate: ODHomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        doViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func doViewUI() {
        let button1 = UIButton(type: .custom)
        button1.setTitle("button1", for: .normal)
        button1.setTitleColor(.red, for: .normal)
        button1.addTarget(self, action: #selector(button1Pressed), for: .touchUpInside)
        self.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(50)
        }
        
        
        let button2 = UIButton(type: .custom)
        button2.setTitle("button2", for: .normal)
        button2.setTitleColor(.red, for: .normal)
        button2.addTarget(self, action: #selector(button2Pressed), for: .touchUpInside)
        self.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(50)
            make.left.right.equalTo(self)
            make.height.equalTo(50)
        }
        
        let button3 = UIButton(type: .custom)
        button3.setTitle("button3", for: .normal)
        button3.setTitleColor(.red, for: .normal)
        button3.addTarget(self, action: #selector(button3Pressed), for: .touchUpInside)
        self.addSubview(button3)
        button3.snp.makeConstraints { make in
            make.top.equalTo(button2.snp.bottom).offset(50)
            make.left.right.equalTo(self)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func button1Pressed() {
        self.delegate?.dg_button1Pressed()
    }
    
    @objc func button2Pressed() {
        self.delegate?.dg_button2Pressed()
    }
    
    @objc func button3Pressed() {
        if let delegate = self.delegate {
            delegate.dg_button3Pressed?()
        }
//        self.delegate?.dg_button3Pressed()
    }
}
