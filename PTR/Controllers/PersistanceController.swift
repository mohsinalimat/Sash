//
//  PTReminderTemplatesManager.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import CoreData



// the persistance manager is isolated, and has no dependencies.
class PTPersistanceManager: Controller {
    
    private var _isPerformingMultipleUpdates = false
    private var _affectedReminders: [PTReminder] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PTR")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var reminders: [PTReminder] = {
        let fetchRequest = NSFetchRequest<PTReminder>(entityName: "Reminder")
        var templates: [PTReminder] = []
        
        do {
            templates = try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Something went wrong when fetching templates!! \(error)")
        }
        
        return templates
    }()
    
    static var shared = PTPersistanceManager()
    
    init() { }
    
    /// Tells the persistance controller that multiple changes will occur, so it won't send notifications or commit the changes until the persistance recieves "endUpdates()"
    func beginUpdates(){
        _isPerformingMultipleUpdates = true
    }

    /// Ends the series of updates happed to the persistance, and commits the changes applied, and sends a notification includes the "affected date components".
    func endUpdates(){
        _isPerformingMultipleUpdates = false
        
        commitChanges()
        
        NotificationCenter.default.post(name: Notifications.persistanceDidFinishUpdating, object: self, userInfo: [NotificationsKeys.affectedReminders: self._affectedReminders])
        self._affectedReminders = []
    }
    
    //MARK: - -- -
    
    /*
     Creates a new reminder with the given parameters
     
     - contents: the reminder text.
     - prayer: the reminder prayer.
     - shift interval: used for notifications.
     - original date: where the reminder belongs to?.
     - repeatDays: what days to repeat the reminder.
    */
    func createReminder(with contents: String, prayer: PTPrayer, shiftInterval: ShiftInterval, originalDate: Date, repeatDays: [Weekday]){
        
        let newReminder = PTReminder(context: viewContext)
        
        newReminder.id = UUID() // :D
        newReminder.contents = contents
        newReminder.prayer = prayer
        newReminder.shiftInterval = shiftInterval.value
        newReminder.repeatDaysValue = repeatDays.stringRepresentation
        newReminder.originalDate = originalDate
        newReminder.dateCreated = Date()
        
        self.reminders.append(newReminder)
        
        addActivity(for: newReminder, action: .none, date: originalDate)
        
        self._affectedReminders.append(newReminder)
        
        if !_isPerformingMultipleUpdates {
            commitChanges(){ [unowned self] in
                NotificationCenter.default.post(name: Notifications.didAddReminder, object: self, userInfo: [NotificationsKeys.reminder: newReminder])
                self._doAfterSendingNotification()
            }
        }
    }
    
    func archive(reminder: PTReminder){
        // mark the reminder as archived.
        reminder.isArchived = true
        reminder.indivaluateCache()
        
        self._affectedReminders.append(reminder)
        
        // search through activities, and delete the ones whose action is not complete.
        let activities = reminder.activities.filter { ($0 as! PTReminderActivity).action != .completed } as! [PTReminderActivity]
        reminder.removeFromActivities(NSSet(array: activities))
        
        for activity in activities {
            viewContext.delete(activity)
        }
        
        if !_isPerformingMultipleUpdates {
            self.commitChanges(){
                NotificationCenter.default.post(name: Notifications.didArchiveReminder, object: nil, userInfo: [NotificationsKeys.reminder: reminder])
                NotificationCenter.default.post(name: Notifications.didDeleteActivities, object: nil, userInfo: [NotificationsKeys.activities: activities])
                self._doAfterSendingNotification()
            }
        } else {
            
        }
    }
    
    func addActivity(for reminder: PTReminder, action: ActivityAction, date: Date){
        let components = date.nessComponents
        var activity: PTReminderActivity
        
        if let alreadyExisting = reminder.activity(for: components) {
            alreadyExisting.action = action
            alreadyExisting.date = date // ^^
            activity = alreadyExisting
        } else {
            let newActivity = PTReminderActivity(context: self.viewContext)
            
            newActivity.reminder = reminder
            newActivity.date = date
            newActivity.action = action
            
            reminder.addToActivities(newActivity)
            activity = newActivity
        }
        
        
        if let nextDate = reminder.expectedNextDate() {
            let newActivity1 = PTReminderActivity(context: self.viewContext)
            
            newActivity1.reminder = reminder
            newActivity1.date = nextDate
            newActivity1.action = .none
            
            reminder.addToActivities(newActivity1)
        }
        
        self._affectedReminders.append(reminder)
        
        if !_isPerformingMultipleUpdates {
            commitChanges {
                NotificationCenter.default.post(name: Notifications.didChangeActivityAction, object: nil, userInfo: [NotificationsKeys.activity: activity])
                self._doAfterSendingNotification()
            }
        }
    }
    
    func delete(reminder: PTReminder){
        // search through activities, and delete the ones whose action is not complete.
//        self._affectedReminders.append(reminder)
        
        NotificationCenter.default.post(name: Notifications.willDeleteReminder, object: nil, userInfo: [NotificationsKeys.reminder: reminder])
        
        let activities = reminder.activities
        reminder.removeFromActivities(activities)
        
        // delete from the context
        viewContext.delete(reminder)
        
        // commit changes
        _affectedReminders = []
        if !_isPerformingMultipleUpdates {
            commitChanges {
                self.reminders.remove(at: self.reminders.index(of: reminder)!)
                
                // post notification
                NotificationCenter.default.post(name: Notifications.didDeleteReminder, object: self, userInfo: [NotificationsKeys.reminder: reminder])
                self._doAfterSendingNotification()
            }
        } else {
            self.reminders.remove(at: self.reminders.index(of: reminder)!)
        }

    }
    
    func delete(activity: PTReminderActivity){
        // remove from parent
        activity.action = .deleted
        activity.reminder?.indivaluateCache()
        
        self._affectedReminders.append(activity.reminder!)

        
        // delete object
        viewContext.delete(activity)
        
        
        if !_isPerformingMultipleUpdates {
            commitChanges(){
                NotificationCenter.default.post(name: Notifications.didDeleteActivity, object: nil, userInfo: [NotificationsKeys.activity: activity])
                self._doAfterSendingNotification()
            }
        }
    }
    
    private func _doAfterSendingNotification(){
        if !_isPerformingMultipleUpdates {
            NotificationCenter.default.post(name: Notifications.persistanceDidFinishUpdating, object: self, userInfo: [NotificationsKeys.affectedReminders: self._affectedReminders])
            self._affectedReminders = []
        }
    }
    
    func commitChanges(onSuccess: (() -> Void)? = nil){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                onSuccess?()
            } catch {
                print("Something went wrong \(error)")
            }
        }
    }
}


extension PTPersistanceManager {
    func reminders(with components: DateComponents, isSorted: Bool) -> [PTReminder] {
        let array = isSorted ? reminders.sorted(by: {  return $0.isCompleted(for: components) && !$1.isCompleted(for: components)} ) : reminders.sorted(by: { $0.originalDate < $1.originalDate })
        return array.filter { return $0.includes(in: components) }.reversed()
    }
    
    func reminders(with components: DateComponents, prayer: PTPrayer, isSorted: Bool) -> [PTReminder] {
        return self.reminders(with: components, isSorted: isSorted).filter { $0.prayer == prayer }
    }
}
