//
//  Gradient.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit


enum Gradient {
    case skyBlue
    case scaryNight
    case rosyRed
    case warmOrange
    case sunsetFade
    case nightyBlue
    case clear
    case color(UIColor)
    
    static func `for`(prayer: PTPrayer) -> Gradient {
        switch prayer {
        case .fajr: return .scaryNight
        case .sunrise: return .rosyRed
        case .dhuhr: return .skyBlue
        case .asr: return .warmOrange
        case .maghrib: return .sunsetFade
        case .isha, .none: return .nightyBlue
        }
    }
    
    var hexCodes: [String] {
        switch self {
        case .skyBlue:
            return ["#6078EA", "#17EAD9"]
        case .scaryNight:
            return ["353B48", "40739E"]
        case .rosyRed:
            return ["#F54EA2", "#FF7676"]
        case .warmOrange:
            return ["#F38181", "#FCE38A"]
        case .sunsetFade:
            return ["#40739E", "#FF7676"]
        case .nightyBlue:
            return ["#192A56", "#40739E"]
        case .clear:
            return ["#000000", "#000000"]
        case .color:
            return ["", ""]
        }
    }
    
    func colors() -> [UIColor] {
        if case .color(let color) = self {
            return [color, color]
        }
        
        return self.hexCodes.map { return UIColor(hexString: $0) }
    }
    
    func mainColor() -> UIColor {
        let colors = self.colors()
        switch self {
        case .scaryNight:
            return colors.first!
        case .rosyRed:
            return colors[1]
        case .skyBlue:
            return colors.first!.toColor(colors[1], percentage: 0.25)
        case .warmOrange:
            return colors.first!.toColor(colors[1], percentage: 0.25)
        case .sunsetFade:
            return colors[1]
        case .nightyBlue:
            return colors.first!
        case .clear:
            return colors.first!
        case .color(let color):
            return color
        }
    }
}

extension PTPrayer {
    var gradient: Gradient {
        return Gradient.for(prayer: self)
    }
}

enum GradientPoint {
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    var point: CGPoint {
        switch self {
        case .left: return CGPoint(x: 0.0, y: 0.5)
        case .top: return CGPoint(x: 0.5, y: 0.0)
        case .right: return CGPoint(x: 1.0, y: 0.5)
        case .bottom: return CGPoint(x: 0.5, y: 1.0)
        case .topLeft: return CGPoint(x: 0.0, y: 0.0)
        case .topRight: return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

