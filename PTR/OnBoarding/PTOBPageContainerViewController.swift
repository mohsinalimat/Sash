//
//  PTOBPageContainerViewController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 10/25/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import EMPageViewController

protocol PTOBPageContainerViewControllerDelegate: class {
    func pageContainerViewControllerShouldFinish(viewController: PTOBPageContainerViewController)
}

class PTOBPageContainerViewController: EMPageViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundView: PTBackgroundView!
    
    var animator: UIViewPropertyAnimator!
    
    weak var onboardingDelegate: PTOBPageContainerViewControllerDelegate?
    
    lazy var onboardingItems: [OnBoardingPageItem] = {
        var items: [OnBoardingPageItem] = []
        
        items.append(OnBoardingPageItem.welcome())
        items.append(OnBoardingPageItem.notifications())
        items.append(OnBoardingPageItem.location())
        
        return items
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        self.scrollView.backgroundColor = .clear
        
        let currentViewController = self.viewController(at: 0)!
        self.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: nil)
        
        backgroundView.backgroundType = .solid
        backgroundView.alpha = 0.80
        backgroundView.gradientView.colors = currentViewController.pageItem.gradient.colors()
        backgroundView.backgroundColor = currentViewController.pageItem.gradient.mainColor()
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = currentViewController.pageItem.backgroundImage
    }
    
    func numberOfPages() -> Int {
        return onboardingItems.count
    }
    
    func insertLocationSelectionAndGoForward(){
        let newItem = OnBoardingPageItem.locationSelection()
        if !self.onboardingItems.contains(where: { (item) -> Bool in
            item.identifier == newItem.identifier
        }){
            self.onboardingItems.append(newItem)
        }
        
        guard let viewController = self.viewController(at: newItem.index) else {
            return
        }
        
        self.selectViewController(viewController, direction: .forward, animated: true, completion: nil)
    }
    
}

extension PTOBPageContainerViewController {
    func finish(){
        self.onboardingDelegate?.pageContainerViewControllerShouldFinish(viewController: self)
    }
    
    func next(){
        self.scrollForward(animated: true, completion: nil)
    }
    
    func previous(){
        self.scrollReverse(animated: true, completion: nil)
    }
}

extension PTOBPageContainerViewController: EMPageViewControllerDataSource {
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! PTOBViewController) {
            let beforeViewController = self.viewController(at: viewControllerIndex - 1)
            return beforeViewController
        } else {
            return nil
        }
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! PTOBViewController) {
            let afterViewController = self.viewController(at: viewControllerIndex + 1)
            return afterViewController
        } else {
            return nil
        }
    }
    
    func viewController(at index: Int) -> PTOBViewController? {
        if (index < 0) || (index >= numberOfPages()) {
            return nil
        }
        
        let item = onboardingItems[index]
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: item.identifier) as! PTOBViewController
        viewController.pageContainerViewController = self
        viewController.pageItem = item
        
        return viewController
    }
    
    func index(of viewController: PTOBViewController) -> Int? {
        return viewController.pageItem.index
    }
}

extension PTOBPageContainerViewController: EMPageViewControllerDelegate {
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {
        let firstGradient = (startViewController as! PTOBViewController).pageItem.gradient
        let secondGradient = (destinationViewController as! PTOBViewController).pageItem.gradient
        
        backgroundView.gradientView.set(gradients: [firstGradient, secondGradient])
        
        self.animator.stopAnimation(true)
        self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.backgroundView.backgroundColor = secondGradient.mainColor()
        })
        
        self.animator.startAnimation()
        self.animator.pauseAnimation()
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {        
        self.backgroundView.gradientView.set(progress: Double(abs(progress)))
        self.animator.fractionComplete = abs(progress)
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        
        if transitionSuccessful {
            let nextImage = (destinationViewController as! PTOBViewController).pageItem.backgroundImage
            UIView.transition(with: self.backgroundImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.backgroundImageView.image = nextImage
            }, completion: nil)
        }
    }
}
