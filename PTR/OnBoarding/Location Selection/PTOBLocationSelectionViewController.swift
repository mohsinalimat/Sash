//
//  PTOBLocationSelectionViewController.swift
//  PTR
//
//  Created by Hussein AlRyalat on 2/2/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import UIKit
import AlgoliaSearch
import GenericDataSources

class PTOBLocationSelectionViewController: PTOBViewController {
    
    struct Constants {
        static let searchPlaceholder = "Search City.."
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.font = FontType.bold.with(size: 21)
            searchTextField.attributedPlaceholder = NSAttributedString(string: Constants.searchPlaceholder, attributes: [NSAttributedString.Key.font: FontType.bold.with(size: 21), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.2)])
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.backgroundColor = .clear
            self.tableView.ds_useDataSource(dataSource)
        }
    }
    
    /* the data source used to display results */
    var dataSource = PTLocationSearchHitsDataSource()
    
    /* the controller used to fetch the results */
    var controller = PTLocationSearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        controller.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: UITextField.textDidChangeNotification, object: searchTextField)
        
        let selectionHandler = BlockSelectionHandler<LocationSearchHit, UITableViewCell>()
        selectionHandler.didSelectBlock = { [unowned self] ds, cl, ip in
            // get coordinates
            self.finish(with: ds.item(at: ip))
        }
        
        dataSource.setSelectionHandler(selectionHandler)
        self.controller.performSearch(with: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldTextDidChange(){
//        self.controller.performSearch(with: searchTextField.text)
    }
    
    
    
    func finish(with item: LocationSearchHit){
        PTPreferencesController.shared.set(locationName: item.title)
        PTPreferencesController.shared.set(coordinates: item.coordinates)
        
        self.pageContainerViewController?.finish()
    }
}

extension PTOBLocationSelectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        controller.performSearch(with: textField.text)
        return textField.resignFirstResponder()
    }
}

extension PTOBLocationSelectionViewController: LocationSelectionClientDelegate {
    func locationClient(client: PTLocationSearchController, didChangeLoadingState loading: Bool) {
        loading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }
    
    func locationClient(client: PTLocationSearchController, didRecieveError error: Error) {
        print("GO ERROR \(error)")
    }
    
    func locationClient(client: PTLocationSearchController, didRecieve results: [LocationSearchHit]) {
        self.dataSource.items = results
        self.tableView.ds_reloadData()
    }
}
