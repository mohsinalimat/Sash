//
//  PTAboutHeaderView.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/6/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class PTAboutHeaderView: UIView {

    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var iconBackgroundView: PTRoundedView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var backButton: PTBackButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var onBackButtonTap: (() -> Void)?
    
    func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        self.mainStackView.alpha = max(0, min(1, stretchFactor))
        self.backButton.alpha = max(0, min(1, stretchFactor))
    }
    
    @IBAction func backButtonTapped(){
        self.onBackButtonTap?()
    }

}
