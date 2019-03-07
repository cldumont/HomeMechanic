//
//  MaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/6/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class MaintenanceViewController: UITableViewController {
    

    var maintenanceItemList: MaintenanceItemList
    
    required init?(coder aDecoder: NSCoder) {
        maintenanceItemList = MaintenanceItemList()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Oil Change"
        

        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintenanceItemList.maintenanceItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell", for: indexPath) as! MaintenanceTableViewCell
        cell.actualDateLabel.text = maintenanceItemList.maintenanceItems[indexPath.row].date
        cell.actualOdometerLabel.text = maintenanceItemList.maintenanceItems[indexPath.row].odometer
        cell.notesLabel.text = maintenanceItemList.maintenanceItems[indexPath.row].notes
        
        return cell
    }

}

