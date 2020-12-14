//
//  SchedulingItemVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SchedulingItemVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
    var id: String?
    var nextIndex: Int?
        
    var tableData:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension SchedulingItemVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedData = tableData?[indexPath.row]
        
        guard let fieldID = id else {
            print("no id set")
            return
        }
        
        guard let updater = surgeryInfoUpdater else{
            print("updater not set")
            return
        }
        
        var tempSurgeryInfo = updater.getCurrentInfo()
        
        switch fieldID{
        case "Hospital":
            tempSurgeryInfo.hospital = selectedData
            break
        case "Procedure":
            tempSurgeryInfo.procedure = selectedData
            break
        default:
            print("fieldID \(fieldID) not recognized for selected row")
            return
        }
        
        guard let nextVCIndex = nextIndex else {
            fatalError("no vc to pass to next")
        }
        updater.updateSurgeryInfo(newInfo: tempSurgeryInfo, nextIndex: nextVCIndex)
    }
}

extension SchedulingItemVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleHospitalCell") as? ScheduleHospitalCell else {
            fatalError("could not find cell with reuse idenfier 'tableCell' in SchedulingItemVC")
        }
        
        if tableView.tag == 1 {
             myCell.hospitalNameLabel.text = tableData?[indexPath.row]
        }
        
        else if tableView.tag == 2 {
                myCell.procedureNameLabel.text = tableData?[indexPath.row]
        }
    
        
        return myCell
    }
}
