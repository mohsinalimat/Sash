//
//  PTNotification.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/5/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationThreadIdentifier: String {
    case prayer = "prayer-notifications"
    case reminder = "reminders-notifications"
}

protocol PTNotification: class {
    
    var identifier: String { get }
    
    var title: String { get }
    
    var body: String { get }
    
    var threadIdentifier: NotificationThreadIdentifier { get }
    
    var userInfo: [String: Any]? { get }
    
    func trigger() -> UNNotificationTrigger
}

extension PTNotification {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


