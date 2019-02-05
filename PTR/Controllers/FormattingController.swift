//
//  DatesFormatter.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/30/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

struct PTNumberFormatter {
    lazy var formatter: NumberFormatter = {
        let fr = NumberFormatter()
        fr.allowsFloats = false
        fr.numberStyle = .decimal
        fr.locale = Locale.autoupdatingCurrent
        return fr
    }()
    
    
    static var shared = PTNumberFormatter()
    
    /// generates a short time string from the given date
    mutating func string(from number: Int) -> String {
        // default to use the short type
        return NumberFormatter.localizedString(from: NSNumber(value: number), number: .decimal)
    }
}

struct PTTimeFormatter {
    
    lazy var formatter: DateFormatter = {
        let fr = DateFormatter()
        fr.dateStyle = .none
        fr.timeStyle = .short
        fr.timeZone = TimeZone.autoupdatingCurrent
        
        return fr
    }()
    
    static var shared = PTTimeFormatter()
    
    /// generates a short time string from the given date
    mutating func string(from date: Date) -> String {
        // default to use the short type
        return self.formatter.string(from: date)
    }
}

struct PTDateFormatter {
    lazy var formatter: DateFormatter = {
        let fr = DateFormatter()
        fr.dateStyle = .full
        fr.timeStyle = .none
        fr.doesRelativeDateFormatting = true
        return fr
    }()
    
    static var shared = PTDateFormatter()
    
    /// generates a short time string from the given date
    mutating func string(from date: Date) -> String {
        // default to use the short type
        return self.formatter.string(from: date)
    }
    
    mutating func string(from dateComponents: DateComponents) -> String {
        return self.formatter.string(from: Calendar.georgian.date(from: dateComponents)!)
    }
}
