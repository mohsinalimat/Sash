//
//  HighLatitudeRule.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/15/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

/* Rule for approximating Fajr and Isha at high latitudes */
enum PTHighLatitudeRule: Int, Codable {
    case middleOfTheNight
    case seventhOfTheNight
    case twilightAngle
}


extension PTHighLatitudeRule: Selectable {
    var text: String {
        return HighLatitudeRuleNames.name(for: self)
    }
    
    var index: Int {
        return (PTHighLatitudeRule.allOptions as! [PTHighLatitudeRule]).index(of: self)!
    }
    
    static var allOptions: [Selectable] {
        return [.middleOfTheNight, .seventhOfTheNight, .twilightAngle] as [PTHighLatitudeRule]
    }
}

struct HighLatitudeRuleNames {
    static let middleOfTheNight = "constants.hlr.middleOfTheNight".localized
    static let seventhOfTheNight = "constants.hlr.seventhOfTheNight".localized
    static let twilightAngle = "constants.hlr.twilightAngle".localized
    
    static func name(for hightLatitudeRule: PTHighLatitudeRule) -> String {
        switch hightLatitudeRule {
        case .middleOfTheNight: return middleOfTheNight
        case .seventhOfTheNight: return seventhOfTheNight
        case .twilightAngle: return twilightAngle
        }
    }
}
