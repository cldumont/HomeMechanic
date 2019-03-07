//
//  MaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/6/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class MaintenanceViewController: UITableViewController {
    
    var date = [String]()
    var odometer = [String]()
    var notes = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Oil Change"
        
        date += ["1999", "2000", "2005"]
        odometer += ["12123", "14514", "37844"]
        notes += ["Synthetic Oil. 20w50 Amsoil Extreme. Changed oil filter. Synthetic Oil. 20w50 Amsoil Extreme. Changed oil filter. Synthetic Oil. 20w50 Amsoil Extreme. Changed oil filter", "Oil change and filter", "Oil change, replace plug"]
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell", for: indexPath) as! MaintenanceTableViewCell
        cell.actualDateLabel.text = date[indexPath.row]
        cell.actualOdometerLabel.text = odometer[indexPath.row]
        cell.notesLabel.text = notes[indexPath.row]
        return cell
    }

}

