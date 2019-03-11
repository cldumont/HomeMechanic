//
//  AllMaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/10/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class AllMaintenanceViewController: UITableViewController, AddEditListViewControllerDelegate {
    
    var lists = [MaintenanceList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maintenance List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        var list = MaintenanceList(name: "Oil Change")
        lists.append(list)
        
        list = MaintenanceList(name: "Rotate Tires")
        lists.append(list)
        
        loadMaintenanceItems()
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMaintenanceCell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let maintenanceList = lists[indexPath.row]
        performSegue(withIdentifier: "ShowMaintenance", sender: maintenanceList)
    }
    
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
                controller.maintenanceListToEdit = lists[indexPath.row]
            }
        }
    }
    
    // MARK:- Add Edit List View Controller Delegates
    func addEditListViewControllerDidCancel(_ controller: AddEditListViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEditListViewController(_ controller: AddEditListViewController, didFinishAdding maintenanceList: MaintenanceList) {
        let newRowIndex = lists.count
        lists.append(maintenanceList)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addEditListViewController(_ controller: AddEditListViewController, didFinishEditing maintenanceList: MaintenanceList) {
        if let index = lists.index(of: maintenanceList) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = maintenanceList.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
