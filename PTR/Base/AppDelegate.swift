//
//  AppDelegate.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 6/30/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension AppDelegate: PTOBPageContainerViewControllerDelegate {
    func pageContainerViewControllerShouldFinish(viewController: PTOBPageContainerViewController) {
        hideOnboarding()
    }
}

extension AppDelegate {
    func showOnboarding() {
        if let window = self.window, let onboardingViewController = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateInitialViewController() as? PTOBPageContainerViewController {
            onboardingViewController.onboardingDelegate = self
            window.rootViewController = onboardingViewController
        }
    }
    
    func hideOnboarding() {
        if let window = UIApplication.shared.keyWindow, let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
            mainViewController.view.frame = window.bounds
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = mainViewController
            }, completion: nil)
        }
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        
        PTCalculationsController.shared.startControllingTheWorld()
        PTLocationController.shared.startControllingTheWorld()
        PTNotificationsController.shared.startControllingTheWorld()
        PTPreferencesController.shared.startControllingTheWorld()
        
        
        if PTPreferencesController.shared.getRunsCount() < 2 || PTPreferencesController.shared.isTestingTutorials {
            showOnboarding()
        }
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PTPersistanceManager.shared.commitChanges()
    }
}
