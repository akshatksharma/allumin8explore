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
    let prep_status: String?
    let patient: Patient?
//    var prep_status_enum: PrepStatusEnum {
//        switch prep_status {
//        case "Scheduled":
//            return .scheduled
//        case "Confirmed":
//            return .confirmed
//        case "Items Shipped":
//            return .itemsShipped
//        case "Items Recieved":
//            return .itemsRecieved
//        default:
//            return .noStatus
//        }
//    }
    
    let procedure: String?
    let status: String?
    let suregon_id: String?
    let surgeon_name: String?
    let tracking: [productTrackInfo]?
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
    let weight: Double
}

struct Kit: Codable {
    let instruments: [Product]?
    let kit_name: String?
}


struct KitInfo {
    var name: String?
    var products: [Product]
}
