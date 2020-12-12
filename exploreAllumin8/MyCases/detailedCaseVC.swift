//
//  detailedCaseVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import Lightbox
import PopupDialog
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CodableFirebase



class detailedCaseVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, imageViewer {
    
    
    @IBOutlet weak var tableView: UITableView!
    let imagePicker = UIImagePickerController()
    var images = [LightboxImage]()
    var detailedCase:Surgery?
    var items = [DetailedViewItem]()
    var db:Firestore?
    
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
                return cell
            }
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
        
        if let surgeryName = detailedCase?.procedure, let surgeon = detailedCase?.surgeon_name, let date = detailedCase?.date, let hospital = detailedCase?.hospital {
            
            let caseInfoItem = CaseInfoItem(surgeryName: surgeryName, surgeon: surgeon, date: date, hospital: hospital)
            
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
        
        // this function sets up the dialogs to open the photo library
        // there is an option to open the Camera, but this will crash on the simulator
        // i commented out the if statement to hide the camera if not availible, but i thought it would be good to have the camera option shown in the video, even if we don't click on it
        
        // calls the function below when done
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // called after the user has picked an image
        // chosenImage: UIImage -- the image the user chose
        
        // this function then summons the custom modal that allows the user to caption the image
        
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        dismiss(animated: true, completion: nil)
        
        showCaptionModal(chosenImage)
    }
    
    func showCaptionModal(_ image: UIImage) {
        
        // this function sets up a modal/popup that allows the user to make their own caption
        
        // setting up styles and view
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.blurEnabled = false
        overlayAppearance.opacity = 0.3
        
        let captionVC = AddCaptionVC(nibName: "AddCaptionVC", bundle: nil)
        
        // making the popup itself
        
        let popup = PopupDialog(viewController: captionVC, buttonAlignment: .horizontal)
        
        guard let customView = popup.viewController as? AddCaptionVC else {
            print("could not get customVIew")
            return
        }
        
        guard let progressBar = customView.progressBar else {
            print("could not get progress bar")
            return
        }
        
        // defining buttons and callback functions
        
        
        let addButton = DefaultButton(title: "Add", height: 60, dismissOnTap: false) {
            
            /*
             ************
             this is where the image and caption will be accessible and able to be stored in firebase
             ************
             
             image: UIImage -- parameter to this function
             caption: String? -- variable in this closure (right below this comment)
             */
            
            let randomID = UUID.init().uuidString
            let newImagePath = "images/\(randomID).jpeg"
            let uploadRef = Storage.storage().reference(withPath: newImagePath)
            guard let imageData = image.pngData() else {
                print("image could not be converted to jpeg")
                return
            }
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            
            let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
                if let error = error{
                    print("ERROR:\(error.localizedDescription)")
                    return
                }
                print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            }
            
            progressBar.isHidden = false;
            
            taskReference.observe(.progress) {[weak self] (snapshot) in
                guard let pctThere = snapshot.progress?.fractionCompleted else {
                    print("upload progress not defined")
                    return
                }
                print("You are \(pctThere) complete")
                progressBar.progress = Float(pctThere)
            }
            
            taskReference.observe(.success){[weak self] (snapshot) in
                let caption = customView.captionText.text
                print("uploaded image, updating operation")
                //Update surgery with new Image struct
                guard let surgeryInfo = self?.detailedCase else {
                    print("couldn't get documentID for detailedCase")
                    return
                }
                
                guard let db = self?.db else {
                    print("couldn't get firebase databse in detaliedCaseVC")
                    return
                }
                //TO-DO: appending to copy of list, need to update list
                guard var images = self?.detailedCase?.images else {
                    print("couldn't get images from surgeryInfo")
                    return
                }
                
                let newImage = SurgeryImage(image_path: newImagePath, comment: caption)
                
                images.append(newImage)
                
                guard let documentID = self?.detailedCase?.id else {
                    print("couldn't get documentID from surgeryInfo")
                    return
                }
                
                
                let imagesData = try? FirebaseEncoder().encode(images)
                
                db.collection("operations").document(documentID).updateData([
                    "images": imagesData
                    
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
                let lightboxImage = LightboxImage(image: image, text:caption ?? "")
                
                self?.images.append(lightboxImage)
                print("dimissing modal")
                self?.dismiss(animated: true, completion: nil)
                DispatchQueue.main.async {
                    self?.detailedCase?.images = images
                    self?.loadItems()
                }
            }
            
            taskReference.observe(.failure){[weak self] (snapshot) in
                print("upload failed")
                // Create new Alert
                var dialogMessage = UIAlertController(title: "Upload failed", message: "Could not upload image to case", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self?.present(dialogMessage, animated: true, completion: nil)
            }
        }
        
        
        
        let cancelButton = CancelButton(title: "Cancel", height: 60) { return }
        
        // adding buttons to popup
        
        popup.addButtons([addButton, cancelButton])
        
        // adding image to popup
        
        customView.imageView.image = image
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func fetchImages(){
        let storage = Storage.storage()
        
        guard let imagesInfo = detailedCase?.images else {
            print("detailedCase.images not defined")
            return
        }
        
        for imageInfo in imagesInfo {
            DispatchQueue.global(qos: .userInitiated).async  {
                print("dispatched queue to get image with path \(imageInfo.image_path)")
                let imageRef = storage.reference(withPath: imageInfo.image_path)
                imageRef.getData(maxSize: 32 * 1024 * 1024, completion: {[weak self] (data, error) in
                    if let error = error{
                        print("ERROR: \(error.localizedDescription)")
                    }
                    if let data = data{
                        guard let newImage = UIImage(data: data) else {
                            print("cannot create new image from data")
                            return
                        }
                        let newLightboxImage = LightboxImage(image: newImage, text: imageInfo.comment ?? "")
                        DispatchQueue.main.async {[weak self] in
                            print("appending image to images")
                            self?.images.append(newLightboxImage)
                            self?.loadItems()
                        }
                    }
                })
            }
        }
        
    }
    
    
    
    func showImage(images: [LightboxImage], startIndex: Int) {
        
        // handles showing the image gallery when an image is clicked
        
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
        
        self.db = Firestore.firestore()
        fetchImages()
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



