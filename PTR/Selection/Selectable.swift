//
//  Selectable.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/9/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

protocol Selectable {
    var text: String { get }
    
    var icon: Icon? { get }
    var color: UIColor? { get }
    
    static var allOptions: [Selectable] { get }
}


// default no icon
extension Selectable {
    var icon: Icon? { return nil }
    var color: UIColor? { return nil }
}

