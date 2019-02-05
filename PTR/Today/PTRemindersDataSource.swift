//
//  PTCollectionRemindersDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation
import GenericDataSources
import DifferenceKit

class PTRemindersDataSource: BasicDataSource<PTReminder, PTReminderTableViewCell> {
    
    weak var tableView: UITableView?
    
    var collection: PTPrayerRemindersCollection
    
    var once: Bool = true
    
    /* used to determinate the reminder completed value */
    var dateComponents: DateComponents {
        return collection.dateComponents
    }
        
    /* executed when the user deletes a row */
    var onDeleteButtonTap: ((PTRemindersDataSource, GeneralCollectionView, IndexPath) -> Void)?
    
    /* executed when the user taps on the checkbox of a row */
    var onCheckBoxTap: ((IndexPath, Bool) -> Void)?
    
    /* when the user taps on the row, not the checkbox */
    var onItemTap: ((IndexPath) -> Void)?
    
    var deleteSession: PTDeleteReminderSession?
    
    /* used as section when performing changes */
    var collectionIndex: Int = 0
    
    init(collection: PTPrayerRemindersCollection, tableView: UITableView?){
        self.collection = collection
        self.tableView = tableView
        
        super.init()
        
        /* set custom selection handler :D */
        let selectionHandler = BlockSelectionHandler<PTReminder, PTReminderTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cl, ip in
            self.onItemTap?(ip)
        }
        
        self.onDeleteButtonTap = { [unowned self] ds, cv ,ip in
            let reminder = ds.item(at: ip)
            self.deleteSession = PTDeleteReminderSession(reminder: reminder, dateComponents: self.dateComponents)
            self.deleteSession?.start()
        }
        
        //
        
        
        self.onCheckBoxTap = { [unowned self] ip, isOn in
            let reminder = self.item(at: ip)
            let components = self.dateComponents
            
            
            let date = PTPrayerTimesController.default.date(with: reminder.prayer, in: components)
            PTPersistanceManager.shared.addActivity(for: reminder, action: isOn ? .completed : .none, date: date ?? Date())
        }
        
        self.setSelectionHandler(selectionHandler)
        
        NotificationCenter.default.addObserver(self, selector: #selector(persistanceDidChange), name: Notifications.persistanceDidFinishUpdating, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeActivityState(notification:)), name: Notifications.didChangeActivityAction, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedPrayerDidChange), name: Notifications.selectedPrayerDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, cellForItemAt indexPath: IndexPath) -> ReusableCell {
        let cell = super.ds_collectionView(collectionView, cellForItemAt: indexPath) as! PTReminderTableViewCell
        let reminder = item(at: indexPath)
        let isCompleted = reminder.isCompleted(for: dateComponents)

        cell.titleLabel.text = reminder.contents
        cell.subtitleLabel.text = reminder.details()
        
        
        cell.titleLabel.textColor = isCompleted ? ColorsDefines.gray : .black
        cell.subtitleLabel.alpha = isCompleted ? 0.5 : 1
        cell.checkBox.on = isCompleted
        
        cell.tintColor = reminder.prayer.color
        
        cell.onCheckBoxTap = { [unowned cell, self] isOn in
            let ip = self.tableView?.indexPath(for: cell)
            self.onCheckBoxTap?(ip!, isOn)
        }
        
        
        return cell
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1, height: 75)
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, sizeForSupplementaryViewOfKind kind: String, at indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, editingStyleForItemAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func ds_collectionView(_ collectionView: GeneralCollectionView, commit editingStyle: UITableViewCell.EditingStyle, forItemAt indexPath: IndexPath) {
        onDeleteButtonTap?(self, collectionView, indexPath)
    }

    
    func reload(using stagedChangeset: StagedChangeset<[PTReminder]>, sectionIndex: Int, with animation: UITableView.RowAnimation, setData: ([PTReminder]) -> Void){
        for changeset in stagedChangeset {
            _performBatchUpdates {
                setData(changeset.data)
                
                if !changeset.elementDeleted.isEmpty {
                    self.tableView?.deleteRows(at: changeset.elementDeleted.map { IndexPath(row: $0.element, section: sectionIndex) }, with: UITableView.RowAnimation.middle)
                }
                
                if !changeset.elementInserted.isEmpty {
                    self.tableView?.insertRows(at: changeset.elementInserted.map { IndexPath(row: $0.element, section: sectionIndex) }, with: .top)
                }
                
                if !changeset.elementUpdated.isEmpty {
                    self.tableView?.reloadRows(at: changeset.elementUpdated.map { IndexPath(row: $0.element, section: sectionIndex) }, with: .none)
                }
                
                for (source, target) in changeset.elementMoved {
                    self.tableView?.moveRow(at: IndexPath(row: source.element, section: sectionIndex), to: IndexPath(row: target.element, section: sectionIndex))
                }
            }
        }
    }
    
    private func _performBatchUpdates(_ updates: () -> Void) {
        if #available(iOS 11.0, tvOS 11.0, *) {
            tableView?.performBatchUpdates(updates)
        } else {
            tableView?.beginUpdates()
            updates()
            tableView?.endUpdates()
        }
    }
    
    @objc func selectedPrayerDidChange(){
        
    }
    
    @objc func persistanceDidChange(){
        let source = collection.reminders
        collection.reload()
        let target = collection.reminders
                
        let changeset = StagedChangeset(source: source, target: target)
        if changeset.isEmpty { return }
        
        changeset.forEach { (change) in
            for var elementPath in change.elementDeleted {
                elementPath.section = self.collectionIndex
            }
            
            for var elementPath in change.elementMoved {
                elementPath.source.section = self.collectionIndex
                elementPath.target.section = self.collectionIndex
            }
            
            for var elementPath in change.elementInserted {
                elementPath.section = self.collectionIndex
            }
        }
        
        reload(using: changeset, sectionIndex: self.collectionIndex, with: .automatic) { (data) in
            self.items = data
        }
        
        self.tableView?.reloadEmptyDataSet()
    }
    
    @objc func didChangeActivityState(notification: NSNotification){
        if let reminder = notification.activity?.reminder, var indexPath = self.indexPath(for: reminder) {
            indexPath.section = collectionIndex
            self.tableView?.reloadRows(at: [indexPath], with: .none)
        }
    }
}
