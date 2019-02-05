//
//  Coordinates.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

struct PTCoordinates: Codable {
    var longitude: Double
    var latitude: Double
    
    func isEmpty() -> Bool {
        return longitude == -1 && longitude == -1
    }
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(){
        self.init(longitude: -1, latitude: -1)
    }
}
