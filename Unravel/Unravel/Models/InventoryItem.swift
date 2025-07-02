//
//  InventoryItem.swift
//  Unravel
//
//  Created by Abdalla Abdelmagid on 6/29/25.
//

import Foundation

struct InventoryItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var description: String
    var imageName: String
} 