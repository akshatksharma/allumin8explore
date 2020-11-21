//
//  ViewController.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/20/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var db:Firestore?
    
    override func viewDidLoad() {
        self.db = Firestore.firestore()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func insert(_ sender: Any) {
        addToDb()
    }
    
    
    @IBAction func read(_ sender: Any) {
        readFromDb()
    }
    
    
    func readFromDb() {
        self.db?.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func addToDb() {
        
        var ref: DocumentReference? = nil
        ref = self.db?.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
}

