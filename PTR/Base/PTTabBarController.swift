//
//  PTTabBarController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/24/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTTabBarController: UITabBarController {
    
//    var previousTabBarIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.shadowImage = UIImage()
        
        self.tabBar.unselectedItemTintColor = ColorsDefines.gray
        self.tabBar.backgroundColor = .white
        self.tabBar.backgroundImage = UIImage()
        
        self.tabBar.layer.borderColor = UIColor(hexString: "ECECEC").cgColor
        self.tabBar.layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedPrayerDidChange), name: Notifications.selectedPrayerDidChange, object: nil)
        
        self.delegate = self
        self.selectedPrayerDidChange()
        
        self.tabBar.items?[0].title = "labels.titles.today".localized
        self.tabBar.items?[0].title = "labels.titles.calendar".localized
        self.tabBar.items?[0].title = "labels.titles.preferences.title".localized
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
//    private func resetAnimator(){
//        tabBar.tintColor = PTPrayerTimesController.default.selectedPrayer.color
//
//        
//        var keyTimes: [Double] = []
//        for i in 0..<colors.count {
//            let value = 1 / Double(colors.count - 1)
//            keyTimes.append(Double(i) * value)
//        }
//        
//        
//        let relativeDuration = 1 / Double(colors.count - 1)
//        animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
//            UIView.animateKeyframes(withDuration: 1, delay: 0, options: .overrideInheritedDuration, animations: {
//                for i in 1..<self.colors.count + 1 {
//                    let keytime = keyTimes[i - 1]
//                    let color = i == self.colors.count ? self.colors[i - 1] : self.colors[i]
//                    
//                    UIView.addKeyframe(withRelativeStartTime: keytime, relativeDuration: relativeDuration, animations: {
//                        self.tabBar.tintColor = color
//                    })
//                }
//            }, completion: nil)
//        })
//        
//        
//        animator?.addCompletion({ [unowned self] (position) in
//            if position == .end {
//                self.tabBar.tintColor = PTApperanceController.shared.currentApperance().tintColor
//                self.tabBar.unselectedItemTintColor = ColorsDefines.gray
//            }
//        })
//    }
//
//    func changeProgress(_ progress: CGFloat){
//        self.animator?.fractionComplete = progress
//    }
    
    @objc
    func selectedPrayerDidChange(){
        UIView.animate(withDuration: 0.2) {
            self.tabBar.tintColor = PTPrayerTimesController.default.selectedPrayer.color
        }
    }
}

extension PTTabBarController: UITabBarControllerDelegate {
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let index = tabBar.items!.index(of: item)!
//        if index > 0 {
//            self.animator?.stopAnimation(true)
//
//            if previousTabBarIndex == 0 {
//                self.tabBar.tintColor = PTApperanceController.shared.currentApperance().tintColor
//                self.tabBar.unselectedItemTintColor = ColorsDefines.gray
//            }
//        } else {
//            resetAnimator()
//        }
//
//        previousTabBarIndex = index
//    }
}
