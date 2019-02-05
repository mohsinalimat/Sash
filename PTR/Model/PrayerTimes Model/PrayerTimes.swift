//
//  PTPrayerTimes.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/15/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

struct PTPrayerTimes {
    
    var dateComponents: DateComponents
    
    var fajr: Date
    var sunrise: Date
    var dhuhr: Date
    var asr: Date
    var maghrib: Date
    var isha: Date
    
    var allDates: [Date] {
        return [fajr, sunrise, dhuhr, asr, maghrib, isha]
    }
    
    public func currentPrayer(at time: Date = Date()) -> PTPrayer {
        if isha.timeIntervalSince(time) <= 0 {
            return .isha
        } else if maghrib.timeIntervalSince(time) <= 0 {
            return .maghrib
        } else if asr.timeIntervalSince(time) <= 0 {
            return .asr
        } else if dhuhr.timeIntervalSince(time) <= 0 {
            return .dhuhr
        } else if sunrise.timeIntervalSince(time) <= 0 {
            return .sunrise
        } else if fajr.timeIntervalSince(time) <= 0 {
            return .fajr
        } else {
            return .none
        }
    }
    
    public func nextPrayer(at time: Date = Date()) -> PTPrayer {
        if isha.timeIntervalSince(time) <= 0 {
            return .none
        } else if maghrib.timeIntervalSince(time) <= 0 {
            return .isha
        } else if asr.timeIntervalSince(time) <= 0 {
            return .maghrib
        } else if dhuhr.timeIntervalSince(time) <= 0 {
            return .asr
        } else if sunrise.timeIntervalSince(time) <= 0 {
            return .dhuhr
        } else if fajr.timeIntervalSince(time) <= 0 {
            return .sunrise
        } else {
            return .fajr
        }
    }
    
    public func previousPrayer(for prayer: PTPrayer) -> PTPrayer {
        return PTPrayer.all[prayer.index == 0 ? PTPrayer.all.count - 1 : prayer.index - 1]
    }
    
    public func time(for prayer: PTPrayer) -> Date? {
        switch prayer {
        case .none:
            return nil
        case .fajr:
            return fajr
        case .sunrise:
            return sunrise
        case .dhuhr:
            return dhuhr
        case .asr:
            return asr
        case .maghrib:
            return maghrib
        case .isha:
            return isha
        }
    }
}

struct PrayerTimesNames {
    static let fajr = "constant.prayers.fajr".localized
    static let sunrise = "constant.prayers.sunrise".localized
    static let dhuhr = "constant.prayers.dhuhr".localized
    static let asr = "constant.prayers.asr".localized
    static let magrib = "constant.prayers.maghrib".localized
    static let isha = "constant.prayers.isha".localized
    
    static func name(for prayer: PTPrayer) -> String {
        switch prayer {
        case .fajr: return fajr
        case .sunrise: return sunrise
        case .dhuhr: return dhuhr
        case .asr: return asr
        case .maghrib: return magrib
        case .isha: return isha
        default: return ""
        }
    }
}
