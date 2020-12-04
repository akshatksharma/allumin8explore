//
//  DetailedViewModel.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/4/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation

// actual info in each cell
struct patientInfo {
    var caseID: String?
    var patientID: String?
}

struct itemKitInfo {
    var name: String?
    var items: [surgeryItem]?
    var trackingInfo: String?
}

struct surgeryItem {
    var name: String?
    var catalogNum: Int?
    var quantity: Int?
}

struct surgeryStatus {
    var currentStatus: String?
}


// enum for what kind of cell will be displayed
enum detailedViewItemType {
    case patientInfo
    case itemInfo
    case statusInfo
}

// wrapper protocol for cell types
// adapted from https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429

protocol DetailedViewItem {
    var type: detailedViewItemType {get}
    var rowCount: Int {get}
    var sectionTitle: String {get}
}

extension DetailedViewItem {
    var rowCount: Int {
        return 1;
    }
}

// making specific cell data types
struct PatientInfoItem: DetailedViewItem {
    var sectionTitle = "Patient Info"
    var type: detailedViewItemType = .patientInfo
}

struct SurgeryInfoItem: DetailedViewItem {
    var sectionTitle = "Surgery Kits"
    var surgeryItems: [surgeryItem]
    var rowCount: Int {
        return surgeryItems.count
    }
    var type: detailedViewItemType = .itemInfo
}

struct StatusInfoItem:DetailedViewItem {
    var sectionTitle = "Procedure Status"
    var type: detailedViewItemType = .statusInfo
}



