//
//  PTBackButton.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/12/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTBackButton: UIButton {
    
    enum Size: String {
        case small
        case big
        
        func insets() -> UIEdgeInsets {
            let language: PTLocalizationController.Language = .english//PTLocalizationController.shared.language
            
            switch self {
            case .small:
                return UIEdgeInsets(top: 15, left: language == .arabic ? 30 : 0, bottom: 15, right: language == .english ? 30 : 0)
            case .big:
                return UIEdgeInsets(top: 10, left: language == .arabic ? 20 : 0, bottom: 10, right: language == .english ? 20 : 0)
            }
        }
    }
    
    var size: Size = .big {
        didSet {
            configure()
        }
    }
    
    @IBInspectable var sizeString: String = "big" {
        didSet {
            size = Size(rawValue: sizeString) ?? .big
        }
    }
    
    private func configure(){
        self.contentEdgeInsets = self.size.insets()
        self.transform = PTLocalizationController.shared.language == .arabic ?  CGAffineTransform.init(rotationAngle: CGFloat.pi) : .identity
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
}
