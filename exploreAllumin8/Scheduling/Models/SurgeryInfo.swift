//
//  SurgeryInfo.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

/*
 self.newColoredViewController("SurgeryDate"),
 self.newColoredViewController("PatientID"),
 self.newColoredViewController("Hospital"),
 self.newColoredViewController("Procedure"),
 self.newColoredViewController("Instruments"),
 self.newColoredViewController("Implants"),
 self.newColoredViewController("Requests"),
 self.newColoredViewController("Notes"),
 self.newColoredViewController("Photo"),
 self.newColoredViewController("Confirmation")]
 */

struct SurgeryInfo: Codable {
    let date: Date
    let patientID: Int
    let hospital: String
    let procedure: String
    let instruments: [CatalogItem]
    let implants: [CatalogItem]
    //TODO: Implement the following info into the settings as well
//    let requests: [String]
//    let notes: [String]
//    let photos: [Data]
    
    enum CodingKeys:String, CodingKey {
        case date, patientID, hospital, procedure, instruments, implants
    }
    

    init(date: Date, patientID: Int, hospital: String, procedure: String, instruments: [CatalogItem],
         implants: [CatalogItem]) {
        self.date = date
        self.patientID = patientID
        self.hospital = hospital
        self.procedure = procedure
        self.instruments = instruments
        self.implants = implants
    }
    
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(patientID, forKey: .patientID)
        try container.encode(hospital, forKey: .hospital)
        try container.encode(procedure, forKey: .procedure)
        try container.encode(instruments, forKey: .instruments)
        try container.encode(implants, forKey: .implants)
    }
    
    init (from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(Date.self, forKey: .date)
        patientID = try container.decode(Int.self, forKey: .patientID)
        hospital = try container.decode(String.self, forKey: .hospital)
        procedure = try container.decode(String.self, forKey: .procedure)
        instruments = try container.decode([CatalogItem].self, forKey: .instruments)
        implants = try container.decode([CatalogItem].self, forKey: .implants)
    }
    

}
