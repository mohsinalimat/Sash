//
//  LocationSelectionDataSource.swift
//  PTR
//
//  Created by Hussein AlRyalat on 2/2/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import GenericDataSources
import UIKit

class PTLocationSearchHitsDataSource: BasicDataSource<LocationSearchHit, UITableViewCell> {
    override func ds_collectionView(_ collectionView: GeneralCollectionView, configure cell: UITableViewCell, with item: LocationSearchHit, at indexPath: IndexPath) {
        cell.textLabel?.text =  (item.administrative.first ?? "") + ", " + item.country
        cell.textLabel?.font = FontType.medium.with(size: 15)
    }
}
