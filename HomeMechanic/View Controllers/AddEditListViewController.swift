//
//  AddEditListViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/11/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

protocol AddEditListViewControllerDelegate: class {
    func addEditListViewControllerDidCancel(_ controller: AddEditListViewController)
    
    func addEditListViewController(_ controller: AddEditListViewController, didFinishAdding maintenanceList: MaintenanceList)
    
    func addEditListViewController(_ controller: AddEditListViewController, didFinishEditing maintenanceList: MaintenanceList)
}

class AddEditListViewController: UIViewController {
    
    weak var delegate: AddEditListViewControllerDelegate?
     
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var maintenanceListToEdit: MaintenanceList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        textField.delegate = self
        
        if let maintenanceList = maintenanceListToEdit {
            title = "Edit Maintenance List"
            textField.text = maintenanceList.name
            doneBarButton.isEnabled = true
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addEditListViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let maintenanceList = maintenanceListToEdit {
            maintenanceList.name = textField.text!
            delegate?.addEditListViewController(self, didFinishEditing: maintenanceList)
        } else {
            let maintenanceList = MaintenanceList(name: textField.text!)
            delegate?.addEditListViewController(self, didFinishAdding: maintenanceList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    

}

extension AddEditListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
