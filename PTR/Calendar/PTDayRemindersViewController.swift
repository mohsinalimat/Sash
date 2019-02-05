//
//  PTTodayListViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources

class PTDayRemindersViewController: PTViewController {
    
    lazy var prayerTimes: PTPrayerTimes? = {
       return PTPrayerTimesController.default.prayerTimes(for: dateComponents)
    }()
    
    
    var deleteSession: PTDeleteReminderSession?
    var reminderDetailsSession: PTReminderDetailsSession?
    
    var dateComponents: DateComponents! = Date().nessComponents {
        didSet {
            var collections: [PTPrayerRemindersCollection] = []
            for prayer in PTPrayer.all {
                collections.append(PTPrayerRemindersCollection(prayer: prayer, dateComponents: dateComponents))
            }
            
            dataSource = PTDayRemindersDataSource(collections: collections, tableView: self.tableView)
            dataSource.onSelectionBlock = { [unowned self] item in
                DispatchQueue.main.async {
                    self.open(reminder: item)
                }
            }
            
            self.prayerTimes  = PTPrayerTimesController.default.prayerTimes(for: self.dateComponents)
            
            self.tableView.ds_useDataSource(dataSource)
            self.tableView.reloadData()
        }
    }
    
    lazy var tableView: PTRemindersTableView = {
        let tv = PTRemindersTableView(frame: .zero)
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 5))
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tv)
        tv.pinToSuperView()
        
        return tv
    }()
    
    lazy var dataSource: PTDayRemindersDataSource = {
        return PTDayRemindersDataSource(collections: [], tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.ds_useDataSource(dataSource)
        tableView.ds_reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.tableView = tableView
        tableView.ds_reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.tableView = nil
    }
    
    func open(reminder: PTReminder){
        reminderDetailsSession = PTReminderDetailsSession(with: reminder, for: self.dateComponents)
        reminderDetailsSession?.start()
    }
}
