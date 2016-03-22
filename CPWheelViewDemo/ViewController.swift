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
            let dateGap = Int(i) - Int(count + 1) / 2
            let date = today.dateByAddingTimeInterval(Double(dateGap) * 60 * 60 * 24)
            retArray.append(date)
        }
        return retArray
    }
    
    func infiniteTableView(tableView: InfiniteTableView, didSelectIdentifier identifier: AnyObject) {
        let alert = UIAlertController(title: "InfiniteTableView", message: "\(identifier)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: { (UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
