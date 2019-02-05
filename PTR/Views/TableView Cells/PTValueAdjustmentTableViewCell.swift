//
//  PTValueAdjustmentView.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/26/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import ValueStepper

class PTValueAdjustmentTableViewCell: UITableViewCell {
    
    var onValueChange: ((Double) -> Void)?
    
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.font = FontType.medium.with(size: 14)
        }
    }
    
    
    @IBOutlet weak var valueStepper: ValueStepper! {
        didSet {
            valueStepper.tintColor = self.tintColor
            valueStepper.stepValue = 1
            valueStepper.minimumValue = -30
            valueStepper.maximumValue = 30
            valueStepper.value = 0
            valueStepper.numberFormatter.positiveSuffix = Extras.smallMinSuffix
            valueStepper.numberFormatter.negativeSuffix = Extras.smallMinSuffix
            valueStepper.labelTextColor = tintColor
            valueStepper.valueLabel.font = FontType.medium.with(size: 11)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        self.valueStepper.tintColor = tintColor
        valueStepper.labelTextColor = tintColor
    }
    
    
    @IBAction func valueStepperValueChange(_ sender: Any) {
        onValueChange?(valueStepper.value)
    }
}
