//
//  PTAcknowledgmentItem.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

struct PTAcknowledgmentsContainer: Codable {
    
    static var once: PTAcknowledgmentsContainer = {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "PTR-Acks", withExtension: "plist")!)
            let decoder = PropertyListDecoder()
            
            return try decoder.decode(PTAcknowledgmentsContainer.self, from: data)
        } catch {
            print("Something went wrong while decoding \(error)")
            return PTAcknowledgmentsContainer(specs: [])
        }
    }()
    
    var specs: [PTAcknowledgmentItem]
}

struct PTAcknowledgmentItem: Codable, Selectable {
    
    var text: String {
        return name
    }
    
    static var allOptions: [Selectable] { return [] }
    
    var name: String = ""
    var licenseType: String = ""
    var licenseText: String = ""
}
