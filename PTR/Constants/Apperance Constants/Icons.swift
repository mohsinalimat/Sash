//
//  Icons.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

enum Icon: CaseIterable {
    
    // prayer times
    case fajr
    case sunrise
    case sun
    case asr
    case maghrib
    case isha
    
    // additional
    case checkmark
    case `repeat`
    case notification
    case location
    
    case home
    case calendar
    case preferences
    
    static func `for`(prayer: PTPrayer) -> Icon {
        switch prayer {
        case .fajr: return .fajr
        case .sunrise: return .sunrise
        case .dhuhr: return .sun
        case .asr: return .asr
        case .maghrib: return .maghrib
        case .isha: return .isha
        case .none: return .sun
        }
    }
    
    var image: UIImage! { return UIImage(named: name) }
    
    var name: String {
        return String(describing: self)
    }
    
    var lincesName: String {
        switch self {
        case .fajr: return "Lucy González"
        case .sunrise: return "Ricardo Cardoso"
        case .sun: return "Austin Condiff"
        case .asr: return "Ricardo Cardoso"
        case .maghrib: return "Ricardo Cardoso"
        case .isha: return "Marco Livolsi"
        case .repeat: return "mikael bonnevie"
        case .notification: return "Beau Wingfield"
        case .home: return "designvector"
        case .calendar: return "Zlatko Najdenovski"
        case .preferences: return "Wouter Buning"
        case .checkmark: return "Setyo Ari Wibowo"
        case .location: return "Studio GLD"
        }
    }
}
