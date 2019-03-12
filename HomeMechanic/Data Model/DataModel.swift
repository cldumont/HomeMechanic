//
//  DataModel.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/11/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [MaintenanceList]()
    
    var indexOfSelectedMaintenanceList: Int {
        get {
            return UserDefaults.standard.integer(forKey: "MaintenanceListIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MaintenanceListIndex")
        }
    }
    
    init() {
        loadMaintenanceItems()
        registerDefaults()
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")

    }
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("MaintenanceItems.plist")
    }
    
    func saveMaintenanceItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadMaintenanceItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([MaintenanceList].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    func registerDefaults() {
        let dictionary = ["MaintenanceListIndex": -1]
        UserDefaults.standard.register(defaults: dictionary)
    }
}
