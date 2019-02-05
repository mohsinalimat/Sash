//
//  PTCalendarCollectionViewCell.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/11/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import FSCalendar

class PTCalendarCollectionViewCell: FSCalendarCell {

    /* the color used to tint the progress :) */
    var progressColor: UIColor = .white {
        didSet {
            self.progressShapeLayer.strokeColor = progressColor.cgColor
        }
    }
    
    /* unfinished color */
    var trackColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            self.trackShapeLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var fillColor: UIColor = UIColor.clear {
        didSet {
            self.progressShapeLayer.fillColor = fillColor.cgColor
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            self.titleLabel.textColor = textColor
        }
    }
    
    /* progress indicator width */
    var lineWidth: CGFloat = 2 {
        didSet {
            self.trackShapeLayer.lineWidth = lineWidth
            self.progressShapeLayer.lineWidth = lineWidth
        }
    }
    
    /* value between 0 and 1 */
    var progress: CGFloat = 0 {
        didSet {
            self.progressShapeLayer.strokeEnd = progress
        }
    }
    
    /* applied to both circle and title */
    var offset: CGFloat = {
        let screenType = UIDevice.current.screenType
        if screenType == .iPhones_5_5s_5c_SE || screenType == .iPhones_4_4S {
            return 2
        } else if screenType == .iPhones_6_6s_7_8 || screenType == .iPhones_X_XS {
            return 4//3.5
        } else {
            return 4.5
        }
    }(){
        didSet {
            setNeedsLayout()
        }
    }
    
    var indicatorOffset: CGFloat = 6 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var showsProgressIndicator: Bool = false {
        didSet {
            progressShapeLayer?.isHidden = !showsProgressIndicator && !isSelected
            trackShapeLayer?.isHidden = !showsProgressIndicator && !isSelected
        }
    }
    
    fileprivate var progressShapeLayer: CAShapeLayer!
    fileprivate var trackShapeLayer: CAShapeLayer!
    
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup(){
        trackShapeLayer = CAShapeLayer()
        trackShapeLayer.lineWidth = lineWidth
        trackShapeLayer.fillColor = nil
        trackShapeLayer.strokeColor = trackColor.cgColor
        trackShapeLayer.isHidden = !showsProgressIndicator
        trackShapeLayer.lineCap = .round
        
        progressShapeLayer = CAShapeLayer()
        progressShapeLayer.lineWidth = lineWidth
        progressShapeLayer.lineCap = CAShapeLayerLineCap.round
        progressShapeLayer.fillColor = nil
        progressShapeLayer.strokeColor = progressColor.cgColor
        progressShapeLayer.strokeEnd = progress
        progressShapeLayer.isHidden = !showsProgressIndicator

        
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
        
        self.contentView.addSubview(view)
        contentView.layer.addSublayer(trackShapeLayer)
        contentView.layer.addSublayer(progressShapeLayer)
        
        titleLabel.superview?.bringSubviewToFront(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.backgroundView?.frame = self.bounds.insetBy(dx: offset, dy: offset)
        
        self.trackShapeLayer.frame = self.contentView.bounds
        self.progressShapeLayer.frame = self.contentView.bounds
        
        let x = self.contentView.bounds.height / 2
//        let y = self.backgroundView!.bounds.height / 2
        
        let center = titleLabel.superview!.convert(titleLabel.center, to: contentView)
//        center.y -= offset
        
        let path = UIBezierPath(arcCenter: center, radius: x - (lineWidth + offset), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: contentView.bounds.minX + indicatorOffset, y: contentView.bounds.maxY - indicatorOffset))
        bottomPath.addLine(to: CGPoint(x: contentView.bounds.maxX - indicatorOffset, y: contentView.bounds.maxY - indicatorOffset))

        
        self.progressShapeLayer.path = isSelected ? path.cgPath : bottomPath.cgPath
        self.trackShapeLayer.path = isSelected ? path.cgPath : bottomPath.cgPath
    }
    
    override func configureAppearance() {
        super.configureAppearance()

        eventIndicator.isHidden = !dateIsToday
        
        preferredEventOffset = isSelected ? CGPoint(x: 0, y: lineWidth + offset) : .zero
        
        
        trackColor = isSelected ? .clear : UIColor.black.withAlphaComponent(0.3)
        progressColor = isSelected ? .clear : UIColor.white
        fillColor = isSelected ? .white : .clear
        textColor = isSelected ? .black : .white
        
        titleLabel.alpha = isPlaceholder ? 0.3 : 1
        progressShapeLayer.opacity = isPlaceholder ? 0.3 : 1
        
        numberOfEvents = dateIsToday ? 1 : 0
        eventIndicator.color = UIColor.white
    }
}
