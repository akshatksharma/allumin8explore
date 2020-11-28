//
//  case.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 11/27/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift


struct Surgery: Identifiable, Codable {
    @DocumentID var id: String?
    
    let date: Date?
    let hospital: String?
    let name: String?
    let patient_id: Double?
    let surgeon: String?
    let instruments: [String: String]?
    let implants: [String: String]?
}


struct Product: Codable {
    let id: Double?
    let cost: Double?
    let manufacturer: String?
    let name: String?
    let status: String?
}
