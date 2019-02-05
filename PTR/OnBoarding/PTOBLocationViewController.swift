//
//  PTOBLocationViewController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/26/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import CoreLocation

class PTOBLocationViewController: PTOBPageViewController {
    
    lazy var anotherMainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        button.backgroundColor = .white
        button.titleLabel?.font = FontType.bold.with(size: 17)
        button.setTitleColor(Gradient.sunsetFade.mainColor(), for: .normal)
        
        return button
    }()
    
    var mainButtonIsEnabled: Bool = true {
        didSet {
            self.mainButton.isEnabled = mainButtonIsEnabled
            self.mainButton.alpha = mainButtonIsEnabled ? 1.0 : 0.5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsStackView.insertArrangedSubview(anotherMainButton, at: 0)
        buttonsStackView.spacing = 8
        
        self.anotherMainButton.setTitle("onboarding.location.action.selection".localized, for: .normal)
        self.anotherMainButton.addTarget(self, action: #selector(anotherMainButtonTapped), for: .touchUpInside)
        
        self.iconImageView.image = Icon.location.image
        self.titleLabel.text = "onboarding.location.title".localized
        self.subtitleLabel.text = "onboarding.location.description".localized
        
        self.mainButton.setTitle("onboarding.location.action.permession".localized, for: .normal)
        self.alternativeButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notifications.locationControllerDidChangeAuthorizationStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishFetchingLocation), name: Notifications.locationControllerDidFinishFetchingLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didStartFetchingLocation), name: Notifications.locationControllerDidBeginFetchingLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFaildFetchingLocation), name: Notifications.locationControllerDidFaildFetchingLocation, object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.anotherMainButton.layer.cornerRadius = anotherMainButton.bounds.height / 2
    }
    override func mainButtonTapped() {
        PTLocationController.shared.requestAuthorization()
    }
    
    @objc func anotherMainButtonTapped(){
        self.pageContainerViewController?.insertLocationSelectionAndGoForward()
    }
    
    @objc func didStartFetchingLocation(){
        self.mainButtonIsEnabled = false
        self.mainButton.setTitle("", for: .normal)
        self.titleLabel.text = "onboarding.location.title".localized
        self.subtitleLabel.text = "onboarding.location.action.fetching".localized
        self.mainButton.layer.cornerRadius = mainButton.frame.height / 2
        self.loadingIndicator.startAnimating()
    }

    @objc func didFaildFetchingLocation(){
        self.mainButtonIsEnabled = true
        self.mainButton.setTitle("onboarding.location.action.reload".localized, for: .normal)
        self.titleLabel.text = "onboarding.location.title_error".localized
        self.subtitleLabel.text = "onboarding.location.description_error".localized
        self.loadingIndicator.stopAnimating()
    }
    
    @objc func didFinishFetchingLocation(){
        self.pageContainerViewController?.finish()
    }
    
    func setPermessionDenied(){
        self.mainButtonIsEnabled = false
        self.mainButton.setTitle("onboarding.location.permession_denied".localized, for: .normal)
    }
    
    func setPermessionAuthorized(){
        PTLocationController.shared.startUpdatingLocation()
    }
    
    func setPermessionNotDeterminated(){
        self.mainButtonIsEnabled = true
        self.mainButton.setTitle("onboarding.location.action.permession".localized, for: .normal)
    }
    
    @objc func reload(){
        self.mainButton.layer.cornerRadius = mainButton.frame.height / 2
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            self.setPermessionDenied()
        } else if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            self.setPermessionAuthorized()
        } else if authorizationStatus == .notDetermined {
            self.setPermessionNotDeterminated()
        }
    }
}
