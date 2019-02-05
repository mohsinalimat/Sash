//
//  UIViewController+Navigation.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/6/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissViewController() {
        if let navigationController = navigationController, navigationController.viewControllers.first != self {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
