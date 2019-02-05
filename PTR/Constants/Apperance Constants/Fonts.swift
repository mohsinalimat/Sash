//
//  Fonts.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

typealias FontSize = CGFloat

struct FontType: ExpressibleByStringLiteral {
    
    static let englishName: FontType = "AvenirNext"
    static let arabicName: FontType = "NotoSansArabicUI"
    
    static let regular: FontType = "Regular"
    static let ultraLight: FontType = "UltraLight"
    static let medium: FontType = "Medium"
    static let bold: FontType = "Bold"
    static let black: FontType = "Black"
    
    fileprivate var rawValue: String
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    func build(with name: String) -> String {
        return name + "-" + self.rawValue
    }
    
    func with(size: CGFloat) -> UIFont {
        return UIFont(name: build(with: FontType.arabicName.rawValue), size: size)!
    }
}

