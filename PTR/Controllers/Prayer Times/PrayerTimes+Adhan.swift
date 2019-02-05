//
//  PrayerTimes+Adhan.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/13/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation
import Adhan


extension PrayerTimes {
    func nativePrayerTimes() -> PTPrayerTimes {
        return PTPrayerTimes(dateComponents: self.date, fajr: self.fajr, sunrise: self.sunrise, dhuhr: self.dhuhr, asr: self.asr, maghrib: self.maghrib, isha: self.isha)
    }
}


extension PTCoordinates {
    func coordinates() -> Coordinates {
        return Coordinates(latitude: latitude, longitude: longitude)
    }
}

extension PTCalculationMethod {
    func calculationMethod() -> CalculationMethod {
        switch self {
        case .muslimWorldLeague: return .muslimWorldLeague
        case .egyptian: return .egyptian
        case .karachi: return .karachi
        case .ummAlQura: return .ummAlQura
        case .gulf: return .gulf
        case .moonsightingCommittee: return .moonsightingCommittee
        case .northAmerica: return .northAmerica
        case .kuwait: return .kuwait
        case .qatar: return .qatar
        case .singapore: return .singapore
        case .other: return .other
        }
    }
}

extension PTMadhab {
    func madhab() -> Madhab {
        return self == .shafi ? .shafi : .hanafi
    }
}

extension PTHighLatitudeRule {
    func highLatitudeRule() -> HighLatitudeRule {
        switch self {
        case .middleOfTheNight: return .middleOfTheNight
        case .seventhOfTheNight: return .seventhOfTheNight
        case .twilightAngle: return .twilightAngle
        }
    }
}

extension PTPrayerAdjustments {
    func prayerAdjustments() -> PrayerAdjustments {
        return PrayerAdjustments(fajr: fajr, sunrise: sunrise, dhuhr: dhuhr, asr: asr, maghrib: maghrib, isha: isha)
    }
}
