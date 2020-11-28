//
//  detailedCaseVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class detailedCaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var detailedCase:Surgery?
    @IBOutlet weak var surgeryName: UILabel!
    @IBOutlet weak var surgeryCaseId: UILabel!
    @IBOutlet weak var surgeryPatientId: UILabel!
    @IBOutlet weak var surgeon: UILabel!
    @IBOutlet weak var implantsTable: UITableView!
    @IBOutlet weak var instrumentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detailedCase = detailedCase else {return}
        
        implantsTable.delegate = self
        implantsTable.dataSource = self
        instrumentsTable.delegate = self
        instrumentsTable.dataSource = self
        
        print(detailedCase)
        setupView()
//        self.title = detailedCase.name
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        surgeryName.text = detailedCase?.name
        surgeryCaseId.text = detailedCase?.id
        surgeon.text = detailedCase?.surgeon
        guard let patientIdDouble = detailedCase?.patient_id else {return}
        guard let patientId = patientIdDouble.toInt() else { return }
        surgeryPatientId.text = "\(patientId)"
        

        DispatchQueue.main.async {
            self.implantsTable.reloadData()
        }
    }
    
    
    // populates the instrument and implant tables with the items from the respective arrays in the database
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==implantsTable{
            guard let numImplants = (detailedCase?.implants?.count) else{
                return 0
            }
            return numImplants
        }
        else{
            guard let numInstruments = (detailedCase?.instruments?.count) else{
                return 0
            }
            return numInstruments
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==implantsTable{
            let cell = implantsTable.dequeueReusableCell(withIdentifier: "implantCell", for: indexPath)
            cell.textLabel!.text = detailedCase?.implants?[indexPath.row].name
            return cell;
        }
        else{
            let cell = instrumentsTable.dequeueReusableCell(withIdentifier: "instrumentCell", for: indexPath)
            cell.textLabel!.text = detailedCase?.instruments?[indexPath.row].name
            return cell;
        }
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
