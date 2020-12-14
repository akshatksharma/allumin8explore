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
                    self.products = products
                }
            }
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func saveSpecialRequest(_ sender: UIButton){
        let specialRequestKit = Kit(instruments: addedItems, kit_name: "Special Requests")
        updateDelegate?.updateSpecialRequest(requestedKit: specialRequestKit)
        navigationController?.popViewController(animated: true)
    }
    
    func addToSpecialKit(_ newProduct: Product) {
        addedItems?.append(newProduct)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let catalogSearchVC = segue.destination as? CatalogSearchVC{
            catalogSearchVC.products = self.products
            catalogSearchVC.srkDelegate = self
        }
    }
}

extension SpecialRequestsVC: UITableViewDelegate {
    //IF HAVE TIME: On click shows details of product without add button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            addedItems?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var detailedProductVC = UIStoryboard(name: "scheduleScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailedProductVC") as? CatalogItemDetailedVC else{
                fatalError("could not instantiate new detailedProductVC")
        }
        detailedProductVC.catalog_item = addedItems?[indexPath.row]
        detailedProductVC.addDisabled = true
        
        present(detailedProductVC, animated: true, completion: nil)
    }
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
