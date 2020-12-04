//
//  File.swift
//  exploreAllumin8
//
//  Created by Ethan Evans on 11/29/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

struct CatalogItem: Codable{
    let itemID:String
    let cost:Float
    let manufacturer:String
    let name:String
    
    enum CodingKeys:String, CodingKey {
        case itemID, cost, manufacturer, name
    }
    
    
    init(itemID:String, cost:Float, manufacturer:String, name:String) {
        self.itemID = itemID
        self.cost = cost
        self.manufacturer = manufacturer
        self.name = name
    }
    
    func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(itemID, forKey: .itemID)
        try container.encode(cost, forKey: .cost)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(name, forKey: .name)
    }
    
    init (from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        itemID = try container.decode(String.self, forKey: .itemID)
        cost = try container.decode(Float.self, forKey: .cost)
        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        name = try container.decode(String.self, forKey: .name)
    }
    
}
