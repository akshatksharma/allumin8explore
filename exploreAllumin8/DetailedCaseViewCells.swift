//
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/4/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Lightbox

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

class PatientInfoTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var caseInfo: DetailedViewItem? {
        didSet {
            setupCollectionView()
        }
    }
    
    var patientAsArray: [[String: String]]? {
        guard let caseInfo = caseInfo as? PatientInfoItem else { return nil }
        
        let patient = caseInfo.patient
        
        guard let id = patient.id, let name = patient.name, let age = patient.age, let sex = patient.sex, let weight = patient.weight else { return nil }
    
        return [ ["\(id)" : "\(id)"], [name : name], ["\(age)" : "\(age)"], [sex : sex], ["\(weight)" : "\(weight)"]]
      }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let patientInfo = patientAsArray  {
            return patientInfo.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let patientInfo = patientAsArray else { return UICollectionViewCell() }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "patientInfoCell", for: indexPath) as? PatientInfoCell  {
            
            let info = patientInfo[indexPath.item]
            
            for (label, value) in info {
                cell.subtitleLabel.text = label
                cell.statLabel.text = value
            }
            
            return cell
            
            
          }
        
          return UICollectionViewCell()
             
    }
    
    func setupCollectionView() {
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.reloadData()
        }
    
    
}

class PatientInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    

}




class DetailedSurgeryKitInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var caseName: UILabel!
    
    var kit: Kit? {
        didSet {
            caseName.text = kit?.kit_name
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
    var delegate: imageViewer!
    
    var caseInfo: DetailedViewItem? {
             didSet {
                  setupCollectionView()
              }
         }
    
    
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let caseInfo = caseInfo as? SurgeryImagesItem else { return }
        
        let images = caseInfo.images
        
        self.delegate.showImage(images: images, startIndex: indexPath.item)
        
        
    }
    
  
}

class SurgeryImageViewImages: UICollectionViewCell {
    
    @IBOutlet weak var surgeryImages: UIImageView!
}


protocol imageViewer {
    func showImage(images: [LightboxImage], startIndex: Int)
}
