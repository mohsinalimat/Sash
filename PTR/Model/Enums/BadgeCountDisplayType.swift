//
//  BadgeCountDisplayType.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/10/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation

/*
    controls the badge count of the application ( un-completed reminders count ), for the current prayer or for the whole day.
*/
enum BadgeCountDisplayType: String, Codable, Selectable {
    
    case prayer
    case day
    case none
    
    var text: String {
        return BadgeCountDisplayTypeNames.name(for: self)
    }
    
    var index: Int {
        return self == .prayer ? 0 : 1
    }
    
    static var allOptions: [Selectable] {
        return [BadgeCountDisplayType.prayer, BadgeCountDisplayType.day, BadgeCountDisplayType.none]
    }
}

struct BadgeCountDisplayTypeNames {
    static let prayer = "constants.badgeType.prayer".localized
    static let day = "constants.badgeType.day".localized
    static let none = "constants.badgeType.none".localized
    
    static func name(for badgeType: BadgeCountDisplayType) -> String {
        switch badgeType {
        case .prayer: return prayer
        case .day: return day
        case .none: return none
        }
    }
}
