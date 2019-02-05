//
//  PTCircleView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 7/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

@IBDesignable
class PTRoundedView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            if fullyRounded {
                return
            }
            layer.cornerRadius = newValue; setNeedsDisplay()
        } get { return layer.cornerRadius }
    }
    
    @IBInspectable var fullyRounded: Bool = false {
        didSet {
            layer.cornerRadius = bounds.height / 2
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue; setNeedsDisplay() } get { return layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        } get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            
            return nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if fullyRounded {
            cornerRadius = bounds.height / 2
        }
    }
}
