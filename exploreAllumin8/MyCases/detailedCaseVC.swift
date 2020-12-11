//
//  detailedCaseVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Lightbox

class detailedCaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var detailedCase:Surgery?
    var items = [DetailedViewItem]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        dump(indexPath.section)
//        dump(indexPath.row)
        let item = items[indexPath.section]
        
        print("saw item")
//        dump(item)
        
        switch item.type {
        case .caseInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "caseInfo", for: indexPath) as? DetailedCaseInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .itemInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                
                print("making surgery cell  ")
                cell.caseInfo = item
                return cell
            }
        case .statusInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .instrumentInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .surgeryImageInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "imageInfo", for: indexPath) as? SurgeryImageTableViewCell {
                cell.caseInfo = item
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.section]

        switch item.type {
        case .caseInfo:
            return
        case .itemInfo:
            guard let item = item as? SurgeryKitItem else { return }
            let kitInfo = KitInfo(name: item.kitName, products: item.surgeryItems)
    
            performSegue(withIdentifier: "showItems", sender: kitInfo )
        case .statusInfo:
            return
        case .instrumentInfo:
            return
        case .surgeryImageInfo:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func loadItems() {
        
        dump(detailedCase)
        
        if let patientId = detailedCase?.patient?.id, let caseId = detailedCase?.id, let surgeon = detailedCase?.surgeon_name, let surgeryName = detailedCase?.procedure {
            
            let caseInfoItem = CaseInfoItem(surgeryName: surgeryName, surgeon: surgeon, caseId: caseId, patientId: "\(patientId)")
            
            print("appending patientInfo to items")
            items.append(caseInfoItem)
        }
        
        if let instruments = detailedCase?.kits?[0].instruments, let procedure = detailedCase?.procedure {
            let surgeryKitItem = SurgeryKitItem(kitName: "\(procedure) Kit", surgeryItems: instruments)
            
            print("appending surgery to items")
            items.append(surgeryKitItem)
//            dump(items)
        }
        
    
        
       let images = [
        LightboxImage(image: #imageLiteral(resourceName: "sampleImg3")),
        LightboxImage(image: #imageLiteral(resourceName: "sampleImg2")),
        LightboxImage(image: #imageLiteral(resourceName: "sampleImg1"))
        
        ]
        
        
        
        let surgeryImageItem = SurgeryImagesItem(images: images)
        items.append(surgeryImageItem)
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadItems()
    }
  
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        let instrumentsNavController = segue.destination as! UINavigationController
        
        guard let instrumentsVC =  instrumentsNavController.topViewController as? DetailedItemsVC else { return }
            
        instrumentsVC.kitInfo = sender as? KitInfo
        
     }
     
    
}



