//
//  SchedulingViewController.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase


protocol SurgeryInfoUpdater{
    func updateSurgeryInfo(newInfo: SchedulingSurgery, nextIndex: Int)
    func getCurrentInfo() -> SchedulingSurgery
}

class SchedulingPageController: UIPageViewController, SurgeryInfoUpdater{
    
    
    var surgeryInfo:SchedulingSurgery
    
    var db:Firestore?
    
    
    //Info needed for Surgery scheduling
    var procedureKits:[Kit]?
    var products:[Product]?
    var surgeonInfo: Surgeon?
    
    var surgeryListUpdater:SurgeryListLocalUpdater?
    
    required init?(coder: NSCoder) {
        surgeryInfo = SchedulingSurgery()
        
        super.init(coder: coder)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.db = Firestore.firestore()
        loadData()
    }
    
    func loadData() {
        // accessing the surgeries_test collection from cloud firestore, and setting a snapshot listener so that this method is called whenever something new is added to the table
        
        let userId = "wnBfdSqoyNcj537YAk9M" //TODO: UPDATE TO USER AUTHENTICATION ON LOGIN
        
        
        //Firebase querying for surgeon information
        let docRef = db?.collection("surgeons").document(userId)
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                let surgeonData = try? document.data(as: Surgeon.self)
                DispatchQueue.main.async {
                    self.surgeonInfo = surgeonData
                }
            } else {
                print("Document does not exist")
            }
        }
        
        //Firebase querying for procedure kits
        let procedureCollection = db?.collection("procedures")
        var procedureKits:[Kit] = []
        procedureCollection?.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let newKit = try? document.data(as: Kit.self) {
                        procedureKits.append(newKit)
                        
                    }
                }
                DispatchQueue.main.async {
                    self.procedureKits = procedureKits
                    
//                    DUMMY DATA FOR TESTING UPLOAD
//                    let userId = "wnBfdSqoyNcj537YAk9M" //TODO: UPDATE TO USER AUTHENTICATION ON LOGIN
//                    let testPatient = Patient(age: 20, id: 1234, name: "Evans, Ethan", sex: "M", weight: 190)
//                    let trackingInfo:[productTrackInfo] = []
//                    let testSchedulingSurgery = SchedulingSurgery(date: Timestamp(date: Date(timeIntervalSinceNow: 0)), hospital: "Habif", kits: procedureKits, notes: ["Patient is a loser"], patient: testPatient, procedure: "Spine Replacement", status: "Pending confirmation", surgeon_id: userId, surgeon_name: "Todd Sproull", tracking: trackingInfo)
//                    self.testOperationUpload()
                }
            }
        }
        
        //TEST
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
                    self.products = products
                }
            }
        }
        
    }
    
    
    //FUNCTION THAT UPLOADS NEW OPERATION TO FIRESTORE
    //Pass in fully defined SchedulingSurgery Struct (tracking can just be an empty array)
    func testOperationUpload(newOperation: SchedulingSurgery){
        do{
            //Convert surgery into JSON object for Firebase to decode
            let operationData = try FirebaseEncoder().encode(newOperation) as! [String: Any]
            
            //New ID of operation in Firestore
            var ref: DocumentReference? = nil
            ref = db?.collection("operations").addDocument(data: operationData) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }catch{
            fatalError("could not convert patient info to JSON")
        }
    }
    
    func updateSurgeryInfo(newInfo: SchedulingSurgery, nextIndex:Int) {
        print("newInfo =")
        print(newInfo)
        surgeryInfo = newInfo
        
        setViewControllers([orderedViewControllers[nextIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    func getCurrentInfo() -> SchedulingSurgery{
        return surgeryInfo
    }
    
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewController("Hospital", nextIndex: 1),
            self.newViewController("PatientID", nextIndex: 2),
            self.newViewController("Procedure", nextIndex: 3),
            self.newViewController("SurgeryDate", nextIndex: 4),
            self.newViewController("Confirmation", nextIndex: -1)]
    }()
    
    private func newViewController(_ id: String, nextIndex: Int) -> UIViewController {
        if id == "SurgeryDate"{
            guard let vc = UIStoryboard(name: "scheduleScreen", bundle: nil)
                .instantiateViewController(withIdentifier: "\(id)VC") as? SurgeryDatePickerVC else{
                    fatalError("could not set delegate of \(id)VC")
            }
            vc.surgeryInfoUpdater = self
            vc.surgeryListUpdater = surgeryListUpdater
            vc.id = id
            vc.nextIndex = nextIndex
            return vc
        }
        guard let vc = UIStoryboard(name: "scheduleScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "\(id)VC") as? SchedulingItemVC else{
                fatalError("could not set delegate of \(id)VC")
        }
        vc.surgeryInfoUpdater = self
        vc.surgeryListUpdater = surgeryListUpdater
        vc.id = id
        vc.nextIndex = nextIndex
        return vc
    }
    
}

extension SchedulingPageController:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        
        guard let vcIndex = orderedViewControllers.firstIndex(of: previousViewControllers[0]) else {
            print("could not find vc")
            return
        }
        guard let vc = orderedViewControllers[vcIndex] as? SchedulingItemVC else {
            print("could not convert to SchedulingItemVC")
            return
        }
    }
}

extension SchedulingPageController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
}
