//
//  PreferencesController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources
import DeckTransition
import StoreKit
import MessageUI


class PTPreferencesController: NSObject, Controller {
    
    static let shared = PTPreferencesController()
    
    var isTestingTutorials = false
    var isTestingLocation = false
    
    
    fileprivate(set) lazy var prayerTimesOptionsSessions: [PTSession] = {
        let sessions =  [methodSelectionSession, madhabSelectionSession, hlrSelectionSession] as [PTSession]
        
        for (index, session) in sessions.enumerated() {
            session.identifier = "\(index)"
        }
        
        return sessions
    }()
    
    fileprivate(set) lazy var notificationsOptionsSessions: [PTSession] = {
        return [badgeCountDisplayTypeSelectionSession]
    }()
    
    //MARK: Sessions
    
    fileprivate(set) lazy var methodSelectionSession: PTSelectionSession<PTCalculationMethod> = {
        let session = PTSelectionSession<PTCalculationMethod>()
        session.selectionType = .single
        session.selectedIndexes = [getCalculationMethod().index]
        session.selectionTitle = SessionsStrings.CalculationMethodSelection.title
        session.selectionDetails = SessionsStrings.CalculationMethodSelection.details
        
        session.onSelectionChange = { [unowned self] selectedItems in
            self.set(calculationMethod: selectedItems.first!)
        }
        
        return session
    }()
    
    fileprivate(set) lazy var madhabSelectionSession: PTSelectionSession<PTMadhab> = {
        let session = PTSelectionSession<PTMadhab>()
        session.selectionType = .single
        session.selectedIndexes = [getMadhab().index]
        session.selectionTitle = SessionsStrings.MadhabMethodSelection.title
        session.selectionDetails = SessionsStrings.MadhabMethodSelection.details
        
        session.onSelectionChange = { [unowned self] selectedItems in
            self.set(madhab: selectedItems.first!)
        }
        
        return session
    }()
    
    fileprivate(set) lazy var hlrSelectionSession: PTSelectionSession<PTHighLatitudeRule> = {
        let session = PTSelectionSession<PTHighLatitudeRule>()
        session.selectionType = .single
        session.selectedIndexes = [self.getHighLatitudeRule().index]
        session.selectionTitle = SessionsStrings.HLRMethodSelection.title
        session.selectionDetails = SessionsStrings.HLRMethodSelection.details
        
        session.onSelectionChange = { [unowned self] selectedItems in
            self.set(highLatitudeRule: selectedItems.first!)
        }

        return session
    }()
    
    fileprivate(set) lazy var badgeCountDisplayTypeSelectionSession: PTSelectionSession<BadgeCountDisplayType> = {
        let session = PTSelectionSession<BadgeCountDisplayType>()
        session.selectionType = .single
        session.selectedIndexes = [self.getBadgeCountDisplayType().index]
        session.selectionTitle = SessionsStrings.BadgeCountDisplayTypeSelection.title
        session.selectionDetails = SessionsStrings.BadgeCountDisplayTypeSelection.details
        
        session.onSelectionChange = { [unowned self] selectedItems in
            self.set(badgeCountDisplayType: selectedItems.first!)
        }
        
        
        return session
    }()
    
    
    func prayerSession(at index: Int) -> PTSession? {
        if index < 0 || index >= prayerTimesOptionsSessions.count { return nil }        
        return prayerTimesOptionsSessions[index]
    }
    
    func notificationSession(at index: Int) -> PTSession? {
        if index < 0 || index >= notificationsOptionsSessions.count { return nil }
        return notificationsOptionsSessions[index]
    }
    
    func startControllingTheWorld() {
        increamentRunsCount()
        UserDefaults.standard.register(defaults: [PreferenceKey.notificationsIsEnabled.rawValue: true])
    }
}


//MARK: - Managing Data Source -
extension PTPreferencesController {
    func requestContactUsPromopt(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(AppConstants.contactEmailAddresses)
            mail.setSubject("\(AppConstants.appName) \(AppConstants.appVersion) - \(Actions.contact)")
            
            UIApplication.topViewController()?.present(mail, animated: true, completion: nil)
        }
    }
    
    func requestRateOrReview(){
        if getRunsCount() % 5 == 0 {
            if #available(iOS 10.3, *){
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func savePreferences(){
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notifications.preferencesDidChange, object: self, userInfo: [:])
    }
}


extension PTPreferencesController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss()
    }
}

//MARK: - Preferences -
extension PTPreferencesController {
    func set(prayerAdjustments: PTPrayerAdjustments){
        set(object: prayerAdjustments, for: .prayerAdjustments)
    }
    
    func set(coordinates: PTCoordinates){
        set(object: coordinates, for: .coordinate)
    }
    
    func set(madhab: PTMadhab){
        set(object: madhab, for: .madhab)
    }
    
    func set(calculationMethod: PTCalculationMethod){
        set(object: calculationMethod, for: .calculationMethod)
    }
    
    func set(highLatitudeRule: PTHighLatitudeRule){
        set(object: highLatitudeRule, for: .highLatitudeRule)
    }
    
    func set(badgeCountDisplayType: BadgeCountDisplayType){
        set(object: badgeCountDisplayType, for: .badgeCountDisplayType)
    }
    
    func set(locationName: String?){
        UserDefaults.standard.set(locationName, forKey: PreferenceKey.locationName.rawValue)
        savePreferences()
    }
    
    func set(notificationsIsEnabled: Bool){
        UserDefaults.standard.set(notificationsIsEnabled, forKey: PreferenceKey.notificationsIsEnabled.rawValue)
        savePreferences()
    }
    
    func increamentRunsCount(){
        UserDefaults.standard.set(getRunsCount() + 1, forKey: PreferenceKey.runsCount.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func set(notificationsShiftInterval: ShiftInterval){
        UserDefaults.standard.set(notificationsShiftInterval.value, forKey: PreferenceKey.notificationsShiftInterval.rawValue)
        savePreferences()
    }
    
    func getPrayerAdjustments() -> PTPrayerAdjustments {
        return get(objectType: PTPrayerAdjustments.self, for: .prayerAdjustments) ?? PTPrayerAdjustments()
    }
    
    func getCoordinates() -> PTCoordinates {
        return get(objectType: PTCoordinates.self, for: .coordinate) ?? PTCoordinates()
    }
    
    func getMadhab() -> PTMadhab {
        return get(objectType: PTMadhab.self, for: .madhab) ?? .shafi
    }
    
    func getCalculationMethod() -> PTCalculationMethod {
        return get(objectType: PTCalculationMethod.self, for: .calculationMethod) ?? .ummAlQura
    }
    
    func getHighLatitudeRule() -> PTHighLatitudeRule {
        return get(objectType: PTHighLatitudeRule.self, for: .highLatitudeRule) ?? .middleOfTheNight
    }
    
    func getLocationName() -> String {
        return UserDefaults.standard.string(forKey: PreferenceKey.locationName.rawValue) ?? Extras.unknown
    }
    
    func getBadgeCountDisplayType() -> BadgeCountDisplayType {
        return get(objectType: BadgeCountDisplayType.self, for: .badgeCountDisplayType) ?? .prayer
    }
    
    func getNotificationsIsEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: PreferenceKey.notificationsIsEnabled.rawValue)
    }
    
    func getRunsCount() -> Int {
        return UserDefaults.standard.integer(forKey: PreferenceKey.runsCount.rawValue)
    }
    
    func getNotificationsShiftInterval() -> ShiftInterval {
        return ShiftInterval.from(timeInterval: UserDefaults.standard.double(forKey: PreferenceKey.notificationsShiftInterval.rawValue))
    }
    
    func set(integer: Int, for key: PreferenceKey){
        UserDefaults.standard.set(integer, forKey: key.rawValue)
        savePreferences()
    }
    
    func getInt(for key: PreferenceKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    fileprivate func set<T: Codable>(object: T, for key: PreferenceKey){
        do {
            try UserDefaults.standard.set(object: [object], forKey: key.rawValue)
            savePreferences()
        } catch(_){
        }
    }
    
    fileprivate func get<T: Codable>(objectType: T.Type, for key: PreferenceKey) -> T? {
        do {
            return try UserDefaults.standard.get(objectType: [T].self, forKey: key.rawValue)?.first
        } catch(_){
            return nil
        }
    }
}
