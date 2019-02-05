//
//  PTIconView.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

@IBDesignable
class PTIconView: PTRoundedView {
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = solidColor
        
        insertSubview(view, at: 0)
        view.pinToSuperView()
        
        return view
    }()
    
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = imageColor
        view.isOpaque = true
        
        addSubview(view)
        
        view.centerInSuperView()
        imageViewConstraints = [view.leadingAnchor.constraint(equalTo: leadingAnchor), view.topAnchor.constraint(equalTo: topAnchor)]
        
        return view
    }()
    
    fileprivate var imageViewConstraints: [NSLayoutConstraint] = [] {
        didSet {
            NSLayoutConstraint.activate(imageViewConstraints)
        }
    }
    
    /// must call layoutIfNeeded to apply changes
    @IBInspectable var padding: CGFloat = 0 {
        didSet {
            imageViewConstraints.forEach { $0.constant = padding }
        }
    }
    
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var solidColor: UIColor? = .white {
        didSet {
            backgroundView.backgroundColor = solidColor
        }
    }
    
    @IBInspectable var imageColor: UIColor? = .black {
        didSet {
            imageView.tintColor = imageColor
        }
    }
    
    @IBInspectable var imageIsHidden: Bool = false {
        didSet {
            imageView.isHidden = imageIsHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doSomething()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSomething()
    }
    
    fileprivate func doSomething(){
        self.clipsToBounds = true
        self.fullyRounded = true
        self.borderWidth = 1
    }
}
