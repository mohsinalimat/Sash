//
//  PTAcknowledgmentItemViewController.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/25/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTAcknowledgmentItemViewController: PTViewController {
    
    var firstAppear = true
    
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.textColor = .black
        textView.font = FontType.medium.with(size: 14)
        textView.isEditable = false
        textView.isSelectable = false
        
        return textView
    }()
    

    var item: PTAcknowledgmentItem? {
        didSet {
            itemDidChange()
        }
    }
    
    var headerView: PTSelectionHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(contentTextView)
                
        let safeArea = view.safeAreaLayoutGuide
        contentTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25).isActive = true
        contentTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        contentTextView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        contentTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        setupHeaderView()
        itemDidChange()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.isScrollEnabled = false
        
        if firstAppear {
            /* fix a bug, need to manually set the content offset to let the header appear */
            contentTextView.contentOffset = CGPoint(x: 0, y: -headerView.maximumContentHeight)
            firstAppear = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentTextView.isScrollEnabled = true
    }
    
    func setupHeaderView() {
        if self.headerView != nil {
            return
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.headerView = PTSelectionHeaderView.instantiateFromNIB()
        headerView.frame = CGRect(x: 0, y: 0, width: self.contentTextView.bounds.width, height: statusBarHeight + 100)
        headerView.backgroundColor = .clear
        
        headerView.maximumContentHeight = statusBarHeight + 100
        headerView.minimumContentHeight = statusBarHeight
        
        headerView.subtitleLabel.isHidden = true
        
        headerView.titleLabel.font = FontType.bold.with(size: 21)
        headerView?.titleLabel?.text = item?.name

        headerView.backButton.tintColor = ColorsDefines.gray
        

        self.contentTextView.addSubview(headerView)
    }
}

extension PTAcknowledgmentItemViewController {
    func itemDidChange() {
        headerView?.titleLabel?.text = item?.name
        contentTextView.text = item?.licenseText
    }
}
