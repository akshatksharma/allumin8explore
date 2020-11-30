//
//  SchedulingItemVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class SchedulingItemVC: UIViewController{

    @IBOutlet weak var itemField: UIView!
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
    var surgeryListUpdater: SurgeryListLocalUpdater?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    func onFlip(){
        
        var newInfo:Any = ""
        if let controlItem = itemField as? UIDatePicker{
            newInfo = controlItem.date
        }else if let textItem = itemField as? UITextField{
            newInfo = textItem.text
        }else{
            print("could not parse item Field")
            return
        }
        
        
        guard let surgeryInfoField = id else {
            print("no id was passed")
            return
        }
        
        /*
         var date: Date?
         var patientID: Int?
         var hospital: String?
         var procedure: String?
         var instruments: [CatalogItem]
         var implants: [CatalogItem]
         */
        
        guard let updater = surgeryInfoUpdater else{
            print("updater not set")
            return
        }
        
        var tempSurgeryInfo = updater.getCurrentInfo()
        print(surgeryInfoField)
        switch surgeryInfoField{
        case "SurgeryDate":
            guard let date = newInfo as? Date else {
                print("Failed to convert date to Date")
                return
            }
            tempSurgeryInfo.date = date
            break
        case "PatientID":
            guard let patientIDString = newInfo as? String else{
                print("Failed to convert patientID to String")
                return
            }
            print(patientIDString)
            guard let patientID = Int(patientIDString) else {
                print("Failed to convert patientID to Int")
                return
            }
            tempSurgeryInfo.patientID = patientID
            break
        case "Hospital":
            guard let hospital = newInfo as? String else {
                print("Failed to convert hospital to String")
                return
            }
            tempSurgeryInfo.hospital = hospital
            break
        case "Procedure":
            guard let procedure = newInfo as? String else {
                print("Failed to convert procedure to String")
                return
            }
            tempSurgeryInfo.procedure = procedure
        default:
            print("ID not recognized")
            break
        }
        
        updater.updateSurgeryInfo(newInfo: tempSurgeryInfo)
        
        //Update surgeryInfo with info in current vc
        //If nothing, set to nil
        //At end of vcs, only confirm if all required fields are set
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
