//
//  DynamicStrings.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/8/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

protocol StringFactory {
    func string() -> String
}

struct NotificationBodyFactory: StringFactory {
    
    var shiftInterval: ShiftInterval
    var prayer: PTPrayer
    
    init(prayer: PTPrayer, shiftInterval: ShiftInterval){
        self.prayer = prayer
        self.shiftInterval = shiftInterval
    }

    func string() -> String {
        let minutes = shiftInterval.minutes
        let minutesLocalized = PTNumberFormatter.shared.string(from: minutes)
        
        if minutes > 0 {
            return String(format: "notifications.reminders.details.after".localized, minutesLocalized, prayer.text)
        } else if minutes < 0 {
            return String(format: "notifications.reminders.details.before".localized, minutesLocalized, prayer.text)
        } else {
            return String(format: "notifications.reminders.details.immeditly".localized, prayer.text)
        }
    }
}

struct HomeDetailsFactory: StringFactory {
    var currentPrayer: PTPrayer
    
    init(currentPrayer: PTPrayer){
        self.currentPrayer = currentPrayer
    }
    
    func string() -> String {
        if currentPrayer == .none {
            return ""
        }
        
        return String(format: "constants.home.details".localized, currentPrayer.text)
    }
}

struct RepeatDaysDetailsFactory: StringFactory {
    var repeatDays: [Weekday]
    var includesEmptyString: Bool
    
    init(repeatDays: [Weekday], includesEmptyString: Bool){
        self.repeatDays = repeatDays
        self.includesEmptyString = includesEmptyString
    }
    
    func string() -> String {
        if repeatDays.count == 0 {
            return !includesEmptyString ? "" : "constants.repeatDays.none".localized
        }
        
        
        if repeatDays.count == 1 {
            return "constants.repeatDays.multiple".localized + " " + "\(repeatDays.first!.text)"
        } else if repeatDays.count == Weekday.all.count {
            return RepeatDayNames.everyday
        } else {
            var strings = repeatDays.map { $0.text }
            
            //[first], [mid], [mid2] and [final]
            let prefix = "constants.repeatDays.multiple".localized + " "
            let suffix = " " + "\(Extras.and) \(strings.removeLast())"
            
            let mids = strings.reduce(into: "", { (result, newValue) in
                result = result + newValue + "\(Extras.separator) "
            })
            
            // remove last two characters
            let newMid = String(mids.dropLast(2))
            
            return prefix + newMid + suffix
        }
    }
}

struct ReminderDetailsFactory: StringFactory {
    
    var shiftInterval: ShiftInterval
    var repeatDays: [Weekday]
    
    init(shiftInterval: ShiftInterval, repeatDays: [Weekday]){
        self.shiftInterval = shiftInterval
        self.repeatDays = repeatDays
    }
    
    func string() -> String {
        var overall = ""
        let prefix = shiftInterval.text
        
        overall += prefix
        if repeatDays.count != 0 {
            overall += Extras.separator + " "
            
            let repeatDaysDetails = RepeatDaysDetailsFactory(repeatDays: repeatDays, includesEmptyString: true).string().lowercasingFirstLetter()
            overall += repeatDaysDetails
        }
        
        return overall
    }
}
