//
//  CollectionsDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/17/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources

class PTCollectionsDataSource: BasicDataSource<PTPrayerRemindersCollection, PTCollectionCardCollectionViewCell> {
    
    var onDisplayBlock: ((IndexPath) -> Void)?
    var onPercengtageScrollChange: ((CGFloat) -> Void)?
    var onDidSelectBlock: ((IndexPath) -> Void)?
    var onBeginScroll: (() -> Void)?
    
    weak var collectionView: UICollectionView?
    
    
    init(collectionView: UICollectionView?){
        self.collectionView = collectionView
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(persistanceDidChange), name: Notifications.persistanceDidFinishUpdating, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesDidChange), name: Notifications.preferencesDidChange, object: nil)
        
        persistanceDidChange()
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, cellForItemAt indexPath: IndexPath) -> ReusableCell {
        let cell = super.ds_collectionView(collectionView, cellForItemAt: indexPath) as! PTCollectionCardCollectionViewCell
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.detailsLabel.text = item.details
        
        cell.tintColor = item.color
        cell.clipsToBounds = false
        
        cell.iconImageView.image = item.icon?.image
        
        let unCompletedCount = PTCalculationsController.shared.prayerInfo(in: item.dateComponents, at: item.prayer).uncompletedRemindersCount
        cell.badgeButton.setTitle("\(unCompletedCount)", for: .normal)
        cell.badgeButton.isHidden = unCompletedCount == 0
        
        return cell
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onDidSelectBlock?(indexPath)
    }
    
    @objc func persistanceDidChange(){
        self.items = PTPrayer.all.map { PTPrayerRemindersCollection(prayer: $0, dateComponents: Date().nessComponents) }
        self.collectionView?.reloadData()
    }
    
    @objc func preferencesDidChange(){
        self.collectionView?.reloadData()
    }
}


