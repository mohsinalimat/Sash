//
//  PTReminderDetailsViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/13/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import BEMCheckBox

class PTReminderDetailsViewController: PTViewController {
    
    struct DetailsData {
        var dateComponents: DateComponents
        var reminder: PTReminder
    }
    
    var detailsData: DetailsData! {
        didSet {
            detailsDataDidChange()
        }
    }
    
    var reminder: PTReminder {
        return detailsData.reminder
    }

    var dateComponents: DateComponents {
        return detailsData.dateComponents
    }
    
    lazy var dataSource: PTReminderDetailsDataSource = {
        return PTReminderDetailsDataSource()
    }()
    

    //MARK: Outlets
    @IBOutlet weak var checkbox: BEMCheckBox! {
        didSet {
            checkbox.lineWidth = 3
            checkbox.onCheckColor = .white
            checkbox.onAnimationType = .bounce
            checkbox.offAnimationType = .bounce
        }
    }
    
    
    @IBOutlet weak var headerTitleLabel: UILabel! {
        didSet {
            headerTitleLabel.textColor = .black
            headerTitleLabel.font = FontType.medium.with(size: 21)
        }
    }
    
    @IBOutlet weak var headerSubtitleLabel: UILabel! {
        didSet {
            headerSubtitleLabel.textColor = ColorsDefines.gray
            headerSubtitleLabel.font = FontType.regular.with(size: 15)
        }
    }
    
    
    @IBOutlet weak var headerView: UIView! {
        didSet {
            // no customization here :D
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.ds_register(headerFooterNib: PTSectionHeaderView.self)
            tableView.ds_register(cellNib: PTSelectableTableViewCell.self)

        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.ds_useDataSource(self.dataSource)
        tableView.ds_reloadData()
    
        detailsDataDidChange()
        selectedPrayerDidChange()
    }
}

extension PTReminderDetailsViewController {
    func detailsDataDidChange(){
        // let the data source reload
        dataSource.reminder = reminder
        
        // reload the tableview for changes to take effect
        tableView?.ds_reloadData()
        
        // update labels
        headerTitleLabel?.text = reminder.contents
        headerSubtitleLabel?.text = PTDateFormatter.shared.string(from: Calendar.georgian.date(from: dateComponents)!)
        
        checkbox?.onFillColor = reminder.prayer.color!
        checkbox?.onTintColor = reminder.prayer.color!
        checkbox?.tintColor = reminder.prayer.color!

        
        // update the checkbox view
        checkbox?.on = reminder.isCompleted(for: self.dateComponents)
    }
    
    override func selectedPrayerDidChange() {
    }
    
    @IBAction func checkBoxValueChanged(){
        PTPersistanceManager.shared.addActivity(for: self.reminder, action: self.checkbox.on ? .completed : .none, date: PTPrayerTimesController.default.date(with: self.detailsData.reminder.prayer, in: self.detailsData.dateComponents) ?? Date())

    }
}
