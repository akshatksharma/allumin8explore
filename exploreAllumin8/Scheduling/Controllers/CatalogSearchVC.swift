//
//  CatalogSearchVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class CatalogSearchVC: SchedulingItemVC, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = UICollectionViewCell()
        return myCell
    }
    

    var collectionElements:[CatalogItem] = [
        CatalogItem(itemID: "ree1", cost: 19.99, manufacturer: "Johnson and Johnson", name: "Wet Wipes"),
        CatalogItem(itemID: "ree2", cost: 1.99, manufacturer: "Trotta's", name: "Medical Mask"),
        CatalogItem(itemID: "ree3", cost: 9.99, manufacturer: "JPMorgan", name: "Hankies")
    
        
    ]
    @IBOutlet weak var searchBarCatalog: UISearchBar!
    
    @IBOutlet weak var catalogCollectionView: UICollectionView!
    
    //    var selectedCatalogItem:String? = nil
    @IBOutlet weak var collectionView:UICollectionView!
    
    
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






