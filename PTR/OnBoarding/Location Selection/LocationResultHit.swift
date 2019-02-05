//
//  LocationResultHit.swift
//  PTR
//
//  Created by Hussein AlRyalat on 2/2/19.
//  Copyright © 2019 SketchMe. All rights reserved.
//

import Foundation

typealias LocationSelectionResult = [LocationSearchHit]

struct LocationSearchHit: Hashable, Codable {
    
    var title: String {
        return (administrative.first ?? "") + ", " + country
    }
    
    var coordinates: PTCoordinates {
        return PTCoordinates(longitude: geoloc.lng, latitude: geoloc.lat)
    }
    
    let country: String
    let countryCode: String
    let isCity: Bool
    let administrative: [String]
    let localeNames: [String]
    let geoloc: LocationResultCoordinates
    
    enum CodingKeys: String, CodingKey {
        case country
        case countryCode = "country_code"
        case isCity = "is_city"
        case administrative
        case localeNames = "locale_names"
        case geoloc = "_geoloc"
    }
}

struct LocationResultCoordinates: Hashable, Codable {
    let lat, lng: Double
}
