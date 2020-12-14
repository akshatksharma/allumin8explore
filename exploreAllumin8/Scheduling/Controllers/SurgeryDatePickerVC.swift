//
//  SurgeryDatePickerVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 12/9/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase
import FSCalendar

class SurgeryDatePickerVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
    var id: String?
    var nextIndex: Int?
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateSelected:String?
    let dateFormatter = DateFormatter()

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateSelected = dateFormatter.string(from: date)
        print(dateSelected)
        
    }
    
    @IBAction func reviewSurgery(_ sender:UIButton){
        guard let updater = surgeryInfoUpdater else {
            fatalError("updater not provided to surgeryDatePickerVC")
        }
        var tempSurgeryInfo = updater.getCurrentInfo()

        
//        let date = datePicker.date
//        tempSurgeryInfo.date = Timestamp(date: date)
        var time = datePicker.date
        dateFormatter.dateFormat = "hh:mm a"
        var timeString:String = dateFormatter.string(from: time)
        
        
        print(timeString)
        
        guard let nextVCIndex = nextIndex else {
            fatalError("no nextIndex provided to surgeryDatePickerVC")
        }
        
        updater.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: nextVCIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self

    }
}
