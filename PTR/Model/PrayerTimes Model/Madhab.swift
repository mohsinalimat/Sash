//
//  Madhab.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/15/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

enum PTMadhab: Int, Codable {
    case shafi
    case hanafi
}

extension PTMadhab: Selectable {
    var text: String {
        return MadhabNames.name(for: self)
    }
    
    
    var index: Int {
        return (PTMadhab.allOptions as! [PTMadhab]).index(of: self)!
    }
    
    static var allOptions: [Selectable] {
        return [.shafi, .hanafi] as [PTMadhab]
    }
}


struct MadhabNames {
    static let shafi = "constants.madhab.shafi".localized
    static let hanafi = "constants.madhab.hanafi".localized
    
    static func name(for madhab: PTMadhab) -> String {
        switch madhab {
        case .shafi: return shafi
        case .hanafi: return hanafi
        }
    }
}
