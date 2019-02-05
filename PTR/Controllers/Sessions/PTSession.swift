//
//  PTSession.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/17/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation

protocol PTSession: class {
    
    var identifier: String? { set get }
    
    func start()
    func cancel()
    
    func option() -> PTOption?
}

extension PTSession {
    func option() -> PTOption? {
        return nil
    }
}
