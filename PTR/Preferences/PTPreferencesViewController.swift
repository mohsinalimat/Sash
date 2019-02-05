//
//  PTPreferencesViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/30/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import MessageUI


/*
    - Apperance depends on the selected prayer.
    - Listens to preference change event and updates the view upon the change.
    - Performs actions like navigating to different screens.
*/
class PTPreferencesViewController: PTViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Labels.Preferences.title
            titleLabel.font = FontType.bold.with(size: 27)
            titleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.text = Labels.Preferences.subtitle
            subtitleLabel.font = FontType.regular.with(size: 15)
            subtitleLabel.textColor = ColorsDefines.gray
        }
    }
    
    var headerView: PTMainHeaderView!
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.ds_register(headerFooterNib: PTSectionHeaderView.self)
            tableView.ds_register(cellNib: PTSelectableTableViewCell.self)
            tableView.ds_register(cellNib: PTSwitchTableViewCell.self)
        }
    }
    
    lazy var dataSource: PTPreferencesDataSource = {
        return PTPreferencesDataSource(tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupHeaderView()
        
        tableView.ds_useDataSource(dataSource)
        tableView.ds_reloadData()
        
        /* Executed Once.. */
        PTLocationController.shared.startUpdatingLocation()
        selectedPrayerDidChange()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController!.viewControllers.count > 1
    }
    
    func setupHeaderView() {
        if self.headerView != nil {
            return
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.headerView = PTMainHeaderView.instantiateFromNIB()
        headerView.backgroundColor = .clear
        
        headerView.subtitleLabel.text = Labels.Preferences.subtitle
        headerView.subtitleLabel.font = FontType.regular.with(size: 15)
        headerView.subtitleLabel.textColor = ColorsDefines.gray

        headerView.titleLabel.text = Labels.Preferences.title
        headerView.titleLabel.font = FontType.bold.with(size: 35)

        
        headerView.maximumContentHeight = statusBarHeight + 120
        headerView.minimumContentHeight = statusBarHeight
        
        self.tableView.addSubview(headerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.observeNotificationsAuthorization()
    }
}

extension PTPreferencesViewController {
    // Update the apperance
    override func selectedPrayerDidChange() {
        let selectedPrayer = PTPrayerTimesController.default.selectedPrayer
        
        headerView?.subtitleLabel.textColor = selectedPrayer.color
        headerView?.topViewColor = selectedPrayer.color
    }
}
