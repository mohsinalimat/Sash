//
//  PTViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources

class PTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedPrayerDidChange), name: Notifications.selectedPrayerDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    // Event: Selected Prayer Change
    @objc dynamic func selectedPrayerDidChange(){
        
    }
}

