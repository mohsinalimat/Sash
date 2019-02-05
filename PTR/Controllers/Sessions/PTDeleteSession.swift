//
//  PTDeleteSession.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/14/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

class PTDeleteReminderSession: PTSession {
    
    private(set) var reminder: PTReminder
    private(set) var dateComponents: DateComponents
    private(set) var persistance: PTPersistanceManager
    
    var identifier: String?
    
    init(reminder: PTReminder, dateComponents: DateComponents){
        self.reminder = reminder
        self.dateComponents = dateComponents
        self.persistance = .shared
    }
    
    func start(){
//        print("*** DELETING ACTION REQUEST ***")
//        print("*** \(reminder.contents) || \(reminder.prayer.text) || \(reminder.repeatDaysValue) ***")
//        print("*** Activities Count: \(reminder.activities.count) ***")
        
        if reminder.activities.count <= 1 {
            // the reminder has only one activity, so delete it permenetly.
            delete(reminder: reminder)
            return
        }
        
        // up to now we assume that the reminder activities count is more than one ( it has repeat days ).
        if let activity = reminder.activity(for: dateComponents){
            // in case the user chooses to delete a completed activity reminder, delete only the activity
            if activity.action == .completed {
                delete(activity: activity)
            } else {
                // the activity is not completed, archive the reminder.
                archive(reminder: reminder)
            }
            
            return
        }
        
        // we didn't found an activity for that day, so archive the reminder, same beahvior.
        archive(reminder: reminder)
    }
    
    func cancel() {
        // no canceling :)
    }
}

extension PTDeleteReminderSession {
    private func delete(reminder: PTReminder){
//        print("*** DELETE REMINDER ***")
        persistance.delete(reminder: reminder)
    }
    
    private func delete(activity: PTReminderActivity){
//        print("*** DELETE ACTIVITY ***")
        persistance.delete(activity: activity)
    }
    
    private func archive(reminder: PTReminder){
//        print("*** ARCHIVING REMINDER ***")
        persistance.archive(reminder: reminder)
//        print("*** Activities Count after archiving: \(reminder.activities.count) ***")
    }
}
