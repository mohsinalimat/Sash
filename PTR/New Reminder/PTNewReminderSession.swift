//
//  NewReminderSession.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/11/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources
import DeckTransition

class PTNewReminderSession: NSObject, UIGestureRecognizerDelegate, PTSession {
    
    private struct Constants {
        static let newReminderVCIdentifier = "NewReminderVC"
        static let optionsVCIdentifier = "OptionsVC"
        static let storyboardName = "NewReminderSession"
        static let textKey = "newReminder_text"
    }
    
    fileprivate var newReminderViewController: PTNewReminderViewController!
    
    /* if the session has enough information to save.. */
    var canSave: Bool {
        // check the text
        if newReminderViewController.textField?.text == nil || newReminderViewController.textField?.text?.isEmpty == true {
            return false
        }
        
        // check the containers
        if prayer == .none { return false }
        
        return true
    }
    
    var identifier: String?
    
    /// any view controller who wishes to present this view controller may need to set the original prayer times ( note: if not provided, it will be set default for today ).
    lazy var prayerTimes: PTPrayerTimes? = {
        return PTPrayerTimesController.default.prayerTimes(for: self.dateComponents)
    }()
    
    var dateComponents: DateComponents = Date().nessComponents {
        didSet {
        }
    }
    
    /// the new reminder view controller must have a prayer, otherwise it won't select
    var prayer: PTPrayer = .none {
        didSet {
            if prayer == .none {
                prayer = .fajr
            }
            
            reload()
        }
    }
    
    
    var repeatDays: [Weekday] = [] {
        didSet {
            reload()
        }
    }
    
    var shiftInterval: ShiftInterval = .zero {
        didSet {
            reload()
        }
    }
    
    fileprivate lazy var prayerSelectionSession: PTSelectionSession<PTPrayer> = {
        let session = PTSelectionSession<PTPrayer>()
        session.selectionTitle = SessionsStrings.PrayerSelection.title
        session.selectionDetails = SessionsStrings.PrayerSelection.details
        session.selectedIndexes = [prayer.index]
        
        session.onSelectionChange = { [unowned self] items in
            self.prayer = items.first!
        }
        
        return session
    }()
    
    fileprivate lazy var repeatDaysSelectionSession: PTSelectionSession<Weekday> = {
        let session = PTSelectionSession<Weekday>()
        session.selectionTitle = SessionsStrings.RepeatDaysSelection.title
        session.selectionDetails = SessionsStrings.RepeatDaysSelection.details
        session.selectedIndexes = self.repeatDays.map { $0.index }
        session.selectionType = .multiple
        
        session.onSelectionChange = { [unowned self] items in
            self.repeatDays = items
        }
        
        return session
    }()
    
    fileprivate lazy var shiftIntervalSelectionSession: PTSelectionSession<ShiftInterval> = {        
        let session = PTSelectionSession<ShiftInterval>()
        session.selectionTitle = SessionsStrings.ShiftIntervalSelection.title
        session.selectionDetails = SessionsStrings.ShiftIntervalSelection.details
        session.selectedIndexes = [self.shiftInterval.index]
        session.selectionType = .single
        
        session.onSelectionChange = { [unowned self] items in
            self.shiftInterval = items.first!
        }
        
        return session
    }()
    
    fileprivate var contents: String = ""

    
    fileprivate(set) lazy var dataSource: PTOptionsDataSource! = {
        let ds = PTOptionsDataSource(items: _options())
        ds.defaultAccessoryType = .disclosureIndicator
        ds.tintedViewElementTypes = [.icon]

        let selectionHandler = BlockSelectionHandler<PTOption, PTSelectableTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cv, ip in
            self._openSession(at: ip.row)
        }
        
        ds.setSelectionHandler(selectionHandler)
        
        return ds
    }()
    
    init(in dateComponents: DateComponents) {
        super.init()
        
        self.prayer = PTPrayerTimesController.default.selectedPrayer == .none ? .fajr : PTPrayerTimesController.default.selectedPrayer
        self.dateComponents = dateComponents
        
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        
        self.newReminderViewController = storyboard.instantiateInitialViewController() as? PTNewReminderViewController
        self.newReminderViewController.session = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (newReminderViewController?.navigationController?.viewControllers.count ?? 0) > 1
    }
    
    func reload(){
        // update the datasource with the updated items :)
        dataSource.items = self._options()
        
        // set the color based on prayer
        let color = Gradient.for(prayer: self.prayer).mainColor()
        
        newReminderViewController.color = color
        dataSource.defaultColor = color
        
        
        newReminderViewController.saveButtonIsEnabled = canSave
        
        // update the options tableview
        newReminderViewController.tableView?.reloadData()
    }
    
    func set(text: String?){
        self.contents = text ?? ""
        
        UserDefaults.standard.set(text, forKey: Constants.textKey)
        UserDefaults.standard.synchronize()
    }
    
    private func _options() -> [PTOption] {
        let prayerOption = PTOption(title: prayer.text, details: nil, optionIcon: prayer.icon)
        let repeatDaysOption = PTOption(title: RepeatDaysDetailsFactory(repeatDays: self.repeatDays, includesEmptyString: true).string(), optionIcon: .repeat)
        let shiftIntervalOption = PTOption(title: shiftInterval.text, optionIcon: .notification)
        
        return [prayerOption, repeatDaysOption, shiftIntervalOption]
    }
    
    private func _openSession(at index: Int) {
        switch index {
        case 0: prayerSelectionSession.start()
        case 1: repeatDaysSelectionSession.start()
        case 2: shiftIntervalSelectionSession.start()
        default: return
        }
    }
}

extension PTNewReminderSession {
    func start() {
        let viewController = UIApplication.topViewController()
        
        reload()
        
        let transitionDelegate = DeckTransitioningDelegate(isSwipeToDismissEnabled: true, presentDuration: 0.25, presentAnimation: nil, presentCompletion: nil, dismissDuration: 0.25, dismissAnimation: nil, dismissCompletion: nil)
        
        let navigationController = UINavigationController(rootViewController: newReminderViewController)
        navigationController.transitioningDelegate = transitionDelegate
        navigationController.modalPresentationStyle = .custom
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = self
        
        newReminderViewController.text = UserDefaults.standard.string(forKey: Constants.textKey)
        
        viewController?.present(navigationController, animated: true){ [unowned self] in
            self.reload()
        }
    }
    
    func cancel(){
        newReminderViewController.dismissViewController()
    }
    
    func save(){
        if !canSave { return }
        
        /// create a new reminder based on the input :D
        let text = newReminderViewController.textField.text!
        let prayer = self.prayer
        let repeatDays = self.repeatDays
        
        let time = PTPrayerTimesController.default.date(with: prayer, in: self.dateComponents)
        let original = Calendar.georgian.date(from: dateComponents)
        let now = Date()
        
        PTPersistanceManager.shared.createReminder(with: text, prayer: prayer, shiftInterval: self.shiftInterval, originalDate: (time ?? original) ?? now, repeatDays: repeatDays)
        newReminderViewController.dismissViewController()
        
        UserDefaults.standard.set(nil, forKey: Constants.textKey)
        UserDefaults.standard.synchronize()
    }
}
