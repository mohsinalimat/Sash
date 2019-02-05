//
//  PTReminderNotification.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/5/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import UserNotifications

class PTReminderNotification: PTNotification {
    
    fileprivate(set) var reminder: PTReminder
    
    var identifier: String {
        return reminder.id.uuidString
    }
    
    var title: String {
        return reminder.contents
    }
    
    var body: String {
        return NotificationBodyFactory(prayer: reminder.prayer, shiftInterval: ShiftInterval.from(timeInterval: reminder.shiftInterval)).string()
    }
    
    var threadIdentifier: NotificationThreadIdentifier {
        return NotificationThreadIdentifier.reminder
    }
    
    var userInfo: [String: Any]? {
        return [NotificationsKeys.reminder: reminder.id.uuidString]
    }
    
    init(reminder: PTReminder){
        self.reminder = reminder
    }
    
    func trigger() -> UNNotificationTrigger {
        var date: Date = reminder.notificationDate
        
        let prayer = reminder.prayer
        let dateComponents = date.nessComponents
        let shiftInterval = reminder.shiftInterval
        
        if let dDate = PTPrayerTimesController.default.date(with: prayer, in: dateComponents)?.addingTimeInterval(shiftInterval) {
            date = dDate
        }
        
        let components = Calendar.georgian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
}
