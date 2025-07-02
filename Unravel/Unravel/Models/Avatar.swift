//
//  Avatar.swift
//  Unravel
//
//  Created by Aiden on 6/29/25.
//

import Foundation

struct Avatar: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
} 