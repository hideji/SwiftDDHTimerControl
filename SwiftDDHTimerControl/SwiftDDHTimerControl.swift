//
//  SwiftDDHTimerControl.swift
//  SwiftDDHTimerControl
//
//  Created by hideji on 2014/10/16.
//  Copyright (c) 2014 hideji. All rights reserved.
//

import UIKit

extension Double {
    var CGFloatValue: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}
extension Int {
    var CGFloatValue: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}
extension Float {
    var CGFloatValue: CGFloat {
        get {
            return CGFloat(self)
        }
    }
}


enum DDHTimerType: Int {
    /**
    *  The ring looks like a clock
    */
    case DDHTimerTypeElements = 0,
    /**
    *  All the elements are equal
    */
    DDHTimerTypeEqualElements,
    /**
    *  The ring is a solid line
    */
    DDHTimerTypeSolid,
    /**
    *  The number of the different types
    */
    DDHTimerTypeNumberOfTypes
    
}

class SwiftDDHTimerControl: UIControl {

    // ：private　　@property (nonatomic, assign)として
    private var currentValue:Float = 0.0
    private var timerCenter:CGPoint = CGPoint(x: 0.0, y: 0.0)
    private var timerElementRect:CGRect = CGRectMake(0,0,0,0)
    private var radius:CGFloat = 0.0
    private var endAngle:CGFloat = 0.0
    private var minutesOrSecondsLabel = UILabel()
    private var staticLableRect:CGRect = CGRectMake(0,0,0,0)
    private var majorShapeLayer:CAShapeLayer = CAShapeLayer()
    private var minorShapeLayer:CAShapeLayer = CAShapeLayer()
    private let maxValue:CGFloat = 60.0
    private let kDDHInsetX: CGFloat = 10.0
    private let kDDHInsetY: CGFloat  = 10.0
    private let kDDHLabelWidth: CGFloat = 40.0
    private let kDDHLabelHeight: CGFloat  = 40.0
    
    // TODO: private ?
    private var fontSize:CGFloat = 0.0
    
    // TODO: public ?
    internal var minutesOrSeconds:Int = 0 {
        didSet(oldMinutesOrSeconds) {
            if (minutesOrSeconds > lroundf(Float(self.maxValue))) {
                self.minutesOrSeconds = lroundf(Float(self.maxValue));
            } else if (minutesOrSeconds < 0) {
                self.minutesOrSeconds = 0;
            }
            
            if (oldMinutesOrSeconds != minutesOrSeconds) {
                self.setNeedsDisplay()
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
                
            }
        }
    }
    
    
    var color = UIColor.greenColor()
    var highlightColor = UIColor.yellowColor()
    var titleLabel = UILabel()
    var ringWidth:CGFloat = 4.0
    
    var dtype:DDHTimerType = .DDHTimerTypeElements
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        minutesOrSecondsLabel.layer.cornerRadius = 6.0
        minutesOrSecondsLabel.clipsToBounds = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .Center
        
        minorShapeLayer = CAShapeLayer()
        majorShapeLayer = CAShapeLayer()
        
        self.layer.addSublayer(minorShapeLayer)
        self.layer.addSublayer(majorShapeLayer)
        
        self.addSubview(titleLabel)
        self.addSubview(minutesOrSecondsLabel)
        
        
    }
    
    
    override func layoutSubviews() {
        var frame = self.frame
        self.timerElementRect = CGRectInset(frame, kDDHInsetX, kDDHInsetY)
        self.radius = CGRectGetWidth(self.timerElementRect) / 2
        
        self.staticLableRect = CGRectInset(self.bounds, kDDHInsetX + CGFloat(floorf(Float(0.18 * frame.size.width))), kDDHInsetY + CGFloat(floorf(Float(0.18 * frame.size.height))))
        self.staticLableRect.origin.y -= CGFloat(floorf(Float(0.1*frame.size.height)))
        self.minutesOrSecondsLabel.frame = staticLableRect
        
        var height:CGFloat = staticLableRect.size.height
        titleLabel.frame = CGRectMake(CGRectGetMinX(staticLableRect), CGRectGetMaxY(staticLableRect) - CGFloat(floorf(Float(0.1 * height))), staticLableRect.size.width, CGFloat(floorf(Float(0.4 * height))))
        titleLabel.textColor = self.color
        
        self.fontSize = CGFloat(ceilf(Float(0.85 * height)))
        
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(floorf(Float(self.fontSize/2.0))))
        
    }
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // FIXME: Objc [NSString stringWithFormat: @"%ld", (long)round(self.minutesOrSeconds)];
        var expression = NSString(format: "%d", self.minutesOrSeconds)
        
        //// TimerElement Drawing
        let startAngle = 3.0 * CGFloat(M_PI) / 2.0
        self.endAngle = CGFloat(self.minutesOrSeconds) * 2.0 * CGFloat(M_PI) / self.maxValue - CGFloat(M_PI_2)
        self.timerCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        let dashLength = 2.0 * self.radius * CGFloat(M_PI) / 2.0 * (self.maxValue - 1.0)
        
        var timerColor = self.highlighted ? self.highlightColor : self.color
        timerColor.setFill()
        
        var timerElementPath = UIBezierPath()
        timerElementPath.addArcWithCenter(self.timerCenter, radius: self.radius, startAngle: startAngle, endAngle: startAngle - 0.01, clockwise: true)
        
        self.majorShapeLayer.fillColor = UIColor.clearColor().CGColor
        self.majorShapeLayer.strokeColor = timerColor.CGColor
        self.majorShapeLayer.lineWidth = self.ringWidth
        self.majorShapeLayer.strokeEnd = CGFloat(self.minutesOrSeconds) / self.maxValue
        
        if (self.dtype == .DDHTimerTypeSolid) {
            if (self.dtype == .DDHTimerTypeElements) {
                // FIXME: あってる？　@[@(dashLength), @(8.76*dashLength)];
                self.majorShapeLayer.lineDashPattern = [dashLength, 8.76*dashLength]
            } else if (self.dtype == .DDHTimerTypeEqualElements) {
                self.majorShapeLayer.lineDashPattern = [dashLength, 0.955*dashLength]
            }
            self.majorShapeLayer.lineDashPhase = 1
        }
        self.majorShapeLayer.path = timerElementPath.CGPath
        
        if (self.dtype == .DDHTimerTypeElements) {
            var timerMinorElementPath = UIBezierPath()
            timerMinorElementPath.addArcWithCenter(self.timerCenter, radius: self.radius, startAngle: startAngle, endAngle: startAngle - 0.01, clockwise: true)
            self.minorShapeLayer.fillColor = UIColor.clearColor().CGColor
            self.minorShapeLayer.strokeColor = timerColor.colorWithAlphaComponent(0.5).CGColor
            self.minorShapeLayer.lineWidth = 1
            self.minorShapeLayer.strokeEnd = CGFloat(self.minutesOrSeconds) / self.maxValue
            // FIXME: 　@[@(dashLength), @(0.955*dashLength)];
            self.minorShapeLayer.lineDashPattern = [dashLength, 0.955*dashLength]
            self.minorShapeLayer.path = timerMinorElementPath.CGPath
        }
        
        var handleRadius = self.userInteractionEnabled ? self.ringWidth : self.ringWidth / 2
        
        var handlePath: Void = UIBezierPath().addArcWithCenter(self.handlePoint(), radius: handleRadius, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
        
        var labelStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        labelStyle.alignment = NSTextAlignment.Center
        
        var labelFontAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: self.fontSize),
            NSForegroundColorAttributeName: self.color,
            NSParagraphStyleAttributeName: labelStyle
        ]
        
        self.minutesOrSecondsLabel.attributedText = NSAttributedString(string: expression, attributes: labelFontAttributes)
        
    }
    
    // MARK: helper methods
    func handlePoint() -> CGPoint {
        let handleAngle = self.endAngle + CGFloat(M_PI_2)
        var handlePoint = CGPointZero
        handlePoint.x = self.timerCenter.x + (self.radius) * sin(Float(handleAngle)).CGFloatValue
        handlePoint.y = self.timerCenter.y - (self.radius) * cosf(Float(handleAngle)).CGFloatValue
        return handlePoint
    }
    
    // MARK: Touch events
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = event.touchesForView(self)?.anyObject() as UITouch
        let position = touch.locationInView(self)
        
        var angleInDegrees = CGFloat(atanf(Float(position.y - self.timerCenter.y) / Float(position.x - self.timerCenter.x))) * 180.0 / CGFloat(M_PI) + 90
        if (position.x < self.timerCenter.x) {
            angleInDegrees += 180;
        }
        
        let selectedMinutesOrSeconds = angleInDegrees * self.maxValue / 360
        self.minutesOrSeconds = lroundf(Float(selectedMinutesOrSeconds))
        
        let handlePoint:CGPoint = self.handlePoint()
        let handlePath = UIBezierPath(arcCenter: handlePoint, radius: 20.0, startAngle: 0.0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
        
        self.highlighted = handlePath.containsPoint(position) ? true : false
        self.currentValue = Float(self.minutesOrSeconds)
        
        //        UIView.animateWithDuration(0.2,
        //            delay: 0.0,
        //            usingSpringWithDamping: 1.0,
        //            initialSpringVelocity: 20.0,
        //            options: nil,
        //            animations: {
        //                self.minutesOrSecondsLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20)
        //            },
        //            completion: {finished in
        //                self.setNeedsDisplay()
        //            })
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.highlighted = false
        
        self.minutesOrSecondsLabel.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(0.2,
            animations: {
                self.minutesOrSecondsLabel.center = CGPointMake(CGRectGetMidX(self.staticLableRect), CGRectGetMidY(self.staticLableRect))
            }, completion: { finished in
                self.setNeedsDisplay()
        })
    }
    
    // MARK: Accessibility
    func isAccessibilityElement() -> Bool {
        return true
    }
    
    func accessibilityValue() -> String {
        return "\(self.minutesOrSecondsLabel.text) \(self.titleLabel.text)"
    }
    
    func accessibilityTraits() -> UIAccessibilityTraits {
        return UIAccessibilityTraitAdjustable
    }
    
    override func accessibilityIncrement() {
        self.minutesOrSeconds = self.minutesOrSeconds + 1;
    }
    
    override func accessibilityDecrement() {
        self.minutesOrSeconds = self.minutesOrSeconds - 1;
    }


}
