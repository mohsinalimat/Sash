//
//  PTCollectionCardViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources
import DeckTransition
import MaterialShowcase

class PTRemindersViewController: PTViewController {
    
    //MARK: Outlets
    @IBOutlet weak var backgroundView: PTBackgroundView! {
        didSet {
            backgroundView.backgroundType = .solid
            backgroundView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var tableView: PTRemindersTableView! {
        didSet {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 5))
            tableView.emptyViewVerticalOffset = -100
            
        }
    }
    
    @IBOutlet weak var plusButton: PTPlusButton! {
        didSet {
        }
    }
    
    var headerView: PTRemindersHeaderView!
    
    //MARK: Vars
    var newReminderSession: PTNewReminderSession?
    var reminderDetailsSession: PTReminderDetailsSession?
    
    
    // Model: Changing the model requires to reload both apperance and data.
    var collection: PTPrayerRemindersCollection! {
        didSet {
            collectionDidChange()
        }
    }
    
    var canAddReminder: Bool {
        guard let date = collection.date else {
            return false
        }
        
        return date >= Date()
    }
    
    lazy var dataSource: PTRemindersDataSource! = {
        return PTRemindersDataSource(collection: self.collection, tableView: self.tableView)
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.onItemTap = { [unowned self] ip in
            DispatchQueue.main.async {
                let reminder = self.dataSource.item(at: ip)
                self.open(reminder: reminder)
            }
        }
        
        tableView.ds_useDataSource(self.dataSource)
        collectionDidChange()
        setupHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if PTPreferencesController.shared.getInt(for: .remindersOpensCount) < 1 || PTPreferencesController.shared.isTestingTutorials {
            let newReminderShowcase = MaterialShowcase()
            newReminderShowcase.setTargetView(view: plusButton)
            newReminderShowcase.primaryText = "tutorial.reminders.title".localized
            newReminderShowcase.secondaryText = "tutorial.reminders.details".localized
            newReminderShowcase.backgroundPromptColor = plusButton.backgroundColor
            
            newReminderShowcase.show(completion: nil)
            
            PTPreferencesController.shared.set(integer: 1, for: .remindersOpensCount)
        }
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
    
    
    
    func setupHeaderView() {
        if self.headerView != nil {
            return
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.headerView = PTRemindersHeaderView.instantiateFromNIB()
        headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: statusBarHeight + 220)
        
        headerView.maximumContentHeight = statusBarHeight + 180
        headerView.minimumContentHeight = statusBarHeight + 70
        
        headerView.detailsLabel.text = collection?.details
        headerView.detailsLabel.font = FontType.regular.with(size: 21)
        headerView.detailsLabel.textColor = ColorsDefines.gray
        
        headerView.titleLabel.text = collection?.title
        headerView.titleLabel.font = FontType.medium.with(size: 35)
        
        headerView.titleLabel?.textColor = collection.color
        
        headerView.onBackButtonTap = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        
        headerView.iconBackgroundView?.backgroundColor = collection.color//?.withAlphaComponent(0.05)
        headerView.iconImageView?.tintColor = .white//collection.color
        headerView.iconImageView?.image = collection.icon?.image
        
        
        self.tableView.addSubview(headerView)
    }
    
    func open(reminder: PTReminder){
        reminderDetailsSession = PTReminderDetailsSession(with: reminder, for: self.collection.dateComponents)
        reminderDetailsSession?.start()
    }
}

extension PTRemindersViewController {
    // On collection ( model ) change, we want to reload the data and the apperance
    func collectionDidChange(){
        collection.reload()
        
        // update the apperance
        backgroundView?.gradientView.colors = collection.gradient!.colors()
        plusButton?.backgroundColor = collection.color
        
        headerView?.detailsLabel.text = collection?.details
        headerView?.detailsLabel.font = FontType.regular.with(size: 21)
        headerView?.detailsLabel.textColor = ColorsDefines.gray
        
        headerView?.titleLabel.text = collection?.title
        headerView?.titleLabel?.textColor = collection.color
        
        
        headerView?.iconBackgroundView?.backgroundColor = collection.color//?.withAlphaComponent(0.08)
        headerView?.iconImageView?.tintColor = .white//collection.color
        headerView?.iconImageView?.image = collection.icon?.image
        
        self.dataSource.collection = self.collection
        self.dataSource.items = collection.reminders
        self.dataSource.tableView = tableView
        
        tableView?.placeholder = Placeholder.default()
        tableView?.ds_reloadData()
    }
    
    @IBAction func plusButtonTapped(){
        self.newReminderSession = PTNewReminderSession(in: self.collection.dateComponents)
        self.newReminderSession?.start()
    }
}
