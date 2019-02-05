//
//  PTReminder+CoreDataClass.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/8/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//
//

import Foundation
import CoreData
import DifferenceKit

struct _ReminderExistance: Hashable {
    var dateComponents: DateComponents
    var included: Bool
}

class PTReminder: NSManagedObject, Differentiable {
    fileprivate var _cachedLcoations: Set<_ReminderExistance> = []
}

extension PTReminder {
    
    @nonobjc  class func fetchRequest() -> NSFetchRequest<PTReminder> {
        return NSFetchRequest<PTReminder>(entityName: "Reminder")
    }
    
    @NSManaged var contents: String
    @NSManaged var id: UUID
    @NSManaged var prayer: PTPrayer
    @NSManaged var repeatDaysValue: String
    @NSManaged var shiftInterval: Double
    @NSManaged var originalDate: Date
    @NSManaged var dateCreated: Date
    @NSManaged var activities: NSSet
    @NSManaged var isArchived: Bool
    
    var repeatDays: [Weekday] {
        return Weekday.parse(from: self.repeatDaysValue)
    }
    
    var isRepeatable: Bool {
        return !isArchived && repeatDays.count > 0
    }
    
    var notificationDate: Date {
        return lastActivity().date.addingTimeInterval(shiftInterval) // :D
    }
}

extension PTReminder {
    
    func indivaluateCache(){
        _cachedLcoations = []
    }
    
    func includes(in dateComponents: DateComponents) -> Bool {
        let activities = (self.activities.allObjects as! [PTReminderActivity])
        return activities.contains(where: { (obj) -> Bool in
            return dateComponents == obj.date.nessComponents && obj.action != .deleted
        })
    }
    
    
    func expectedNextDate() -> Date? {
        // get the last
        let last = lastActivity()
        
        if !isRepeatable || isArchived || last.action != .completed {
            return nil
        }
        
        
        
        return self.nextDate(for: last.date)
    }
    
    func activity(for dateComponents: DateComponents) -> PTReminderActivity? {
        // search through activities, if we found one in the given date components, good, return it :D
        let activities = (self.activities.allObjects as! [PTReminderActivity])
        if let index = activities.index(where: { (obj) -> Bool in
            return dateComponents == obj.date.nessComponents
        }){
            return activities[index]
        }
        
        // generate an empty activity if not found.
        return nil
    }
    
    func lastActivity() -> PTReminderActivity {
        return ((self.activities.max {
            let lhs = $0 as! PTReminderActivity
            let rhs = $1 as! PTReminderActivity
            return lhs.date < rhs.date
        }) as! PTReminderActivity)
    }
    
    func nextDate(for date: Date) -> Date {
        let original = originalDate
        let givenDate = date
        let afterWeek = Calendar.georgian.date(byAdding: .day, value: 7, to: givenDate)!
        
        if  original > date {
            return original
        }
        
        /* from that date component to the next seven days, loop through.. */
        for date in givenDate.allDates(till: afterWeek){
            let components = date.nessComponents
            if self.repeatDays.contains(Weekday.from(dateComponents: components)) && !Calendar.georgian.isDate(date, inSameDayAs: givenDate){
                return date
            }
        }
        
        return date
    }
}

extension PTReminder {
    func isCompleted(for dateComponents: DateComponents) -> Bool {
        if let activity = self.activity(for: dateComponents){
            return activity.action == .completed
        }
        
        return false
    }
    
    func details() -> String {
        return ReminderDetailsFactory(shiftInterval: ShiftInterval.from(timeInterval: self.shiftInterval), repeatDays: self.repeatDays).string()
    }
}

// MARK: Generated accessors for activities
extension PTReminder {
    
    @objc(addActivitiesObject:)
    @NSManaged func addToActivities(_ value: PTReminderActivity)
    
    @objc(removeActivitiesObject:)
    @NSManaged func removeFromActivities(_ value: PTReminderActivity)
    
    @objc(addActivities:)
    @NSManaged func addToActivities(_ values: NSSet)
    
    @objc(removeActivities:)
    @NSManaged func removeFromActivities(_ values: NSSet)
    
}
