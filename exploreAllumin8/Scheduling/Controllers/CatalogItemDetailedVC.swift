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
    @IBOutlet weak var addButton: UIButton!
    
    var srkDelegate:SpecialRequestKitDelegate?
    var addDisabled:Bool = false
    
    @IBAction func addItemToKit(_ sender: Any) {
        print("adding to kit")
        
        guard let newProduct = catalog_item else {
            fatalError("could not unwrap catalog_item")
        }
        srkDelegate?.addToSpecialKit(newProduct)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.isHidden = addDisabled
        
        productDescLabel.text = catalog_item?.description
        productNumberLabel.text = catalog_item?.catalog_number
        
        if let quantity = catalog_item?.quantity{
            productQuantityLabel.text = "\(quantity)"
        }
    }
    

}
