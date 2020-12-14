//
//  addHospitalVC.swift
//  exploreAllumin8
//
//  Created by Kathy Zhou on 12/13/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase
import FirebaseAuth
class addHospitalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hospitalTable: UITableView!
    var hospitals:[String] = []
    
    var db:Firestore?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hospitals == []{
            return 0
        }
        return hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hospitalTable.dequeueReusableCell(withIdentifier: "hospital", for: indexPath) as! hospitalCell
        cell.hospitalNameLabel.text = hospitals[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        hospitalTable.delegate = self
        hospitalTable.dataSource = self
        
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true,animated:animated)
    }
    
    @IBAction func add(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add Hospital", message: "", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            guard let input = addAlert.textFields?[0].text else {
                return
            }
            self.hospitals.append(input)
            self.hospitalTable.reloadData()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlert.addTextField(configurationHandler: nil)
        addAlert.addAction(save)
        addAlert.addAction(cancel)
        
        self.present(addAlert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any){
        let home = storyboard?.instantiateViewController(identifier: "userHome") as? UITabBarController
        guard let documentID = Auth.auth().currentUser?.uid else {
            print("couldn't get documentID from surgeryInfo")
            return
        }
        
        
        
        let hospitalData = try? FirebaseEncoder().encode(hospitals) as Any
        
        db?.collection("surgeons").document(documentID).updateData([
            "hospitals": hospitalData
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Hospitals successfully written!")
            }
        }
        
        view.window?.rootViewController = home
        view.window?.makeKeyAndVisible()
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
