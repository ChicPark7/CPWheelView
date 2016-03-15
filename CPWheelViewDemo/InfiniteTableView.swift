//
//  InfiniteTableView.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 2/2/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

class InfiniteTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    var dataArray = [Int]()
    var indexpathOffset = 0
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    var isAdjustingOffset = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
        self.dataArray.removeAll()
        var numberOfRows = Int(self.frame.size.height / self.tableView.rowHeight) + 2
        numberOfRows = numberOfRows % 2 == 0 ? numberOfRows + 1 : numberOfRows
        for i in 0..<numberOfRows {
            self.dataArray.insert(i, atIndex: i)
        }
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 50000 + self.dataArray.count / 2, inSection: 0), animated: false, scrollPosition: .Middle)
        print(self.dataArray)
    }
    
    func initProperties() {
        self.addSubview(self.tableView)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 200
        self.tableView.bounces = false
        self.tableView.separatorStyle = .None
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TEST")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100000
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let realIndex = (indexPath.row + indexpathOffset) % self.dataArray.count
        let cell = tableView.dequeueReusableCellWithIdentifier("TEST")!
        cell.textLabel?.text = "realIndex : \(realIndex)\nindex : \(indexPath.row)\ndata : \(self.dataArray[realIndex])"//
        cell.textLabel?.numberOfLines = 3
        cell.selectionStyle = .Blue

        if !isAdjustingOffset && indexPath.row != 0{
            if realIndex == 0 {
                self.dataArray.insert(self.dataArray.first! - 1, atIndex: 0)
                self.dataArray.removeLast()
                indexpathOffset++
            }
            
            else if realIndex == self.dataArray.count - 1{
                self.dataArray.append(self.dataArray.last! + 1)
                self.dataArray.removeFirst()
                indexpathOffset--
            }
        }
        return cell
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isAdjustingOffset = true
        let movedLevel = Int(self.tableView.contentOffset.y - self.tableView.contentSize.height / 2) / (dataArray.count * Int(self.tableView.rowHeight))
        let newContentOffset = self.tableView.contentOffset.y - self.tableView.rowHeight * CGFloat(dataArray.count * movedLevel)
        
        self.tableView.setContentOffset(CGPointMake(0, newContentOffset), animated: false)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.indexpathOffset = self.indexpathOffset + movedLevel * self.dataArray.count
            self.isAdjustingOffset = false
        }
    }
}

