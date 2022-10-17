//
//  JJYilanLVideoCell.swift
//  PeopleStoryI
//
//  Created by J+ on 2022/10/12.
//

import UIKit

class JJYilanLVideoCell: JJHomeBaseCell {
    static let CellId = "JJYilanLVideoCellId"
    //下图
    lazy var kImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    //时长label
    lazy var videoTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.7)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    //右下角播放图标
    lazy var playCountLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "c_video_play_1"))
        return imageView
    }()
    //播放量label
    lazy var playCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 13)
        return label
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
        //视频占位图
        self.contentView.addSubview(self.kImageView)
        self.kImageView.snp.makeConstraints { make in
            make.left.equalTo(self.leftWhitespace)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.28)
            make.height.equalTo(self.kImageView.snp.width).multipliedBy(0.6)
        }
        //播放时长
        let vtHeight = 18.0
        self.contentView.addSubview(self.videoTimeLabel)
        self.videoTimeLabel.font = .systemFont(ofSize: 12)
        self.videoTimeLabel.snp.makeConstraints { make in
            make.right.equalTo(self.kImageView.snp.right).offset(-5)
            make.bottom.equalTo(self.kImageView.snp.bottom).offset(-5)
            make.height.equalTo(vtHeight)
        }
        
        //右侧文字区域view
        let rightAreaView = UIView()
        self.contentView.addSubview(rightAreaView)
        rightAreaView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(self.topWhitespace)
            make.left.equalTo(self.kImageView.snp.right).offset(5)
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
        
        //播放量
        self.playCountLabel.textAlignment = .left
        rightAreaView.addSubview(self.playCountLabel)
        self.playCountLabel.snp.makeConstraints { make in
            make.left.equalTo(self.kSourceLabel.snp.right).offset(5)
            make.top.bottom.equalTo(self.kSourceLabel)
        }
        
        self.kImageView.layer.cornerRadius = self.cornerWithVideoImage
        self.kImageView.layer.masksToBounds = true
        self.videoTimeLabel.layer.cornerRadius = vtHeight * 0.5
        self.videoTimeLabel.layer.masksToBounds = true
    }
    
    //MARK: - Public Method
    //title:标题 imageLink:视频占位图 videoTime:播放时长 source:作者名称 headPortrait:头像地址 playCount:播放次数
    public func echoContent(title: String?,imageLink: String?,videoDuration: Int? ,author: String?, headPortrait: String?, playCount: Int?) {
        if let value = title {//标题
            self.kTitleLabel.text = value
        }
        if let link = imageLink,let url = URL(string: link) {//图片
            self.kImageView.sd_setImage(with: url)
        }
        if let value = author {//来源
            self.kSourceLabel.text = value
        }
        if let value = headPortrait,let url = URL(string: value) {
            self.kHeadPortrait.sd_setImage(with: url)
        }
        if let value = PTools.convertMillisecondToMinute(ms: videoDuration) {
            self.videoTimeLabel.text = "\(value)\u{3000}"
        }
        if let value = PTools.convertPlayCountFormat(number: playCount) {
            self.playCountLabel.textAlignment = .left
            self.playCountLabel.text = value + "次播放"
            self.playCountLogo.isHidden = false
        } else {
            //未获取到有效播放次数，隐藏播放次数logo
            self.playCountLogo.isHidden = true
        }
    }
}


