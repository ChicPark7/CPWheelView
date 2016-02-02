//
//  CPWheelView.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 2/2/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

public class CPWheelView: UIView {
    public var decellerateRate: CGFloat = 0.5
    var currentOffset: CGFloat = 0.0
    var viewArray: [UIView] = [UIView]()
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPan:"))
        for i in 1...10 {
            var frame = CGRectMake(0, 0, 10, 10)
            frame.origin = self.pointOnCircle(Float(self.frame.size.width / CGFloat(2.0)), center: self.center, index: i)
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.greenColor()
            viewArray.append(view)
            self.addSubview(view)
        }
    }
    
    func onPan(panGesture: UIPanGestureRecognizer) {
        switch (panGesture.state) {
        case .Began:
            print("Began")
            currentOffset = panGesture.translationInView(self).y
            break
        case .Changed:
            let movedDistance = currentOffset - panGesture.translationInView(self).y
            for view in viewArray {
                var viewFrame = view.frame
                viewFrame.origin.y -= movedDistance
                view.frame = viewFrame
            }
            print("Changed: \(movedDistance)")
            currentOffset = panGesture.translationInView(self).y
            break
        case .Ended:
            print("End: \(panGesture.velocityInView(self).y)")
            currentOffset = 0.0
            break
        default:
            break
        }
    }
    
    func pointOnCircle(radius:Float, center:CGPoint, index: NSInteger) -> CGPoint {
        let theta = Float(index) / 20.0 * Float(M_PI) * 2.0
        let x = radius * cosf(theta)
        let y = radius * sinf(theta)
        return CGPointMake(CGFloat(x)+center.x,CGFloat(y)+center.y)
    }
}

public protocol CPWheelViewDelegate: NSObjectProtocol {
    func pushViewFromTop(wheelView: CPWheelView) -> UIView
    func pushViewFromBottom(wheelView: CPWheelView) -> UIView
    func wheelView(wheelView: CPWheelView, didChangeHightlightedIndex index: NSInteger)
}
