//
//  PTSelectionHeaderView.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 12/29/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class PTSelectionHeaderView: GSKStretchyHeaderView {
    
    @IBOutlet weak var titlesStackView: UIStackView!
    @IBOutlet weak var backButton: PTBackButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var onBackButtonTap: (() -> Void)?
    
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        self.titlesStackView.alpha = max(0, min(1, stretchFactor))
        self.backButton.alpha = max(0, min(1, stretchFactor))
    }
    
    @IBAction func backButtonTapped(){
        self.onBackButtonTap?()
    }
}
