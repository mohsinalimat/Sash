//
//  XIBInstantiatable.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/10/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import UIKit

 protocol XIBInstantiatable {
    static func instantiateFromNIB() -> Self?
}

extension XIBInstantiatable {
    static func instantiateFromNIB() -> Self? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? Self
    }
}

extension UIView: XIBInstantiatable { }
