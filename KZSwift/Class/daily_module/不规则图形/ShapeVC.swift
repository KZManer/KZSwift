//
//  ShapeVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/25.
//

import UIKit

class ShapeVC: RootHomeVC {

    lazy var sliderView: UISlider = {
        let view = UISlider()
        view.addTarget(self, action: #selector(valueChanged(slider:)), for: .valueChanged)
        return view
    }()
    lazy var baseView: ShapeView = {
        let view = ShapeView(frame: .zero)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startItem = UIBarButtonItem(title: "start", style: .plain, target: self, action: #selector(startAnimation))
        self.navigationItem.rightBarButtonItem = startItem
        
        self.sliderView.frame = CGRect(x: 100, y: 80, width: width_screen - 200, height: 10)
        self.view.addSubview(self.sliderView)
        
        self.baseView.frame = CGRect(x: 100, y: self.sliderView.frame.size.height + self.sliderView.frame.origin.y + 80, width: 100, height: 70)
        self.view.addSubview(baseView)
    }
    @objc func valueChanged(slider: UISlider) {
        self.baseView.changeShape(scale: slider.value)
    }
    @objc func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotationAnimation.toValue = NSNumber(floatLiteral: Double.pi * 2)
        rotationAnimation.duration = 5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        self.baseView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

class ShapeView: UIView {
    var scale: Double = 0
    let ltPoint = CGPoint(x: 0, y: 20)
    let lbPoint = CGPoint(x: 0, y: 70)
    let rbPoint = CGPoint(x: 100, y: 50)
    let rtPoint = CGPoint(x: 100, y: 0)
    var leftYSpace: Double {
        get { return lbPoint.y - ltPoint.y }
    }
    var rightYSpace: Double {
        get { return rbPoint.y - rtPoint.y }
    }
    var ltp: CGPoint {
        get {
            if self.scale < 0.5 {
                return ltPoint
            }
            return CGPoint(x: ltPoint.x, y: ltPoint.y + leftYSpace * (self.scale - 0.5) * 2)
        }
    }
    var lbp: CGPoint {
        get {
            if self.scale < 0.5 {
                return lbPoint
            }
            return CGPoint(x: lbPoint.x, y: lbPoint.y - leftYSpace * (self.scale - 0.5) * 2)
        }
    }
    var rbp: CGPoint {
        get {
            if self.scale > 0.75 {
                return rtPoint
            } else if self.scale > 0.5 {
                return CGPoint(x: rbPoint.x, y: rbPoint.y - rightYSpace * (self.scale + (self.scale - 0.5)))
            }
            return CGPoint(x: rbPoint.x, y: rbPoint.y - rightYSpace * self.scale)
        }
    }
    var rtp: CGPoint {
        get {
            if self.scale > 0.75 {
                return rbPoint
            } else if self.scale > 0.5 {
                return CGPoint(x: rtPoint.x, y: rtPoint.y + rightYSpace * (self.scale + (self.scale - 0.5)))
            }
            return CGPoint(x: rtPoint.x, y: rtPoint.y + rightYSpace * self.scale)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let color = UIColor.red
        color.set()
        
        let aPath = UIBezierPath()
        aPath.lineWidth = 2
        
        aPath.lineCapStyle = .round
        aPath.lineJoinStyle = .round
        
        //起点
        aPath.move(to: ltp)
        //绘制线条
        aPath.addLine(to: lbp)
        aPath.addLine(to: rbp)
        aPath.addLine(to: rtp)
        aPath.close()
        
        aPath.stroke()
        
    }
    func changeShape(scale: Float) {
//        KLog(message: scale)
        self.scale = Double(scale)
        setNeedsDisplay()
        KLog(message: ltp.y)
    }
}
