//
//  DetailedItemsVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/5/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class DetailedItemsVC: UIViewController, UITableViewDataSource {

    
    var kitInfo: KitInfo?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kitName: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let instruments = kitInfo?.products else { return 0 }
        
        print(instruments)
        return instruments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let instruments = kitInfo?.products else { return UITableViewCell() }
        
        let instrument = instruments[indexPath.row]
        
        guard let instrumentName = instrument.description, let instrumentCatNum = instrument.catalog_number, let instrumentNum = instrument.quantity?.toInt() else {return UITableViewCell()}
        
        
        
        let instrumentItem = InstrumentItem( InstrumentName: instrumentName, catalogNum: instrumentCatNum, InstrumentNum: "\(instrumentNum)")
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "instrumentInfo", for: indexPath) as? InstrumentTableViewCell {
            
            cell.caseInfo = instrumentItem
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Instruments"

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        kitName.text = kitInfo?.name
        

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
