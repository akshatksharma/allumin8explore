//
//  detailedPatientReview.swift
//  exploreAllumin8
//
//  Created by Namit Sambare on 12/12/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation
import UIKit

import FirebaseFirestore

class detailedPatientReview: UIViewController {
    
    var patientInfo: Patient?
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientGender: UILabel!
    @IBOutlet weak var patientID: UILabel!
    @IBOutlet weak var patientAge: UILabel!
    @IBOutlet weak var patientWeight: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientName.text = patientInfo?.name
        patientGender.text = patientInfo?.sex
        
        if let id = patientInfo?.id {
            patientID.text = "\(id)"
        }
        if let age = patientInfo?.age{
            patientAge.text = "\(age)"
        }
        if let weight = patientInfo?.weight{
            patientWeight.text = "\(weight)"
        }
    }
    
    
}
