//
//  LocalStorage.swift
//  Bythen
//
//  Created by edisurata on 16/08/24.
//

import Foundation

class LocalStorage {
    static func setValueString(_ value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getValueString(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func setBool(_ value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getBool(_ key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    static func setValueObject(_ value: Codable, key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(value) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    static func getValueObject<T: Codable>(_ key: String) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let loadedObj = try? decoder.decode(T.self, from: savedData) {
                return loadedObj
            }
        }
        return nil
    }
    
    static func removeValue(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
