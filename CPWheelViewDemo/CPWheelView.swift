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
    let max = 100
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let panGesture = UIPanGestureRecognizer(target: self, action: "onPan:")
        panGesture.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
        for i in 0...max {
            var frame = CGRectMake(0, 0, 50, 50)
            frame.origin = self.pointOnCircle(Float(180), center: self.center, index: CGFloat(i))
            let view = UILabel(frame: frame)
            view.text = "\(i)"
            view.backgroundColor = UIColor.greenColor()
            viewArray.append(CPWheelViewUnit(view: view, position: CGFloat(i)))
            view.tag = i
            self.addSubview(view)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0...max {
            var frame = CGRectMake(0, 0, 50, 50)
            frame.origin = self.pointOnCircle(Float(180), center: self.center, index: CGFloat(i))
            let item = viewArray[i]
            item.view.frame = frame
            item.view.backgroundColor = UIColor.greenColor()
        }
    }
    
    func onPan(panGesture: UIPanGestureRecognizer) {
        switch (panGesture.state) {
        case .Began:
            print("Began")
            lastTouchY = panGesture.translationInView(self).y

            break
        case .Changed:
            currentOffset = (lastTouchY - panGesture.translationInView(self).y) / 100
            for i in 0...max {
                let item = viewArray[i]
                let offset = item.position + currentOffset
                var viewFrame = item.view.frame
                viewFrame.origin = self.pointOnCircle(Float(180), center: self.center, index: offset)
                item.view.frame = viewFrame
//                let centerOffset = 1 - abs(offset - CGFloat(self.viewArray.count / 2)) / 100
//                item.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, centerOffset, centerOffset)
//                if (i == 0) {
//                    print(centerOffset)
//                }
            }
            break
        case .Ended:
            currentOffset = round((lastTouchY - panGesture.translationInView(self).y) / 100)
            let storedCurrentOffset = currentOffset
            let animationOptions: UIViewAnimationOptions = .CurveEaseOut
            let keyframeAnimationOptions: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
            let allDuration: CGFloat = 0.6
            for i in 0...self.max {

                let item = self.viewArray[i]
                let currentViewIndex = item.position + storedCurrentOffset
                let midIndex = CGFloat(self.viewArray.count / 2)
                let nextIndex = round((currentViewIndex) - panGesture.velocityInView(self).y / 1000)

                let destPosition = self.pointOnCircle(Float(180), center: self.center, index: nextIndex)
                let midPosition = self.pointOnCircle(Float(180), center: self.center, index: midIndex)
                
                let needPassbyMid = (midIndex > currentViewIndex) != (midIndex > nextIndex)
                
                let originToMidDistance = self.distanceBetweenPoints(item.view.center, midPosition)
                let midToDestDistance = self.distanceBetweenPoints(midPosition, destPosition)
                
                let originToMidDuration = allDuration * originToMidDistance / (originToMidDistance + midToDestDistance)
                UIView.animateKeyframesWithDuration(NSTimeInterval(allDuration), delay: 0, options: keyframeAnimationOptions,
                    animations: { () -> Void in
                        if (needPassbyMid) {
                            
                            [UIView .addKeyframeWithRelativeStartTime(0, relativeDuration: Double(originToMidDuration), animations: { () -> Void in
                                var viewFrame = item.view.frame
                                viewFrame.origin = midPosition
                                item.view.frame = viewFrame
                            })]
                        }
                        [UIView .addKeyframeWithRelativeStartTime(Double(needPassbyMid ? originToMidDuration : 0), relativeDuration: Double(needPassbyMid ? allDuration - originToMidDuration : allDuration), animations: { () -> Void in
                            var viewFrame = item.view.frame
                            viewFrame.origin = destPosition
                            item.view.frame = viewFrame
                            
                        })]
                        item.position = nextIndex
                    }, completion:{ (Bool) -> Void in
                        item.position = nextIndex
                    }
                
                )
            }
            
            break
        default:
            break
        }
    }
    
    func pointOnCircle(radius:Float, center:CGPoint, index: CGFloat) -> CGPoint {
        let midIndex: NSInteger = self.viewArray.count / 2
        let distanceToMid = index - CGFloat(midIndex)
        
        let x = self.frame.size.width / CGFloat(2.0) + pow(abs(distanceToMid), 0.5) * 100
        let y = self.frame.size.height / CGFloat(2.0) + pow(abs(distanceToMid), 2) * ((index - CGFloat(midIndex) > 0) ? 40 : -40)
        return CGPointMake(x, y)
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
