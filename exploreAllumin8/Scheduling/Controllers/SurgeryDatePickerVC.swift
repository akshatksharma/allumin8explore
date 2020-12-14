//
//  SurgeryDatePickerVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 12/9/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase

class SurgeryDatePickerVC: UIViewController {

    var surgeryInfoUpdater: SurgeryInfoUpdater?
    var surgeryListUpdater: SurgeryListLocalUpdater?
    var id: String?
    var nextIndex: Int?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func reviewSurgery(_ sender:UIButton){
//        let startTime = startDatePicker.date
//        let endTime = endDatePicker.date
        
        
        guard let updater = surgeryInfoUpdater else {
            fatalError("updater not provided to surgeryDatePickerVC")
        }
        var tempSurgeryInfo = updater.getCurrentInfo()
//        tempSurgeryInfo.startDate = startTime
//        tempSurgeryInfo.endDate = endTime
        
        let date = datePicker.date
        tempSurgeryInfo.date = Timestamp(date: date)
        //NAMIT TO-DO: Needs to update tempSurgeryInfo.date from whatever calendar you use
        
        guard let nextVCIndex = nextIndex else {
            fatalError("no nextIndex provided to surgeryDatePickerVC")
        }
        
        updater.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: nextVCIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
