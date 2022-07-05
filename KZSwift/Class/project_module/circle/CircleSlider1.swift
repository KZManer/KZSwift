//
//  CircleSlider1.swift
//  KZSwift
//
//  Created by J+ on 2022/7/4.
//

import UIKit

class CircleSlider1: UIControl {

    public var value : CGFloat  = 0 {
        didSet {
            self.setNeedsDisplay()
            self.sendActions(for: .valueChanged)
        }
    }
    public  var minimumValue : CGFloat  = 0.0
    public  var maximumValue : CGFloat  = 360.0
    public  var filledColor  : UIColor = .orange
    public  var unfilledColor: UIColor = .lightGray
    private var radius       : CGFloat = 0.0
    private var centerPoint  : CGPoint = .zero
    private var indicatorRadius = 10.0 //可拖动圆 半径
    private var circleLineWidth = 40.0  //圆 线宽
    private var circleRadius : CGFloat {//圆 半径
        let frameWidth = self.frame.size.width
        let value = frameWidth / 2.0 - indicatorRadius * 2
        return value
    }
    
    //MARK: - Override Method
    override init(frame: CGRect) {
        super.init(frame: frame)
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

        guard let context = UIGraphicsGetCurrentContext() else { return }
        //圆
        context.addArc(center: centerPoint, radius: circleRadius, startAngle: 0, endAngle: Double.pi * 2.0, clockwise: true)
        UIColor.gray.setStroke()
        context.setLineWidth(circleLineWidth)
        context.setLineCap(.butt)
        context.drawPath(using: .stroke)
        
        //进度
        let endAngle = self.value / valueRange() * Double.pi * 2.0
        context.addArc(center: centerPoint, radius: circleRadius, startAngle: 0, endAngle: endAngle, clockwise: false)
        UIColor.red.setStroke()
        context.setLineWidth(circleLineWidth)
        context.setLineCap(.round)
        context.drawPath(using: .stroke)
        
        
        //可拖动圆
        var resultP = CGPoint.zero
        resultP.y = round(centerPoint.y + circleRadius * sin(endAngle))
        resultP.x = round(centerPoint.x + circleRadius * cos(endAngle))
        context.setShadow(offset: CGSize.zero, blur: 3, color: UIColor.blue.cgColor)
//        context.addRect(CGRect(x: resultP.x, y: resultP.y, width: indicatorRadius, height: indicatorRadius))
        UIColor.blue.setStroke()
        context.setLineWidth(indicatorRadius * 2)
        context.addEllipse(in: CGRect(x: resultP.x, y: resultP.y, width: indicatorRadius * 2, height: indicatorRadius * 2))
//        context.addLines(between: [centerPoint,resultP])
        context.drawPath(using: .stroke)
        
        return
        //unfilled part - 外圆
        unfilledColor.setFill()
        let contourRect = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: diameter, height: diameter)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
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
        
//        KLog(message: degrees)
        
        //绘制拖动小圆块
        var result = CGPoint.zero
        result.x = centerPoint.x + (radius-space/2.0) * cos(degrees / 180.0 * Double.pi - Double.pi/2)
        result.y = centerPoint.y + (radius-space/2.0) * sin(degrees / 180.0 * Double.pi - Double.pi/2)
//        KLog(message: result.x)
//        KLog(message: result.y)
        
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
        let touch = touches.first
        
        if let point = touch?.location(in: self) {
            let a = valueForPoint(point: point)
            let b = angleForPoint(endPoint: point)
            KLog(message: a)
            KLog(message: b)
        }
        
        if let point = touch?.location(in: self),
           containsPoint(point: point),
           inPathway(point: point)
        {
            sendActions(for: .touchDown)
//            value = valueForPoint(point: point)
            value = angleForPoint(endPoint: point)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        
        if let point = touch?.location(in: self) {
            if containsPoint(point: point),
               inPathway(point: point)
            {
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
        
        if let point = touch?.location(in: self)
//           inPathway(point: point)
        {
//            value = valueForPoint(point: point)
            value = angleForPoint(endPoint: point)
        }
    }
    
    private func inPathway(point: CGPoint) -> Bool {
        
        let lineWidth = 8.0
        let radiusTemp = radius - lineWidth * 2.0 - lineWidth / 2.0
        
        let x = point.x - centerPoint.x
        let y = point.y - centerPoint.y
        
        let result = sqrt(x*x + y*y)
        
        KLog(message: result)
//        KLog(message: radius)
//        KLog(message: radiusTemp)
        
        var value = true
        if result < radiusTemp {
            value = false
        }
        if result > radius {
            value = false
        }
        KLog(message: value)
        return value
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
    func angleForPoint(endPoint: CGPoint) -> CGFloat {
        var v = CGPoint(x: endPoint.x - centerPoint.x, y: endPoint.y - centerPoint.y)
        let vmag = sqrt(v.x * v.x + v.y * v.y)
        var result = 0.0
        v.x = v.x/vmag
        v.y = v.y/vmag
        let radians = atan2(v.y, v.x)
        result = 180.8 * radians / Double.pi
        let value = result >= 0 ? result : result + 360.0
        return value
    }
    
    //MARK: - Setters
    
}
