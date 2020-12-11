//
//  DetailedCaseInfoTableViewCell.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/4/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class DetailedCaseInfoTableViewCell: UITableViewCell {


    @IBOutlet weak var caseId: UILabel!
    @IBOutlet weak var patientId: UILabel!
    @IBOutlet weak var surgeonName: UILabel!
    
    var caseInfo: DetailedViewItem? {
        didSet {
            guard let caseInfo = caseInfo as? CaseInfoItem else { return }
            
            guard let truncatedCaseId = caseInfo.caseId?[0..<7], let truncatedPatientId = caseInfo.patientId?[0..<7]  else { return }
            
            caseId.text = truncatedCaseId
            patientId.text = truncatedPatientId
            surgeonName.text = caseInfo.surgeon
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DetailedSurgeryKitInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var caseName: UILabel!
    
    var caseInfo: DetailedViewItem? {
        didSet {
            guard let caseInfo = caseInfo as? SurgeryKitItem else {
                print("failed convert")
                return
            }
            caseName.text = caseInfo.kitName
        }
    }

    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
}

class InstrumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var instrumentTitle: UILabel!
    @IBOutlet weak var instrumentItems: UILabel!
    @IBOutlet weak var catalogNumber: UILabel!
    
    var caseInfo: DetailedViewItem? {
        didSet {
            guard let caseInfo = caseInfo as? InstrumentItem else {
                print("failed convert")
                return
            }
            
            guard let instNum = caseInfo.InstrumentNum else { return  }
            
            instrumentTitle.text = caseInfo.InstrumentName
            instrumentItems.text = "x\(instNum)"
            catalogNumber.text = caseInfo.catalogNum
            
            
            
        }
    }
    
}

class SurgeryImageTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
     }
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let caseInfo = caseInfo as? SurgeryImagesItem {
            return caseInfo.images.count
        }
        
        return 0
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let caseInfo = caseInfo as? SurgeryImagesItem else { return UICollectionViewCell() }
         
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? SurgeryImageViewImages else { return UICollectionViewCell() }
        
        let image = caseInfo.images[indexPath.item].image
        
        cell.surgeryImages.image = image
        
        return cell
     }
    
    var caseInfo: DetailedViewItem? {
           didSet {
            
            setupCollectionView()
            
//            guard let caseInfo = caseInfo as? SurgeryImagesItem else {
//                         print("failed convert")
//                         return
//                }
            }
       }
    
    
 
}

class SurgeryImageViewImages: UICollectionViewCell {
    
    @IBOutlet weak var surgeryImages: UIImageView!
    
}

