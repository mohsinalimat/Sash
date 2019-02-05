//
//  PTRemindersTableView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources
import DZNEmptyDataSet

class PTRemindersTableView: UITableView {
    
    /* for empty state */
    var placeholder: Placeholder?
    
    /* how much indention applied to the empty view */
    var emptyViewVerticalOffset: CGFloat = 0
    
    init(frame: CGRect){
        super.init(frame: frame, style: .grouped)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        separatorStyle = .none
        backgroundColor = .clear
        
        ds_register(cellNib: PTReminderTableViewCell.self)
        ds_register(headerFooterNib: PTSectionHeaderView.self)
        
        emptyDataSetSource = self
        emptyDataSetDelegate = self
    }
}

extension PTRemindersTableView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return placeholder?.attributedTitleString()
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return placeholder?.attributedDescriptionString()
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 5
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return self.emptyViewVerticalOffset
    }
}
