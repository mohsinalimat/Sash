//
//  PTReminderDetailsSession.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 1/18/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation
import UIKit
import DeckTransition

class PTReminderDetailsSession: PTSession {
    
    var identifier: String?

    fileprivate(set) var reminder: PTReminder
    fileprivate(set) var dateComponents: DateComponents
    
    fileprivate var viewController: PTReminderDetailsViewController?
    
    init(with reminder: PTReminder, for dateComponents: DateComponents){
        self.reminder = reminder
        self.dateComponents = dateComponents
    }
    
    func start() {
        viewController = UIStoryboard(name: "ReminderDetailsSession", bundle: nil).instantiateInitialViewController() as? PTReminderDetailsViewController
        viewController?.detailsData = PTReminderDetailsViewController.DetailsData(dateComponents: dateComponents, reminder: reminder)
        
        let transitionDelegate = DeckTransitioningDelegate(isSwipeToDismissEnabled: true, presentDuration: 0.25, presentAnimation: nil, presentCompletion: nil, dismissDuration: 0.25, dismissAnimation: nil, dismissCompletion: nil)
        
        viewController?.transitioningDelegate = transitionDelegate
        viewController?.modalPresentationStyle = .custom
        
        let presentingVC = UIApplication.topViewController()
        presentingVC?.present(viewController!, animated: true, completion: nil)
    }
    
    func cancel() {
        viewController?.dismiss()
    }
}
