//
//  CollectionViewDataSource.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class CVDataSource:NSObject, UICollectionViewDataSource {
    var collectionElements:[String]
    
    
    init( elements:[String]){
        self.collectionElements = elements;
//        self.selectedElementCallback = passSelectedElement

        
//        UIStoryboard(name: "Main", bundle: nil).instantiateNavigationCont
    }
    
    func updateData(with elements:[String]){
        self.collectionElements = elements;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        
        
        let testFrame = CGRect(x: 20, y: 20, width: 80, height: 60)
        
        cell.frame = testFrame
        
        setUpCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
        
   
    
    private func setUpCell(cell:UICollectionViewCell, indexPath:IndexPath) {
        
        let titleView = UILabel(frame: CGRect(x: 0, y: 4*cell.bounds.height/5, width: cell.bounds.width, height: cell.bounds.height/5))
        titleView.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        titleView.textColor = UIColor.black
        titleView.adjustsFontSizeToFitWidth = false
        titleView.lineBreakMode = .byTruncatingTail
        titleView.font = titleView.font.withSize(12)
        titleView.numberOfLines = 2
        titleView.textAlignment = .center
        titleView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        titleView.text = collectionElements[indexPath.row]


        cell.addSubview(titleView)
    }
}

extension CVDataSource: UICollectionViewDelegate{
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
            
    //        let movieDetailVC = MovieDetailViewController(movieInfo: movieData[indexPath.row], imageData: movieImages[indexPath.row], favorites: [])
        
        print("clicked on cv element in CVDataSource")
        

        
            //print(navigationController)
        
//            navController?.pushViewController(elementDetailVC, animated: true)
        
               //
            //self.presentViewController(navigationController?, animated: true, completion: nil)

        }
}
