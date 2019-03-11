//
//  AllMaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/10/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class AllMaintenanceViewController: UITableViewController {
    
    //new
    var lists = [MaintenanceList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maintenance List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        var list = MaintenanceList(name: "Oil Change")
        lists.append(list)
        
        list = MaintenanceList(name: "Rotate Tires")
        lists.append(list)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMaintenanceCell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //new
        let maintenanceList = lists[indexPath.row]
        performSegue(withIdentifier: "ShowMaintenance", sender: maintenanceList)
    }
    
    //new
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMaintenance" {
            let controller = segue.destination as! MaintenanceViewController
            controller.maintenanceList = sender as? MaintenanceList
        }
    }

}
