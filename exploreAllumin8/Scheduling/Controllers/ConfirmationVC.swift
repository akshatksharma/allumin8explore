//
//  ConfirmationVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class ConfirmationVC: SchedulingItemVC {
    @IBOutlet weak var caseIdLabel: UILabel!
    @IBOutlet weak var patientIDLabel: UILabel!
    @IBOutlet weak var surgeonNameLabel: UILabel!
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell()
        return myCell
    }
    

   
    @IBOutlet weak var kitTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let updater = surgeryInfoUpdater else {
            fatalError("no updater passed to confirmationVC")
        }
        
        let tempInfo = updater.getCurrentInfo()
        
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let info = surgeryInfoUpdater?.getCurrentInfo() else {
            print("failed to get info")
            return
        }
        
        caseIdLabel.text = "ljkl;aejsf"
        patientIDLabel.text = String(info.patientID!)
        surgeonNameLabel.text = "Todd Sproul"
        


    }
    
    override func viewDidDisappear(_ animated: Bool) {
     
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
