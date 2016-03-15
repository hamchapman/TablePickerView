//
//  TablePickerView.swift
//  TablePickerView
//
//  Created by Hamilton Chapman on 09/10/2015.
//  Copyright © 2015 hc.gg. All rights reserved.
//

import Foundation
import UIKit

public class TablePickerView: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {
    public let tableData: [[String:String]]!
    public let tableView: UITableView!
    public let numberOfRows: Int!
    public var cleanedTableView = false
    public var initialLoad = true
    
    public init(tableData: [[String:String]], inout tableView: UITableView!, numberOfRows: Int) {
        var loopedData: [[String:String]] = []
        
        for _ in 1...50 {
            loopedData += tableData
        }
        
        self.tableData = loopedData
        self.tableView = tableView
        self.numberOfRows = numberOfRows
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollToCellTop(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        setTextOfMiddleElement(scrollView)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToCellTop(scrollView)
        }
    }
    
    public func scrollToCellTop(scrollView: UIScrollView) {
        let tableViewOffset = scrollView.contentOffset.y
        let cellHeight = tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height
        
        if self.numberOfRows % 2 == 1 {
            if ((tableViewOffset % cellHeight) < (cellHeight / 2)) {
                scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset - (tableViewOffset % cellHeight))), animated: true)
            } else {
                scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset + cellHeight - (tableViewOffset % cellHeight))), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPointMake(0, CGFloat(tableViewOffset + (cellHeight / 2) - (tableViewOffset % cellHeight))), animated: true)
        }
    }
    
    public func setTextOfMiddleElement(scrollView: UIScrollView) {
        let tableViewOffset = scrollView.contentOffset.y
        let visibleTableViewHeight = scrollView.frame.height
        let cellHeight = tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height
        let cellsOnScreen = visibleTableViewHeight / cellHeight
        
        let middleRowIndex = (cellsOnScreen / 2) + (tableViewOffset / cellHeight)
        tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(middleRowIndex), inSection: 0))?.textLabel?.textColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1.0)
        self.cleanedTableView = false
    }
    
    public func getSelectedValue(scrollView: UIScrollView) -> String {
        let tableViewOffset = scrollView.contentOffset.y
        let visibleTableViewHeight = scrollView.frame.height
        let cellHeight = tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).height
        let cellsOnScreen = visibleTableViewHeight / cellHeight
        
        let middleRowIndex = (cellsOnScreen / 2) + (tableViewOffset / cellHeight)
        let tableCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(middleRowIndex), inSection: 0))
        return tableCell!.textLabel!.text!
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.cleanedTableView {
            for cell in tableView.visibleCells {
                cell.textLabel!.textColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:0.4)
            }
            self.cleanedTableView = true
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let item = tableData[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.text = String(stringInterpolationSegment: item["text"]!)
        // TODO: Set font height to be multiple of cell height by default (add option to choose)
        let myFont = UIFont(name: "Avenir-Light", size: 46.0);
        cell.textLabel!.font  = myFont;
        cell.textLabel?.textColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:0.4)
        return cell
    }
}