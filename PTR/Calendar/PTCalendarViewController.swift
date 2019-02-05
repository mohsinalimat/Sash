//
//  PTCalendarViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import FSCalendar
import AYGestureHelpView

class PTCalendarViewController: PTViewController, UIGestureRecognizerDelegate {

    //MARK: Variables
    var newReminderSession: PTNewReminderSession?
    
    var helpView: AYGestureHelpView?
    
    var date: Date? {
        didSet {
            dayRemindersViewController.dateComponents = (date ?? Date()).nessComponents
        }
    }
    
    var plusButtonIsEnabled: Bool = true {
        didSet {
            plusButton.alpha = plusButtonIsEnabled ? 1 : 0.5
            plusButton.isEnabled = plusButtonIsEnabled
        }
    }
    
    
    var appearsCount = 0
    
    weak var tableView: PTRemindersTableView?
    
    var dayRemindersViewController: PTDayRemindersViewController {
        return children.first as! PTDayRemindersViewController
    }
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Ouetlets
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButton: PTPlusButton!
    @IBOutlet weak var headerBackgroundView: PTBackgroundView!
    @IBOutlet weak var calendarView: PTCalendarView!
    @IBOutlet weak var containerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "labels.titles.calendar".localized
        
        tableView = self.dayRemindersViewController.tableView

        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView?.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(persistanceDidChange), name: Notifications.persistanceDidFinishUpdating, object: nil)
        
        self.headerBackgroundView.backgroundType = .solid
        selectedPrayerDidChange()

        self.calendarView.select(Date())
        dayRemindersViewController.dateComponents = (date ?? Date()).nessComponents
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PTPreferencesController.shared.getRunsCount() < 2 || PTPreferencesController.shared.isTestingTutorials {
            if appearsCount == 0 {
                showTutorial()
            }
        }
        
        appearsCount += 1
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func selectedPrayerDidChange() {
        super.selectedPrayerDidChange()
        
        let prayer = PTPrayerTimesController.default.selectedPrayer
        
        self.headerBackgroundView.gradientView.colors = prayer.gradient.colors()
        self.headerBackgroundView.backgroundColor = prayer.color
        
        self.plusButton.backgroundColor = prayer.color
        self.calendarView.appearance.titleTodayColor = prayer.color
    }
    
    func showTutorial(){
        let labelText = "tutorial.calendar.title".localized
        
        let bottomPoint = CGPoint(x: self.view.center.x, y: self.calendarView.frame.maxY)
        let topPoint = self.calendarView.center
        let labelPoint = CGPoint(x: bottomPoint.x, y: bottomPoint.y + 30)
        
        helpView = AYGestureHelpView(label: FontType.bold.with(size: 17))
        helpView?.swipe(withLabelText: labelText, label: labelPoint, touchStart: bottomPoint, touchEnd: topPoint, dismissHandler: nil, hideOnDismiss: true)
    }
}


//MARK: Events
extension PTCalendarViewController {
    @objc func persistanceDidChange(){
        configureVisibleCells()
    }
    
    @IBAction func plusButtonTapped(){
        self.newReminderSession = PTNewReminderSession(in: (self.date ?? Date()).nessComponents)
        self.newReminderSession?.start()
    }
}


//MARK: Calendar
extension PTCalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let tableView = self.tableView else { return false }
        let shouldBegin = tableView.contentOffset.y <= -tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell as! PTCalendarCollectionViewCell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.heightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let cell = calendar.cell(for: date, at: monthPosition) as? PTCalendarCollectionViewCell {
            configure(cell: cell, for: date, at: monthPosition)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.date = date
        
        let date1 = Calendar.georgian.date(from: (self.date ?? Date()).nessComponents)!
        let date2 = Calendar.georgian.date(from: Date().nessComponents)!
        
        self.plusButtonIsEnabled = date1 >= date2
        
        let cell = calendar.cell(for: date, at: monthPosition) as! PTCalendarCollectionViewCell
        configure(cell: cell, for: date, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: PTCalendarView.cellReuseIdentifier, for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if Calendar.georgian.isDateInToday(date) {
            return 1
        } else { return 0 }
    }
    
    
    
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell as! PTCalendarCollectionViewCell, for: date!, at: position)
        }
    }
    
    private func configure(cell: PTCalendarCollectionViewCell, for date: Date, at position: FSCalendarMonthPosition) {
        let components = date.nessComponents
        let dayInfo = PTCalculationsController.shared.dayInfo(for: components)
        
        cell.showsProgressIndicator = dayInfo.remindersCount > 0
        if dayInfo.remindersCount > 0 {
            cell.progress = CGFloat(dayInfo.completedRemindersCount) / CGFloat(dayInfo.remindersCount)
        }
    }
}

