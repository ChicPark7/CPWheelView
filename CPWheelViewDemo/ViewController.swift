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
    }
    
    func identifierForNewElementAtTop(tableView: InfiniteTableView, topIdentifier: AnyObject) -> AnyObject {
        print(topIdentifier)
        return topIdentifier as! Int - 1
    }
    
    func identifierForNewElementAtBottom(tableView: InfiniteTableView, bottomIdentifier: AnyObject) -> AnyObject {
        return bottomIdentifier as! Int + 1
    }
    
    func cellForNewElement(tableView: InfiniteTableView, identifier: AnyObject) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TEST")
        cell.textLabel?.text = "\(identifier)"
        return cell
    }
    
    func initialIdentifiers(tableView: InfiniteTableView, count: UInt) -> [AnyObject] {
        var retArray = [AnyObject]()
        for i in 0...count {
            retArray.append(i)
        }
        return retArray
    }
}
