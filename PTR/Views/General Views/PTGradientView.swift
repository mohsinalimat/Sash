//
//  PTGradientView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTGradientView: UIView {
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
        
    var colors: [UIColor] {
        set {
            _gradientLayer.colors = newValue.map { $0.cgColor }
        } get {
            return (_gradientLayer.colors?.map { return UIColor(cgColor: $0 as! CGColor)}) ?? []
        }
    }
    
    fileprivate var _gradientLayer: CAGradientLayer! {
        return (self.layer as! CAGradientLayer)
    }
    
    fileprivate var _current = 1
    fileprivate var _isConfigured = false
    fileprivate var _animation: CAKeyframeAnimation!
    fileprivate var _completion: (() -> Void)?

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    func beginProgressAnimation(with gradients: [Gradient], initialProgress: Double){
        _animation = CAKeyframeAnimation(keyPath: Animation.keyPath)
        
        let cgColors = gradients.map { return $0.colors() }.map { return $0.map { return $0.cgColor} }
        
        var keyTimes: [NSNumber] = []
        for i in 0..<gradients.count {
            let value = 1 / Double(gradients.count - 1)
            keyTimes.append(NSNumber(floatLiteral: Double(i) * value))
        }
        
        _animation.values = cgColors
        _animation.keyTimes = keyTimes
        _animation.fillMode = CAMediaTimingFillMode.both
        _animation.isRemovedOnCompletion = false
        _animation.duration = 1
        _animation.path = nil
        
        _gradientLayer.speed = 0
        _gradientLayer.add(_animation, forKey: Animation.key)
        
        _gradientLayer.colors = gradients[Int(initialProgress)].colors().map { $0.cgColor }
        _gradientLayer.timeOffset = initialProgress
    }
    
    func set(progress: Double){
        _gradientLayer.timeOffset = progress
    }
    
    func endProgressAnimation(with gradient: Gradient){
        _gradientLayer.removeAllAnimations()
        _gradientLayer.colors = gradient.colors().map { $0.cgColor }
        _gradientLayer.speed = 1
    }
    
    func set(gradients: [Gradient]){
        guard gradients.count > 0 else { return }
        
        _animation = CAKeyframeAnimation(keyPath: Animation.keyPath)

        let cgColors = gradients.map { return $0.colors() }.map { return $0.map { return $0.cgColor} }

        var keyTimes: [NSNumber] = []
        for i in 0..<gradients.count {
            let value = 1 / Double(gradients.count - 1)
            keyTimes.append(NSNumber(floatLiteral: Double(i) * value))
        }

        _animation.values = cgColors
        _animation.keyTimes = keyTimes
        _animation.fillMode = CAMediaTimingFillMode.both
        _animation.isRemovedOnCompletion = false
        _animation.duration = 1
        _animation.path = nil

        _gradientLayer.colors = gradients.first!.colors().map { $0.cgColor }
        
        _gradientLayer.speed = 0
        _gradientLayer.add(_animation, forKey: Animation.key)
    }
    
    /*
     sets the animation progress of the gradient to the given progress, the animation is technically stopped and we control the timeOffset of the keyframe animation, note the gradients must bet set and the animation is configured in order to animate the gradients.
     
     */

    
    func animate(to gradient: Gradient, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil){
        _completion = completion
        _gradientLayer.speed = 1
        _gradientLayer.removeAllAnimations()
        
        let cgColors = gradient.colors().map { $0.cgColor }
        
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        
        animation.toValue = cgColors
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = true
        animation.duration = duration
        animation.delegate = self
        
        _gradientLayer.add(animation, forKey: Animation.key)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        _gradientLayer.removeAllAnimations()
    }
}

extension PTGradientView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self._completion?()
        self._completion = nil
    }
}
