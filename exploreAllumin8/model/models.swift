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


struct Surgery: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var date: Timestamp?
    
    let hospital: String?
    let name: String?
    let patient_id: Double?
    let surgeon: String?
    let instruments: [Product]?
    let implants: [Product]?
}


struct Product: Codable {
    let id: Double?
    let cost: Double?
    let manufacturer: String?
    let name: String?
    let status: String?
}
