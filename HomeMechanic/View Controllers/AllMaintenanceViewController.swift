//
//  AllMaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/10/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class AllMaintenanceViewController: UITableViewController {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Maintenance List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedMaintenanceList
        
        if index >= 0 && index < dataModel.lists.count {
            let maintenanceList = dataModel.lists[index]
            performSegue(withIdentifier: "ShowMaintenance", sender: maintenanceList)
        }
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMaintenanceCell", for: indexPath)
        cell.textLabel?.text = dataModel.lists[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedMaintenanceList = indexPath.row
        let maintenanceList = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowMaintenance", sender: maintenanceList)
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMaintenance" {
            let controller = segue.destination as! MaintenanceViewController
            controller.maintenanceList = sender as? MaintenanceList
        } else if segue.identifier == "AddListSegue" {
            let controller = segue.destination as! AddEditListViewController
            controller.delegate = self
        } else if segue.identifier == "EditListSegue" {
            let controller = segue.destination as! AddEditListViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.maintenanceListToEdit = dataModel.lists[indexPath.row]
            }
        }
    }
    
}

extension AllMaintenanceViewController: AddEditListViewControllerDelegate {
    // MARK:- Add Edit List View Controller Delegates
    func addEditListViewControllerDidCancel(_ controller: AddEditListViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEditListViewController(_ controller: AddEditListViewController, didFinishAdding maintenanceList: MaintenanceList) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(maintenanceList)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addEditListViewController(_ controller: AddEditListViewController, didFinishEditing maintenanceList: MaintenanceList) {
        if let index = dataModel.lists.index(of: maintenanceList) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = maintenanceList.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension AllMaintenanceViewController: UINavigationControllerDelegate {
    // MARK:- Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedMaintenanceList = -1
        }
        
    }
}
