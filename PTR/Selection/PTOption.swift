//
//  PTOption.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

// a mutable selectable
struct PTOption: Selectable {
    
    
    var title: String
    
    var details: String?
    
    var optionIcon: Icon?
    
    var originalObject: Selectable?
    
    var text: String {
        return title
    }
    
    var icon: Icon? {
        return self.optionIcon
    }
    

    static var allOptions: [Selectable] {
        return []
    }
    
    init(title: String, details: String? = nil, optionIcon: Icon? = nil, originalObject: Selectable? = nil){
        self.title = title
        self.details = details
        self.optionIcon = optionIcon
        self.originalObject = originalObject
    }
}

extension PTOption {
    static func from(repeatDays: [Weekday]) -> PTOption {
        return PTOption(title: Weekday.string(from: repeatDays), optionIcon: Weekday.fri.icon)
    }
}
