//
//  PTAcknowledgmentsDataSource.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources

class PTAcknowledgmentsDataSource: CompositeDataSource {
    
    var iconsDataSource: PTOptionsDataSource?
    var librairesDataSource: PTOptionsDataSource?
    
    init(){
        super.init(sectionType: .multi)
        
        
        var headers: [PTSectionHeader] = []

        let headerCreator = BasicBlockSupplementaryViewCreator<PTSectionHeader, PTSectionHeaderView>(size: CGSize(width: 1, height: 50)) { (section, headerView, indexPath) in
            headerView.icon = nil
            
            headerView.titleLabel.text = section.title
            headerView.detailsLabel.text = section.details
            
            headerView.tintColor = .black
            headerView.detailsLabel.textColor = ColorsDefines.gray
        }
        
        let iconsDataSource = _buildIconsDataSource()
        self.iconsDataSource = iconsDataSource
        headers.append(PTSectionHeader(title: Labels.Ack.icons, details: Labels.Ack.iconsDetails, icon: nil, color: nil))
        add(iconsDataSource)
        
        if let librariesDataSource = _buildCodeLibrariesDataSource() {
            self.librairesDataSource = librariesDataSource
            headers.append(PTSectionHeader(title: Labels.Ack.libraries, details: nil, icon: nil, color: nil))
            add(librariesDataSource)
        }
        
        headerCreator.setSectionedItems(headers)
        self.set(headerCreator: headerCreator)
    }
    
    private func _buildIconsDataSource() -> PTOptionsDataSource {
        let icons = Icon.allCases
        
        let defaultDetails = ""
        var options: [PTOption] = []
        
        
        for icon in icons {
            options.append(PTOption(title: icon.lincesName, details: defaultDetails, optionIcon: icon))
        }
        
        
        let dataSource = PTOptionsDataSource(items: options)
        dataSource.defaultAccessoryType = .none
        dataSource.defaultColor = .black
        dataSource.tintedViewElementTypes = [.icon]
        
        return dataSource
    }
    
    private func _buildCodeLibrariesDataSource() -> PTOptionsDataSource? {
        let dataContainer: PTAcknowledgmentsContainer = PTAcknowledgmentsContainer.once
        let options: [PTOption] = dataContainer.specs.map { PTOption(title: $0.name, details: $0.licenseType, originalObject: $0) }
    
        let dataSource = PTOptionsDataSource(items: options)
        dataSource.defaultAccessoryType = .disclosureIndicator
        dataSource.tintedViewElementTypes = []
        
        return dataSource
    }
}
