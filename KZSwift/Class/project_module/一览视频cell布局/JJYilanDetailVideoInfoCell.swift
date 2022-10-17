//
//  JJYilanDetailVideoInfoCell.swift
//  PeopleStoryI
//
//  Created by J+ on 2022/10/14.
//  一览详情页视频信息cell（标题+播放次数...）

import UIKit

class JJYilanDetailVideoInfoCell: JJHomeBaseCell {
    static let CellId = "JJYilanDetailVideoInfoCellId"
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    //MARK: - Override Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        doViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Method
    private func doViewUI() {
        //箭头
        self.contentView.addSubview(self.arrowImageView)
        self.arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(self.topWhitespace)
            make.right.equalTo(-self.topWhitespace)
            make.width.height.equalTo(10)
        }
        //标题
        self.contentView.addSubview(self.kTitleLabel)
        self.kTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.topWhitespace)
            make.left.equalTo(self.leftWhitespace)
            make.right.equalTo(arrowImageView.snp.left).offset(-rightWhitespace)
        }
        //播放次数
        self.contentView.addSubview(self.kPlayCountLabel)
        self.kPlayCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.kTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(kTitleLabel)
            make.bottom.equalTo(self.kBottomLine.snp.bottom).offset(-bottomWhitespace)
            make.right.equalTo(-self.rightWhitespace)
        }
    }
    
    //MARK: - Public Method
    public func echoContent(title: String?, playCount: Int?, unfold: Bool) {
        self.kTitleLabel.numberOfLines = unfold ? 3 : 1
        let imageName = unfold ? "c_arrow_up" : "c_arrow_down"
        arrowImageView.image = UIImage(named: imageName)
        
        if let value = title {
            self.kTitleLabel.text = value
        }
        if let value = PTools.convertPlayCountFormat(number: playCount) {
            self.kPlayCountLabel.text = value + "次播放"
        }
    }
}
