//
//  LocalData.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//

import Foundation


class LocalData {
    
    enum DataKey:String,CaseIterable
    {
        case resumeList = "RESUME_LIST"
        case exportingResume = "EXPORTING_RESUME"
    }
    
    //MARK: local Data
    static func saveData<T>(_ key: DataKey, item: T) {
        UserDefaults.standard.set(item, forKey: key.rawValue)
    }
    
    static func loadData<T>(_ key: DataKey) ->T? {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? T {
            return value
        }
        
        return nil
    }
    
    static func removeData(_ key: DataKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    static func saveObject<T:Codable>(_ key:DataKey, item:T) -> Bool
    {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(item) {
            UserDefaults.standard.set(data, forKey:key.rawValue)
            return true
        }
        
        return false
    }
    
    static func loadObject<T:Codable>(_ key:DataKey) ->T?
    {
        var data:T?
        
        if let rawData = UserDefaults.standard.object(forKey: key.rawValue) as? Data
        {
            let decoder = JSONDecoder()
            data = try? decoder.decode(T.self, from: rawData)
        }
        
        
        return data
    }
}
