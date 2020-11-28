//
//  myCasesVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/27/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase

class myCasesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db:Firestore?
    
// caseData: an array of type Surgery that contains all the information fed in from fireStore
// look at models.swift for the definition of the Surgery type
    var caseData: [Surgery]?
    
    
    @IBOutlet weak var caseTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let caseData = caseData else { return 0 }
        
        return caseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = caseTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! caseCell
        
        guard let caseData = caseData else { return cell }

        
        cell.caseTitle.text = caseData[indexPath.row].name
        
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let caseData = caseData else { return }

        let aCase = caseData[indexPath.row]
        
        // a segue on the main storyboard. this line is passing in the Surgery case that was clicked on as a parameter to the detailed view controller
        // look in the prepare() method at the bottom to see the rest of the transition process
        performSegue(withIdentifier: "showDetailedSurgery", sender: aCase)
    }
    
    func loadData() {
        print("loading data")
        // this is just firebase stuff
        
        // accessing the surgeries_test collection from cloud firestore, and setting a snapshot listener so that this method is called whenever something new is added to the table
        db?.collection("surgeries_test").addSnapshotListener {
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
            }
        }
        
      
    }
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore.firestore()
        
        caseTable.delegate = self
        caseTable.dataSource = self
        
        loadData()
    

        // Do any additional setup after loading the view.
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
