//
//  CatalogSearchVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CatalogSearchVC: UIViewController{
    

    @IBOutlet weak var searchBarCatalog: UISearchBar!
    
    @IBOutlet weak var catalogCollectionView: UICollectionView!
    
    //    var selectedCatalogItem:String? = nil
    @IBOutlet weak var collectionView:UICollectionView!
        var collectionElements:[Product] = []
    
    @IBOutlet weak var searchFilter: UISegmentedControl!
//    var db:Firestore?
    
    var products:[Product]?
    var queryResults:[Product]?
    var srkDelegate:SpecialRequestKitDelegate?
    
    required init?(coder: NSCoder){
        
        
        super.init(coder: coder)
        
        
        print("creating cvDataSource")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 10)
        
      
        layout.itemSize = CGSize(width: collectionView.bounds.width / 3, height: 40)
        
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBarCatalog.delegate = self
        
//        db = Firestore.firestore()
        
        
    }
    
    
    func searchByDescription(_ query: String){
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let productList = self?.products else {
                print("could not unwrap products")
                return
            }

            var queryResult:[Product] = []
            
            for product in productList {
                guard let desc = product.description else {
                    print("could not unwrap product.description")
                    return
                }
                if desc.contains(query){
                    queryResult.append(product)
                }
            }
            DispatchQueue.main.async {
                self?.queryResults = queryResult
                print(queryResult)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func searchByCatalogNumber(_ query: String){
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let productList = self?.products else {
                print("could not unwrap products")
                return
            }

            var queryResult:[Product] = []
            
            for product in productList {
                guard let catalog_number = product.catalog_number else {
                    print("could not unwrap product.description")
                    return
                }
                if catalog_number.contains(query){
                    queryResult.append(product)
                }
            }
            DispatchQueue.main.async {
                self?.queryResults = queryResult
                print(queryResult)
                self?.collectionView.reloadData()
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        print("item=\(selectedCatalogItem)")
        
        guard let detailedVC = segue.destination as? CatalogItemDetailedVC else{
            fatalError("Could not convert segue.destination to CatalogItemDetailedVC")
        }
        
        
        
        
        print("seguing")

        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func updateSelectedCatalogItem(element: String) {
        print("updating selected catalog item")
//        selectedCatalogItem = element
    }

}

//MARK: Extensions

//MARK: UICollectionViewDataSource
extension CatalogSearchVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard var detailedProductVC = UIStoryboard(name: "scheduleScreen", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailedProductVC") as? CatalogItemDetailedVC else{
                fatalError("could not instantiate new detailedProductVC")
        }
        detailedProductVC.catalog_item = queryResults?[indexPath.row]
        detailedProductVC.srkDelegate = srkDelegate
        present(detailedProductVC, animated: true, completion: nil)
    }
}

extension CatalogSearchVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("num of items = \(queryResults?.count ?? 0)")
        return queryResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        for subview in myCell.subviews {
            subview.removeFromSuperview()
        }
        let product_info = queryResults?[indexPath.row]
        
        myCell.backgroundColor = UIColor.green
        
        let textLabel = UILabel(frame: myCell.bounds)
        
        textLabel.text = product_info?.description
        
        myCell.addSubview(textLabel)
        
        return myCell
    }
}

//MARK: UISearchBarDelegate
extension CatalogSearchVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        
        searchBarCatalog.resignFirstResponder()
        
        if searchFilter.selectedSegmentIndex == 0 {
            searchByDescription(searchText)
        } else if searchFilter.selectedSegmentIndex == 1{
            searchByCatalogNumber(searchText)
        }
        
        
    }
}



