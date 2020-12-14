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
    
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newViewController("Hospital", nextIndex: 1),
            self.newViewController("Patient", nextIndex: 2),
            self.newViewController("Procedure", nextIndex: 3),
            self.newViewController("SurgeryDate", nextIndex: 4),
            self.newViewController("Confirmation", nextIndex: -1)]
    }()
    
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
        
        let firstViewController =  UIStoryboard(name: "scheduleScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "FetchInfoVC")
        
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
       self.db = Firestore.firestore()
       loadData()
        
        
        //DEBUG
//        let userId = "wnBfdSqoyNcj537YAk9M" //TODO: UPDATE TO USER AUTHENTICATION ON LOGIN
//        let testPatient = Patient(age: 20, id: 1234, name: "Evans, Ethan", sex: "M", weight: 190)
//        let trackingInfo:[productTrackInfo] = []
//        let testSchedulingSurgery = SchedulingSurgery(date: Timestamp(date: Date(timeIntervalSinceNow: 0)), hospital: "Habif", kits: procedureKits, notes: ["Patient is a loser"], patient: testPatient, procedure: "Spine Replacement", status: "Pending confirmation", surgeon_id: userId, surgeon_name: "Todd Sproull", tracking: trackingInfo, images: [])
//        testOperationUpload(newOperation: testSchedulingSurgery)
        
 
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
                    print("fetched surgeon info")
                    self.surgeonInfo = surgeonData
                    self.finishFetchSurgeryInfo()
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
                    print("fetched procedure kits")
                    self.procedureKits = procedureKits
                    self.finishFetchSurgeryInfo()
                }
            }
        }
        
        
        
    }
    
    func finishFetchSurgeryInfo(){
        if surgeonInfo != nil && procedureKits != nil{
            print("finished fetching data, updating")
            var newSurgeryInfo = SchedulingSurgery()
            newSurgeryInfo.surgeon_id = surgeonInfo?.id
            newSurgeryInfo.surgeon_name = surgeonInfo?.name
            updateSurgeryInfo(newInfo: newSurgeryInfo, nextIndex: 0)
        }else{
            print("still waiting on data")
        }
        
    }
    
    func updateSurgeryInfo(newInfo: SchedulingSurgery, nextIndex:Int) {
        let previousProcedure = surgeryInfo.procedure
        surgeryInfo = newInfo
        
        
        if let procedure = newInfo.procedure {
            print("procedure updated")
            //Procedure is updated / set
            
            if procedure != previousProcedure {
                //Set kits[0]
                if let kits = procedureKits {
                    var newKits = newInfo.kits ?? [Kit(instruments: nil, kit_name: nil)]
                    for kit in kits{
                        if kit.kit_name == procedure {
                            newKits[0] = kit
                        }
                    }
                    print("updating surgeryInfo.kits to")
                    print(newKits)
                    surgeryInfo.kits = newKits
                }
            }
        }
        
        
        
        setViewControllers([orderedViewControllers[nextIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    func getCurrentInfo() -> SchedulingSurgery{
        return surgeryInfo
    }
    
    
    
    
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
        }else if id == "Patient"{
            guard let vc = UIStoryboard(name: "scheduleScreen", bundle: nil)
                .instantiateViewController(withIdentifier: "\(id)VC") as? patientInfoVC else{
                    fatalError("could not set delegate of \(id)VC")
            }
            vc.surgeryInfoUpdater = self
            vc.surgeryListUpdater = surgeryListUpdater
            vc.id = id
            vc.nextIndex = nextIndex
            return vc
        }else if id == "Confirmation"{
            guard let vc = UIStoryboard(name: "scheduleScreen", bundle: nil)
                .instantiateViewController(withIdentifier: "\(id)VC") as? ConfirmationVC else{
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
        
        print("id = \(id)")
        if id == "Hospital"{
            print("setting info to the following:")
            print(surgeonInfo)
            vc.info = surgeonInfo?.hospitals
            return vc
        } else if id == "Procedure" {
            guard let kits = procedureKits else {
                print("couldn't get kits")
                return vc
            }
            var kitNames:[String] = []
            for kit in kits{
                kitNames.append(kit.kit_name ?? "missing kit")
            }
            vc.info = kitNames
        }
        
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
