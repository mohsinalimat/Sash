//
//  PTCalendarView.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/30/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import FSCalendar

class PTCalendarView: FSCalendar {
    
    static var cellReuseIdentifier: String {
        return "ProgressCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupApperance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupApperance()
    }
    
    fileprivate func setupApperance(){
        let apperance = self.appearance
        
        // fonts
        apperance.titleFont = FontType.medium.with(size: 14)
        apperance.weekdayFont = FontType.medium.with(size: 16)
        apperance.headerTitleFont = FontType.medium.with(size: 18)
        
        
        apperance.weekdayTextColor = .white
        apperance.titleDefaultColor = .white
        apperance.headerTitleColor = .white
        
        // default selection
        apperance.selectionColor = .clear
        apperance.borderSelectionColor = .clear
        
        
        // semi faded
        apperance.titlePlaceholderColor = UIColor.clear
        
        // today
        apperance.todayColor = .clear
        apperance.titleTodayColor = .black
        
        apperance.titlePlaceholderColor = .clear
        
        // other
        apperance.separators = .none
        apperance.headerMinimumDissolvedAlpha = 0
        
        self.register(PTCalendarCollectionViewCell.self, forCellReuseIdentifier: PTCalendarView.cellReuseIdentifier)
        
        self.scope = .month
        self.weekdayHeight = 50
        self.clipsToBounds = true
    }
}
