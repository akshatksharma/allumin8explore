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
        dateFormatter.dateFormat = "MM/dd/yyyy "
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
        
        guard let dateString = dateSelected else {
            print("date not converted")
            displayAlert(message: "Select a date to continue")
            return
        }
        
        
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        guard let newDate = dateFormatter.date(from: dateString + timeString) else {
            print("date not converted to time")
            
            return
        }
        
        print("newDate=")
        print(dateFormatter.string(from: newDate))
        
        guard let nextVCIndex = nextIndex else {
            fatalError("no nextIndex provided to surgeryDatePickerVC")
        }
        
        tempSurgeryInfo.date = Timestamp(date: newDate)
        
        updater.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: nextVCIndex)
    }
    
    func displayAlert(message: String){
        let alert = UIAlertController(title: "Date Not Selected", message: message, preferredStyle: .alert)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self

    }
}
