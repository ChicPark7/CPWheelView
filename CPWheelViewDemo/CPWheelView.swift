//
//  CPWheelView.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 2/2/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

public class CPWheelViewUnit: NSObject {
    let view: UIView
    var position: CGFloat
    public init(view: UIView, position: CGFloat) {
//        super.init()
        self.view = view
        self.position = position
    }
}

public class CPWheelView: UIView {
    public var decellerateRate: CGFloat = 0.5
    var currentOffset: CGFloat = 0.0
    var lastTouchY: CGFloat = 0.0
    var viewArray: [CPWheelViewUnit] = [CPWheelViewUnit]()
    let max = 30
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let panGesture = UIPanGestureRecognizer(target: self, action: "onPan:")
        panGesture.minimumNumberOfTouches = 1
        var transformPerspective = CATransform3DIdentity
        transformPerspective.m34 = -1 / 500.0
        self.layer.sublayerTransform = transformPerspective
        
        
//        CATransform3D transformPerspective = CATransform3DIdentity;
//        transformPerspective.m34 = -1.0 / 500.0;
//        self.layer.sublayerTransform = transformPerspective;

        self.addGestureRecognizer(panGesture)
        for i in 0...max {
            let view = UILabel(frame: CGRectMake(0, 0, 100, 50))
            view.text = "\(i)"
            view.backgroundColor = UIColor.greenColor()
            viewArray.append(CPWheelViewUnit(view: view, position: CGFloat(i)))
            view.tag = i
            view.center = self.pointOnCircle(Float(180), center: self.center, index: CGFloat(i))
            self.addSubview(view)
        }
    }
    func createBezierPath() -> UIBezierPath {
        
        // create a new path
        let path = UIBezierPath()
        
        // starting point for the path (bottom left)
        path.moveToPoint(CGPoint(x: 2, y: 26))
        
        // *********************
        // ***** Left side *****
        // *********************
        
        // segment 1: line
        path.addLineToPoint(CGPoint(x: 2, y: 15))
        
        // segment 2: curve
        path.addCurveToPoint(CGPoint(x: 0, y: 12), // ending point
            controlPoint1: CGPoint(x: 2, y: 14),
            controlPoint2: CGPoint(x: 0, y: 14))
        
        // segment 3: line
        path.addLineToPoint(CGPoint(x: 0, y: 2))
        
        // *********************
        // ****** Top side *****
        // *********************
        
        // segment 4: arc
        path.addArcWithCenter(CGPoint(x: 2, y: 2), // center point of circle
            radius: 2, // this will make it meet our path line
            startAngle: CGFloat(M_PI), // π radians = 180 degrees = straight left
            endAngle: CGFloat(3*M_PI_2), // 3π/2 radians = 270 degrees = straight up
            clockwise: true) // startAngle to endAngle goes in a clockwise direction
        
        // segment 5: line
        path.addLineToPoint(CGPoint(x: 8, y: 0))
        
        // segment 6: arc
        path.addArcWithCenter(CGPoint(x: 8, y: 2),
            radius: 2,
            startAngle: CGFloat(3*M_PI_2), // straight up
            endAngle: CGFloat(0), // 0 radians = straight right
            clockwise: true)
        
        // *********************
        // ***** Right side ****
        // *********************
        
        // segment 7: line
        path.addLineToPoint(CGPoint(x: 10, y: 12))
        
        // segment 8: curve
        path.addCurveToPoint(CGPoint(x: 8, y: 15), // ending point
            controlPoint1: CGPoint(x: 10, y: 14),
            controlPoint2: CGPoint(x: 8, y: 14))
        
        // segment 9: line
        path.addLineToPoint(CGPoint(x: 8, y: 26))
        
        // *********************
        // **** Bottom side ****
        // *********************
        
        // segment 10: line
        path.closePath() // draws the final line to close the path
        
        return path
    }
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let path = createBezierPath()
        // fill
        let fillColor = UIColor.whiteColor()
        fillColor.setFill()
        
        // stroke
        path.lineWidth = 1.0
        let strokeColor = UIColor.blueColor()
        strokeColor.setStroke()
        
        // Move the path to a new location
        path.applyTransform(CGAffineTransformMakeTranslation(10, 10))
        
        // fill and stroke the path (always do these last)
        path.fill()
        path.stroke()

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0...max {
            let item = viewArray[i]
            item.view.center = self.pointOnCircle(Float(180), center: self.center, index: CGFloat(i))
            item.view.backgroundColor = UIColor.greenColor()
        }
    }
    
    func onPan(panGesture: UIPanGestureRecognizer) {
        switch (panGesture.state) {
        case .Began:
            print("=====================================================================================================")
            lastTouchY = panGesture.translationInView(self).y
            print(self.viewArray[0].position)
            break
        case .Changed:
            currentOffset = (lastTouchY - panGesture.translationInView(self).y) / 100
            print(currentOffset)
            for i in 0...max {
                let item = viewArray[i]
                let offset = item.position + currentOffset
                item.view.center = self.pointOnCircle(Float(180), center: self.center, index: offset)
//                let centerOffset = 1 - abs(offset - CGFloat(self.viewArray.count / 2)) / 100
//                item.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, centerOffset, centerOffset)
//                if (i == 0) {
//                    print(centerOffset)
//                }
            }
            break
        case .Ended:
            currentOffset = round((lastTouchY - panGesture.translationInView(self).y) / 100)
//            let animationOptions: UIViewAnimationOptions = .CurveEaseOut
//            let keyframeAnimationOptions: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
            let allDuration: CGFloat = 0.9
            for i in 0...self.max {

                let item = self.viewArray[i]
                let currentViewIndex = item.position + currentOffset
                let midIndex = CGFloat(self.viewArray.count / 2)
                let nextIndex = round((currentViewIndex) - panGesture.velocityInView(self).y / 500)

                let destPosition = self.pointOnCircle(Float(180), center: self.center, index: nextIndex)
                let midPosition = self.pointOnCircle(Float(180), center: self.center, index: midIndex)
                
                let needPassbyMid = (midIndex >= currentViewIndex) != (midIndex >= nextIndex) && currentViewIndex != midIndex && nextIndex != midIndex
                if needPassbyMid {
                    print(needPassbyMid, currentViewIndex, nextIndex)
                }
                let originToMidDistance = self.distanceBetweenPoints(item.view.center, midPosition)
                let midToDestDistance = self.distanceBetweenPoints(midPosition, destPosition)
                
                let originToMidDuration = allDuration * (originToMidDistance / (originToMidDistance + midToDestDistance))
                if (needPassbyMid) {
                    UIView.animateWithDuration(Double(originToMidDuration), delay: 0, options: .CurveLinear, animations: { () -> Void in
                        item.view.center = midPosition
                        }, completion: { (Bool) -> Void in
                            UIView.animateWithDuration(Double(allDuration - originToMidDuration), delay: 0, options: .CurveLinear, animations: { () -> Void in
                                    item.view.center = destPosition
                                }, completion: nil)
                        
                    })
                }
                else {
                    UIView.animateWithDuration(Double(allDuration), delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                        item.view.center = destPosition
                        }, completion: { (Bool) -> Void in
                    })
                }
            }
            
            break
        default:
            break
        }
    }
    
    func pointOnCircle(radius:Float, center:CGPoint, index: CGFloat) -> CGPoint {
        let midIndex: NSInteger = self.viewArray.count / 2
        let distanceToMid = index - CGFloat(midIndex)
        
//        let x = self.frame.size.width / CGFloat(2.0) + pow(abs(distanceToMid), 0.5) * 100
        let y = self.frame.size.height / CGFloat(2.0) + distanceToMid * 100
        return CGPointMake(100, y)
    }
    
    func distanceBetweenPoints(point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(point2.x - point1.x), Float(point2.y - point1.y)));
    }
}

public protocol CPWheelViewDelegate: NSObjectProtocol {
    func pushViewFromTop(wheelView: CPWheelView) -> UIView
    func pushViewFromBottom(wheelView: CPWheelView) -> UIView
    func wheelView(wheelView: CPWheelView, didChangeHightlightedIndex index: NSInteger)
}
