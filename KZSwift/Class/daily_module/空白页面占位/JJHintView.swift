//
//  JJHintView.swift
//  KZSwift
//
//  Created by KZ on 2022/5/25.
//

import UIKit
import SnapKit

protocol JJHintViewDelegate: NSObjectProtocol {
    ///按钮被点击
    func dg_hintViewButtonPressed(hintView: JJHintView, scene: JJHintScene?)
}

class JJHintView: UIView {
    
    var delegate: JJHintViewDelegate?
    
    lazy var baseView: UIView = {
        let baseView = UIView()
        return baseView
    }()
    lazy var hintImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .pingFangBold(size: 26)
        label.textColor = .darkGray
        return label
    }()
    lazy var hintDescLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .pingFangRegular(size: 14)
        label.textColor = .darkGray
        return label
    }()
    lazy var hintButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = .pingFangRegular(size: 18)
        button.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        return button
    }()
    
    let imageSide = width_screen * 0.25//图片的宽高
    let verSpace = 20//控件垂直方向的间距
    var hintScene: JJHintScene?
    
    //MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        doViewUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Private Method
    private func doViewUI() {
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retryAction)))
        
        //包裹具体控件的父view，用于控制居中
        self.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        //hint图
        baseView.addSubview(hintImageView)
        hintImageView.snp.makeConstraints { make in
            make.top.equalTo(baseView)
            make.width.height.equalTo(imageSide)
            make.centerX.equalTo(baseView)
        }
        //hint文本
        baseView.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(hintImageView.snp.bottom).offset(verSpace)
            make.width.centerX.equalTo(baseView)
        }
        //hint描述
        baseView.addSubview(hintDescLabel)
        hintDescLabel.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(verSpace)
            make.width.centerX.equalTo(baseView)
        }
        //hint按钮
        baseView.addSubview(hintButton)
        hintButton.snp.makeConstraints { make in
            make.top.equalTo(hintDescLabel.snp.bottom).offset(verSpace)
            make.centerX.equalTo(baseView)
        }
        hintButton.layer.cornerRadius = 5.0
        hintButton.layer.borderColor = UIColor.red.cgColor
        hintButton.layer.borderWidth = 0.8
        
        baseView.snp.makeConstraints { make in
            make.bottom.equalTo(hintButton.snp.bottom)
        }
    }
    
    override func updateConstraints() {
        
        if let scene = self.hintScene {
            var hasValue = false
            
            hasValue = scene.image == nil ? false : true
            self.hintImageView.snp.updateConstraints { make in
                make.width.height.equalTo(hasValue ? imageSide : 0)
            }
            self.hintLabel.snp.updateConstraints { make in
                make.top.equalTo(self.hintImageView.snp.bottom).offset(hasValue ? verSpace : 0)
            }
            
            if let value = scene.title,value.isEmpty == false {
                hasValue = true
            } else { hasValue = false }
            self.hintDescLabel.snp.updateConstraints { make in
                make.top.equalTo(self.hintLabel.snp.bottom).offset(hasValue ? verSpace : 0)
            }
            
            if let value = scene.description,value.isEmpty == false {
                hasValue = true
            } else { hasValue = false }
            self.hintButton.snp.updateConstraints { make in
                make.top.equalTo(self.hintDescLabel.snp.bottom).offset(hasValue ? verSpace : 0)
            }
        }
        super.updateConstraints()
    }
    
    //显示内容
    private func fillContent(scene: JJHintScene) {
        
        self.hintImageView.image = scene.image ?? UIImage()
        self.hintLabel.text = scene.title ?? ""
        self.hintDescLabel.text = scene.description ?? ""
        if let value = scene.buttonTitle,!value.isEmpty {
            self.hintButton.setTitle("\u{3000}\(value)\u{3000}", for: .normal)
            self.hintButton.isHidden = false
        } else {
            self.hintButton.isHidden = true
        }
    }
    @objc private func retryAction() {
        self.delegate?.dg_hintViewButtonPressed(hintView: self, scene: self.hintScene)
    }
    
    //MARK: - Public Method
    public func show(in view: UIView,scene: JJHintScene) {
        view.addSubview(self)
        self.hintScene = scene
        self.setNeedsUpdateConstraints()
        fillContent(scene: scene)
    }
    public func hide() {
        self.removeFromSuperview()
    }
}

//MARK: - 配置场景元素
enum JJHintScene {
    ///无网络
    case noNetwork
    ///无数据
    case noData
    ///加载失败
    case loadFailure
    
    var image: UIImage? {
        switch self {
        case .noNetwork: return UIImage(named: "hint_noNetwork")
        case .noData: return UIImage(named: "hint_emptyData")
        case .loadFailure: return UIImage(named: "hint_loadFailure")
        }
    }
    var title: String? {
        switch self {
        case .noNetwork: return "网络不给力"
        case .noData: return ""
        case .loadFailure: return ""
        }
    }
    var description: String? {
        switch self {
        case .noNetwork: return "请检查网络或\n去设置里为此APP打开网络后再试"
        case .noData: return "暂无数据"
        case .loadFailure: return "加载失败"
        }
    }
    var buttonTitle: String? {
        switch self {
        case .noNetwork: return "重试"
        case .noData: return "重试"
        case .loadFailure: return "重试"
        }
    }
}
