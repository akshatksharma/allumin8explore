//
//  detailedCaseVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Lightbox

class detailedCaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, imageViewer {
    
    
    @IBOutlet weak var tableView: UITableView!
    let imagePicker = UIImagePickerController()
    var images = [LightboxImage]()
    var detailedCase:Surgery?
    var items = [DetailedViewItem]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.section]
        
        switch item.type {
        case .caseInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "caseInfo", for: indexPath) as? DetailedCaseInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .patientInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "patientInfo", for: indexPath) as? PatientInfoTableViewCell {
                cell.caseInfo = item
                return cell
            }
        case .itemInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                
                print("making surgery cell  ")
                guard let surgeryItem = item as? SurgeryKitItem else {
                    print("failed convert")
                    return cell
                }
                
                let kit = surgeryItem.kits[indexPath.row]
                cell.kit = kit
                //               cell.caseInfo = item
                return cell
            }
            //        case .statusInfo:
            //            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
            //                cell.caseInfo = item
            //                return cell
        //            }
        case .instrumentInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as? DetailedSurgeryKitInfoTableViewCell {
                return cell
            }
        case .surgeryImageInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "imageInfo", for: indexPath) as? SurgeryImageTableViewCell {
                cell.caseInfo = item
                cell.delegate = self
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
            guard let surgeryItem = item as? SurgeryKitItem else { return }
            let kit = surgeryItem.kits[indexPath.row]
            let kitInfo = kit
            performSegue(withIdentifier: "showItems", sender: kitInfo )
            //        case .statusInfo:
        //            return
        case .instrumentInfo:
            return
        case .surgeryImageInfo:
            return
        case .patientInfo:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func loadItems() {
        
        items.removeAll()
        
        if let patientId = detailedCase?.patient?.id, let caseId = detailedCase?.id, let surgeon = detailedCase?.surgeon_name, let surgeryName = detailedCase?.procedure {
            
            let caseInfoItem = CaseInfoItem(surgeryName: surgeryName, surgeon: surgeon, caseId: caseId, patientId: "\(patientId)")
            
            print("appending caseInfo to items")
            items.append(caseInfoItem)
        }
        
        if let patient = detailedCase?.patient {
            
            let patientInfoItem = PatientInfoItem(patient: patient)
            print("appending patientInfo to items")
            items.append(patientInfoItem)
        }
        
        
        if let kits = detailedCase?.kits {
            let surgeryKitItem = SurgeryKitItem(kits: kits)
            print("appending surgery to items")
            items.append(surgeryKitItem)
        }
        
        let surgeryImageItem = SurgeryImagesItem(images: images)
        items.append(surgeryImageItem)
        
        self.tableView.reloadData()
        
    }
    
    
    
    @IBAction func addImage(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Choose an image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        //        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("am hereee")
        
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("f")
            
            return
            
        }
        
        let lightboxImage = LightboxImage(image: chosenImage)
        
        images.append(lightboxImage)
        
        dump(images)
        
        DispatchQueue.main.async {
            self.loadItems()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func showImage(images: [LightboxImage], startIndex: Int) {
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images, startIndex: startIndex)
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        imagePicker.delegate = self
        loadItems()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let instrumentsNavController = segue.destination as! UINavigationController
        
        guard let instrumentsVC =  instrumentsNavController.topViewController as? DetailedItemsVC else { return }
        
        instrumentsVC.kitInfo = sender as? Kit
        
    }
    
    
}



