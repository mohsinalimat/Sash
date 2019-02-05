//
//  PrayerTimesController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/1/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import Adhan
import UIKit

private struct _CachedPrayerTimes: Equatable {
    var dateComponents: DateComponents
    var prayerTimes: PTPrayerTimes
    
    static func == (lhs: _CachedPrayerTimes, rhs: _CachedPrayerTimes) -> Bool {
        return lhs.dateComponents == rhs.dateComponents
    }
}


/*
 Dependencies:
    - Preferences Controller
 
 Subscribes to:
    - Preferences Did Change
    - Application will enter foreground
    - Application will resign active
 
 Sends:
    - Current Prayer Did Change
    - Selected Prayer Did Change
 
*/


/// A Core class that is responsable for computing prayer times for specific configurations, configurations contain the coordinates that the controller uses for computing prayer times.
class PTPrayerTimesController: Controller {
    
    enum Configuration {
        case `default`
        case custom(PTPrayerTimesControllerConfigurations)
        
        func configurations() -> PTPrayerTimesControllerConfigurations {
            if case .custom(let configs) = self {
                return configs
            }
            
            // gets the configurations from preferences
            let preferencesController = PTPreferencesController.shared
            
            
            let coordinates = preferencesController.getCoordinates()
            let calculationMethod = preferencesController.getCalculationMethod()
            let madhab = preferencesController.getMadhab()
            let highLatitudeRule = preferencesController.getHighLatitudeRule()
            let prayerAdjustments = preferencesController.getPrayerAdjustments()
            
            return PTPrayerTimesControllerConfigurations(coordinates: coordinates, calculationMethod: calculationMethod, madhab: madhab, highLatitudeRule: highLatitudeRule, adjustments: prayerAdjustments)
        }
    }
    
    // access the default controller
    static var `default`: PTPrayerTimesController = PTPrayerTimesController(configuration: .default)
    
    /// preferences used for computing the prayer times
    fileprivate var configurations: PTPrayerTimesControllerConfigurations
    
    /// instead of computing the prayer times repeatedly, we calculate them once and save them into the cache, to get them back later.
    fileprivate var cachedPrayerTimes: [_CachedPrayerTimes] = []
    
    /// used to schedule an operation to the next prayer, and when the next prayer comes, the timer will be schedule to the next, and so on :)
    fileprivate var timer: Timer?
    
    var testCurrentPrayer: PTPrayer? {
        didSet {
            NotificationCenter.default.post(name: Notifications.currentPrayerDidChange, object: nil)
        }
    }
    
    var selectedPrayer: PTPrayer {
        didSet {
            if selectedPrayer == .none {
                selectedPrayer = nextPrayerForToday
            }
            
            NotificationCenter.default.post(name: Notifications.selectedPrayerDidChange, object: nil)
        }
    }
    
    init(configuration: Configuration){
        self.selectedPrayer = .none
        self.configurations = configuration.configurations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChangedNotification), name: Notifications.preferencesDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
        
        
        rescheduleTimer()
        self.selectedPrayer = .fajr
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func rescheduleTimer(){
        guard let nextPrayerDate = self.nextPrayerDate else {
            return
        }
        
        self.timer = Timer(fire: nextPrayerDate, interval: 0, repeats: false, block: { [unowned self] (timer) in
            NotificationCenter.default.post(name: Notifications.currentPrayerDidChange, object: nil)
            self.rescheduleTimer()
            RunLoop.main.add(timer, forMode: .common)
        })
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    fileprivate func invalidateCache(){
        self.cachedPrayerTimes = []
    }
    
    fileprivate func resetToOriginalConfigurations(){
        self.configurations = Configuration.default.configurations()
    }
}

// MARK: Notifications
extension PTPrayerTimesController {
    @objc func preferencesDidChangedNotification(){
        invalidateCache()
        resetToOriginalConfigurations()
        rescheduleTimer()
    }
    
    @objc func applicationDidEnterForeground(){
        rescheduleTimer()
        NotificationCenter.default.post(name: Notifications.currentPrayerDidChange, object: nil)
    }
    
    @objc func applicationWillResignActiveNotification(){
        self.timer?.invalidate()
    }
}

extension PTPrayerTimesController {


    
    func prayerTimes(for dateComponents: DateComponents) -> PTPrayerTimes? {
        if let index = self.cachedPrayerTimes.index(where: { $0.dateComponents == dateComponents }){
            return cachedPrayerTimes[index].prayerTimes
        }
        
        // getting prayer times based on current configurations
        let coordinates = configurations.coordinates
        let date = dateComponents
        
        if coordinates.isEmpty() {
            /* non-valid coordinates, return a constant prayer times */
            return nil
        }
        
        var parameters = configurations.calculationMethod.calculationMethod().params
        parameters.adjustments = configurations.prayerAdjustments.prayerAdjustments()
        parameters.madhab = configurations.madhab.madhab()
        parameters.highLatitudeRule = configurations.highLatitudeRule.highLatitudeRule()
        
        guard let prayerTimes = PrayerTimes(coordinates: coordinates.coordinates(), date: date, calculationParameters: parameters) else {
            return nil
        }
        
        let native = prayerTimes.nativePrayerTimes()
        
        self.cachedPrayerTimes.append(_CachedPrayerTimes(dateComponents: dateComponents, prayerTimes: native))
        return native
    }
    
    func prayerTimesForToday() -> PTPrayerTimes? {
        return prayerTimes(for: Date().nessComponents)
    }
    
    var nextPrayerForToday: PTPrayer {
        let prayerTimesForToday = self.prayerTimesForToday()
        let currentPrayer = prayerTimesForToday?.nextPrayer()
        return currentPrayer ?? .none
    }
    
    var nextPrayerDate: Date? {
        guard let next = self.prayerTimesForToday()?.nextPrayer() else { return nil }
        return prayerTimesForToday()?.time(for: next)
    }

}

extension PTPrayerTimesController {
    
    /// Generates a new date at the given date components and with selected prayer, returns nil if prayer times could not be determinated for the given date components
    func date(with prayer: PTPrayer, in dateComponents: DateComponents) -> Date? {
        
        guard var originalDate = Calendar.georgian.date(from: dateComponents) else { return nil }
        
        guard var date = prayerTimes(for: dateComponents)?.time(for: prayer) else {
            return nil
        }
        
        originalDate = Calendar.georgian.date(bySetting: .hour, value: date.hour, of: originalDate)!
        originalDate = Calendar.georgian.date(bySetting: .minute, value: date.minute, of: originalDate)!
        
        return originalDate
    }
}
