//
//  PTDayRemindersDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/10/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources

class PTDayRemindersDataSource: CompositeDataSource {
    
    var collections: [PTPrayerRemindersCollection] {
        didSet {
            _setupDataSources()
            _setupHeaders()
        }
    }
    
    weak var tableView: PTRemindersTableView? {
        didSet {
            for dataSource in self.dataSources {
                if let remindersDS = dataSource as? PTRemindersDataSource {
                    remindersDS.tableView = tableView
                }
            }
        }
    }
    
    var onSelectionBlock: ((PTReminder) -> Void)?
    var onDeleteBlock: ((PTReminder) -> Void)?
    
    init(collections: [PTPrayerRemindersCollection], tableView: PTRemindersTableView?){
        self.collections = collections
        self.tableView = tableView
        
        super.init(sectionType: .multi)
        
        _setupDataSources()
        _setupHeaders()
    }
    
    private func _setupDataSources(){
        self.removeAllDataSources()
        
        for collection in collections {
            // create
            let dataSource = PTRemindersDataSource(collection: collection, tableView: self.tableView)
            
            dataSource.items = collection.reminders
            dataSource.tableView = tableView
            
            dataSource.onItemTap = { [unowned self, unowned dataSource] ip in
                self.onSelectionBlock?(dataSource.item(at: ip))
            }
            
            add(dataSource)
            dataSource.collectionIndex = self.index(of: dataSource)!
        }
    }
    
    private func _setupHeaders(){        
        let headerCreator = BasicBlockSupplementaryViewCreator<PTPrayerRemindersCollection, PTSectionHeaderView>(size: CGSize(width: 1, height: 50)) { (collection, headerView, indexPath) in
            headerView.iconImageView.image = collection.icon?.image
            
            headerView.titleLabel.text = collection.title
            headerView.detailsLabel.text = collection.details
            
            headerView.tintColor = collection.color
            headerView.detailsLabel.textColor = ColorsDefines.gray
        }
        
        headerCreator.setSectionedItems(collections)
        self.set(headerCreator: headerCreator)
    }
    
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, editingStyleForItemAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, commit editingStyle: UITableViewCell.EditingStyle, forItemAt indexPath: IndexPath) {
        super.ds_collectionView(collectionView, commit: editingStyle, forItemAt: indexPath)
    }
}
