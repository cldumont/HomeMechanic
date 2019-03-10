//
//  MaintenanceItemList.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/7/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import Foundation

class MaintenanceItemList: NSObject, Codable {
    
    var maintenanceItems: [MaintenanceItem] = []
    
    override init() {
        let row0Item = MaintenanceItem()
        row0Item.date = "1999"
        row0Item.odometer = "12123"
        row0Item.notes = "Synthetic Oil. 20w50 Amsoil Extreme. Changed oil filter. Synthetic Oil. 20w50 Amsoil Extreme. Changed oil filter. Synthetic Oil. 20w50 Amsoil Extreme. Changed oil filter"

        let row1Item = MaintenanceItem()
        row1Item.date = "2000"
        row1Item.odometer = "14514"
        row1Item.notes = "Oil change and filter"

        let row2Item = MaintenanceItem()
        row2Item.date = "2005"
        row2Item.odometer = "37844"
        row2Item.notes = "Oil change, replace plug"

        maintenanceItems.append(row0Item)
        maintenanceItems.append(row1Item)
        maintenanceItems.append(row2Item)
    }
    
    func newMaintenanceItem() -> MaintenanceItem {
        let maintenanceItem = MaintenanceItem()
        maintenanceItems.append(maintenanceItem)
        return maintenanceItem
    
    }
    
    func move(item: MaintenanceItem, to index: Int) {
        guard let currentIndex = maintenanceItems.index(of: item) else {
            return
        }
        maintenanceItems.remove(at: currentIndex)
        maintenanceItems.insert(item, at: index)
    }
    
    func remove(items: [MaintenanceItem]) {
        for item in items {
            if let index = maintenanceItems.index(of: item) {
                maintenanceItems.remove(at: index)
            }
        }
    }
    
}
