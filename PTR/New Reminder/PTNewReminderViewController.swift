//
//  PTAddReminderViewController.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 8/18/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit
import GenericDataSources
import MaterialShowcase

class PTNewReminderViewController: PTViewController, UITextFieldDelegate {
    
    //MARK: Variables
    weak var session: PTNewReminderSession?
    
    var text: String? {
        didSet {
            textField?.text = text
        }
    }
    
    var color: UIColor! {
        didSet {
            saveButton?.backgroundColor = color
            textField?.tintColor = color
        }
    }
    
    var saveButtonIsEnabled: Bool = false {
        didSet {
            saveButton?.isEnabled = saveButtonIsEnabled
            saveButton?.alpha = saveButtonIsEnabled ? 1 : 0.5
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Labels.NewReminder.title
            titleLabel.font = FontType.bold.with(size: 15)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = Labels.NewReminder.details
            descriptionLabel.textColor = ColorsDefines.gray
            descriptionLabel.font = FontType.regular.with(size: 15)
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = Labels.NewReminder.placeholder
            textField.delegate = self
            textField.font = FontType.medium.with(size: 27)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.ds_register(cellNib: PTSelectableTableViewCell.self)
            tableView.ds_useDataSource(session!.dataSource)
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.setTitle(Actions.save, for: .normal)
            saveButton.tintColor = .white
            saveButton.layer.cornerRadius = 12
            saveButton.titleLabel?.font = FontType.medium.with(size: 17)
            
            let cc = saveButtonIsEnabled
            saveButtonIsEnabled = cc
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedPrayer = PTPrayerTimesController.default.selectedPrayer
        self.color = selectedPrayer.color
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: UITextField.textDidChangeNotification, object: self.textField)
        
        textField.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldTextDidChange(){
        session?.set(text: textField.text)
    }
}

extension PTNewReminderViewController {
    @IBAction func saveButtonTapped(){
        self.session?.save()
    }
    
    @IBAction func textFieldEditingChanged(){
        self.saveButtonIsEnabled = self.session!.canSave
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
