//
//  JJYilanVideoCell.swift
//  PeopleStoryI
//
//  Created by J+ on 2022/10/10.
//  一览视频

import UIKit
import SDWebImage

class JJYilanVideoCell: JJHomeBaseCell {
    static let CellId = "JJYilanVideoCellId"
    //下图
    lazy var kImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    //时长label
    lazy var videoTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.8)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    //播放次数图标
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
        //标题
        self.contentView.addSubview(self.kTitleLabel)
        self.kTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.topWhitespace)
            make.left.equalTo(self.leftWhitespace)
            make.right.equalTo(-self.rightWhitespace)
        }
        //视频占位图
        self.contentView.addSubview(self.kImageView)
        self.kImageView.snp.makeConstraints { make in
            make.top.equalTo(self.kTitleLabel.snp.bottom).offset(5)
            make.left.right.equalTo(self.kTitleLabel)
            make.height.equalTo(self.kImageView.snp.width).multipliedBy(0.5)
        }
        //中间播放图标
        let playImageView = UIImageView(image: UIImage(named: "c_video_play"))
        self.kImageView.addSubview(playImageView)
        playImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(self.kImageView.snp.height).multipliedBy(0.3)
        }
        //播放时长
        let vtHeight = 24.0
        self.contentView.addSubview(self.videoTimeLabel)
        self.videoTimeLabel.snp.makeConstraints { make in
            make.right.equalTo(self.kImageView.snp.right).offset(-10)
            make.bottom.equalTo(self.kImageView.snp.bottom).offset(-10)
            make.height.equalTo(vtHeight)
        }
        //作者头像
        self.contentView.addSubview(self.kHeadPortrait)
        self.kHeadPortrait.snp.makeConstraints { make in
            make.top.equalTo(self.kImageView.snp.bottom).offset(10)
            make.left.equalTo(self.kTitleLabel)
            make.width.height.equalTo(self.kHeadePortraitSide)
            make.centerY.equalTo(self.closeBtn)
        }
        //一览logo
        let yilanLogo = UIImageView(image: UIImage(named: "th_yilan_logo"))
        self.contentView.addSubview(yilanLogo)
        yilanLogo.snp.makeConstraints { make in
            make.bottom.equalTo(self.kHeadPortrait)
            make.centerX.equalTo(self.kHeadPortrait.snp.right)
            make.width.height.equalTo(10)
        }
        //来源
        self.contentView.addSubview(self.kSourceLabel)
        self.kSourceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.kHeadPortrait)
            make.left.equalTo(yilanLogo.snp.right).offset(3)
        }
        //播放次数图标
        let plHeight = 12.0; let plWidth = 50.0 * plHeight / 44.0
        self.contentView.addSubview(self.playCountLogo)
        self.playCountLogo.snp.makeConstraints { make in
            make.right.equalTo(self.closeBtn.snp.left).offset(-5)
            make.centerY.equalTo(self.closeBtn)
            make.height.equalTo(plHeight)
            make.width.equalTo(plWidth)
        }
        //播放量
        self.contentView.addSubview(self.playCountLabel)
        self.playCountLabel.snp.makeConstraints { make in
            make.right.equalTo(self.playCountLogo.snp.left).offset(-5)
            make.centerY.equalTo(self.playCountLogo)
            make.left.equalTo(self.kSourceLabel.snp.right).offset(5)
        }

//        self.contentView.layoutIfNeeded()
        self.kImageView.layer.cornerRadius = self.cornerWithVideoImage
        self.kImageView.layer.masksToBounds = true
        self.kHeadPortrait.layer.cornerRadius = self.kHeadePortraitSide * 0.5
        self.kHeadPortrait.layer.masksToBounds = true
        self.videoTimeLabel.layer.cornerRadius = vtHeight * 0.5
        self.videoTimeLabel.layer.masksToBounds = true
    }
    
    //MARK: - Public Method
    //title:标题 imageLink:视频占位图 videoTime:播放时长 source:作者名称 headPortrait:头像地址 playCount:播放次数
    public func echoContent(title: String?,imageLink: String?,videoTime: Int? ,source: String?, headPortrait: String?, playCount: Int?) {
        if let value = title {//标题
            self.kTitleLabel.text = value
        }
        if let link = imageLink,let url = URL(string: link) {//图片
            self.kImageView.sd_setImage(with: url)
        }
        if let value = source {//来源
            self.kSourceLabel.text = value
        }
        if let value = headPortrait,let url = URL(string: value) {
            self.kHeadPortrait.sd_setImage(with: url)
        }
        if let value = convertMillisecondToMinute(ms: videoTime) {
            self.videoTimeLabel.text = "\(value)\u{3000}"
        }
        if let value = convertPlayCountFormat(number: playCount) {
            self.playCountLabel.text = value + "次播放"
            self.playCountLogo.isHidden = false
        } else {
            //未获取到有效播放次数，隐藏播放次数logo
            self.playCountLogo.isHidden = true
        }
    }
    //毫秒转换为00:00格式
    public func convertMillisecondToMinute(ms: Int?) -> String? {
        guard let millisecond = ms else { return nil }
        let second = millisecond / 1000
        var minutePosition = String(second / 60)
        var secondPosition = String(second % 60)
        if minutePosition.count == 1 {
            minutePosition = "0" + minutePosition
        }
        if secondPosition.count == 1 {
            secondPosition = "0" + secondPosition
        }
        return minutePosition + ":" + secondPosition
    }
    //播放次数转化，小于10000展示实际数据。大于10000以万为单位展示，保留小数点后一位，向下取整
    public func convertPlayCountFormat(number: Int?) -> String? {
        guard let numInt = number, numInt > 0 else { return nil }
        let divisionNum = 10000
        if numInt < divisionNum {
            return "\(numInt)"
        }
        let integetPart  = numInt / divisionNum
        var decimalsPart = numInt % divisionNum
        if decimalsPart > 0 {
            decimalsPart = decimalsPart / 1000
        }
        return "\(integetPart).\(decimalsPart)万"
    }
}

