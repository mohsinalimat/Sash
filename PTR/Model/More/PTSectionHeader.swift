//
//  PTSectionHeader.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/13/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

struct PTSectionHeader {
    var title: String?
    var details: String?
    var icon: Icon?
    var color: UIColor?
    
    init(title: String? = nil, details: String? = nil, icon: Icon? = nil, color: UIColor? = nil){
        self.title = title
        self.details = details
        self.icon = icon
        self.color = color
    }
}
