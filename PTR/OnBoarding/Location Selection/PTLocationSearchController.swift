//
//  LocationSelectionCleint.swift
//  PTR
//
//  Created by Hussein AlRyalat on 2/2/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation
import AlgoliaSearch

protocol LocationSelectionClientDelegate: class {
    func locationClient(client: PTLocationSearchController, didRecieveError error: Error)
    func locationClient(client: PTLocationSearchController, didRecieve results: [LocationSearchHit])
    func locationClient(client: PTLocationSearchController, didChangeLoadingState loading: Bool)
}

class PTLocationSearchController {
    
    enum AnError: Error {
        case apiError(Error)
        case objectNotFound
        case parsingError(Error)
    }
    
    private struct Constants {
        static let appID = "plE6UXX49TES"
        static let apiKey = "a94f863122c8ef2aab0690dfec489c00"
    }
    
    weak var delegate: LocationSelectionClientDelegate?
    
    var isLoading: Bool = false {
        didSet {
            self.delegate?.locationClient(client: self, didChangeLoadingState: isLoading)
        }
    }
    
    /* The client used to execute the query and return the data */
    lazy var placesClient: PlacesClient = PlacesClient(appID: Constants.appID, apiKey: Constants.apiKey)
    
    /* The query used to get cities. */
    lazy var query: PlacesQuery = {
        let query = PlacesQuery()
        query.language = PTLocalizationController.shared.language.localizationIdentifier
        query.hitsPerPage = 20
        query.type = .city
        
        return query
    }()
    
    init(){ }
    
    
    func performSearch(with query: String?){
        isLoading = true
        self.query.query = query
        placesClient.search(self.query) { [unowned self] (json, error) in
            self.isLoading = false
            if let error = error {
                self.report(error: .apiError(error))
                return
            }
            
            guard let hits = json?["hits"] as? [JSONObject] else {
                self.report(error: .objectNotFound)
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: hits, options: [])
               
                let decoder = JSONDecoder()
                let result = try decoder.decode(LocationSelectionResult.self, from: data)
            
                self.report(result: Array(Set(result)))
            } catch( let error){
                self.report(error: .parsingError(error))
                return
            }
        }
    }
    
    private func report(error: AnError){
        self.delegate?.locationClient(client: self, didRecieveError: error)
    }
    
    private func report(result: LocationSelectionResult){
        self.delegate?.locationClient(client: self, didRecieve: result)
    }
}
