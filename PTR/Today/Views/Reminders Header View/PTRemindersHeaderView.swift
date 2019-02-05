//
//  File.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 12/28/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class PTRemindersHeaderView: GSKStretchyHeaderView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconBackgroundView: PTRoundedView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var backButton: PTBackButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomSeparatorView: UIView!
    
    var onBackButtonTap: (() -> Void)?
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        self.bottomSeparatorView.alpha = 1 - max(0, min(1, stretchFactor))
        self.iconImageView.alpha = max(0, min(1, stretchFactor))
        self.iconBackgroundView.alpha = max(0, min(1, stretchFactor))
        self.backButton.alpha = max(0, min(1, stretchFactor))
    }
    
    @IBAction func backButtonTapped(){
        onBackButtonTap?()
    }
}
