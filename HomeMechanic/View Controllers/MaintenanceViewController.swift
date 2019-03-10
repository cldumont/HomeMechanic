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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [MaintenanceItem]()
            for indexPath in selectedRows {
                items.append(maintenanceItemList.maintenanceItems[indexPath.row])
            }
            maintenanceItemList.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: true)
//        tableView.setEditing(tableView.isEditing, animated: true)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintenanceItemList.maintenanceItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell", for: indexPath) as! MaintenanceTableViewCell
        let item = maintenanceItemList.maintenanceItems[indexPath.row]
        configureText(for: cell, with: item)
        return cell
    }
 
    func configureText(for cell: UITableViewCell, with item: MaintenanceItem) {
        if let cell = cell as? MaintenanceTableViewCell {
            cell.actualDateLabel.text = item.date
            cell.actualOdometerLabel.text = item.odometer
            cell.notesLabel.text = item.notes
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        maintenanceItemList.maintenanceItems.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        maintenanceItemList.move(item: maintenanceItemList.maintenanceItems[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addEditItemViewController = segue.destination as? AddEditItemViewController {
                addEditItemViewController.delegate = self
                addEditItemViewController.maintenanceItemList = maintenanceItemList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let addEditItemViewController = segue.destination as? AddEditItemViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    let item = maintenanceItemList.maintenanceItems[indexPath.row]
                    addEditItemViewController.itemToEdit = item
                    addEditItemViewController.delegate = self
                }
            }
        }
    }
}

extension MaintenanceViewController: AddEditViewControllerDelegate {
    func addEditViewControllerDidCancel(_ controller: AddEditItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEditViewController(_ controller: AddEditItemViewController, didFinishAdding item: MaintenanceItem) {
        navigationController?.popViewController(animated: true)
        let rowIndex = maintenanceItemList.maintenanceItems.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addEditViewController(_ controller: AddEditItemViewController, didFinishEditing item: MaintenanceItem) {
        if let index = maintenanceItemList.maintenanceItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell as! MaintenanceTableViewCell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}

