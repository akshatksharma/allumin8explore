//
//  detailedCaseVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class detailedCaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var detailedCase:Surgery?
    var items = [DetailedViewItem]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.section]
        
        print(item)
        
        switch item.type {
        case .caseInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "caseInfo", for: indexPath) as? DetailedCaseInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .itemInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .statusInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .instrumentInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.section]

        switch item.type {
        case .caseInfo:
            return
        case .itemInfo:
            guard let item = item as? SurgeryKitItem else { return }
            let kitInfo = KitInfo(name: item.kitName, products: item.surgeryItems)
    
            performSegue(withIdentifier: "showItems", sender: kitInfo )
        case .statusInfo:
            return
        case .instrumentInfo:
            return
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func loadItems() {
        if let patientId = detailedCase?.patient_id, let caseId = detailedCase?.id, let surgeon = detailedCase?.surgeon_name, let surgeryName = detailedCase?.procedure {
            
            let caseInfoItem = CaseInfoItem(surgeryName: surgeryName, surgeon: surgeon, caseId: caseId, patientId: patientId)
            
            items.append(caseInfoItem)
        }
        
        if let instruments = detailedCase?.instruments, let procedure = detailedCase?.procedure {
            let surgeryKitItem = SurgeryKitItem(kitName: "\(procedure) Kit", surgeryItems: instruments)
            
            items.append(surgeryKitItem)
        }
    }
    
    
    //    @IBOutlet weak var surgeryCaseId: UILabel!
    //    @IBOutlet weak var surgeryName: UILabel!
    //    @IBOutlet weak var surgeon: UILabel!
    //    @IBOutlet weak var surgeryPatientId: UILabel!
    //    @IBOutlet weak var instrumentsTable: UITableView!
    //    @IBOutlet weak var implantsTable: UITableView!
    //    @IBOutlet weak var pageScrollView: UIScrollView!
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadItems()
        guard let detailedCase = detailedCase else {return}
        
        //        dump(detailedCase)
        
        //        implantsTable.delegate = self
        //        implantsTable.dataSource = self
        //        instrumentsTable.delegate = self
        //        instrumentsTable.dataSource = self
        //        pageScrollView.delegate = self
        //
        //        setupView()
        //
        //        instrumentsTable.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped)))
        //        implantsTable.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped)))
        //        pageScrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(scrollViewSwiped)))
        
    }
    //
    //    func setupView() {
    //        surgeryName.text = detailedCase?.name
    //        surgeryCaseId.text = detailedCase?.id
    //        surgeon.text = detailedCase?.surgeon
    //        guard let patientIdDouble = detailedCase?.patient_id else {return}
    //        guard let patientId = patientIdDouble.toInt() else { return }
    //        surgeryPatientId.text = "\(patientId)"
    //
    //
    //        DispatchQueue.main.async {
    //            self.implantsTable.reloadData()
    //        }
    //    }
    //
    //
    //    // populates the instrument and implant tables with the items from the respective arrays in the database
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        if tableView==implantsTable{
    //            guard let numImplants = (detailedCase?.implants?.count) else{
    //                return 0
    //            }
    //            return numImplants
    //        }
    //        else{
    //            guard let numInstruments = (detailedCase?.instruments?.count) else{
    //                return 0
    //            }
    //            return numInstruments
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        if tableView==implantsTable{
    //            let cell = implantsTable.dequeueReusableCell(withIdentifier: "implantCell", for: indexPath)
    //            cell.textLabel!.text = detailedCase?.implants?[indexPath.row].name
    //            return cell;
    //        }
    //        else{
    //            let cell = instrumentsTable.dequeueReusableCell(withIdentifier: "instrumentCell", for: indexPath)
    //            cell.textLabel!.text = detailedCase?.instruments?[indexPath.row].name
    //            return cell;
    //        }
    //    }
    //
    //    @objc func tableViewSwiped(){
    //        pageScrollView.isScrollEnabled = false
    //        instrumentsTable.isScrollEnabled = true
    //        implantsTable.isScrollEnabled = true
    //
    //        print("swiping table")
    //    }
    //
    //    @objc func scrollViewSwiped(){
    //        pageScrollView.isScrollEnabled = true
    //        instrumentsTable.isScrollEnabled = false
    //        implantsTable.isScrollEnabled = false
    //
    //        print("swiping scroll")
    //    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        let instrumentsVC = segue.destination as! DetailedItemsVC
        
        instrumentsVC.kitInfo = sender as? KitInfo
        
     }
     
    
}



