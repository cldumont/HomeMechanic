//
//  MaintenanceList.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/10/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class MaintenanceList: NSObject, Codable {

    var name = ""
    var items = [MaintenanceItem] ()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func newMaintenanceItem() -> MaintenanceItem {
        let maintenanceItem = MaintenanceItem()
        items.append(maintenanceItem)
        return maintenanceItem
        
    }
}
