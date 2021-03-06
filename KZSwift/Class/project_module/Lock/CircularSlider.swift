//
//  CircularSlider.swift
//  KZSwift
//
//  Created by J+ on 2022/6/17.
//

import UIKit

class CircularSlider: UIControl {

    public var value : CGFloat  = 0 {
        didSet {
            KLog(message: value)
            self.setNeedsDisplay()
            self.sendActions(for: .valueChanged)
        }
    }
    public  var minimumValue : CGFloat  = 0.0
    public  var maximumValue : CGFloat  = 1.0
    public  var filledColor  : UIColor = .orange
    public  var unfilledColor: UIColor = .lightGray
    private var radius       : CGFloat = 0.0
    private var centerPoint  : CGPoint = .zero

    lazy var circleView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        let value = 30.0
        imageView.frame = CGRect(x: self.frame.size.width/2.0-value/2.0, y: 0, width: value, height: value)
        return imageView
    }()
    
    //MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.addSubview(circleView)
//        circleView.layer.cornerRadius = 15
        doDefaults()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doDefaults()
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    func doDefaults() {
        self.backgroundColor = .orange
    }
    //MARK: - Layout
    override func layoutSubviews() {
        let halfWidth = self.frame.size.width / 2.0
        let halfHeight = self.frame.size.height / 2.0
        radius = halfWidth > halfHeight ? halfHeight : halfWidth
        centerPoint = CGPoint(x: halfWidth, y: halfHeight)
    }
    //MARK: - UI
    override func draw(_ rect: CGRect) {
        let diameter = radius * 2.0
        let context1 = UIGraphicsGetCurrentContext()

        //unfilled part - 外圆
        unfilledColor.setFill()
        let contourRect = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: diameter, height: diameter)
        
        guard let context = context1 else { return }
        context.fillEllipse(in: contourRect)
        context.fillPath()
        
        //filled part
        context.beginPath()
        filledColor.setFill()
        let degrees = 360.0 * self.value / valueRange()
//        context.addArc(center: centerPoint, radius: radius, startAngle: -Double.pi/2, endAngle: radiansFromDegrees(degrees: degrees) - Double.pi/2, clockwise: false)
        context.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: Double.pi/2, clockwise: false)
        context.addLine(to: centerPoint)
        context.closePath()
        context.fillPath()
        
        //内圆
        let space = 5.0
        let innerCircleX = centerPoint.x - radius + space
        let innerCircleY = centerPoint.y - radius + space
        let innerCircleW = diameter - space * 2
        let innerCircleRect = CGRect(x: innerCircleX, y: innerCircleY, width: innerCircleW, height: innerCircleW)
        LockTools.baseColor().setFill()
        context.fillEllipse(in: innerCircleRect)
        context.fillPath()
        
        KLog(message: degrees)
        
        //绘制拖动小圆块
        var result = CGPoint.zero
        result.x = centerPoint.x + (radius-space/2.0) * cos(degrees / 180.0 * Double.pi - Double.pi/2)
        result.y = centerPoint.y + (radius-space/2.0) * sin(degrees / 180.0 * Double.pi - Double.pi/2)
        KLog(message: result.x)
        KLog(message: result.y)
        
        UIColor.red.setStroke()
        context.setLineWidth(15)
//        context.addRect(CGRect(x: result.x, y: result.y, width: 10, height: 10))
        context.addEllipse(in: CGRect(x: result.x, y: result.y, width: 15, height: 15))
        context.drawPath(using: .stroke)
    }
    
    //MARK: - Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //!!!: Warning
        //UITouch *touch = [touches anyObject];
        let touch = touches.first

        if let value = touch?.location(in: self.circleView) {
//            KLog(message: "\(value.x) - \(value.y)")
            let a = self.circleView.layer.contains(value)
//            KLog(message: a)
        }
//        if let point = touch?.location(in: self.circleView),
//           let movePoint = touch?.location(in: self),
//           self.circleView.layer.contains(point) {
//            sendActions(for: .touchDown)
//            value = valueForPoint(point: movePoint)
//        }
        
        if let point = touch?.location(in: self),
           containsPoint(point: point) {
            sendActions(for: .touchDown)
            value = valueForPoint(point: point)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        
//        if let point = touch?.location(in: self.circleView) {
//            if self.circleView.layer.contains(point) {
//                sendActions(for: .touchUpInside)
//            } else {
//                sendActions(for: .touchUpOutside)
//            }
//        }
        
        if let point = touch?.location(in: self) {
            if containsPoint(point: point) {
                sendActions(for: .touchUpInside)
            } else {
                sendActions(for: .touchUpOutside)
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        sendActions(for: .touchCancel)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        
//        if let point = touch?.location(in: self.circleView),
//           let movePoint = touch?.location(in: self),
//           self.circleView.layer.contains(point) {
//            value = valueForPoint(point: movePoint)
//        }
        
        if let point = touch?.location(in: self) {
            value = valueForPoint(point: point)
        }
    }
    
    //MARK: - Helpers
    func valueRange() -> CGFloat {
        return maximumValue - minimumValue
    }
    func containsPoint(point: CGPoint) -> Bool {
        let distance = sqrtf(powf(Float(point.x - centerPoint.x), 2)+powf(Float(point.y-centerPoint.y), 2))
        return distance <= Float(radius)
    }
    func radiansFromDegrees(degrees: CGFloat) -> CGFloat {
        return degrees * Double.pi / 180.0
    }
    func degreesFromRadians(radians: CGFloat) -> CGFloat {
        return radians * 180.0 / Double.pi
    }
    func valueForPoint(point: CGPoint) -> CGFloat {
        let atan = atan2f(Float(point.x - centerPoint.x), Float(point.y - centerPoint.y))
        var degrees = -(degreesFromRadians(radians: CGFloat(atan)) - 180.0)
        if degrees < 0 {
            degrees = 360.0 + degrees
        }
        return degrees / 360.0 * valueRange()
    }
    
    //MARK: - Setters
    
}
