//
//  DetailedViewModel.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/4/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import Foundation

// enum for what kind of cell will be displayed
enum detailedViewItemType {
    case caseInfo
    case itemInfo
    case statusInfo
    case instrumentInfo
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
    var sectionTitle = "Case Info"
    var surgeryName: String?
    var surgeon: String?
    var caseId: String?
    var patientId: String?
}

struct SurgeryKitItem: DetailedViewItem {
    var sectionTitle = "Surgery Kits"
    var kitName: String?
    var surgeryItems: [Product]
    var rowCount: Int {
        return surgeryItems.count
    }
    var type: detailedViewItemType = .itemInfo
}

struct StatusInfoItem:DetailedViewItem {
    var sectionTitle = "Procedure Status"
    var type: detailedViewItemType = .statusInfo
}

struct InstrumentItem: DetailedViewItem {
    var type: detailedViewItemType = .instrumentInfo
    var sectionTitle: String = "Instruments"
    var InstrumentName: String?
    var catalogNum: String?
    var InstrumentNum: String?
}



