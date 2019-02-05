//
//  PTCollectionCardCollectionViewCell.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTCollectionCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.textColor = tintColor
            self.titleLabel.font = FontType.bold.with(size: 17)
        }
    }
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            self.detailsLabel.textColor = ColorsDefines.gray
            self.detailsLabel.font = FontType.regular.with(size: 14)
        }
    }
    
    @IBOutlet weak var iconBackgroundView: UIView! {
        didSet {
            iconBackgroundView.layer.cornerRadius = iconBackgroundView.bounds.height / 2
            iconBackgroundView.backgroundColor = tintColor.withAlphaComponent(0.1)
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.color = tintColor
        }
    }
    
    @IBOutlet weak var badgeButton: UIButton! {
        didSet {
            badgeButton.backgroundColor = tintColor
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        badgeButton.layer.cornerRadius = badgeButton.bounds.height / 2
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        iconImageView.tintColor = .white//tintColor
        titleLabel.textColor = tintColor
        iconBackgroundView.backgroundColor = tintColor//.withAlphaComponent(0.08)
        activityIndicatorView.color = tintColor
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        
        badgeButton.backgroundColor = tintColor
    }
}
