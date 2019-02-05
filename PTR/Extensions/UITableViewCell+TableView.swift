//
//  UITableViewCell+TableView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/11/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}
