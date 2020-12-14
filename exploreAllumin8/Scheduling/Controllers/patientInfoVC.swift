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
    
    @IBOutlet weak var patientID: UITextField!{
        didSet { patientID?.addDoneCancelToolbar() }
    }
    
    @IBOutlet weak var patientAge: UITextField!{
        didSet { patientAge?.addDoneCancelToolbar() }
    }
    
    @IBOutlet weak var patientWeight: UITextField!{
        didSet { patientWeight?.addDoneCancelToolbar() }
    }
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
//    var surgeryListUpdater: SurgeryListLocalUpdater?
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
        guard var tempSurgeryInfo = surgeryInfoUpdater?.getCurrentInfo() else {
            print("patient Info not passed to surgeryInfo, could not get surgeryInfo")
            return
        }
        
        let name: String? = patientName.text
        
        let age: Double? = Double(patientAge.text!)
        
        let id: Double? = Double(patientID.text!)
        
        let weight: Double? = Double(patientWeight.text!)
        
        var sex: String? = nil
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

        
        var errorMessage = ""
        var isInvalid = false
        if name == nil || name!.count == 0{
            isInvalid = true
            errorMessage += "Patient Name is Invalid \n"
        }
        if age == nil || age! < 0.0 || age! > 140.0 {
            isInvalid = true
            errorMessage += "Patient Age is Invalid \n"
        }
        if id == nil || id! < 0.0 {
            isInvalid = true
            errorMessage += "Patient ID is Invalid \n"
        }
        if sex == nil {
            isInvalid = true
            errorMessage += "Patient Sex is Invalid \n"
        }
        if weight == nil || weight! < 0.0 {
            isInvalid = true
            errorMessage += "Patient Weight is Invalid \n"
        }
        
        if isInvalid{
            displayAlert(message: errorMessage)
            return
        }
        
        var patientInfo = Patient(age: age, id: id, name: name, sex: sex, weight: weight)
        tempSurgeryInfo.patient = patientInfo
        
        guard let i = nextIndex else {
            fatalError("no index passed to patientInfoVC")
        }
        surgeryInfoUpdater?.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: i)
    
    }
    
    func displayAlert(message: String){
        let alert = UIAlertController(title: "Invalid Patient Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            
            default:
                print("ree")
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    // For pressing return on the keyboard to dismiss keyboard
    

}

extension patientInfoVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
