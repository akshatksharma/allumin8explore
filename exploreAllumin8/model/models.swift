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
    let instruments: [Product]?
    let notes: [String]?
    let patient_id: String?
    let prep_status: String?
    
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
    let special_requests: [String]?
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
    let trackingInfo: Double?
}


struct KitInfo {
    var name: String?
    var products: [Product]
}
