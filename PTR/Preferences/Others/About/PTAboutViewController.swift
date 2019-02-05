//
//  PTAboutViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import MessageUI

class PTAboutViewController: PTViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var firstAppear = false
    
    lazy var headerView: PTAboutHeaderView = {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let headerView = PTAboutHeaderView.instantiateFromNIB()!
        headerView.frame = CGRect(x: 0, y: 0, width: self.textView.bounds.width, height: statusBarHeight + 150)
        headerView.backgroundColor = .clear
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.titleLabel.textAlignment = .center
        headerView.titleLabel.textColor = .black
        headerView.titleLabel.font = FontType.bold.with(size: 21)
        
        headerView.subtitleLabel.textAlignment = .center
        headerView.subtitleLabel.textColor = ColorsDefines.gray
        headerView.subtitleLabel.font = FontType.medium.with(size: 14)
        
        headerView.iconBackgroundView.layer.cornerRadius = headerView.iconBackgroundView.bounds.height / 2
        headerView.backButton.tintColor = ColorsDefines.gray
        
        headerView.onBackButtonTap = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        headerView.titleLabel.text = Labels.About.title
        headerView.subtitleLabel.text = Labels.About.subtitle
        
        return headerView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.textColor = .black
        textView.font = FontType.medium.with(size: 14)
        textView.isEditable = false
        textView.isSelectable = false
        
        textView.textAlignment = .center
        textView.textColor = UIColor(white: 0.2, alpha: 1)
        textView.font = FontType.medium.with(size: 17)

        
        
        return textView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(headerView)
        
        let safeArea = view.safeAreaLayoutGuide
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        headerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15).isActive = true
        headerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: statusBarHeight + 150).isActive = true

        view.addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        textView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8).isActive = true
        textView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true


        var string = ""
        do {
            string = try String(contentsOf: Bundle.main.url(forResource: "About", withExtension: "txt")!)
        } catch {
            print("Error reading the file")
        }
        
        textView.text = string
        
        selectedPrayerDidChange()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.isScrollEnabled = false
        
        if firstAppear {
            /* fix a bug, need to manually set the content offset to let the header appear */
//            textView.contentOffset = CGPoint(x: 0, y: -headerView.maximumContentHeight)
            firstAppear = false
        }

//        textView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.isScrollEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self.view) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        /* if the touch location has lies on the same y ( range ) axis as the header view, and the x coordinate is smaller than the header view origin, handle back :) */
        let headerFrame = view.convert(headerView.frame, from: headerView.superview)
        
        if location.y > headerFrame.minY && location.y < headerFrame.maxY && location.x < headerFrame.minX {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        super.touchesEnded(touches, with: event)
    }
}

extension PTAboutViewController {
    override func selectedPrayerDidChange() {
        super.selectedPrayerDidChange()
        
        let selectedPrayer = PTPrayerTimesController.default.selectedPrayer == .none ? .isha : PTPrayerTimesController.default.selectedPrayer
        
        headerView.iconBackgroundView?.backgroundColor = selectedPrayer.color//?.withAlphaComponent(0.05)
        headerView.iconImageView.tintColor = .white//selectedPrayer.color
        headerView.iconImageView?.image = selectedPrayer.icon?.image
        
        headerView.titleLabel.textColor = selectedPrayer.color
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactUsButtonTapped(){
        PTPreferencesController.shared.requestContactUsPromopt()
    }
}
