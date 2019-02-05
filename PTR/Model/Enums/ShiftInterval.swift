//
//  ShiftInterval.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/6/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

enum ShiftInterval: Selectable, Equatable {
    
    case minusHalfHour
    case minusFiftyMin
    case minusTenMin

    case zero
    
    case tenMin
    case fiftyMin
    case halfHour
    
    case custom(TimeInterval)
    
    static var all: [ShiftInterval] {
        return [.minusHalfHour, .minusFiftyMin, .minusTenMin, .zero, .tenMin, .fiftyMin, .halfHour]
    }
    
    var text: String {
        let localizedMinutes = PTLocalizationController.shared.language == .arabic ? PTNumberFormatter.shared.string(from: minutes) : "\(minutes)"
        
        if value == 0 {
            return ShiftIntervalNames.immeditly
        } else if value > 0 {
            return String(format: ShiftIntervalNames.after, localizedMinutes)
        } else {
            return String(format: ShiftIntervalNames.before, localizedMinutes)
        }
    }
    
    var index: Int {
        return ShiftInterval.all.index(of: self) ?? ShiftInterval.all.index(of: .zero)!
    }
    
    var minutes: Int {
        return Int(Double(abs(Int32(value))) / 60)
    }
    
    var value: TimeInterval {
        switch self {
        case .minusHalfHour: return -1800
        case .minusFiftyMin: return -900
        case .minusTenMin: return -600
        case .zero: return 0
        case .tenMin: return 600
        case .fiftyMin: return 900
        case .halfHour: return 1800
        case .custom(let interval): return interval
        }
    }
    

    static func from(timeInterval: TimeInterval) -> ShiftInterval {
        switch timeInterval {
        case ShiftInterval.minusHalfHour.value: return ShiftInterval.minusHalfHour
        case ShiftInterval.minusFiftyMin.value: return ShiftInterval.minusFiftyMin
        case ShiftInterval.minusTenMin.value: return ShiftInterval.minusTenMin
        case ShiftInterval.zero.value: return ShiftInterval.zero
        case ShiftInterval.tenMin.value: return ShiftInterval.tenMin
        case ShiftInterval.fiftyMin.value: return ShiftInterval.fiftyMin
        case ShiftInterval.halfHour.value: return ShiftInterval.halfHour
        default: return ShiftInterval.custom(timeInterval)
        }
    }
    
    static var allOptions: [Selectable] {
        return all
    }
    
    public static func == (lhs: ShiftInterval, rhs: ShiftInterval) -> Bool {
        return lhs.value == rhs.value
    }
}

struct ShiftIntervalNames {
    static let before = "constants.delay.before".localized
    static let after = "constants.delay.after".localized
    static let immeditly = "constants.delay.immeditly".localized
}
