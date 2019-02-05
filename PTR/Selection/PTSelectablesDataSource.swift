//
//  PTActionsDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources

class PTSelectablesDataSource: BasicDataSource<Selectable, PTSelectableTableViewCell> {
    
    enum SelectionStyle {
        case single
        case multiple
    }
    
    // color is applied when the option does not provide color
    var defaultColor: UIColor = .black
    
    // must call reload data on the collection in order for this value to take effect
    var selectionStyle: SelectionStyle = .single
    
    // automaticly changes
    var selectedIndexPaths: [IndexPath] = []
    
    // the cells accessory types
    var selectedCellAccessoryType: UITableViewCell.AccessoryType = .none
    
    // when cells are not selected
    var unselectedCellAccessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    
    // whether to use the color for labels
    var usesColorsForTitles: Bool = true
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, cellForItemAt indexPath: IndexPath) -> ReusableCell {
        let cell = super.ds_collectionView(collectionView, cellForItemAt: indexPath) as! PTSelectableTableViewCell
        let option = item(at: indexPath)
        
        cell.icon = option.icon
        cell.titleLabel.text = option.text
        
        cell.titleLabel.textColor = usesColorsForTitles ? option.color ?? defaultColor : .black
        cell.iconImageView.tintColor = option.color ?? defaultColor
        
        cell.tintColor = usesColorsForTitles ? option.color ?? defaultColor : ColorsDefines.gray
        cell.accessoryType = selectedIndexPaths.contains(indexPath) ? selectedCellAccessoryType : unselectedCellAccessoryType
        cell.accessoryView?.backgroundColor = .clear
                
        
        return cell
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.size.width, height: 70)
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectionStyle == .multiple {
            if !selectedIndexPaths.contains(indexPath){
                selectedIndexPaths.append(indexPath)
            } else {
                let index = selectedIndexPaths.index(of: indexPath)!
                selectedIndexPaths.remove(at: index)
            }
        } else if selectionStyle == .single {
            selectedIndexPaths.removeAll()
            selectedIndexPaths.append(indexPath)
        }
        
        collectionView.ds_reloadData()
        super.ds_collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
