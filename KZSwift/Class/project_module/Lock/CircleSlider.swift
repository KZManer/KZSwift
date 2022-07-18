//
//  CircleSlider1.swift
//  KZSwift
//
//  Created by J+ on 2022/7/4.
//

import UIKit

class CircleSlider: UIControl {

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
    private var dragCircleRadius = 10.0 //可拖动圆 半径
    private var circleLineWidth = 40.0  //圆 线宽
    private var circleRadius : CGFloat {//圆 半径
        let frameWidth = self.frame.size.width
        let value = frameWidth / 2.0 - dragCircleRadius * 2
        return value
    }
    private var dragCircleRect: CGRect {
        let endAngle = self.value / valueRange() * Double.pi * 2.0
        let x = round(centerPoint.x + circleRadius * cos(endAngle))
        let y = round(centerPoint.y + circleRadius * sin(endAngle))
        let side = dragCircleRadius * 2
        return CGRect(x: x - side/2.0, y: y - side/2.0, width: side, height: side)
    }//可拖动圆frame
    private var canMove: Bool = false//记录是否可以拖动圆
    
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
        self.backgroundColor = .clear
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
        UIColor.lightGray.setStroke()
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
        context.setShadow(offset: CGSize.zero, blur: 3, color: UIColor.blue.cgColor)
//        context.addRect(dragCircleRect)
        UIColor.blue.setStroke()
        context.setLineWidth(dragCircleRadius * 2)
        context.addEllipse(in: dragCircleRect)
        context.drawPath(using: .stroke)
        
//        //圆心到拖动圆圆心之间的线
//        var resultP = CGPoint.zero
//        resultP.y = round(centerPoint.y + circleRadius * sin(endAngle))
//        resultP.x = round(centerPoint.x + circleRadius * cos(endAngle))
//        context.setLineWidth(5.0)
//        UIColor.blue.setStroke()
//        context.addLines(between: [centerPoint,resultP])
//        context.drawPath(using: .stroke)
        
        
    }
    
    //MARK: - Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        
//        if let point = touch?.location(in: self) {
//            let a = valueForPoint(point: point)
//            let b = angleForPoint(endPoint: point)
//            KLog(message: a)
//            KLog(message: b)
//        }
        
        if let point = touch?.location(in: self),inDragCircle(point: point) {
            canMove = true
            sendActions(for: .touchDown)
            value = angleForPoint(endPoint: point)
        }
        
//        if let point = touch?.location(in: self),
//           containsPoint(point: point),
//           inPathway(point: point)
//        {
//            sendActions(for: .touchDown)
////            value = valueForPoint(point: point)
//            value = angleForPoint(endPoint: point)
//        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        canMove = false
        if let point = touch?.location(in: self) {
            if containsPoint(point: point),
               inPathway(point: point) {
                sendActions(for: .touchUpInside)
            } else {
                sendActions(for: .touchUpOutside)
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        canMove = false
        sendActions(for: .touchCancel)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        
        if let point = touch?.location(in: self),canMove
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
        
//        KLog(message: result)
//        KLog(message: radius)
//        KLog(message: radiusTemp)
        
        var value = true
        if result < radiusTemp {
            value = false
        }
        if result > radius {
            value = false
        }
//        KLog(message: value)
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
    //判断手指点击的点是否在可拖动圆内
    private func inDragCircle(point: CGPoint) -> Bool {
        var inFrame = false
        KLog(message: "\(point.x) - \(point.y)")
        KLog(message: "\(dragCircleRect.origin.x) - \(dragCircleRect.origin.y) - \(dragCircleRect.width) - \(dragCircleRect.height)")
        let dragMinX = dragCircleRect.origin.x
        let dragMaxX = dragMinX + dragCircleRect.width
        let dragMinY = dragCircleRect.origin.y
        let dragMaxY = dragMinY + dragCircleRect.height
        if point.x >= dragMinX && point.x <= dragMaxX && point.y >= dragMinY && point.y <= dragMaxY {
            inFrame = true
        }
        KLog(message: inFrame)
        return inFrame
    }
    
    //MARK: - Setters
    
}
