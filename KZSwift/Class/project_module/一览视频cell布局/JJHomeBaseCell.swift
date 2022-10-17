//
//  JJHomeBaseCell.swift
//  PeopleStoryI
//
//  Created by J+ on 2022/4/14.
//  首页cell的父cell，维护一些公用属性或者方法

import UIKit

protocol JJHomeBaseCellDelegate: NSObjectProtocol {
    func dg_closeButtonPressed(withCell cell: JJHomeBaseCell)
}

class JJHomeBaseCell: UITableViewCell {
    
    static let CellRootId = "JJHomeBaseCellId"
    
    weak var delegate: JJHomeBaseCellDelegate?
    
    ///cell左侧留白
    var leftWhitespace = 16.0
    ///cell右侧留白
    var rightWhitespace = 16.0
    ///cell顶部留白
    var topWhitespace = 10.0
    ///cell底部留白
    var bottomWhitespace = 10.0
    ///三图布局中：图片之间的水平间距
    var horizontalImageSpace = 2.0
    ///三图布局中：图片的宽度
    var widthWithSingleImage: Double {
        return (width_screen - (leftWhitespace + rightWhitespace) - horizontalImageSpace * 2) / 3 
    }
    ///三图布局中：图片的高度
    var heightWithSingleImage: Double {
        return widthWithSingleImage * 2 / 3 
    }
    ///三图布局圆角大小
    var cornerWithSingleImage = 10.0
    ///视频占位图圆角大小
    var cornerWithVideoImage = 3.0
    ///作者头像view边长
    let kHeadePortraitSide = 26.0
    
    //标题
    lazy var kTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    //作者头像
    lazy var kHeadPortrait: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    //内容来源
    lazy var kSourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    //播放次数
    lazy var kPlayCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    //关闭按钮
    lazy var closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setImage(UIImage(named: "c_close"), for: .normal)
//        button.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return button
    }()
    //底部线
    lazy var kBottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray.withAlphaComponent(0.4)
        return line
    }()
    
    //MARK: - Override Method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-bottomWhitespace)
            make.right.equalTo(-rightWhitespace)
            make.width.height.equalTo(15)
        }
        
        //底部分割线
        self.contentView.addSubview(self.kBottomLine)
        self.kBottomLine.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.equalTo(self.leftWhitespace)
            make.right.equalTo(-self.rightWhitespace)
            make.height.equalTo(0.3)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Method
    @objc private func closeBtnPressed() {
        KLog(message: "close btn pressed")
        self.delegate?.dg_closeButtonPressed(withCell: self)
    }
}
