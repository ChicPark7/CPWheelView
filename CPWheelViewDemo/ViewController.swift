//
//  ViewController.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 3/9/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InfiniteTableViewDelegate {
    
    @IBOutlet var tableView: InfiniteTableView?
    
    override func viewDidLoad() {
        tableView?.delegate = self
        tableView?.cellHeight = 50
        tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TEST")
    }
    
    func identifierForNewElementAtTop(tableView: InfiniteTableView, topIdentifier: AnyObject) -> AnyObject {
        return (topIdentifier as! NSDate).dateByAddingTimeInterval(-60 * 60 * 24)
    }
    
    func identifierForNewElementAtBottom(tableView: InfiniteTableView, bottomIdentifier: AnyObject) -> AnyObject {
        return (bottomIdentifier as! NSDate).dateByAddingTimeInterval(60 * 60 * 24)
    }
    
    func cellForIdentifier(tableView: InfiniteTableView, identifier: AnyObject) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TEST")
        cell.textLabel?.text = "\(identifier)"
        return cell
    }
    
    func initialIdentifiers(tableView: InfiniteTableView, count: UInt) -> [AnyObject] {
        var retArray = [AnyObject]()
        let today = NSDate()
        for i in 0...count {
            retArray.append(today.dateByAddingTimeInterval(Double(i) * 60 * 60 * 24))
        }
        return retArray
    }
}
