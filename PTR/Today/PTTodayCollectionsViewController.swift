//
//  PTHome1ViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/9/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources
import ViewAnimator
import MaterialShowcase

class PTTodayCollectionsViewController: PTViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: PTTodayCollectionView!
    
    fileprivate var headerView: PTMainHeaderView!
    fileprivate var appearsCount = 0
    
    lazy var dataSource: PTCollectionsDataSource = {
        return PTCollectionsDataSource(collectionView: self.collectionView)
    }()
    
    var remindersCount: Int {
        return PTCalculationsController.shared.dayInfo(for: Date().nessComponents).remindersCount
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.title = "labels.titles.today".localized
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.tabBarItem.title = Labels.today
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentPrayerDidChange), name: Notifications.currentPrayerDidChange, object: nil)
        
        
        dataSource.onDidSelectBlock = { [unowned self] ip in
            let collection = self.dataSource.item(at: ip)
            
            PTPrayerTimesController.default.selectedPrayer = collection.prayer
            let remindersVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PTRemindersViewController.self)) as! PTRemindersViewController
            remindersVC.collection = collection
            
            self.navigationController?.pushViewController(remindersVC, animated: true)
        }
        
        self.view.backgroundColor = .white

        setupHeaderView()
        collectionView.ds_useDataSource(self.dataSource)
        collectionView.ds_reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nextPrayer = PTPrayerTimesController.default.nextPrayerForToday
        if nextPrayer != .none {
            PTPrayerTimesController.default.selectedPrayer = nextPrayer
        }
        
        currentPrayerDidChange()
        
        if appearsCount < 1 {
            /* fix a bug, need to manually set the content offset to let the header appear */
            collectionView.contentOffset = CGPoint(x: 0, y: -headerView.maximumContentHeight)
        }
        
        PTPrayerTimesController.default.selectedPrayer = PTPrayerTimesController.default.nextPrayerForToday
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PTPreferencesController.shared.getRunsCount() < 2 || PTPreferencesController.shared.isTestingTutorials {
            switch appearsCount {
            case 0: // still the first appear
                showFirstTutorial()
                break
            case 1:
                showSecondTutorial()
                break
            default:
                break
            }
        }


        appearsCount += 1
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
        headerView.frame = .zero
        headerView.titleLabel.text = "constants.home.title".localized
        headerView.backgroundColor = .clear
        headerView.autoresizingMask = []
        
        headerView.subtitleLabel.font = FontType.regular.with(size: 15)
        headerView.titleLabel.font = FontType.bold.with(size: 35)
        
        
        headerView.maximumContentHeight = statusBarHeight + 120
        headerView.minimumContentHeight = statusBarHeight
        
        self.collectionView.addSubview(headerView)
    }
    
    func showFirstTutorial(){
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: collectionView.cellForItem(at: IndexPath(item: 0, section: 0))!)
        showcase.primaryText = "tutorial.today.first.title".localized
        showcase.secondaryText = "tutorial.today.first.details".localized
        showcase.show(completion: nil)
    }
    
    func showSecondTutorial(){
        guard let tabBar = self.tabBarController?.tabBar else {
            return
        }
        
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(tabBar: tabBar, itemIndex: 1)
        showcase.primaryText = "tutorial.today.second.title".localized
        showcase.secondaryText = "tutorial.today.second.details".localized
        showcase.show(completion: nil)
    }
}


extension PTTodayCollectionsViewController {
    @objc func currentPrayerDidChange(){
        let nextPrayer = PTPrayerTimesController.default.nextPrayerForToday

        /* Only change the selected prayer to match the current prayer if we're in the top level view controllers. */
        let currentVisibleViewControllerType = type(of: UIApplication.topViewController()!)
        
        if currentVisibleViewControllerType == PTTodayCollectionsViewController.self || currentVisibleViewControllerType == PTCalendarViewController.self || currentVisibleViewControllerType == PTPreferencesController.self {
            PTPrayerTimesController.default.selectedPrayer = nextPrayer
        }
        
        /* attempting to get prayer times, if not found we return and display error */
        guard let prayerTimesForToday = PTPrayerTimesController.default.prayerTimesForToday() else {
            headerView?.subtitleLabel.text = "constants.home.details.error".localized
            headerView?.subtitleLabel.textColor = ColorsDefines.gray
            return
        }
        
        /* it's the end of the day.. */
        if nextPrayer == .none && prayerTimesForToday.isha.timeIntervalSinceNow <= 0 {
            headerView?.subtitleLabel.text = "constants.home.details.end_of_day".localized
            headerView?.subtitleLabel.textColor = PTPrayer.isha.color
            return
        }
        
        guard let nextPrayerDate = prayerTimesForToday.time(for: prayerTimesForToday.nextPrayer()) else {
            headerView?.subtitleLabel.text = "constants.home.details.error".localized
            headerView?.subtitleLabel.textColor = ColorsDefines.gray
            return
        }
        
        let formatted = PTTimeFormatter.shared.string(from: nextPrayerDate)
        
        headerView?.subtitleLabel.text = String(format: "constants.home.details".localized, nextPrayer.text, formatted)
        headerView?.subtitleLabel.textColor = nextPrayer.color
        headerView?.topViewColor = nextPrayer.color
    }
}
