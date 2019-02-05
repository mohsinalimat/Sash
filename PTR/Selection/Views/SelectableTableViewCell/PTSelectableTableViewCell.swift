//
//  PTReminderTableViewCell.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTSelectableTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.font = FontType.medium.with(size: 14)
        }
    }
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            self.detailsLabel.font = FontType.regular.with(size: 14)
            self.detailsLabel.textColor = self.tintColor
        }
    }
    
    @IBOutlet weak var iconBorderView: UIView! {
        didSet {
            iconBorderView.layer.borderColor = ColorsDefines.clouds.cgColor
            iconBorderView.layer.borderWidth = 1
            iconBorderView.layer.cornerRadius = iconBorderView.bounds.height / 2
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    
    var icon: Icon? {
        didSet {
            iconImageView.image = icon?.image
            
            if hidesIconViewIfNoImage {
                iconBorderView.isHidden = icon == nil
                layoutIfNeeded()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconBorderView.layer.cornerRadius = iconBorderView.bounds.height / 2
    }
    
    var hidesIconViewIfNoImage: Bool = true
}
