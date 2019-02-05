//
//  PTSwitchTableViewCell.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/28/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTSwitchTableViewCell: UITableViewCell {
    
    var onValueChanged: ((Bool) -> Void)?

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = FontType.medium.with(size: 14)
        }
    }
    
    @IBOutlet weak var switchView: UISwitch! {
        didSet {
            switchView.onTintColor = tintColor
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        switchView.onTintColor = tintColor
    }
    
    
    @IBAction func switchValueChanged(_ sender: Any) {
        onValueChanged?(self.switchView.isOn)
    }
}
