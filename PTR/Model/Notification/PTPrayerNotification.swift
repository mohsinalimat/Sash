//
//  PTPrayerNotification.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/5/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import UserNotifications

/*
 Prayer notifications are not supported yet
 
 */
class PTPrayerNotification: PTNotification, Equatable {
    
    var identifier: String {
        return "\(dateComponents) - \(prayer.text)"
    }
    
    var title: String {
        return ""
    }
    
    var body: String {
        return ""
    }
    
    var threadIdentifier: NotificationThreadIdentifier {
        return NotificationThreadIdentifier.prayer
    }
    
    // time info
    var prayer: PTPrayer
    var dateComponents: DateComponents
    
    // additional info
    var remindersCount: Int
    
    var userInfo: [String: Any]? {
        return nil
    }
    
    init(dateComponents: DateComponents, prayer: PTPrayer, remindersCount: Int){
        self.dateComponents = dateComponents
        self.prayer = prayer
        self.remindersCount = remindersCount
    }
    
    func trigger() -> UNNotificationTrigger {
        guard let date = PTPrayerTimesController.default.date(with: self.prayer, in: self.dateComponents) else {
            return UNCalendarNotificationTrigger(dateMatching: self.dateComponents, repeats: false)
        }
        
        let components = Calendar.georgian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
}
