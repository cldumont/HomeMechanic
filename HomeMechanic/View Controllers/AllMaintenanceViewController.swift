//
//  AllMaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/10/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class AllMaintenanceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMaintenanceCell", for: indexPath)
        cell.textLabel?.text = "List \(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMaintenance", sender: nil)
    }

}
