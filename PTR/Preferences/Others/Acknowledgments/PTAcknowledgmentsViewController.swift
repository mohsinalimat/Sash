//
//  PTAcknowledgmentsViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/21/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources

class PTAcknowledgmentsViewController: PTViewController {
    
    var firstAppear = true
    
    var headerView: PTSelectionHeaderView!
    
    lazy var tableView: UITableView! = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.ds_register(cellNib: PTSelectableTableViewCell.self)
        tableView.ds_register(headerFooterNib: PTSectionHeaderView.self)
        
        view.addSubview(tableView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        return tableView
    }()
    
    lazy var dataSource: PTAcknowledgmentsDataSource = {
        return PTAcknowledgmentsDataSource()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        
        let selectionHandler = BlockSelectionHandler<PTOption, PTSelectableTableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds1, cl, ip in
            self.open(item: ds1.item(at: ip).originalObject as! PTAcknowledgmentItem)
        }
        
        dataSource.librairesDataSource?.setSelectionHandler(selectionHandler)
        
        
        tableView.ds_useDataSource(dataSource)
        setupHeaderView()
        tableView.ds_reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppear {
            /* fix a bug, need to manually set the content offset to let the header appear */
            tableView.contentOffset = CGPoint(x: 0, y: -headerView.maximumContentHeight)
            firstAppear = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self.view) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        /* if the touch location has lies on the same y ( range ) axis as the header view, and the x coordinate is smaller than the header view origin, handle back :) */
        let headerFrame = view.convert(headerView.frame, from: headerView.superview)
        
        if location.y > headerFrame.minY && location.y < headerFrame.maxY && location.x < headerFrame.minX {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        super.touchesEnded(touches, with: event)
    }
    
    func setupHeaderView() {
        if self.headerView != nil {
            return
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.headerView = PTSelectionHeaderView.instantiateFromNIB()
        headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: statusBarHeight + 100)
        headerView.backgroundColor = .clear
        
        headerView.maximumContentHeight = statusBarHeight + 100
        headerView.minimumContentHeight = statusBarHeight
        
        headerView.subtitleLabel.isHidden = true
        
        headerView.titleLabel.font = FontType.bold.with(size: 21)
        headerView.titleLabel.text = Labels.Ack.title
        
        headerView.backButton.tintColor = ColorsDefines.gray
        
        headerView.onBackButtonTap = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        
        self.tableView.addSubview(headerView)
    }
    
    func open(item: PTAcknowledgmentItem){
        let viewController = PTAcknowledgmentItemViewController()
        viewController.item = item
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
