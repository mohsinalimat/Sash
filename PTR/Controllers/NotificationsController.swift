//
//  NotificationsController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/28/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit


/*
 Dependencies:
    - Preferences Controller
    - Persistance Manager
    - Prayer Times Controller
 
 Subscribes to:
    - Persistance Did Finish Updating
    - Preferences Did Change
    - Application Did Become Active
 
 Sends:
    - None
*/
class PTNotificationsController: NSObject, Controller {
    
    private enum ActionIdentifier: String {
        case complete
        case skip
        
        var title: String {
            switch self {
            case .complete:
                return "notifications.reminders.actions.complete".localized
            case .skip:
                return "notifications.reminders.actions.skip".localized
            }
        }
    }
    
    /// shared instance
    static var shared = PTNotificationsController()
    
    /// notifications
    fileprivate(set) var notifications: [PTNotification] = []
    
    /// preferences
    lazy var notificationsEnabled: Bool = {
        return PTPreferencesController.shared.getNotificationsIsEnabled()
    }()
    
    fileprivate var prayerNotificationsIsEnabled = false
    
    
    override init(){
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(persistanceDidChange), name: Notifications.persistanceDidFinishUpdating, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange), name: Notifications.preferencesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(persistanceWillDeleteReminder(notification:)), name: Notifications.willDeleteReminder, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadApplicationBadgeCount), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /* we need to remove any notifications that has expired.. */
    func startControllingTheWorld() {
        let completeAction = UNNotificationAction(identifier: ActionIdentifier.complete.rawValue, title: ActionIdentifier.complete.title, options: .init(rawValue: 0))
        
        // Define the notification type
        let remindersCategory =
            UNNotificationCategory(identifier: NotificationThreadIdentifier.reminder.rawValue,
                                   actions: [completeAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .init(rawValue: 0))
        UNUserNotificationCenter.current().setNotificationCategories([remindersCategory])
        UNUserNotificationCenter.current().delegate = self
    }
    
    func removeAnyScheduledNotifications(){
        self.notifications = []
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { (success, error) in
                    if let _ = error {
                        return
                    }
                })
            } else if settings.authorizationStatus == .denied {
                
            }
        }
    }
    
    func register(notification: PTNotification){
        unregisterNotification(with: notification.identifier)
        
        let trigger = notification.trigger()

        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.threadIdentifier = notification.threadIdentifier.rawValue
        content.categoryIdentifier = notification.threadIdentifier.rawValue
        content.userInfo = notification.userInfo ?? [:]
        content.sound = .default
        
        print("Registering Notification:")
        print(notification.body)
        
        let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)
        self.notifications.append(notification)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ISSUE WITH SCHEDGULING NOTIFICATOIN: \(error)")
            }
        }
    }
    
    func unregisterNotification(with identifier: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        if let index = self.notifications.index(where: { $0.identifier == identifier}){
            self.notifications.remove(at: index)
        }
    }
    
    func reloadCustomNotifications(for reminders: [PTReminder]){
        reminders.forEach { (reminder) in
            if reminder.isDeleted {
                self.unregisterNotification(with: reminder.id.uuidString)
            }
        }
        
        reminders.forEach { (reminder) in
            let notificationDate = reminder.notificationDate
            if notificationDate < Date() || reminder.isArchived {
                return
            }
            
            guard let activity = reminder.activity(for: notificationDate.nessComponents) else {
                return
            }
            
            if activity.action != .none {
                return
            }
            
            let notification = PTReminderNotification(reminder: reminder)            
            self.register(notification: notification)
        }
    }
}

extension PTNotificationsController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let reminderIdentifier = response.notification.request.content.userInfo[NotificationsKeys.reminder] as? String {
            switch response.actionIdentifier {
            case ActionIdentifier.complete.rawValue:
                if let reminder = (PTPersistanceManager.shared.reminders.filter { $0.id.uuidString == reminderIdentifier }).first {
                    PTPersistanceManager.shared.addActivity(for: reminder, action: .completed, date: Date())
                }
                break
            default: break
            }
        }
        
        completionHandler()
    }
}


extension PTNotificationsController {
    func notification(for reminder: PTReminder) -> PTNotification {
        return PTReminderNotification(reminder: reminder)
    }
    
    func notification(for prayer: PTPrayer, in dateComponents: DateComponents) -> PTNotification {
        return PTPrayerNotification(dateComponents: dateComponents, prayer: prayer, remindersCount: PTCalculationsController.shared.prayerInfo(in: dateComponents, at: prayer).remindersCount)
    }
}

/// Notifications
extension PTNotificationsController {
    @objc func persistanceWillDeleteReminder(notification: NSNotification){
        if let reminder = notification.userInfo?[NotificationsKeys.reminder] as? PTReminder {
            unregisterNotification(with: reminder.id.uuidString)
        }
    }
    
    @objc func persistanceDidChange(notification: NSNotification){
        if let affectedReminders = notification.userInfo?[NotificationsKeys.affectedReminders] as? [PTReminder] {
            reloadCustomNotifications(for: affectedReminders)
        }
        
        reloadApplicationBadgeCount()
    }
    
    @objc func applicationDidBecomeActive(){
        reloadApplicationBadgeCount()
    }
    
    @objc func reloadApplicationBadgeCount(){
        let badgeType = PTPreferencesController.shared.getBadgeCountDisplayType()
        let nowDateComponents = Date().nessComponents
        let unCompletedCount: Int
        let nextPrayer = PTPrayerTimesController.default.nextPrayerForToday
        
        if badgeType == .none {
            unCompletedCount = 0
        } else if badgeType == .day {
            unCompletedCount =  PTCalculationsController.shared.dayInfo(for: nowDateComponents).uncompletedRemindersCount
        } else {
            if nextPrayer == .none {
                unCompletedCount = 0
            } else {
                unCompletedCount = PTCalculationsController.shared.prayerInfo(in: nowDateComponents, at: nextPrayer).uncompletedRemindersCount
            }
        }
        
        UIApplication.shared.applicationIconBadgeNumber = unCompletedCount
    }
    
    
    @objc func preferencesDidChange(){
        let preferencesNotificationsIsEnabled = PTPreferencesController.shared.getNotificationsIsEnabled()
        
        if self.notificationsEnabled != preferencesNotificationsIsEnabled {
            self.notificationsEnabled = preferencesNotificationsIsEnabled

            if !notificationsEnabled {
                removeAnyScheduledNotifications()
                return
            }
            
            reloadCustomNotifications(for: PTPersistanceManager.shared.reminders)
        }
        
        reloadApplicationBadgeCount()
    }
}
