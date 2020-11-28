//
//  detailedCaseVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class detailedCaseVC: UIViewController {

    var detailedCase:Surgery?
    @IBOutlet weak var surgeryName: UILabel!
    @IBOutlet weak var surgeryCaseId: UILabel!
    @IBOutlet weak var surgeryPatientId: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailedCase = detailedCase else {return}
        print(detailedCase)
        setupView()
//        self.title = detailedCase.name
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        surgeryName.text = detailedCase?.name
        surgeryCaseId.text = detailedCase?.id
        
        guard var patientIdDouble = detailedCase?.patient_id else {return}
        guard let patientId = patientIdDouble.toInt() else { return }
        surgeryPatientId.text = "\(patientId)"
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

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
