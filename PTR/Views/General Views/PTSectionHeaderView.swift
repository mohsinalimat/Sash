//
//  PTPrayerHeader.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTSectionHeaderView: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.tintColor = tintColor
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.font = FontType.bold.with(size: 14)
        }
    }
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            self.detailsLabel.font = FontType.regular.with(size: 11)
            self.detailsLabel.textColor = tintColor
            self.detailsLabel.textAlignment = .right
        }
    }
    
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        }
    }
    
    var icon: Icon? {
        didSet {
            iconImageView.image = icon?.image
            
            if hidesIconViewIfNoImage {
                iconImageView.isHidden = icon == nil
                layoutIfNeeded()
            }
        }
    }
    
    var hidesIconViewIfNoImage: Bool = true
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        detailsLabel.textColor = tintColor
        iconImageView.tintColor = tintColor
        
    }
}
