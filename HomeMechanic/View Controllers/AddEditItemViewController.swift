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
    weak var maintenanceList: MaintenanceList?
    weak var itemToEdit: MaintenanceItem?
    private var datePicker: UIDatePicker?
    
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var odometerTextfield: UITextField!
    @IBOutlet weak var notesTextview: UITextView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
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
            doneBarButton.isEnabled = true
        } else {
            title = "Add Item"
        }
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddEditItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddEditItemViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextfield.inputView = datePicker
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextfield.text = dateFormatter.string(from: datePicker.date)
        odometerTextfield.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //dateTextfield.becomeFirstResponder()
        //odometerTextfield.becomeFirstResponder()
        //notesTextview.becomeFirstResponder()
        
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
            if let item = maintenanceList?.newMaintenanceItem() {
                if let date = dateTextfield.text,
                    let odometer = odometerTextfield.text,
                    let notes = notesTextview.text {
                    item.date = date
                    item.odometer = odometer
                    item.notes = notes
                }
                delegate?.addEditViewController(self, didFinishAdding: item)
            }
        }
        
    }
    
}

extension AddEditItemViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        odometerTextfield.resignFirstResponder()
        notesTextview.becomeFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let oldText = textView.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: text)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    
    
}

