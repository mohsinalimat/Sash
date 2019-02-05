//
//  LocalizationController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/12/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation


/*
 Dependencies:
    - None
 
 Subscibes to:
    - None
 
 Sends:
    - None
 
*/
class PTLocalizationController: Controller {
    
    enum Language: String {
        case arabic = "ar"
        case english = "en"
        
        var localizationIdentifier: String {
            return self.rawValue
        }
    }
    
    static let shared = PTLocalizationController()
    
    var language: Language {
        return Language(rawValue: Bundle.main.preferredLocalizations.first!)!
    }
}
