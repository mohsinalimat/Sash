//
//  PrayerTime.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

@objc
enum PTPrayer: Int16 {
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case isha
    case none
    
    static var allCases: [PTPrayer] {
        return [.none, .fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
    }
    
    static var all: [PTPrayer] {
        return [.fajr, .sunrise, .dhuhr, .asr, .maghrib, .isha]
    }
}

extension PTPrayer: Selectable {
    var text: String {
        return PrayerTimesNames.name(for: self)
    }
    
    var icon: Icon? {
        return Icon.for(prayer: self)
    }
    
    var color: UIColor? {
        return Gradient.for(prayer: self).mainColor()
    }
    
    var index: Int {
        return PTPrayer.all.index(of: self)!
    }
    
    static var allOptions: [Selectable] {
        return all
    }
}

