//
//  SchedulingVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase

protocol SurgeryListLocalUpdater {
    func updateSurgeries(newSurgery:LocalSurgeryInfo)
}

class SchedulingVC: UIViewController, SurgeryListLocalUpdater {
    
    
    var surgeries:[LocalSurgeryInfo] = [
        
    ]
    
    
    //    var surgeonData:Surgeon?
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    //        print(self.caseData)
    
    
    
    //Temp until connected to FireStore
    func updateSurgeries(newSurgery: LocalSurgeryInfo) {
        print("updating surgery list")
        
        
        surgeries.append(newSurgery)
        
        print(surgeries)
        
        //surgeryTable.reloadData()
        
        // print(surgeryTable.numberOfRows(inSection: 0))
        
        
        //        surgeryTable.beginUpdates()
        //        surgeryTable.insertRows(at: [IndexPath(row: self.surgeries.count-2, section: 0)], with: .automatic)
        //        surgeryTable.endUpdates()
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //        print("seguing to \(segue.destination)")
        if let pageController = segue.destination as? SchedulingPageController{
            pageController.surgeryListUpdater = self
        }
    }
    
    
}

extension SchedulingVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surgeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surgeryTableCell", for: indexPath)
        
        let surgeryInfo = surgeries[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        
        
        guard let procedure = surgeryInfo.procedure else {
            fatalError("procedure is not set")
        }
        
        
        return cell
    }
}




extension SchedulingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let surgeryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SurgeryInfo") as? SurgeryInfoVC else {
            print("couldnt get surgeryInfoVC")
            return;
        }
        
        print("pushing vc from collectionView")
        surgeryVC.surgeryInfo = surgeries[indexPath.row]
        navigationController?.pushViewController(surgeryVC, animated: true)
    }
}
