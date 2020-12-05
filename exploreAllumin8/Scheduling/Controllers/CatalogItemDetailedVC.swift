//
//  CatalogItemDetailedViewController.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/28/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class CatalogItemDetailedVC: UIViewController {

    var catalogItem:CatalogItem?
    
    @IBOutlet weak var itemLabel: UILabel!
    

    @IBAction func addItemToKit(_ sender: Any) {
    }
    init(catalogItem:CatalogItem){
        self.catalogItem = catalogItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.catalogItem = nil
        super.init(coder: coder)
        
        print("made new vc from seque")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
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
