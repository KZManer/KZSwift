//
//  JJAdLImageRTextCell.swift
//  PeopleStoryI
//
//  Created by J+ on 2022/10/15.
//

import UIKit

class JJAdLImageRTextCell: JJHomeBaseCell {
    static let CellId = "JJAdLImageRTextCellId"
    //左图
    lazy var kImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    //广告logo1
    lazy var adLogoImageView1: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    //广告logo2
    lazy var adLogoImageView2: UIImageView = {
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
        //占位图
        self.contentView.addSubview(self.kImageView)
        self.kImageView.snp.makeConstraints { make in
            make.left.equalTo(self.leftWhitespace)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.28)
            make.height.equalTo(self.kImageView.snp.width).multipliedBy(0.6)
        }
        //广告logo2
        self.kImageView.addSubview(self.adLogoImageView2)
        self.adLogoImageView2.snp.makeConstraints { make in
            make.right.bottom.equalTo(self.kImageView)
            make.width.equalTo(28)
            make.height.equalTo(14)
        }
        //广告logo1
        self.kImageView.addSubview(self.adLogoImageView1)
        self.adLogoImageView1.snp.makeConstraints { make in
            make.top.height.equalTo(self.adLogoImageView2)
            make.right.equalTo(self.adLogoImageView2.snp.left)
            make.width.equalTo(14)
        }
        
        //右侧文字区域view
        let rightAreaView = UIView()
        self.contentView.addSubview(rightAreaView)
        rightAreaView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(self.topWhitespace)
            make.left.equalTo(self.kImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-self.rightWhitespace)
            make.bottom.equalTo(self.contentView).offset(-self.bottomWhitespace)
            make.height.greaterThanOrEqualTo(self.kImageView.snp.height).offset(5)
        }
        
        //标题
        self.kTitleLabel.numberOfLines = 3
        rightAreaView.addSubview(self.kTitleLabel)
        self.kTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(rightAreaView)
        }
        
        //标题与来源中间的填充view
        let fillView = UIView()
        rightAreaView.addSubview(fillView)
        fillView.snp.makeConstraints { make in
            make.left.right.equalTo(rightAreaView)
            make.top.equalTo(self.kTitleLabel.snp.bottom)
        }
        
        //来源
        rightAreaView.addSubview(self.kSourceLabel)
        self.kSourceLabel.snp.makeConstraints { make in
            make.left.equalTo(self.kTitleLabel)
            make.top.equalTo(fillView.snp.bottom).offset(5)
            make.bottom.equalTo(rightAreaView)
        }
        
        self.kImageView.layer.cornerRadius = self.cornerWithVideoImage
        self.kImageView.layer.masksToBounds = true
    }
    
    //MARK: - Public Method
    //title:标题 imageLink:视频占位图 videoTime:播放时长 source:作者名称
    public func echoContent(title: String?, imageLink: String?, author: String?, logoLink1: String?, logoLink2: String?) {
        if let value = title {//标题
            self.kTitleLabel.text = value
        }
        if let link = imageLink,let url = URL(string: link) {//图片
            self.kImageView.sd_setImage(with: url)
        }
        if let value = author {//来源
            self.kSourceLabel.text = value
        }
        if let link = logoLink1, let url = URL(string: link) {
            self.adLogoImageView1.sd_setImage(with: url)
        }
        if let link = logoLink2, let url = URL(string: link) {
            self.adLogoImageView2.sd_setImage(with: url)
        }
    }
}

