//
//  PTOBNotificationsViewController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/26/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import UserNotifications

class PTOBNotificationsViewController: PTOBPageViewController {
    
    var notificationsController: PTNotificationsController = .shared
    
    var mainButtonIsEnabled: Bool = true {
        didSet {
            self.mainButton.isEnabled = mainButtonIsEnabled
            self.mainButton.alpha = mainButtonIsEnabled ? 1.0 : 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.iconImageView.image = Icon.notification.image
        self.titleLabel.text = "onboarding.notifications.title".localized
        self.subtitleLabel.text = "onboarding.notifications.description".localized
        
        self.mainButton.setTitle("onboarding.notifications.action_title".localized, for: .normal)
        self.alternativeButton.setTitle("onboarding.notifications.alternative_action_title".localized, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
    
    override func mainButtonTapped() {
        self.mainButtonIsEnabled = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { (enabled, error) in
            DispatchQueue.main.async {
                self.pageContainerViewController?.next()
            }
        }
    }
    
    override func alternativeButtonTapped() {
        self.pageContainerViewController?.next()
    }
    
    func setPermessionDenied(){
        self.mainButtonIsEnabled = false
        self.mainButton.setTitle("onboarding.notifications.permession_denied".localized, for: .normal)
    }
    
    func setPermessionAuthorized(){
        self.mainButtonIsEnabled = false
        self.mainButton.setTitle("onboarding.notifications.authorized".localized, for: .normal)
    }
    
    func setPermessionNotDeterminated(){
        self.mainButtonIsEnabled = true
        self.mainButton.setTitle("onboarding.notifications.action_title".localized, for: .normal)

    }
    
    func reload(){
        mainButtonIsEnabled = false
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied {
                    // authorization denied, so 1. disable the button 2. set the text
                    self.setPermessionDenied()
                    return
                } else if settings.authorizationStatus == .authorized {
                    // authorized, so go to next
                    self.setPermessionAuthorized()
                    return
                } else if settings.authorizationStatus == .notDetermined {
                    self.setPermessionNotDeterminated()
                }
                
                if #available(iOS 12.0, *) {
                    if settings.authorizationStatus == .provisional {
                        self.setPermessionNotDeterminated()
                        return
                    }
                }
            }

        }
    }
}
