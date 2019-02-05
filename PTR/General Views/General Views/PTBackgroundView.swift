//
//  PTBackgroundView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/10/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTBackgroundView: UIView {
    
    enum BackgroundType {
        case gradient
        case solid
    }
    
    var gradientView: PTGradientView!
    
    var backgroundType: BackgroundType = .gradient {
        didSet {
            gradientView.isHidden = backgroundType != .gradient
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradientView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGradientView()
    }
    
    private func addGradientView(){
        gradientView = PTGradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(gradientView)
        gradientView.pinToSuperView()
    }
}
