//
//  JJAdTopTextThreeImageCell.swift
//  PeopleStoryI
//
//  Created by J+ on 2022/9/23.
//  广告：上文下图（三张图）布局

import UIKit
import SnapKit
import SwiftUI

class JJAdTopTextThreeImageCell: JJHomeBaseCell {

    static let CellId = "JJAdTopTextThreeImageCellId"
    var imageViewArray = [UIImageView]()
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
    func doViewUI() {
        //标题
        self.contentView.addSubview(self.kTitleLabel)
        self.kTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.topWhitespace)
            make.left.equalTo(self.leftWhitespace)
            make.right.equalTo(-self.rightWhitespace)
        }
        
        /*存放三张图的父view：单独设置第一张图的左上左下圆角，第三张图的右上右下圆角，会使imageView布局错乱，目前分析是SnapKit导致的问题，直接设置frame的时候没有问题，但是用SnapKit布局的时候，加上layoutIfNeed也无法解决
         目前使用一张baseView包裹三个imageView。设置baseView的4个角为圆角，效果同上
         */
        let baseView = UIView()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.top.equalTo(self.kTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.leftWhitespace)
            make.right.equalTo(-self.rightWhitespace)
            make.height.equalTo(Int(self.heightWithSingleImage))
        }
        //第一张图
        let firstImageView = UIImageView()
        firstImageView.contentMode = .scaleToFill
        baseView.addSubview(firstImageView)
        firstImageView.snp.makeConstraints { make in
            make.top.left.equalTo(0)
            make.width.equalTo(self.widthWithSingleImage)
            make.height.equalTo(baseView)
        }
        //第二张图
        let secondImageView = UIImageView()
        secondImageView.contentMode = .scaleToFill
        baseView.addSubview(secondImageView)
        secondImageView.snp.makeConstraints { make in
            make.top.width.height.equalTo(firstImageView)
            make.left.equalTo(firstImageView.snp.right).offset(self.horizontalImageSpace)
        }
        //第三张图
        let thirdImageView = UIImageView()
        thirdImageView.contentMode = .scaleToFill
        baseView.addSubview(thirdImageView)
        thirdImageView.snp.makeConstraints { make in
            make.top.width.height.equalTo(secondImageView)
            make.left.equalTo(secondImageView.snp.right).offset(self.horizontalImageSpace)
        }
        self.imageViewArray.append(firstImageView)
        self.imageViewArray.append(secondImageView)
        self.imageViewArray.append(thirdImageView)
        //来源
        self.contentView.addSubview(self.kSourceLabel)
        self.kSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.bottom).offset(10)
            make.left.equalTo(self.leftWhitespace)
            make.bottom.equalTo(-self.bottomWhitespace)
//            make.right.equalTo(-self.rightWhitespace)
        }
        //广告logo1
        self.contentView.addSubview(self.adLogoImageView1)
        self.adLogoImageView1.snp.makeConstraints { make in
            make.centerY.equalTo(self.kSourceLabel)
            make.left.equalTo(self.kSourceLabel.snp.right).offset(5)
            make.height.width.equalTo(14)
        }
        //广告logo2
        self.contentView.addSubview(self.adLogoImageView2)
        self.adLogoImageView2.snp.makeConstraints { make in
            make.centerY.equalTo(self.adLogoImageView1)
            make.left.equalTo(self.adLogoImageView1.snp.right)
            make.width.equalTo(28)
            make.height.equalTo(self.adLogoImageView1)
        }
        //删除按钮
        self.closeBtn.isHidden = false
        
        self.contentView.layoutIfNeeded()
        baseView.layer.cornerRadius = self.cornerWithSingleImage
        baseView.clipsToBounds = true
    }
    
    //MARK: - Public Method
    func echoContent(title: String?, imageLinks: [String]?, source: String?, logoLink1: String?, logoLink2: String?) {
        if let value = title {//标题
            self.kTitleLabel.text = value
        }
        if let values = imageLinks {
            //三张图
            for (index,value) in values.enumerated() {
                let url = URL(string: value)
                if index < 3 {
                    let imageView = self.imageViewArray[index]
                    imageView.sd_setImage(with: url)
                }
            }
        }
        if let value = source {//来源
            self.kSourceLabel.text = value
        }
        if let value = logoLink1 {
            self.adLogoImageView1.sd_setImage(with: URL(string: value))
        }
        if let value = logoLink2 {
            self.adLogoImageView2.sd_setImage(with: URL(string: value))
        }
    }
}
