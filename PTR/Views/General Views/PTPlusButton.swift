//
//  PTPlusButton.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTPlusButton: UIButton {
    var insetValue: CGFloat = 0 {
        didSet {
            self.contentEdgeInsets = UIEdgeInsets.init(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
        }
    }
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: bounds.height / 1.25)
    }
}
