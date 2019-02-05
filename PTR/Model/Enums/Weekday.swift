//
//  RepeatDay.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/6/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

@objc
enum Weekday: Int16 {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat

    static var all: [Weekday] {
        return [.sun, .mon, .tue, .wed, .thu, .fri, .sat]
    }
    
    static var today: Weekday {
        let calendar = Calendar.georgian
        let day = calendar.component(Calendar.Component.weekday, from: Date())
        return Weekday(rawValue: Int16(day))!
    }
    
    static func parse(from string: String) -> [Weekday] {
        let strings = string.split(separator: "-")
        var weekdays: [Weekday?] = []
        for letter in strings {
            weekdays.append(.from(shortLetter: String(letter)))
        }
        
        return weekdays.compactMap { return $0 }
    }
    
    static func from(shortLetter: String) -> Weekday? {
        let strings = Weekday.all.map { return $0.shortLetter }
        for (index, string) in strings.enumerated() {
            if shortLetter == string {
                return Weekday.all[index]
            }
        }
        
        return nil
    }
    
    static func from(dateComponents: DateComponents) -> Weekday {
        guard let weekday = dateComponents.weekday else {
            print("WARNING: initializing a weekday with unvalid date component ( no weekday ), a default value will be returned, which is saturday.")
            return .sat
        }
        
        return Weekday(rawValue: Int16(weekday))!
    }
    
    static func string(from weekdays: [Weekday]) -> String {
        return weekdays.stringRepresentation
    }
}

extension Date {
    var weekday: Weekday {
        return Weekday(rawValue: Int16(Calendar.georgian.component(Calendar.Component.weekday, from: self)))!
    }
}



extension Weekday: Selectable {
    var shortLetter: String {
        return "\(RepeatDayNames.name(for: self).prefix(2))"
    }
    
    var threeLetters: String {
        let text = self.text
        let startIndex = text.startIndex
        let endIndex = text.index(text.startIndex, offsetBy: 3)
        return String(text[startIndex ..< endIndex]).uppercased()
    }
    
    var text: String {
        return RepeatDayNames.name(for: self)
    }
    
    var index: Int {
        return Weekday.all.index(of: self)!
    }
    
    var dateInCurrentWeek: Date {
        return Calendar.georgian.date(bySetting: .weekday, value: Int(self.rawValue), of: Date())!
    }
    
    static var allOptions: [Selectable] {
        return all
    }
}

extension Array where Element == Weekday {
    var stringRepresentation: String {
        if self.count == 0 { return "" }
        
        var string = ""
        for weekday in self {
            string.append(weekday.shortLetter)
            string.append("-")
        }
        
        string.removeLast()
        return string
    }
}

struct RepeatDayNames {
    static let sat = "constants.weekdays.sat".localized
    static let sun = "constants.weekdays.sun".localized
    static let mon = "constants.weekdays.mon".localized
    static let tue = "constants.weekdays.tue".localized
    static let wed = "constants.weekdays.wed".localized
    static let thu = "constants.weekdays.thu".localized
    static let fri = "constants.weekdays.fri".localized
    static let everyday = "constants.weekdays.all".localized
    
    static func name(for repeatDay: Weekday) -> String {
        switch repeatDay {
        case .sat: return sat
        case .sun: return sun
        case .mon: return mon
        case .tue: return tue
        case .wed: return wed
        case .thu: return thu
        case .fri: return fri
        }
    }
}

