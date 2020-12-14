//
//  ConfirmationVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
//import FirebaseFirestore

protocol UpdateSpecialRequest{
    func updateSpecialRequest(requestedKit: Kit)
}

class ConfirmationVC: UIViewController, UpdateSpecialRequest {
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var procedureLabel: UILabel!
    @IBOutlet weak var surgeonNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var kitTableView: UITableView!
    @IBOutlet weak var specialRequestButton: UIButton!
    
    //    var kits:[Kit]?
    
    var surgeryInfoUpdater: SurgeryInfoUpdater?
//    var surgeryListUpdater: SurgeryListLocalUpdater?
    var id: String?
    var nextIndex: Int?
    var navController: UINavigationController?
    
    var surgeryInfo: SchedulingSurgery?
    
    var db:Firestore?
    
    var products:[Product]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let updater = surgeryInfoUpdater else {
            fatalError("no updater passed to confirmationVC")
        }
        
        surgeryInfo = updater.getCurrentInfo()
        
        //        kits = surgeryInfo?.kits
        
        hospitalLabel.text = surgeryInfo?.hospital
        procedureLabel.text = surgeryInfo?.procedure
        surgeonNameLabel.text = surgeryInfo?.surgeon_name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy h:mm a"
        
        if let date = surgeryInfo?.date?.dateValue() {
            timeLabel.text = dateFormatter.string(from: date)
        }
        
        
        
        kitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        kitTableView.dataSource = self
        kitTableView.delegate = self
        
        db = Firestore.firestore()
        
        //Firebase querying get all items in the product catalog
        let productCatalog = db?.collection("catalog")
        var products:[Product] = []
        productCatalog?.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let newProduct = try? document.data(as: Product.self) {
                        products.append(newProduct)
                    }
                }
                DispatchQueue.main.async {
                    print("fetched all catalog items")
                    self.products = products
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let kitCount = surgeryInfo?.kits?.count else {return}
        if kitCount == 2 {
            specialRequestButton.titleLabel?.text = "Edit Special Request Kit"
        } else {
            specialRequestButton.titleLabel?.text = "Add Special Request Kit"
        }
    }
    
    //FUNCTION THAT UPLOADS NEW OPERATION TO FIRESTORE
    //Pass in fully defined SchedulingSurgery Struct (tracking can just be an empty array)
    @IBAction func operationUpload(_ sender: UIButton){
        do{
            //Convert surgery into JSON object for Firebase to decode
            let operationData = try FirebaseEncoder().encode(surgeryInfo) as! [String: Any]
            
            //New ID of operation in Firestore
            var ref: DocumentReference? = nil
            ref = db?.collection("operations").addDocument(data: operationData) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
//                    UIAlertAction(title: "Scheduled Operation", style: .default, handler: nil)
                    
//                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    
                  
                    
//                    self.navigationController?.popToRootViewController(animated: false)
                    
//                    self.tabBarController?.selectedIndex = 0
                    
                    self.surgeryInfoUpdater?.postOperationPost()
                    
                }
            }
        }catch{
            fatalError("could not convert patient info to JSON")
        }
    }
    
    
    func updateSpecialRequest(requestedKit: Kit) {
        guard let numberOfNewInstruments = requestedKit.instruments?.count else {
            print("could not get number of new instruments")
            return
        }
        
        guard let numberOfKits = surgeryInfo?.kits?.count else {
            print("could not get number of kits")
            return
        }
        
        if numberOfNewInstruments > 0 && numberOfKits == 1{
            //Requested instruments not added, add Special Request kit
            surgeryInfo?.kits?.append(requestedKit)
        }else if numberOfNewInstruments == 0 {
            //No requested instruments, remove Special Request kit if it's been added
            if numberOfKits == 2{
                surgeryInfo?.kits?.popLast()
            }
        }else {

            //Non-zero number of requested intruments, special request kit already added
            surgeryInfo?.kits?[1] = requestedKit
        }
        print("updated kits =")
        guard let kits = surgeryInfo?.kits else {return}
        for kit in kits{
            print(kit)
        }
        kitTableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let patientReviewVC = segue.destination as? detailedPatientReview{
            patientReviewVC.patientInfo = surgeryInfo?.patient
        } else if let specialRequests = segue.destination as? SpecialRequestsVC {
            specialRequests.updateDelegate = self
            specialRequests.addedItems = []
            if surgeryInfo?.kits?.count == 2 {
                specialRequests.addedItems = surgeryInfo?.kits?[1].instruments
            }
        }
    }
    
    
}

extension ConfirmationVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(surgeryInfo?.kits?[indexPath.row].kit_name)")
        
        guard let detailedItemVC = UIStoryboard(name: "scheduleScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "detailedItemVC") as? DetailedItemsVC else{
                fatalError("could not create detailedItemVC")
        }
        detailedItemVC.kitInfo = surgeryInfo?.kits?[indexPath.row]
        
        self.present(detailedItemVC, animated: true, completion: nil)
    }
}

extension ConfirmationVC: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else {
            fatalError("could not find cell with reuse idenfier 'tableCell' in ConfirmationVC")
        }
        
        myCell.textLabel?.text = surgeryInfo?.kits?[indexPath.row].kit_name
        return myCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surgeryInfo?.kits?.count ?? 0
    }
}


