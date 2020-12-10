//
//  File.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

struct LocalSurgeryInfo{
    var startDate: Date?
    var endDate: Date?
    var patientID: Int?
    var hospital: String?
    var procedure: String?
    var kits: [KitInfo]?
    var notes: [String]?
    var surgeon_name: String?
    //TODO: Implement the following info into the settings as well
    //    let requests: [String]
    //    let notes: [String]
    //    let photos: [Data]
    
    init(){
        self.startDate = nil
        self.endDate = nil
        self.patientID = nil
        self.hospital = nil
        self.procedure = nil

    }
    
    init(startDate: Date, endDate: Date, patientID: Int, hospital: String, procedure: String, instruments: [CatalogItem],
         implants: [CatalogItem]) {
        self.startDate = startDate
        self.endDate = endDate
        self.patientID = patientID
        self.hospital = hospital
        self.procedure = procedure
    }
    
    func updateInfo(key: String, value: Any){
        //        do {
        //            switch key{
        //            case "date":
        //                try date = value as Date
        //                break
        //            case "patientID":
        //                try patientID = value
        //                break
        //            case "hospital":
        //                try hospital = value
        //                break
        //            case "instruments":
        //                try instruments.append(value)
        //                break
        //            case "implants":
        //                try implants.append(value)
        //                break
        //            }
        //        } catch {
        //            print("error: " + error)
        //            return false
        //        }
        //        return true
        
    }
}
