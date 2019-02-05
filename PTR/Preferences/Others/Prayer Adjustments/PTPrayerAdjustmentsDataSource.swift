//
//  PTPrayerAdjustmentsDataSource.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/26/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources


class PTPrayerAdjustmentsDataSource: BasicDataSource<PTPrayerAdjustment, PTValueAdjustmentTableViewCell> {
    
    var adjustments: PTPrayerAdjustments
    
    override init() {
        self.adjustments = PTPreferencesController.shared.getPrayerAdjustments()
        
        super.init()
        
        self.items = adjustments.objects()
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, cellForItemAt indexPath: IndexPath) -> ReusableCell {
        let cell = super.ds_collectionView(collectionView, cellForItemAt: indexPath) as! PTValueAdjustmentTableViewCell
        let item = self.item(at: indexPath)
        
        
        cell.onValueChange = { [unowned self] value in
            self.adjustments.set(value: Int(value), for: item.prayer)
            PTPreferencesController.shared.set(prayerAdjustments: self.adjustments)
        }
        
        cell.label.text = item.prayer.text
        cell.valueStepper.value = Double(item.value)
        cell.tintColor = item.prayer.color
        
        return cell
    }
}
