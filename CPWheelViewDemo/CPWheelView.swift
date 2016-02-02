//
//  CPWheelView.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 2/2/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

public class CPWheelView: UIView {

}

public protocol CPWheelViewDelegate: NSObjectProtocol {
    func wheelView(wheelView: CPWheelView, viewForIndex index: NSInteger) -> UIView
    func wheelView(wheelView: CPWheelView, didChangeHightlightedIndex index: NSInteger)
}
