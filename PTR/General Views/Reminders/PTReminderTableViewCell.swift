//
//  PTReminderTableViewCell.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/29/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import BEMCheckBox

class PTReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var checkBox: BEMCheckBox! {
        didSet {
            checkBox.lineWidth = 1.5
            checkBox.onCheckColor = .white
            checkBox.onFillColor = tintColor
            checkBox.onTintColor = tintColor
            checkBox.tintColor = tintColor//ColorsDefines.clouds.withAlphaComponent(0.6)
            checkBox.onAnimationType = .bounce
            checkBox.offAnimationType = .bounce
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!  {
        didSet {
            self.titleLabel.font = FontType.medium.with(size: 14)
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            self.subtitleLabel.font = FontType.regular.with(size: 11)
            self.subtitleLabel.textColor = tintColor
        }
    }
    
    
    @IBOutlet weak var separatorView: UIView!  {
        didSet {
            separatorView.backgroundColor = ColorsDefines.clouds
        }
    }
    
    var onCheckBoxTap: ((Bool) -> Void)?
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        subtitleLabel.textColor = tintColor
        checkBox.onFillColor = tintColor
        checkBox.onTintColor = tintColor
        checkBox.tintColor = tintColor
    }
    
    @IBAction func checkBoxValueChanged(sender: BEMCheckBox){
        self.onCheckBoxTap?(sender.on)
    }
}
