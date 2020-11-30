//
//  CatalogSearchVC.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class CatalogSearchVC: SchedulingItemVC {

    var collectionElements:[CatalogItem] = [
        CatalogItem(itemID: "ree1", cost: 19.99, manufacturer: "Johnson and Johnson", name: "Wet Wipes"),
        CatalogItem(itemID: "ree2", cost: 1.99, manufacturer: "Trotta's", name: "Medical Mask"),
        CatalogItem(itemID: "ree3", cost: 9.99, manufacturer: "JPMorgan", name: "Hankies")
    
        
    ]
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

extension CatalogSearchVC: UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("setting num sections")
        return collectionElements.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
           
           
           
        
           
        setUpCell(cell: cell, indexPath: indexPath)
           
        return cell
    }
           
      
       
    private func setUpCell(cell:UICollectionViewCell, indexPath:IndexPath) {
           
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        titleView.textColor = UIColor.black
        titleView.adjustsFontSizeToFitWidth = false
        titleView.lineBreakMode = .byTruncatingTail
        titleView.font = titleView.font.withSize(12)
        titleView.numberOfLines = 2
        titleView.textAlignment = .center
        titleView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        titleView.text = collectionElements[indexPath.row].name


        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        
        cell.addSubview(titleView)
    }
}

extension CatalogSearchVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let detailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedCatalogItem") as? CatalogItemDetailedVC else {
            print("couldnt get detailedCatalogItemVC")
            return;
        }
        
        print("pushing vc from collectionView")
        detailedVC.catalogItem = collectionElements[indexPath.row]
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}




