//
//  myCasesVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/27/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase
import FSCalendar
import FirebaseAuth

protocol CasesUpdater {
}

class myCasesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    var db:Firestore?
//    var calendar:FSCalendar?
    
// caseData: an array of type Surgery that contains all the information fed in from fireStore
// look at models.swift for the definition of the Surgery type
    var caseData: [Surgery]?
 
    @IBOutlet weak var switchView: UISegmentedControl!
    
    @IBOutlet weak var caseTable: UITableView!
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarTable: UITableView!
    
    let formatter = DateFormatter()
    var dateSelected:Date = Date()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let caseData = caseData else { return 0 }

        if tableView === caseTable{
            return caseData.count
        }
        else{
            let surgeries = surgeryOnDay(date: dateSelected)
            return surgeries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // caseTable
        if tableView === caseTable{
            let cell = caseTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! caseCell
            
            guard let caseData = caseData else { return cell }

            
            cell.caseTitle.text = caseData[indexPath.row].procedure
            
            
            return cell;
        }
            
        // calendarTable
        else{
            let cell = calendarTable.dequeueReusableCell(withIdentifier: "cal", for: indexPath) as! calCell
            let surgeries = surgeryOnDay(date: dateSelected)
            
            // set surgeryName label
            cell.surgeryName.text =  surgeries[indexPath.row].procedure
            
            // set time label
            
            formatter.dateFormat = "HH:ss"
            guard let timestampToDate = surgeries[indexPath.row].date?.dateValue() else{
                cell.time.text = "00:00"
                return cell
            }
            let time = formatter.string(from: timestampToDate)
            cell.time.text = time
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var aCase:Surgery
        
        // caseTable
        if tableView === caseTable {
            guard let caseData = caseData else { return }

             aCase = caseData[indexPath.row]
        }
            
        // calendarTable
        else {
            let surgeries = surgeryOnDay(date: dateSelected)
            aCase = surgeries[indexPath.row]
        }
        
        // a segue on the main storyboard. this line is passing in the Surgery case that was clicked on as a parameter to the detailed view controller
        // look in the prepare() method at the bottom to see the rest of the transition process
        performSegue(withIdentifier: "showDetailedSurgery", sender: aCase)
    }
    
    
        
    func loadData() {
        print("loading data")
        // this is just firebase stuff
        
        // accessing the surgeries_test collection from cloud firestore, and setting a snapshot listener so that this method is called whenever something new is added to the table
        
        let userId = Auth.auth().currentUser?.uid
//        let userId = "wnBfdSqoyNcj537YAk9M"
        
        db?.collection("operations").whereField("surgeon_id", isEqualTo: userId).addSnapshotListener {
            (querySnapshot, err) in
            
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            

            
            // mapping all of the data from the surgeries_test table to an array of objects of type Surgery
            self.caseData = documents.compactMap { queryDocumentSnapshot -> Surgery? in
                return try? queryDocumentSnapshot.data(as: Surgery.self)
                
            }

            // calling the reloadData on the main method so it happens on time
            DispatchQueue.main.async {
                
                self.caseTable.reloadData()
                self.calendar.reloadData()
                self.calendarTable.reloadData()
            }
        }
      

    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        dateSelected = date
        calendarTable.reloadData()
        
    }
        
    
  // display dots on calendar on days where there are surgeries
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let surgeries = surgeryOnDay(date: date)
        if surgeries.count > 0 {
            return 1
        }
        return 0
    }
    
    // takes in a date, appends all the surgeries on the given date to an array
    func surgeryOnDay(date:Date) -> [Surgery]{
        
        var surgeries:[Surgery] = []
        guard let caseData = caseData else { return[] }
        
        formatter.dateFormat = "MM/dd/yyyy"

        for surgery in caseData{
            
            // convert timestamp from database to type Date
            guard let timestampToDate = surgery.date?.dateValue() else { return []
            }
            
            // convert type Date to string
            let dateString = formatter.string(from: timestampToDate)
            
            // converts the string to type Date with "MM/dd/yyyy" format
            guard let surgeryDate = formatter.date(from: dateString) else{
                return []
            }
            if date == surgeryDate {
                surgeries.append(surgery)
            }
        }
        return surgeries
    }

    
    // toggle between calendar view and table view of cases - switches between hiding and displaying the views
    @IBAction func flipSwitch(_ sender: Any) {
        switch switchView.selectedSegmentIndex {
        case 0:
            caseTable.isHidden = false
            calendar?.isHidden = true
            calendarTable.isHidden = true
        case 1:
            caseTable.isHidden = true
            calendar?.isHidden = false
            calendarTable.isHidden = false
        default:
            break
        }
    }
    
    // sign out adapted from Firebase documentation: https://firebase.google.com/docs/auth/web/password-auth
    

    
    @IBAction func seeAccount(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "account")
        
        
        
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore.firestore()
        self.title = "My Cases"
        
        caseTable.delegate = self
        caseTable.dataSource = self
                
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "calCell")
        calendarTable.delegate = self
        calendarTable.dataSource = self
        calendarTable.isHidden = true
        calendar.isHidden = true
        


        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // casting the segue to the detailed ViewController I made so that I can access and set the currentCase info to a parameter on that VC
        let detailedVC = segue.destination as! detailedCaseVC
        
        detailedVC.detailedCase = sender as? Surgery
        
    }


}
