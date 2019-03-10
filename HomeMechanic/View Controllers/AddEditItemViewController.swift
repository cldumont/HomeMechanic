//
//  AddEditItemViewController.swift
//  HomeMechanic
//
//  Created by Craig Dumont on 3/8/19.
//  Copyright © 2019 Craig Dumont. All rights reserved.
//

import UIKit

protocol AddEditViewControllerDelegate: class {
    func addEditViewControllerDidCancel(_ controller: AddEditItemViewController)
    func addEditViewController(_ controller: AddEditItemViewController, didFinishAdding item: MaintenanceItem)
    func addEditViewController(_ controller: AddEditItemViewController, didFinishEditing item: MaintenanceItem)
}

class AddEditItemViewController: UIViewController {
    
    weak var delegate: AddEditViewControllerDelegate?
    weak var maintenanceItemList: MaintenanceItemList?
    weak var itemToEdit: MaintenanceItem?
    
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var odometerTextfield: UITextField!
    @IBOutlet weak var notesTextview: UITextView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        dateTextfield.delegate = self
        odometerTextfield.delegate = self
        notesTextview.delegate = self
        
        if let item = itemToEdit {
            title = "Edit Item"
            dateTextfield.text = item.date
            odometerTextfield.text = item.odometer
            notesTextview.text = item.notes
            addBarButton.isEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateTextfield.becomeFirstResponder()
        odometerTextfield.becomeFirstResponder()
        notesTextview.becomeFirstResponder()
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addEditViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit,
            let date = dateTextfield.text,
            let odometer = odometerTextfield.text,
            let notes = notesTextview.text {
            item.date = date
            item.odometer = odometer
            item.notes = notes
            delegate?.addEditViewController(self, didFinishEditing: item)
        } else {
            if let item = maintenanceItemList?.newMaintenanceItem() {
            if let textFieldText = dateTextfield.text {
                item.date = textFieldText
            }
            if let textFieldText = odometerTextfield.text {
                item.odometer = textFieldText
            }
            if let textViewText = notesTextview.text {
                item.notes = textViewText
            }
            delegate?.addEditViewController(self, didFinishAdding: item)
        }
        }
        
    }
    
}

extension AddEditItemViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateTextfield.resignFirstResponder()
        odometerTextfield.resignFirstResponder()
        notesTextview.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else { return false }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let oldText = textView.text,
            let stringRange = Range(range, in: oldText) else { return false }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: text)
        if newText.isEmpty {
            addBarButton.isEnabled = false
        } else {
            addBarButton.isEnabled = true
        }
        return true
    }
    
    
    
}


