//
//  CalculationMethod.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/15/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

enum PTCalculationMethod: Int, Codable {
    // Muslim World League
    case muslimWorldLeague
    
    //Egyptian General Authority of Survey
    case egyptian
    
    // University of Islamic Sciences, Karachi
    case karachi
    
    // Umm al-Qura University, Makkah
    case ummAlQura
    
    // The Gulf Region
    case gulf
    
    // Moonsighting Committee
    case moonsightingCommittee
    
    // ISNA
    case northAmerica
    
    // Kuwait
    case kuwait
    
    // Qatar
    case qatar
    
    // Singapore
    case singapore
    
    // Other
    case other
}

extension PTCalculationMethod: Selectable {
    var text: String {
        return CalculationMethodNames.name(for: self)
    }
    
    var index: Int {
        return (PTCalculationMethod.allOptions as! [PTCalculationMethod]).index(of: self)!
    }
    
    static var allOptions: [Selectable] {
        return [.muslimWorldLeague, .egyptian, .karachi, .ummAlQura, .gulf, .moonsightingCommittee, .northAmerica, .kuwait, .qatar, .singapore, .other] as [PTCalculationMethod]
    }
}

struct CalculationMethodNames {
    static let muslimWorldLeague = "constants.method.muslimWorldLeague".localized
    static let egyptian = "constants.method.egyptian".localized
    static let karachi = "constants.method.karachi".localized
    static let ummAlQura = "constants.method.ummAlQura".localized
    static let gulf = "constants.method.gulf".localized
    static let moonsightingCommittee = "constants.method.moonsightingCommittee".localized
    static let northAmerica = "constants.method.northAmerica".localized
    static let kuwait = "constants.method.kuwait".localized
    static let qatar = "constants.method.qatar".localized
    static let singapore = "constants.method.singapore".localized
    static let other = "constants.method.other".localized
    
    static func name(for calculationMethod: PTCalculationMethod) -> String {
        switch calculationMethod {
        case .muslimWorldLeague: return muslimWorldLeague
        case .egyptian: return egyptian
        case .karachi: return karachi
        case .ummAlQura: return ummAlQura
        case .gulf: return gulf
        case .moonsightingCommittee: return moonsightingCommittee
        case .northAmerica: return northAmerica
        case .kuwait: return kuwait
        case .qatar: return qatar
        case .singapore: return singapore
        case .other: return other
        }
    }
}
