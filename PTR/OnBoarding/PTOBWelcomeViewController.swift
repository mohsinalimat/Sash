//
//  PTOBWelcomeViewController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/26/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTOBWelcomeViewController: PTOBPageViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconImageView.image = Icon.sun.image
        self.titleLabel.text = "onboarding.welcome.title".localized
        self.subtitleLabel.text = "onboarding.welcome.description".localized
        
        self.mainButton.setTitle("onboarding.welcome.action_title".localized, for: .normal)
        self.alternativeButton.isHidden = true
    }
    
    override func mainButtonTapped() {
        self.pageContainerViewController?.next()
    }
}
