//
//  InfiniteTableView.swift
//  CPWheelViewDemo
//
//  Created by ParkByounghyouk on 2/2/16.
//  Copyright © 2016 ParkByounghyouk. All rights reserved.
//

import UIKit

public protocol InfiniteTableViewDelegate : NSObjectProtocol {
    func identifierForNewElementAtTop(tableView: InfiniteTableView, topIdentifier: AnyObject) -> AnyObject
    func identifierForNewElementAtBottom(tableView: InfiniteTableView, bottomIdentifier: AnyObject) -> AnyObject
    func cellForNewElement(tableView: InfiniteTableView, identifier: AnyObject) -> UITableViewCell
    func initialIdentifiers(tableView: InfiniteTableView, count: UInt) -> [AnyObject]
}

public class InfiniteTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    public var delegate: InfiniteTableViewDelegate?
    public var cellIdentifierArray = [AnyObject]()
    public var cellHeight: CGFloat {
        get  {
            return tableView.rowHeight
        }
        set {
            tableView.rowHeight = newValue
            self.cellIdentifierArray = self.delegate!.initialIdentifiers(self, count: UInt(self.numberOfRows))
        }
    }
    
    private var indexpathOffset = 0
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private var isAdjustingOffset = false
    private var numberOfRows: Int {
        get {
            let retVal = Int(frame.size.height / tableView.rowHeight) + 2
            return retVal % 2 == 0 ? retVal + 1 : retVal
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }
    
    func initProperties() {
        self.addSubview(self.tableView)
        self.tableView.rowHeight = 100
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.separatorStyle = .None
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TEST")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
        self.cellIdentifierArray.removeAll()
        for i in 0..<numberOfRows {
            self.cellIdentifierArray.insert(i, atIndex: i)
        }
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 50000 + self.cellIdentifierArray.count / 2, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    public func reloadData() {
        self.tableView.reloadData()
    }
    
    public func registerClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.tableView.registerClass(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func registerNib(nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(identifier)!
    }
    
// MARK: Tableview delegate, datasource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100000
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let realIndex = (indexPath.row + indexpathOffset) % self.cellIdentifierArray.count
        if let cell = delegate?.cellForNewElement(self, identifier: self.cellIdentifierArray[realIndex]), delegate = self.delegate {
            cell.selectionStyle = .None
            if !isAdjustingOffset && indexPath.row != 0{
                if realIndex == 0 {
                    let newIdentifier = delegate.identifierForNewElementAtTop(self, topIdentifier: self.cellIdentifierArray.first!)
                    self.cellIdentifierArray.insert(newIdentifier, atIndex: 0)
                    self.cellIdentifierArray.removeLast()
                    indexpathOffset++
                }
                else if realIndex == self.cellIdentifierArray.count - 1{
                    let newIdentifier = delegate.identifierForNewElementAtBottom(self, bottomIdentifier: self.cellIdentifierArray.last!)
                    self.cellIdentifierArray.append(newIdentifier)
                    self.cellIdentifierArray.removeFirst()
                    indexpathOffset--
                }
            }
                
            return cell
        }
        
        return UITableViewCell();
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(self.cellIdentifierArray)
        isAdjustingOffset = true
        let movedLevel = Int(self.tableView.contentOffset.y - self.tableView.contentSize.height / 2) / (cellIdentifierArray.count * Int(self.tableView.rowHeight))
        let newContentOffset = self.tableView.contentOffset.y - self.tableView.rowHeight * CGFloat(cellIdentifierArray.count * movedLevel)
        
        self.tableView.setContentOffset(CGPointMake(0, newContentOffset), animated: false)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.indexpathOffset = self.indexpathOffset + movedLevel * self.cellIdentifierArray.count
            self.isAdjustingOffset = false
        }
    }
}

