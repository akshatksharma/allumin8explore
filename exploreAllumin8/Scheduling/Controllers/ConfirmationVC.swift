//
//  ConfirmationVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class ConfirmationVC: SchedulingItemVC {

    @IBOutlet weak var infoView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let info = surgeryInfoUpdater?.getCurrentInfo() else {
            print("failed to get info")
            return
        }
        

        var nextY = infoView.bounds.minY
        var textFrame = CGRect(x: 0, y: nextY, width: infoView.bounds.width, height: 20)
        
        let dateLabel = UILabel(frame: textFrame)
        nextY += 30
        textFrame.origin = CGPoint(x: 0, y: nextY)
        let patientIDLabel = UILabel(frame: textFrame)
        nextY += 30
        textFrame.origin = CGPoint(x: 0, y: nextY)
        let hospitalLabel = UILabel(frame: textFrame)
        nextY += 30
        textFrame.origin = CGPoint(x: 0, y: nextY)
        let procedureLabel = UILabel(frame: textFrame)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"

        
        dateLabel.text = "Date: \(info.date == nil ? "Not Set" : dateFormatter.string(from: info.date!))"
        patientIDLabel.text = "Patient ID: \(info.patientID == nil ? "Not Set" : String(info.patientID!))"
        hospitalLabel.text = "Hospital: \(info.hospital == "" ? "Not Set" : info.hospital!)"
        procedureLabel.text = "Procedure: \(info.procedure == "" ? "Not Set" : info.procedure!)"
        
        infoView.addSubview(dateLabel)
        infoView.addSubview(patientIDLabel)
        infoView.addSubview(hospitalLabel)
        infoView.addSubview(procedureLabel)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for child in infoView.subviews{
            child.removeFromSuperview()
        }
    }

    
    @IBAction func confirmNewSurgery(_ sender: UIButton) {
        print("confirming surgery")
        guard let info = surgeryInfoUpdater?.getCurrentInfo() else {
            print("failed to get info")
            return
        }
        surgeryListUpdater?.updateSurgeries(newSurgery: info)
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
