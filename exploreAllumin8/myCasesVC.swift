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
    var caseData: [Surgery?]?
    
    
    @IBOutlet weak var caseTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let caseData = caseData else { return 0 }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = caseTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! caseCell
        
        cell.caseTitle.text = "meow"
        
        
        return cell;
        
    }
    
    func loadData() {
        print("loading data")
        db?.collection("surgeries_test").addSnapshotListener {
            (querySnapshot, err) in
            
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            
            for document in documents {
                print("\(document.documentID) => \(document.data())")
            }

            
            self.caseData = documents.compactMap { queryDocumentSnapshot -> Surgery? in
                return try? queryDocumentSnapshot.data(as: Surgery.self)
            }
        }
        
        print(self.caseData)
    }
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore.firestore()
        
        caseTable.delegate = self
        caseTable.dataSource = self
        
        loadData()
    

        // Do any additional setup after loading the view.
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
