//
//  PTOptionsDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/13/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources


class PTOptionsDataSource: BasicDataSource<PTOption, PTSelectableTableViewCell> {
    
    enum ViewElement {
        case title
        case detail
        case icon
    }
    
    var defaultAccessoryType: UITableViewCell.AccessoryType = .none
    
    // if set, the data source will use the color, if not, it will fallback to items colors.
    var defaultColor: UIColor?
    
    // any element type will use the color provided by the item if set.
    var tintedViewElementTypes: [ViewElement] = []
    
    // indexes that match elements in this array won't have the accessory
    var disabledAccessoryIndexes: [Int] = []
    
    
    init(items: [PTOption]){
        super.init()
        self.items = items
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, cellForItemAt indexPath: IndexPath) -> ReusableCell {
        let cell = super.ds_collectionView(collectionView, cellForItemAt: indexPath) as! PTSelectableTableViewCell
        let item = self.item(at: indexPath)
        let color = self.defaultColor// ?? item.color
        
        // customizing the colors
        cell.iconImageView.tintColor = tintedViewElementTypes.contains(.icon) ? color : ColorsDefines.gray // optionally tinting the image
        cell.titleLabel.textColor = tintedViewElementTypes.contains(.title) ? color : .black // optionally tinting the title
        cell.detailsLabel.textColor = tintedViewElementTypes.contains(.detail) ? color : ColorsDefines.gray // optionally tinting the detail
        

        // setting the informations
        cell.icon = item.icon
        cell.titleLabel.text = item.text        
        cell.detailsLabel.text = item.details
        
        // customizing the accessory
        cell.accessoryType = disabledAccessoryIndexes.contains(indexPath.row) ? .none : defaultAccessoryType
        cell.tintColor = ColorsDefines.clouds.withAlphaComponent(0.5)
        
        return cell
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 70)
    }
}
