//
//  ViewController.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 2/2/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var dataArray = [Int]()
    var sampleInt = 0
    override func viewDidLoad() {
        self.tableView.rowHeight = 60
        self.tableView.bounces = false
        self.tableView.separatorStyle = .None
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        var numberOfRows = Int(self.view.frame.size.height / self.tableView.rowHeight) + 20
        numberOfRows = numberOfRows % 2 == 0 ? numberOfRows + 1 : numberOfRows
        for i in 0..<numberOfRows {
            self.dataArray.insert(i, atIndex: i)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: dataArray.count / 2, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10000
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier("TEST") {
            cell.textLabel?.text = "\(self.dataArray[indexPath.row % self.dataArray.count])"
            cell.selectionStyle = .Blue
            return cell
        }
        return UITableViewCell()
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let visibleIndexPaths = self.tableView.indexPathsForVisibleRows
        let midIndex = CGFloat(visibleIndexPaths!.count / 2)
        UIView.setAnimationBeginsFromCurrentState(true)
        for (index, indexPath) in (visibleIndexPaths?.enumerate())! {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            let rate = CGFloat(1 - abs(midIndex - CGFloat(index)) / midIndex)
            cell?.contentView.alpha = rate
        }
        
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let distanceChanged = (scrollView.contentSize.height / 2 - scrollView.contentOffset.y - self.tableView.frame.size.height / 2) % (self.tableView.rowHeight * CGFloat(self.dataArray.count))

        let movingOffset = CGPointMake(0, (self.tableView.contentSize.height - self.tableView.frame.size.height) / CGFloat(2.0) - distanceChanged)
        print("Decelerating", distanceChanged, movingOffset, scrollView.contentOffset.y)
        self.tableView.setContentOffset(movingOffset, animated: false)
    }
}

