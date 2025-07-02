//
//  Room.swift
//  Unravel
//
//  Created by Abdalla Abdelmagid on 6/29/25.
//

import Foundation

struct Room: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var backgroundImage: String
    var puzzles: [Puzzle]
    var objects: [InteractiveObject]
    var isLocked: Bool = false
    var requiredKey: String? = nil
    var connectedRooms: [String] = [] // Room names this room connects to
} 