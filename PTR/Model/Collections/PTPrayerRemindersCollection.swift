//
//  PTPrayerRemindersCollection.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/1/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import UIKit.UIColor

class PTPrayerRemindersCollection {
    
    var identifier: String {
        return "\(dateComponents) - \(prayer.text)"
    }
    
    var title: String {
        return prayer.text
    }
    
    var details: String {
        guard let date = self.date else {
            return ""
        }
        return PTTimeFormatter.shared.string(from: date)
    }
    
    var date: Date? {
        return PTPrayerTimesController.default.date(with: self.prayer, in: self.dateComponents)
    }
    
    var prayer: PTPrayer
    
    var dateComponents: DateComponents
    
    var reminders: [PTReminder]
    
    var progress: Double {
        if reminders.count == 0 { return 0 }
        
        var totalDone = 0
        for reminder in reminders {
            totalDone += reminder.isCompleted(for: dateComponents) ? 1 : 0
        }
        
        return Double(totalDone) / Double(reminders.count)
    }
    
    var subtitle: String {
        let format = NSLocalizedString("RemindersCount", comment: "")
        return String.localizedStringWithFormat(format, reminders.count)
    }
    
    init(prayer: PTPrayer, dateComponents: DateComponents) {
        self.prayer = prayer
        self.dateComponents = dateComponents
        
        self.reminders = PTPersistanceManager.shared.reminders(with: dateComponents, prayer: prayer, isSorted: true)
    }
    
    func reload(){
        self.reminders = PTPersistanceManager.shared.reminders(with: dateComponents, prayer: prayer, isSorted: false)
    }
}


extension PTPrayerRemindersCollection {
    var color: UIColor? {
        return Gradient.for(prayer: self.prayer).mainColor()
    }
    
    var icon: Icon? {
        return Icon.for(prayer: prayer)
    }
    
    var gradient: Gradient? {
        return Gradient.for(prayer: prayer)
    }
}
