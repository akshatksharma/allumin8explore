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
    
    @IBOutlet weak var collectionView:UICollectionView!
        var collectionElements:[Product] = []
    
    @IBOutlet weak var searchFilter: UISegmentedControl!
    
    var products:[Product]?
    var queryResults:[Product]?
    var srkDelegate:SpecialRequestKitDelegate?
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
      
        layout.itemSize = CGSize(width: collectionView.bounds.width / 3, height: 40)
        
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBarCatalog.delegate = self
        
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
                self?.collectionView.reloadData()
            }
        }
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
        return queryResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        for subview in myCell.subviews {
            subview.removeFromSuperview()
        }
        let product_info = queryResults?[indexPath.row]
        
        myCell.backgroundColor = UIColor.white
        let aspectRatio = collectionView.bounds.width/2 - 5
        myCell.frame.size = CGSize(width: aspectRatio, height: aspectRatio / 1.5)
        
        var frameRect = CGRect(x: 0, y: 0, width: myCell.bounds.width, height: 24)
        
        let catalogNumberLabel = UILabel(frame: frameRect) //Font-size = 13
        
        
     
        frameRect.origin.y = myCell.bounds.maxY/2
        
        
        
        
        let descLabel = UILabel(frame: frameRect) //Font-size = 24
        
        frameRect.origin.y = myCell.bounds.maxY - 20
        
        let quantityLabel = UILabel(frame: frameRect)
     
        myCell.backgroundColor = UIColor.systemGray
        
        descLabel.text = product_info?.description
        descLabel.font = UIFont(name: "System", size: 24)
        
        catalogNumberLabel.text = product_info?.catalog_number
        catalogNumberLabel.font = UIFont(name: "System", size: 13)
        
        quantityLabel.text = "\((product_info?.quantity)!)x"
        quantityLabel.font = UIFont(name: "System Bold", size: 18)
        
        myCell.addSubview(catalogNumberLabel)
        myCell.addSubview(descLabel)
        myCell.addSubview(quantityLabel)
             
//        descLabel.centerYAnchor.constraint(equalTo: myCell.safeAreaLayoutGuide.bottomAnchor)
//        let descConstraints = [
//            descLabel.centerYAnchor.constraint(equalTo: myCell.centerYAnchor)
//        ]
//        NSLayoutConstraint.activate(descConstraints)
//        let centerConstrant = NSLayoutConstraint(item: descLabel, attribute: .centerY, relatedBy: .equal, toItem: myCell, attribute: .centerY, multiplier: 1, constant: 0)
//        descLabel.leadingAnchor.constraint(equalTo: myCell.safeAreaLayoutGuide.leadingAnchor, constant: 10)
//        descLabel.widthAnchor.constraint(equal)
//        NSLayoutConstraint.activate([centerConstrant])
//        let quantityLabel = UILabel(frame: frameRect) //Font-size: 18 bold
        
        
//
        
        
//        myCell.addSubview(catalogNumberLabel)
        
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



