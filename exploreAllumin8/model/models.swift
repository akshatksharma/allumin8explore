//
//  case.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/27/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum PrepStatusEnum {
    case scheduled, confirmed, itemsShipped, itemsRecieved, noStatus
}


struct Surgery: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var date: Timestamp?
    let hospital: String?
    let kits: [Kit]?
    let notes: [String]?
    let patient: Patient?
    let procedure: String?
    let status: String?
    let suregon_id: String?
    let surgeon_name: String?
    var images: [SurgeryImage]?
    let tracking: [productTrackInfo]?
}

struct SchedulingSurgery: Codable{
    var date: Timestamp?
    var hospital: String?
    var kits: [Kit]?
    var notes: [String]?
    var patient: Patient?
    var procedure: String?
    var status: String?
    var surgeon_id: String?
    var surgeon_name: String?
    var images: [SurgeryImage]?
    var tracking: [productTrackInfo]?
    
    
    init(date: Timestamp?, hospital: String?, kits: [Kit]?, notes: [String]?, patient: Patient?, procedure: String?, status: String?,
         surgeon_id: String?, surgeon_name: String?, tracking: [productTrackInfo]?, images: [SurgeryImage]?){
        self.date = date
        self.hospital = hospital
        self.kits = kits
        self.notes = notes
        self.patient = patient
        self.procedure = procedure
        self.status = status
        self.surgeon_id = surgeon_id
        self.surgeon_name = surgeon_name
        self.tracking = tracking
        self.images = images
    }
    
    init(){
        self.date = nil
        self.hospital = nil
        self.kits = nil
        self.notes = nil
        self.patient = nil
        self.procedure = nil
        self.status = nil
        self.surgeon_id = nil
        self.surgeon_name = nil
        self.tracking = []
        self.images = []
    }
}

struct SurgeryImage: Codable {
    var image_path: String
    var comment: String?
}

struct Surgeon: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String?
    var hospitals: [String]?
}


struct Product: Codable {
    let catalog_number: String?
    let description: String?
    let quantity: Double?
}

struct productTrackInfo: Codable {
    let order_id: String?
    let status: String?
    let tracking_number: Double?
}

struct Patient: Codable {
    let age: Double?
    let id: Double?
    let name: String?
    let sex: String?
    let weight: Double?
}

struct Kit: Codable {
    let instruments: [Product]?
    let kit_name: String?
}


struct KitInfo {
    var name: String?
    var products: [Product]
}
