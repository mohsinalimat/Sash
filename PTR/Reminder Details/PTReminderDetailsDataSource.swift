//
//  PTReminderDetailsDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/13/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources

class PTReminderDetailsDataSource: CompositeDataSource {
    
    private var sections: [PTSectionHeader] = []
    private var headerCreator: BasicBlockSupplementaryViewCreator<PTSectionHeader, PTSectionHeaderView>!
    
    
    var reminder: PTReminder! {
        didSet {
            _setupDataSources()
        }
    }
    
    private var color: UIColor {
        return reminder.prayer.color ?? .black
    }
    
    init(){
        super.init(sectionType: .multi)
        
        self.headerCreator = BasicBlockSupplementaryViewCreator<PTSectionHeader, PTSectionHeaderView>(size: CGSize(width: 1, height: 50)) { (section, headerView, indexPath) in
            
            headerView.icon = section.icon
            headerView.tintColor = section.color
            headerView.titleLabel.text = section.title
            headerView.detailsLabel.text = section.details
            
        }
        
        
        self.set(headerCreator: headerCreator)
    }
    
    private func _setupDataSources(){
        self.removeAllDataSources()
        
        let infoSection = PTSectionHeader(title: Labels.ReminderDetails.info, details: nil, icon: nil, color: self.color)
        
        let prayerOption = PTOption(title: reminder.prayer.text, optionIcon: reminder.prayer.icon)

        var infoItems = [prayerOption]

        
        let repeatDaysOption = PTOption(title: RepeatDaysDetailsFactory(repeatDays: reminder.repeatDays, includesEmptyString: true).string(), optionIcon: .repeat)
        infoItems.append(repeatDaysOption)
        
        // only add history section when this reminder has repeat days, so multiple activities for it there will be.
        if !reminder.repeatDays.isEmpty {
            let completedCount = reminder.activities.filter { ($0 as! PTReminderActivity).isCompleted }.count
            let format = NSLocalizedString("CompletedCount", comment: "")
            let historyOption = PTOption(title: String.localizedStringWithFormat(format, completedCount), optionIcon: .checkmark)
            

            infoItems.append(historyOption)
        }
        
        let customNotificationsOption = PTOption(title: ShiftInterval.from(timeInterval: reminder.shiftInterval).text, optionIcon: Icon.notification)
        infoItems.append(customNotificationsOption)
        
        
        
        let infoDS = PTOptionsDataSource(items: infoItems)
        infoDS.defaultColor = self.color
        infoDS.tintedViewElementTypes = [.icon]

        register(dataSource: infoDS, for: infoSection)
  
        
 
    }
    
    private func _resetupHeadersCreator(){
        headerCreator.setSectionedItems(sections)
        self.set(headerCreator: headerCreator)
    }
    
    func register(dataSource: AbstractDataSource, for section: PTSectionHeader){
        self.sections.append(section)
        
        _resetupHeadersCreator()
        self.add(dataSource)
    }
}
