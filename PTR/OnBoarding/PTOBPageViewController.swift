//
//  PTOnBoardingBaseViewController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/25/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTOBPageViewController: PTOBViewController {
    
    //MARK: Views
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [iconImageView, titlesStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .center
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 25
        
        return sv
    }()
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true

        iv.widthAnchor.constraint(equalTo: iv.heightAnchor).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return iv
    }()
    
    lazy var titlesStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        
        return sv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontType.bold.with(size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontType.medium.with(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [mainButton, alternativeButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.axis = .vertical
        
        return sv
    }()
    
    lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        button.backgroundColor = .white
        button.titleLabel?.font = FontType.bold.with(size: 17)
        button.setTitleColor(Gradient.sunsetFade.mainColor(), for: .normal)

        return button
    }()
    
    lazy var alternativeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = FontType.medium.with(size: 13)
        return button
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        
        return indicator
    }()
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        furtherCustomization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mainButton.layer.cornerRadius = mainButton.frame.height / 2
    }
    
    private func setupView(){
        view.addSubview(mainStackView)
        view.addSubview(buttonsStackView)
        view.addSubview(loadingIndicator)
        
        
        /* setup constraints */
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        mainStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -50).isActive = true
        
        buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        buttonsStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 25).isActive = true
        
        
        loadingIndicator.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor).isActive = true
    }
    
    private func furtherCustomization(){
        self.mainButton.setTitleColor(pageItem.color, for: .normal)
        view.backgroundColor = .clear
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        alternativeButton.addTarget(self, action: #selector(alternativeButtonTapped), for: .touchUpInside)
    }
    
    @objc func mainButtonTapped(){
        
    }
    
    @objc func alternativeButtonTapped(){
        
    }
}

