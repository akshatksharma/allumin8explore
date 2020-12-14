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
    var id: String?
    var nextIndex: Int?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    

    @IBAction func reviewSurgery(_ sender:UIButton){
        guard let updater = surgeryInfoUpdater else {
            fatalError("updater not provided to surgeryDatePickerVC")
        }
        var tempSurgeryInfo = updater.getCurrentInfo()

        
        let date = datePicker.date
        tempSurgeryInfo.date = Timestamp(date: date)
        
        guard let nextVCIndex = nextIndex else {
            fatalError("no nextIndex provided to surgeryDatePickerVC")
        }
        
        updater.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: nextVCIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
