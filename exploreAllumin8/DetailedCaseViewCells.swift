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
            
            instrumentTitle.text = caseInfo.InstrumentName
            instrumentItems.text = caseInfo.InstrumentNum
            catalogNumber.text = caseInfo.catalogNum
            
            
            
        }
    }
    
}
