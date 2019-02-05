//
//  Placeholders.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/12/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit


/*
    A placeholder is an object that stores the nesseccary information to be displayed in case of empty state in reminders tableview.
*/



struct Placeholder {

    // need any description?
    var title: String
    
    // in case you don't want it, just return an empty
    var description: String
    
    // optional :D
    var image: UIImage?
    
    
    var style: PlaceholderStyle
    
    
    func attributedTitleString() -> NSAttributedString {
        return NSAttributedString(string: title, attributes: style.titleAttributes)
    }
    
    func attributedDescriptionString() -> NSAttributedString {
        return NSAttributedString(string: description, attributes: style.descriptionAttributes)
    }
    
    static func `default`() -> Placeholder {
        let title = PlaceholdersStrings.title
        let description = PlaceholdersStrings.details
        
        return Placeholder(title: title, description: description, image: nil, style: PlaceholderStyle.default())
    }
}



struct PlaceholderStyle {
    
    var titleAttributes: [NSAttributedString.Key: Any]
    
    var descriptionAttributes: [NSAttributedString.Key: Any]
    
    static func `default`() -> PlaceholderStyle {
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: FontType.bold.with(size: 15), .foregroundColor: UIColor.black]
        let descriptionAttributes: [NSAttributedString.Key: Any] = [.font: FontType.bold.with(size: 13), .foregroundColor: ColorsDefines.gray]
        
        
        return PlaceholderStyle(titleAttributes: titleAttributes, descriptionAttributes: descriptionAttributes)
    }
}
