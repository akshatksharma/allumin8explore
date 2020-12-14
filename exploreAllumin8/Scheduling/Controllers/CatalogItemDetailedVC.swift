//
//  CatalogItemDetailedViewController.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class CatalogItemDetailedVC: UIViewController {

    var catalog_item:Product?
    
    @IBOutlet weak var productNumberLabel: UILabel!
    @IBOutlet weak var productDescLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!

    
    var srkDelegate:SpecialRequestKitDelegate?
    
    
    @IBAction func addItemToKit(_ sender: Any) {
        print("adding to kit")
        
        guard let newProduct = catalog_item else {
            fatalError("could not unwrap catalog_item")
        }
        srkDelegate?.addToSpecialKit(newProduct)
        dismiss(animated: true, completion: nil)
        
    }
    
    
//    init(catalogItem:CatalogItem){
//        self.catalogItem = catalogItem
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print("made new vc from seque")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDescLabel.text = catalog_item?.description
        productNumberLabel.text = catalog_item?.catalog_number
        
        if let quantity = catalog_item?.quantity{
            productQuantityLabel.text = "\(quantity)"
        }
        
        
        
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
