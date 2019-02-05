//
//  PrayerTimesControllerConfigurations.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/13/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation


class PTPrayerTimesControllerConfigurations {
    
    var coordinates: PTCoordinates
    var calculationMethod: PTCalculationMethod
    var madhab: PTMadhab
    var highLatitudeRule: PTHighLatitudeRule
    var prayerAdjustments: PTPrayerAdjustments
    
    init(coordinates: PTCoordinates, calculationMethod: PTCalculationMethod, madhab: PTMadhab, highLatitudeRule: PTHighLatitudeRule, adjustments: PTPrayerAdjustments) {
        self.coordinates = coordinates
        self.calculationMethod = calculationMethod
        self.madhab = madhab
        self.highLatitudeRule = highLatitudeRule
        self.prayerAdjustments = adjustments
    }
}
