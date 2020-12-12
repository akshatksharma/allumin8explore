//
//  SurgeryInfoVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class SurgeryInfoVC: UIViewController {
    
    @IBOutlet weak var infoView:UIView!
    
    var surgeryInfo:LocalSurgeryInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let info = surgeryInfo else {
            fatalError("no surgery passed to display")
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
        
        
        dateLabel.text = "Date: \(info.startDate == nil ? "Not Set" : dateFormatter.string(from: info.startDate!))"
        patientIDLabel.text = "Patient ID: \(info.patientID == nil ? "Not Set" : String(info.patientID!))"
        hospitalLabel.text = "Hospital: \(info.hospital == "" ? "Not Set" : info.hospital!)"
        procedureLabel.text = "Procedure: \(info.procedure == "" ? "Not Set" : info.procedure!)"
        
        infoView.addSubview(dateLabel)
        infoView.addSubview(patientIDLabel)
        infoView.addSubview(hospitalLabel)
        infoView.addSubview(procedureLabel)



    }
    
    
    /*
     var date: Date?
     var patientID: Int?
     var hospital: String?
     var procedure: String?
     var instruments: [CatalogItem]
     var implants: [CatalogItem]
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
