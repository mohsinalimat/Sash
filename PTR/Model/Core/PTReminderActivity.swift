//
//  PTReminderActivity+CoreDataClass.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/8/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//
//

import Foundation
import CoreData


 class PTReminderActivity: NSManagedObject {
    var isCompleted: Bool {
        return action == .completed
    }
}

extension PTReminderActivity {
    
    @nonobjc  class func fetchRequest() -> NSFetchRequest<PTReminderActivity> {
        return NSFetchRequest<PTReminderActivity>(entityName: "ReminderActivity")
    }
    
    @NSManaged var action: ActivityAction
    @NSManaged var date: Date
    @NSManaged var reminder: PTReminder?
    
}
