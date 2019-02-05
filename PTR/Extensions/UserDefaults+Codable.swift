//
//  UserDefaults+Codable.swift
//  Prayer Times Reminder
//
//  Created by Hussein Al-Ryalat on 9/16/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import Foundation

// MARK: - UserDefaults extensions

public extension UserDefaults {
    
    /// Set Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    public func set<T: Codable>(object: T, forKey: String) throws {
        
        
        let jsonData = try PropertyListEncoder().encode(object)
        
        set(jsonData, forKey: forKey)
    }
    
    /// Get Codable object into UserDefaults
    ///
    /// - Parameters:
    ///   - object: Codable Object
    ///   - forKey: Key string
    /// - Throws: UserDefaults Error
    public func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        
        return try PropertyListDecoder().decode(objectType, from: result)
    }
}
