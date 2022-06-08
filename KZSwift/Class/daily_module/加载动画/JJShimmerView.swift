//
//  JJShimmerView.swift
//  JJSwift
//
//  Created by J+ on 2022/5/18.
//

import UIKit
class JJShimmerView: UIView {
    
    lazy var animationView: ShimmerVisibleView = {
        let view = ShimmerVisibleView()
        return view
    }()
    
    //MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(self.animationView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        let animationViewH = 80.0
//        let animationViewY = (self.bounds.size.height - animationViewH) / 2.0
//        self.animationView.frame = CGRect(x: 0, y: animationViewY, width: self.bounds.size.width, height: animationViewH)
        //268 / 44
        let imageW = self.bounds.size.width * 0.5
        let imageH = imageW * 44.0 / 268.0;
        let imageX = (self.bounds.size.width - imageW) / 2.0
        let imageY = (self.bounds.size.height - imageH) / 2.0
        self.animationView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
    }
    
    //MARK: - Public Method
    func showInView(of view: UIView,frame: CGRect?) {
        if let frm = frame,frm != .zero {
            self.frame = frm
        } else {
            self.frame = view.bounds
        }
        view.addSubview(self)
    }
    func hide() {
        self.removeFromSuperview()
    }
}

class ShimmerVisibleView: UIView {

    lazy var bgImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "basketball")
        imageV.frame = bounds
        return imageV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "早闻天下事"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 38)
        label.frame = bounds
        return label
    }()
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let bgScale = 235.0/255.0
        let bgColor = UIColor(red: bgScale, green: bgScale, blue: bgScale, alpha: 1.0)
        let fgScale = 200.0/255.0
        let fgColor = UIColor(red: fgScale, green: fgScale, blue: fgScale, alpha: 1.0)
        let colors = [
            bgColor.cgColor,
            fgColor.cgColor,
            fgColor.cgColor,
            bgColor.cgColor
        ]
        layer.colors = colors

        let locations: [NSNumber] = [
             -0.4,
             -0.39,
             -0.24,
             -0.23
        ]
        layer.locations = locations
            
        layer.startPoint = CGPoint(x: 0.0, y: 0.6)
        layer.endPoint = CGPoint(x: 1.0, y: 0.4)
            
        return layer
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.addSubview(self.titleLabel)
        self.addSubview(self.bgImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
//        gradientLayer.mask = self.titleLabel.layer
//        self.titleLabel.frame = gradientLayer.bounds
        gradientLayer.mask = self.bgImageView.layer
        self.bgImageView.frame = gradientLayer.bounds
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.addSublayer(gradientLayer)

        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-0.8,-0.79,-0.64,-0.63]
        gradientAnimation.toValue = [1.5,1.51,1.76,1.77]
        gradientAnimation.duration = 2.0
        gradientAnimation.repeatCount = MAXFLOAT

        gradientLayer.add(gradientAnimation, forKey: nil)
    }
}
