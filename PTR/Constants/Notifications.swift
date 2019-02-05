//
//  Notifications.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/5/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

struct Notifications {
    
    /// prayer times controller
    static let currentPrayerDidChange = NSNotification.Name("current_prayer_change")
    static let selectedPrayerDidChange = NSNotification.Name("selected_prayer_change")
    
    /// location controlelr
    static let locationControllerDidBeginFetchingLocation = NSNotification.Name("location_cr_location_begin")
    static let locationControllerDidFinishFetchingLocation = NSNotification.Name("location_cr_location_finish")
    static let locationControllerDidFaildFetchingLocation = NSNotification.Name("location_cr_location_faild")
    static let locationControllerDidChangeAuthorizationStatus = NSNotification.Name("location_cr_authorization")
    
    /// persistance controller
    static let persistanceDidFinishUpdating = NSNotification.Name("persistance_cr_change")
    
    static let willDeleteReminder = NSNotification.Name("persistance_will_delete_reminder")
    static let didAddReminder = NSNotification.Name("persistance_cr_reminder_creation")
    static let didDeleteReminder = NSNotification.Name("persistance_cr_reminder_delete")
    static let didArchiveReminder = NSNotification.Name("persistance_cr_reminder_archive")
    
    static let didChangeActivityAction = NSNotification.Name("reminder_activity_change")
    static let didDeleteActivity = NSNotification.Name("reminder_activity_delete")
    static let didDeleteActivities = NSNotification.Name("reminder_activities_delete")
    
    
    /// preferences
    static let preferencesDidChange = NSNotification.Name("preferences_change")
}

extension NSNotification {
    var reminder: PTReminder? {
        return userInfo?[NotificationsKeys.reminder] as? PTReminder
    }
    
    var activity: PTReminderActivity? {
        return userInfo?[NotificationsKeys.activity] as? PTReminderActivity
    }
    
    var activities: [PTReminderActivity]? {
        return userInfo?[NotificationsKeys.activities] as? [PTReminderActivity]
    }
}
