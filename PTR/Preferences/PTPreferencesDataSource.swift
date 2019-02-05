//
//  PTPreferencesDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/15/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources
import MessageUI
import UserNotifications

class PTPreferencesDataSource: CompositeDataSource {
    
    private var sections: [PTSectionHeader] = []
    private var headerCreator: BasicBlockSupplementaryViewCreator<PTSectionHeader, PTSectionHeaderView>!
    
    private var prayerDataSource: PTOptionsDataSource!
    private var notificationsDataSource: CompositeDataSource!
    private var notificationsOptionsDataSource: PTOptionsDataSource!
    private var moreDataSource: PTOptionsDataSource!
    
    private var hasChangedNotificationSetting = false
    private var notificationsAuthorizationIsGranted = false

    var color: UIColor! = PTPrayerTimesController.default.selectedPrayer.color {
        didSet {
            prayerDataSource?.defaultColor = color
            moreDataSource?.defaultColor = color
            notificationsOptionsDataSource.defaultColor = color
        }
    }
    
    var onPrayerSelection: ((Int) -> Void)?
    var onNotificationsSelection: ((Int) -> Void)?
    var onMoreSelection: ((Int) -> Void)?
    
    weak var tableView: UITableView?

    init(tableView: UITableView?) {
        super.init(sectionType: .multi)
        
        
        self.tableView = tableView
        self.tableView?.estimatedRowHeight = 65
        
        self.headerCreator = BasicBlockSupplementaryViewCreator<PTSectionHeader, PTSectionHeaderView>(size: CGSize(width: 1, height: 50)) { (section, headerView, indexPath) in
            
            headerView.icon = section.icon
            headerView.tintColor = section.color
            headerView.titleLabel.text = section.title
            headerView.titleLabel.textColor = section.color
            headerView.detailsLabel.text = section.details
        }
        
        self.observeNotificationsAuthorization()
        
        preferencesDidChange()
        selectedPrayerDidChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange), name: Notifications.preferencesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedPrayerDidChange), name: Notifications.selectedPrayerDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func register(dataSource: DataSource, with header: PTSectionHeader){
        self.add(dataSource)
        self.sections.append(header)
        
        _resetupHeadersCreator()
    }
    
    func unregisterAll(){
        self.removeAllDataSources()
        self.sections = []
        self._resetupHeadersCreator()
    }
    
    private func _resetupHeadersCreator(){
        headerCreator.setSectionedItems(sections)
        self.set(headerCreator: headerCreator)
    }
    
     func observeNotificationsAuthorization(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.notificationsAuthorizationIsGranted = settings.authorizationStatus != .denied
            
            DispatchQueue.main.async {
                if self.notificationsDataSource != nil {
                    self.tableView?.reloadData()//.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .none)
                }
            }
        }
    }
}


extension PTPreferencesDataSource {
    @objc func selectedPrayerDidChange(){
        self.color = PTPrayerTimesController.default.selectedPrayer.color
        tableView?.reloadData()
    }
    
    @objc func preferencesDidChange(){
        if hasChangedNotificationSetting {
            hasChangedNotificationSetting = false
            return
        }
        
        unregisterAll()
        
        let prayerTimesSection = PTSectionHeader(title: PreferencesLabels.prayerTimesSection)
        prayerDataSource = _prayerTimesDataSource()
        
        register(dataSource: prayerDataSource, with: prayerTimesSection)
        
        let notificationsSection = PTSectionHeader(title: PreferencesLabels.notificationsSection)
        notificationsDataSource = _notificationsDataSource()
        
        register(dataSource: notificationsDataSource, with: notificationsSection)
        
        let moreSection = PTSectionHeader(title: PreferencesLabels.moreSection)
        moreDataSource = _moreDataSource()
        
        register(dataSource: moreDataSource, with: moreSection)
        
        
        tableView?.reloadData()
    }
}

extension PTPreferencesDataSource {
    private func _prayerTimesDataSource() -> PTOptionsDataSource {
        let preferencesController = PTPreferencesController.shared
        
        let locationOption = PTOption(title: PreferencesLabels.location, details: preferencesController.getLocationName())
        
        let sessionsOptions = preferencesController.prayerTimesOptionsSessions.compactMap { $0.option() }

        let prayerAdjustmentsOption = PTOption(title: PreferencesLabels.shiftIntervals)
        let contents = [locationOption] + sessionsOptions + [prayerAdjustmentsOption]
        
        
        let prayerOptionsDataSource = PTOptionsDataSource(items: contents)
        prayerOptionsDataSource.defaultAccessoryType = .disclosureIndicator
        prayerOptionsDataSource.tintedViewElementTypes = [.detail]
        prayerOptionsDataSource.disabledAccessoryIndexes = [0]
        prayerOptionsDataSource.defaultColor = self.color
        
        let selectionHandler = BlockSelectionHandler<PTOption, PTSelectableTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cl, ip in
            self.openPrayerPreference(at: ip.row)
        }
        
        prayerOptionsDataSource.setSelectionHandler(selectionHandler)
        
        return prayerOptionsDataSource
    }
    
    private func _notificationsDataSource() -> CompositeDataSource {
        let notificationIsEnabledDataSource = BasicBlockDataSource<Bool, PTSwitchTableViewCell> { [unowned self] (value, cell, indexPath) in
            
            cell.tintColor = self.color
            cell.titleLabel.text = PreferencesLabels.notificationsIsEnabled
            cell.selectionStyle = .none
            
            cell.titleLabel.alpha = self.notificationsAuthorizationIsGranted ? 1 : 0.5
            cell.switchView.isEnabled = self.notificationsAuthorizationIsGranted
            cell.switchView.isOn = !self.notificationsAuthorizationIsGranted ? false : value
            
            cell.onValueChanged = { changedValue in
                PTPreferencesController.shared.set(notificationsIsEnabled: changedValue)
            }
        }
        
        notificationIsEnabledDataSource.itemHeight = 65
        notificationIsEnabledDataSource.items = [PTPreferencesController.shared.getNotificationsIsEnabled()]
        
        
        let notificationsOptions = PTPreferencesController.shared.notificationsOptionsSessions.compactMap { $0.option() }
        notificationsOptionsDataSource = PTOptionsDataSource(items: notificationsOptions)
        
        notificationsOptionsDataSource.defaultAccessoryType = .disclosureIndicator
        notificationsOptionsDataSource.tintedViewElementTypes = [.detail]
        notificationsOptionsDataSource.defaultColor = self.color
        
        
        let selectionHandler = BlockSelectionHandler<PTOption, PTSelectableTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cl, ip in
            self.openNotificationPreference(at: ip.row)
        }
        notificationsOptionsDataSource.setSelectionHandler(selectionHandler)
        
        notificationsDataSource = CompositeDataSource(sectionType: .single)
        notificationsDataSource?.add(notificationIsEnabledDataSource)
        notificationsDataSource.add(notificationsOptionsDataSource)
        
        return notificationsDataSource!
    }
    
    private func _moreDataSource() -> PTOptionsDataSource {
        
        var items: [PTOption] = []
        
        let abouOption = PTOption(title: PreferencesLabels.about)
        let acksOption = PTOption(title: PreferencesLabels.acknowledgements)
        let feedbackOption = PTOption(title: PreferencesLabels.feedback)
        
        items.append(abouOption)
        items.append(acksOption)
        
        if MFMailComposeViewController.canSendMail() {
            items.append(feedbackOption)
        }
        
        
        let optionsDataSource = PTOptionsDataSource(items: items)
        optionsDataSource.defaultAccessoryType = .disclosureIndicator
        
        
        let selectionHandler = BlockSelectionHandler<PTOption, PTSelectableTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cl, ip in
            self.openMorePreference(at: ip.row)
        }
        
        optionsDataSource.setSelectionHandler(selectionHandler)
        
        return optionsDataSource
    }
}

//MARK: Handling Selection
extension PTPreferencesDataSource {
    func openPrayerPreference(at index: Int){
        if index == 4 {
            _openPrayerAdjustments()
            return
        }
        
        let preferencesController = PTPreferencesController.shared
        preferencesController.prayerSession(at: index - 1)?.start()
    }
    
    func openNotificationPreference(at index: Int){
        PTPreferencesController.shared.notificationSession(at: index)?.start()
    }
    
    
    func openMorePreference(at index: Int){
        switch index {
        case 0:
            about()
            break
        case 1:
            acks()
            break
        case 2:
            feedback()
            break
        default:
            break
        }
    }
    
    func _openPrayerAdjustments(){
        let viewController = PTPrayerAdjustmentsViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }

    func about(){
        let to = PTAboutViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(to, animated: true)
    }
    
    func acks(){
        let to = PTAcknowledgmentsViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(to, animated: true)
    }
    
    func feedback(){
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(AppConstants.contactEmailAddresses)
        mail.setSubject("\(AppConstants.appName) \(AppConstants.appVersion) - \(PreferencesLabels.feedback)")
        
        UIApplication.topViewController()?.present(mail, animated: true, completion: nil)
    }
}

extension PTPreferencesDataSource: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss()
    }
}
