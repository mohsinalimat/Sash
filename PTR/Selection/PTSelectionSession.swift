//
//  PTSelectionSession.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/19/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources
import DeckTransition


//meant to be subclassed, it does nothing because :D
class PTSelectionSession<T: Selectable>: PTSession {
    enum SelectionType {
        case multiple
        case single
    }
    
    var items: [T]
    
    var identifier: String?
    
    var selectedIndexes: [Int] = [] {
        didSet {
            selectionDidChange()
        }
    }
    
    var isReady: Bool {
        if !isMustHaveSelection {
            return true
        } else {
            return selectedIndexes.count > 0
        }
    }
    
    var selectedValues: [T] {
        var vs: [T] = []
        for index in selectedIndexes {
            vs.append(items[index])
        }
        
        return vs
    }
    
    var selectedValue: T? {
        guard selectedIndexes.count > 0 else { return nil }
        return items[selectedIndexes.first!]
    }
    
    var selectionTitle: String = ""
    
    var selectionDetails: String?
    
    var isMustHaveSelection: Bool = true
    
    var selectionType: SelectionType  = .single
    
    var viewController: PTSelectablesViewController?
    
    var onSelectionChange: (([T]) -> Void)?
    
    init(){
        self.items = T.allOptions as! [T]
    }
    
    func selectionDidChange() {
        onSelectionChange?(self.selectedValues)
    }
}

extension PTSelectionSession {
    func start(){
        // take the top view controller
        let viewController = UIApplication.topViewController()
        
        // generate selectables datasource
        let ds = PTSelectablesDataSource()
        
        ds.unselectedCellAccessoryType = .none
        ds.selectedCellAccessoryType = .checkmark
        ds.items = self.items
        ds.selectionStyle = self.selectionType == .multiple ? .multiple : .single
        ds.selectedIndexPaths = selectedIndexes.map { return IndexPath(item: $0, section: 0) }
        
        
        let selectionHandler = BlockSelectionHandler<Selectable, PTSelectableTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cl, ip in
            let selectablesDS = ds as! PTSelectablesDataSource
            self.selectedIndexes = selectablesDS.selectedIndexPaths.map { return $0.item }
        }
        
        ds.setSelectionHandler(selectionHandler)
        
        
        let optionsVC = PTSelectablesViewController()
        optionsVC.dataSource = ds
        optionsVC.selectionTitle = selectionTitle
        optionsVC.selectionDetails = selectionDetails
        
        
        if let navigationController = viewController?.navigationController {
            navigationController.pushViewController(optionsVC, animated: true)
        } else {
            viewController?.present(optionsVC, animated: true, completion: nil)
        }
    }
    
    func cancel() {
        if let navigationController = viewController?.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            viewController?.dismiss()
        }
    }
    
    func option() -> PTOption? {
        return PTOption(title: self.selectionTitle, details: self.selectedValue?.text)
    }
}
