//
//  CircularSlider.swift
//  KZSwift
//
//  Created by J+ on 2022/6/17.
//

import UIKit

class CircularSlider: UIControl {

//    public  var value        : CGFloat  = 0.0
    public var value : CGFloat  = 0 {
        didSet {
            self.setNeedsDisplay()
            self.sendActions(for: .valueChanged)
        }
    }
    public  var minimumValue : CGFloat  = 0.0
    public  var maximumValue : CGFloat  = 1.0
    public  var filledColor  : UIColor = .blue
    public  var unfilledColor: UIColor = .lightGray
    private var radius       : CGFloat = 0.0
    private var centerPoint  : CGPoint = .zero

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
        let context1 = UIGraphicsGetCurrentContext()
        
        //unfilled part
        unfilledColor.setFill()
        let contourRect = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: diameter, height: diameter)
        
        guard let context = context1 else { return }
        context.fillEllipse(in: contourRect)
        context.fillPath()
        
        //filled part
        context.beginPath()
        filledColor.setFill()
        let degrees = 360.0 * self.value / valueRange()
        context.addArc(center: centerPoint, radius: radius, startAngle: -Double.pi/2, endAngle: radiansFromDegrees(degrees: degrees) - Double.pi/2, clockwise: false)
        context.addLine(to: centerPoint)
        context.closePath()
        context.fillPath()
    }
    
    //MARK: - Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //!!!: Warning
        //UITouch *touch = [touches anyObject];
        let touch = touches.first
        if let point = touch?.location(in: self),
           containsPoint(point: point) {
            sendActions(for: .touchDown)
            value = valueForPoint(point: point)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
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
