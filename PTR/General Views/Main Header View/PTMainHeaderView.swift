//
//  PTHomeHeaderView.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 12/28/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class PTMainHeaderView: GSKStretchyHeaderView {
    
    let maxFontSize: CGFloat = 35
    let minFontSize: CGFloat = 18
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    var topViewColor: UIColor? = .white {
        didSet {
            topView.backgroundColor = topViewColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topView.backgroundColor = topViewColor
        topViewHeightConstraint.constant = UIApplication.shared.statusBarFrame.height
        topView.alpha = 0
        setNeedsLayout()
    }
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        let fontSize = CGFloatTranslateRange(min(1, stretchFactor), 0, 1, minFontSize, maxFontSize)
        
        let p = max(0, min(1, stretchFactor))
        
        self.titleLabel.alpha = p
        self.subtitleLabel.alpha = p

        if abs(fontSize - self.titleLabel.font.pointSize) > 0.05 { // to avoid changing the font too often, this could be more precise though
//            self.titleLabel.font = FontType.black.with(size: fontSize)
        }
        
//        self.topView.alpha = 1 - p
    }
}
