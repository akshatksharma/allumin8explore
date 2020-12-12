//
//  SchedulingItemVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class SchedulingItemVC: UIViewController{
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
    var surgeryListUpdater: SurgeryListLocalUpdater?
    var id: String?
    var nextIndex: Int?
    
    var info:[String] = ["Barnes Jewish"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(nextIndex)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        
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

extension SchedulingItemVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(info[indexPath.row])")
        
        let newInfo = info[indexPath.row]
        
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
            tempSurgeryInfo.hospital = newInfo
            break
        case "Patient":
//            tempSurgeryInfo.patient?.id = Int(newInfo)
            //NAMIT TO-DO: Patient updating was handled here but now needs to be handled elsewhere cause its not a table anymore
            break
        case "Procedure":
            tempSurgeryInfo.procedure = newInfo
            break
        default:
            print("info passed but could not find proper surgery info id to place it into")
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
        return info.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else {
            fatalError("could not find cell with reuse idenfier 'tableCell' in SchedulingItemVC")
        }
        
        myCell.textLabel?.text = info[indexPath.row]
        
        return myCell
    }
}
