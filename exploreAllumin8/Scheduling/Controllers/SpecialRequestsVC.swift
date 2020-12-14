//
//  SpecialRequestsVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 12/13/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Firebase

protocol SpecialRequestKitDelegate{
    func addToSpecialKit(_ newProduct: Product)
}

class SpecialRequestsVC: UIViewController, SpecialRequestKitDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products:[Product]?
    var db:Firestore?
    var addedItems:[Product]?
    var updateDelegate: UpdateSpecialRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        addedItems = []
        
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func saveSpecialRequest(_ sender: UIButton){
//        addedItems?.append(Product(catalog_number: "1.2.3.4", description: "Bell", quantity: 1))
        let specialRequestKit = Kit(instruments: addedItems, kit_name: "Special Requests")
        updateDelegate?.updateSpecialRequest(requestedKit: specialRequestKit)
        navigationController?.popViewController(animated: true)
    }
    
    func addToSpecialKit(_ newProduct: Product) {
        addedItems?.append(newProduct)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing to segue")
        if let catalogSearchVC = segue.destination as? CatalogSearchVC{
            print("seguing to catalog search")
            catalogSearchVC.products = self.products
            catalogSearchVC.srkDelegate = self
        }
    }
}

extension SpecialRequestsVC: UITableViewDelegate {
    //IF HAVE TIME: On click shows details of product without add button
}

extension SpecialRequestsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else{
            fatalError("could not dequeue tableCell for special requests")
        }
        cell.textLabel?.text = addedItems?[indexPath.row].description
        return cell
    }
    
    
}
