//
//  PTCloseButton.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/19/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

@IBDesignable
class PTCloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        self.clipsToBounds = true
        self.setTitle("+", for: .normal)
        self.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: bounds.height / 1.25)
        self.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: bounds.height / 1.25)
    }
}
