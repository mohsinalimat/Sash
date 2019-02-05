//
//  CalculatedInfo.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/13/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation

struct CalculationInfo: Equatable, Hashable {
    var dateComponents: DateComponents
    var remindersCount: Int
    var completedRemindersCount: Int
    var scope: CalculationScope
    
    var uncompletedRemindersCount: Int {
        return remindersCount - completedRemindersCount
    }
}
