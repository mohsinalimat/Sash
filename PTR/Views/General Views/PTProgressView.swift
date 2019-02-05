//
//  PTProgressView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

@IBDesignable
class PTProgressView: PTRoundedView {
    
    fileprivate lazy var progressIndicatorView: UIView = {
        let view = UIView()

        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = progressColor
        
        addSubview(view)
        
        return view
    }()
    
    @IBInspectable var progressColor: UIColor? = .black {
        didSet {
            self.progressIndicatorView.backgroundColor = progressColor
        }
    }
    
    
    /// must call layoutIfNeeded to take effect
    @IBInspectable var progress: CGFloat = 0.5 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable open var spacing : CGFloat = 2 {
        didSet {
            if max(0, spacing) != self.spacing {
                self.spacing = max(0, spacing)
            }
            
            self.updateUI()
        }
    }
    
    fileprivate var progressConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doSomething()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSomething()
    }
    
    func doSomething(){
        clipsToBounds = true
        fullyRounded = true
        progressColor = .red
    }
    
    func set(progress: CGFloat, animated: Bool){
        self.progress = progress
        
        let block = {
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: block)
        } else {
            block()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUI()
    }
    
    private func updateUI() {
        self.removeConstraints(self.progressConstraints)
        self.progressConstraints = [
            self.progressIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.borderWidth + self.spacing),
        self.progressIndicatorView.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor, multiplier: self.progress, constant: -(self.borderWidth * 2 + self.spacing * 2)),
            self.progressIndicatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.borderWidth + self.spacing),
            self.progressIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(self.borderWidth + self.spacing))
        ]
        
        NSLayoutConstraint.activate(progressConstraints)
        
        self.progressIndicatorView.layer.cornerRadius = self.progressIndicatorView.frame.height / 2
        self.progressIndicatorView.backgroundColor = self.progressColor
    }
}
