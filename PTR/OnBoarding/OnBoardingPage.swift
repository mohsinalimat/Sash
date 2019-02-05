//
//  OnBoardingPage.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/26/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class OnBoardingPageItem {
    var identifier: String
    var gradient: Gradient
    var backgroundImage: UIImage!
    var color: UIColor!
    var index: Int
    
    
    init(identifier: String, gradient: Gradient, backgroundImage: UIImage?, index: Int){
        self.identifier = identifier
        self.gradient = gradient
        self.backgroundImage = backgroundImage
        self.color = gradient.mainColor()
        self.index = index
    }
    
    static func welcome() -> OnBoardingPageItem {
        return OnBoardingPageItem(identifier: "Welcome", gradient: Gradient.skyBlue, backgroundImage: UIImage(named: "masjid1"), index: 0)
    }
    
    
    static func notifications() -> OnBoardingPageItem {
        return OnBoardingPageItem(identifier: "Notifications", gradient: Gradient.warmOrange, backgroundImage: UIImage(named: "masjid2"), index: 1)
    }
    
    static func location() -> OnBoardingPageItem {
        return OnBoardingPageItem(identifier: "Location", gradient: Gradient.sunsetFade, backgroundImage: UIImage(named: "masjid3"), index: 2)
    }
    
    static func locationSelection() -> OnBoardingPageItem {
        return OnBoardingPageItem(identifier: "LocationSelection", gradient: Gradient.sunsetFade, backgroundImage: UIImage(named: "masjid3"), index: 3)
    }
}
