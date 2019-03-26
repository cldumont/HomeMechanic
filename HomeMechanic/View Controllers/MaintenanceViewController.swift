//
//  MaintenanceViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/6/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

class MaintenanceViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var maintenanceList: MaintenanceList!
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = maintenanceList.name
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func configureText(for cell: UITableViewCell, with item: MaintenanceItem) {
        if let cell = cell as? MaintenanceTableViewCell {
            cell.actualDateLabel.text = item.date
            cell.actualOdometerLabel.text = item.odometer
            cell.notesLabel.text = item.notes
        }
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintenanceList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell", for: indexPath) as! MaintenanceTableViewCell
        let item = maintenanceList.items[indexPath.row]
        configureText(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        maintenanceList.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addEditItemViewController = segue.destination as? AddEditItemViewController {
                addEditItemViewController.delegate = self
                addEditItemViewController.maintenanceList = maintenanceList
                
                let addEditItemViewController = segue.destination as! AddEditItemViewController
                addEditItemViewController.delegate = self
            }
        } else if segue.identifier == "EditItemSegue" {
            if let addEditItemViewController = segue.destination as? AddEditItemViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    let item = maintenanceList.items[indexPath.row]
                    addEditItemViewController.itemToEdit = item
                    addEditItemViewController.delegate = self
                }
            }
        }
    }
    
}

extension MaintenanceViewController: AddEditViewControllerDelegate {
    // MARK:- Add Edit View Controller Delegates
    func addEditViewControllerDidCancel(_ controller: AddEditItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEditViewController(_ controller: AddEditItemViewController, didFinishAdding item: MaintenanceItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = maintenanceList.items.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addEditViewController(_ controller: AddEditItemViewController, didFinishEditing item: MaintenanceItem) {
        if let index = maintenanceList.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell as! MaintenanceTableViewCell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

