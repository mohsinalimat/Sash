//
//  CalculationsController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/13/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation


/*
 Dependencies:
    - Persistance Manager
 
 Subscribed to:
    - Persistance Did Change
 
 Sends:
    - None
*/


/// A helper class that is used to do the calculations and save them to cache so calculations won't be repeated everytime.
class PTCalculationsController: Controller {
    
    static var shared: PTCalculationsController = PTCalculationsController()
    
    fileprivate var dayCache: Set<CalculationInfo> = []
    fileprivate var prayersCache: Set<CalculationInfo> = []
    
    fileprivate let persistanceManager: PTPersistanceManager

    init(){
        self.persistanceManager = PTPersistanceManager.shared
        NotificationCenter.default.addObserver(self, selector: #selector(persistanceDidChange(notification:)), name: Notifications.persistanceDidFinishUpdating, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func prayerInfo(in dateComponents: DateComponents, at prayer: PTPrayer) -> CalculationInfo {
        if let index = self.prayersCache.index(where: { $0.dateComponents == dateComponents && $0.scope.prayer == prayer }){
            return prayersCache[index]
        }
        
        return computeInfo(for: dateComponents, at: prayer)
    }
    
    func dayInfo(for dateComponents: DateComponents) -> CalculationInfo {
        if let index = self.dayCache.index(where: { $0.dateComponents == dateComponents }){
            return dayCache[index]
        }
        
        return computeDayInfo(for: dateComponents)
    }
    
    func computeInfo(for dateComponents: DateComponents, at prayer: PTPrayer) -> CalculationInfo {
        let reminders = persistanceManager.reminders(with: dateComponents, prayer: prayer, isSorted: false)
        
        let completedRemindersCount = reminders.filter { $0.isCompleted(for: dateComponents) }.count
        let calculatedPrayerInfo = CalculationInfo(dateComponents: dateComponents, remindersCount: reminders.count, completedRemindersCount: completedRemindersCount, scope: .prayer(prayer))
        
        prayersCache.update(with: calculatedPrayerInfo)
        return calculatedPrayerInfo
    }
    
    func computeDayInfo(for dateComponents: DateComponents) -> CalculationInfo {
        let reminders = persistanceManager.reminders(with: dateComponents, isSorted: false)
        
        let totalCount = reminders.count
        let completedCount = reminders.filter { $0.isCompleted(for: dateComponents) }.count
        
        let calculatedDayInfo = CalculationInfo(dateComponents: dateComponents, remindersCount: totalCount, completedRemindersCount: completedCount, scope: .day)
        
        dayCache.update(with: calculatedDayInfo)
        return calculatedDayInfo
    }
    
    func indivaluteCache(){
        self.prayersCache.removeAll()
        self.dayCache.removeAll()
    }
    
    @objc
    func persistanceDidChange(notification: NSNotification){
        indivaluteCache()
    }
}


