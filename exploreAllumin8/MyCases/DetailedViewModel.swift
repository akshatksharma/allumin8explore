//
//  DetailedViewModel.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/4/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation
import Lightbox
import FirebaseFirestore

// enum for what kind of cell will be displayed
enum detailedViewItemType {
    case caseInfo
    case patientInfo
    case itemInfo
//    case statusInfo
    case instrumentInfo
    case surgeryImageInfo
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
struct CaseInfoItem: DetailedViewItem {
    var type: detailedViewItemType = .caseInfo
    var sectionTitle = "Procedure"
    var surgeryName: String?
    var surgeon: String?
    var date: Timestamp?
    var hospital: String?
}

struct PatientInfoItem:DetailedViewItem {
    var sectionTitle = "Patient Info"
    var type: detailedViewItemType = .patientInfo
    var patient: Patient
  
}

struct SurgeryKitItem: DetailedViewItem {
    var sectionTitle = "Surgery Kits"
    var kits: [Kit]
    var rowCount: Int {
        return kits.count
    }
    var type: detailedViewItemType = .itemInfo
}

//struct StatusInfoItem:DetailedViewItem {
//    var sectionTitle = "Procedure Status"
//    var type: detailedViewItemType = .statusInfo
//}

struct InstrumentItem: DetailedViewItem {
    var type: detailedViewItemType = .instrumentInfo
    var sectionTitle: String = "Instruments"
    var InstrumentName: String?
    var catalogNum: String?
    var InstrumentNum: String?
}

struct SurgeryImagesItem: DetailedViewItem {
    var sectionTitle = "Procedure Images"
    var images: [LightboxImage]
    var type: detailedViewItemType = .surgeryImageInfo

}



