//
//  PrayerAdjustments.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

struct PTPrayerAdjustments: Codable {
    var fajr: Int
    var sunrise: Int
    var dhuhr: Int
    var asr: Int
    var maghrib: Int
    var isha: Int
    
    mutating func set(value: Int, for prayer: PTPrayer){
        switch prayer {
        case .fajr:
            fajr = value
            break
        case .sunrise:
            sunrise = value
            break
        case .dhuhr:
            dhuhr = value
            break
        case .asr:
            asr = value
            break
        case .maghrib:
            maghrib = value
            break
        case .isha:
            isha = value
            break
        default:
            break
        }
    }
}

extension PTPrayerAdjustments {
    init(){
        self.init(fajr: 0, sunrise: 0, dhuhr: 0, asr: 0, maghrib: 0, isha: 0)
    }
    
    func objects() -> [PTPrayerAdjustment] {
        return [
            PTPrayerAdjustment(prayer: .fajr, value: fajr),
            PTPrayerAdjustment(prayer: .sunrise, value: sunrise),
            PTPrayerAdjustment(prayer: .dhuhr, value: dhuhr),
            PTPrayerAdjustment(prayer: .asr, value: asr),
            PTPrayerAdjustment(prayer: .maghrib, value: maghrib),
            PTPrayerAdjustment(prayer: .isha, value: isha)
        ]
    }
}

class PTPrayerAdjustment {
    var value: Int = 0
    var prayer: PTPrayer
    
    init(prayer: PTPrayer, value: Int){
        self.prayer = prayer
        self.value = value
    }
}
