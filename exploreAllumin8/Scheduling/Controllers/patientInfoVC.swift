//
//  patientInfoVC.swift
//  exploreAllumin8
//
//  Created by Namit Sambare on 12/12/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation

import UIKit

class patientInfoVC: UIViewController {
    @IBOutlet weak var patientName: UITextField!{
        didSet { patientName?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var patientSex: UISegmentedControl!
    

    @IBOutlet weak var patientID: UITextField! {
        didSet { patientID?.addDoneCancelToolbar() }
    }
    
    @IBOutlet weak var patientAge: UITextField!{
        didSet { patientAge?.addDoneCancelToolbar() }
    }
    
    @IBOutlet weak var patientWeight: UITextField!{
        didSet { patientWeight?.addDoneCancelToolbar() }
    }
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
    var surgeryListUpdater: SurgeryListLocalUpdater?
    var id: String?
    var nextIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        patientName.delegate = self
        patientID.delegate = self
        patientAge.delegate = self
        patientWeight.delegate = self
    }
    

    
    
    @IBAction func updatePatient(_ sender: UIButton){
        
        print("in here")
        
        guard var tempSurgeryInfo = surgeryInfoUpdater?.getCurrentInfo() else {
            print("patient Info not passed to surgeryInfo, could not get surgeryInfo")
            return
        }
        
        guard let name = patientName.text else {
            print("could not get patient name")
            return
        }
        guard let age = Double(patientAge.text!) else {
            print("could not get patient age")
            return
        }
        guard let id = Double(patientID.text!) else {
            print("could not get patient id")
            return
        }
        
        guard let weight = Double(patientWeight.text!) else {
            print("could not get patient weight")
            return
        }
        
        var sex: String = ""
        switch patientSex.selectedSegmentIndex {
        case 0:
            sex = "Female"
            break
        case 1:
            sex = "Male"
            break
        default:
            print("couldn't get patient sex")
            break
        }
        
        //TO-DO: Fix validation for certain input fields
        //Validate age string to be + number only
        //Make sex options
        //Validate weight to be only +
        
        //TO-DO: Fix Keyboards so that typing works with software keyboard
        
        
        
        var patientInfo = Patient(age: age, id: id, name: name, sex: sex, weight: weight)
        tempSurgeryInfo.patient = patientInfo
        
        guard let i = nextIndex else {
            fatalError("no index passed to patientInfoVC")
        }
        surgeryInfoUpdater?.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: i)
    
    }
    
    // For pressing return on the keyboard to dismiss keyboard
    

}

extension patientInfoVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("returning")
        textField.resignFirstResponder()
        
        return true
    }

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
