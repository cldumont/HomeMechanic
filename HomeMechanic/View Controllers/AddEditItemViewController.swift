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
        
        dateTextfield.becomeFirstResponder()
        addDatePicker()
        
        if let item = itemToEdit {
            title = "Edit Item"
            dateTextfield.text = item.date
            odometerTextfield.text = item.odometer
            notesTextview.text = item.notes
            doneBarButton.isEnabled = true
        } else {
            title = "Add Item"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddEditItemViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneNumPad))]
        numberToolbar.sizeToFit()
        odometerTextfield.inputAccessoryView = numberToolbar
    
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func doneNumPad () {
        // Take a look bounces on smaller screens
        odometerTextfield.resignFirstResponder()
        
        notesTextview.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardSize.height

        let editingTextViewY: CGFloat! = self.notesTextview?.frame.origin.y

        //Checking if the textView is really hidden behind the keyboard
        if self.view.frame.origin.y >= 0 {
            if editingTextViewY > keyboardY - 200 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextViewY! - (keyboardY - 200)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
   
    func addDatePicker() {
        datePicker = UIDatePicker()
        let doneDatePicker = UIToolbar()
        doneDatePicker.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.dateChanged))
        doneDatePicker.setItems([done], animated: false)
        dateTextfield.inputAccessoryView = doneDatePicker
        dateTextfield.inputView = datePicker
        datePicker?.datePickerMode = .date
    }
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextfield.text = dateFormatter.string(from: datePicker!.date)
        odometerTextfield.becomeFirstResponder()
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
        //odometerTextfield.resignFirstResponder()
        return true
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        notesTextview = textView
    }
    
    

}

