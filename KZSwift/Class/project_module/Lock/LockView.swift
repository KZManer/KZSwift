//
//  LockView.swift
//  KZSwift
//
//  Created by J+ on 2022/6/16.
//

import UIKit

protocol LockViewDelegate {
    func dg_pressedMenuBtn()
    func dg_pressedBeginBtn()
}
class LockView: UIView {
    private let kBaseColor = UIColor.rgb(r: 68, g: 147, b: 116)
    var delegate: LockViewDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36)
        return label
    }()
    //MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        doViewUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    private func doViewUI() {
        self.backgroundColor = kBaseColor
        /**导航栏view**/
        let navView = UIView()
        self.addSubview(navView)
        navView.snp.makeConstraints { make in
            make.top.equalTo(KTools.height_status())
            make.left.right.equalTo(0)
            make.height.equalTo(KTools.height_navigation())
        }
        /**菜单按钮*/
        let menuBtn = UIButton(type: .system)
        menuBtn.backgroundColor = .white
        menuBtn.addTarget(self, action: #selector(pressedMenuBtn), for: .touchUpInside)
        navView.addSubview(menuBtn)
        menuBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(KTools.height_navigation() * 0.6)
        }
        /**标题**/
        self.addSubview(titleLabel)
        let titleHorSpace = 20
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(titleHorSpace)
            make.right.equalToSuperview().offset(-titleHorSpace)
            make.height.equalTo(60)
        }
        /**slider**/
        let sliderWidth = 200.0
        let sliderX = (self.frame.size.width - sliderWidth) / 2
        let sliderY = (self.frame.self.height - sliderWidth) / 2
        let sliderFrame = CGRect(x: sliderX, y: sliderY, width: sliderWidth, height: sliderWidth)
        let slider = CircularSlider(frame: sliderFrame)
        slider.filledColor = .hex("#84bd00")
        slider.unfilledColor = .hex("#cbccd1")
        slider.minimumValue = 0
        slider.maximumValue = 120
        slider.value = 10
        slider.addTarget(self, action: #selector(sliderValueDidChange(slider:)), for: .valueChanged)
        self.addSubview(slider)
        /**timeLabel**/
        self.addSubview(timeLabel)
        timeLabel.text = String(format: "%.0f分钟", slider.value)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        /**开始按钮**/
        let beginBtn = UIButton(type: .system)
        beginBtn.setTitleColor(.white, for: .normal)
        beginBtn.setTitle("开始", for: .normal)
        beginBtn.titleLabel?.font = .systemFont(ofSize: 18)
        beginBtn.backgroundColor = .rgb(r: 86, g: 196, b: 153)
        beginBtn.addTarget(self, action: #selector(pressedBeginBtn), for: .touchUpInside)
        self.addSubview(beginBtn)
        beginBtn.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        beginBtn.layer.shadowColor = UIColor.black.cgColor
        beginBtn.layer.shadowOffset = CGSize(width: 0, height:5)
        beginBtn.layer.shadowOpacity = 1
        beginBtn.layer.shadowRadius = 5
        
    }
    @objc func pressedMenuBtn() {
        self.delegate?.dg_pressedMenuBtn()
    }
    @objc func sliderValueDidChange(slider: CircularSlider) {
        timeLabel.text = String(format: "%.0f分钟", slider.value)
    }
    @objc func pressedBeginBtn() {
        self.delegate?.dg_pressedBeginBtn()
    }
    
    //MARK: Publick Method
    func echoTitle(text: String?) {
        if let value = text {
            titleLabel.text = "您今天已经专注了\n\(value)分钟"
        }
    }
}
