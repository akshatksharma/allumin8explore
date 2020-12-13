//
//  accountVC.swift
//  exploreAllumin8
//
//  Created by Kathy Zhou on 12/14/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class accountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hospitalTable: UITableView!
    
    var db:Firestore?
    var hospitals:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore.firestore()
        
        // Do any additional setup after loading the view.
        navigationController?.title = "Account"
        hospitalTable.delegate = self
        hospitalTable.dataSource = self
        
        loadInfo()
    }
    
    func loadInfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.db?.collection("surgeons").document(uid) else { return }
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let surgeonInfo = document.data() else {
                    return
                }
                self.name.text = surgeonInfo["name"] as! String
                if let hospitalList = surgeonInfo["hospitals"] {
                    self.hospitals = hospitalList as! [String]
                }
            
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hospitalTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
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
