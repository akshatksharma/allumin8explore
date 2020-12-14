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
    
    var db:Firestore?
    var hospitals:[String] = []
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hospitalTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore.firestore()
        
        // Do any additional setup after loading the view.
        navigationController?.title = "Account"
        hospitalTable.delegate = self
        hospitalTable.dataSource = self
        
        loadInfo()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        // display login page if user successfully signed out
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Auth.auth().currentUser == nil{
            print("no user")
            guard let login = storyboard.instantiateViewController(identifier: "loginRegister") as? UINavigationController else{
                print("error")
                return
            }
            view.window?.rootViewController = login
            view.window?.makeKeyAndVisible()
        }
    }
    
    func loadInfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.db?.collection("surgeons").document(uid) else { return }
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let surgeonInfo = document.data() else {
                    return
                }
                
                self.name.text = surgeonInfo["name"] as? String
                
                if let hospitalList = surgeonInfo["hospitals"] {
                    self.hospitals = hospitalList as! [String]
                }
                
                DispatchQueue.main.async {
                    self.hospitalTable.reloadData()
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
        if let cell = hospitalTable.dequeueReusableCell(withIdentifier: "hospitalCell", for: indexPath) as? hospitalCell {
            
            cell.hospitalNameLabel.text = hospitals[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hospitals"
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
