//
//  CalculationScope.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/13/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation

enum CalculationScope: Equatable, Hashable {
    case day
    case prayer(PTPrayer)
    
    var prayer: PTPrayer {
        if case .prayer(let prayer) = self {
            return prayer
        }
        
        return .none
    }
}
