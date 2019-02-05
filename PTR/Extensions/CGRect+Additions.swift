//
//  CGRect+Additions.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/14/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
