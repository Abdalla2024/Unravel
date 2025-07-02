//
//  InteractiveObject.swift
//  Unravel
//
//  Created by Abdalla Abdelmagid on 6/29/25.
//

import Foundation
import CoreGraphics

struct InteractiveObject: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String
    var position: CGPoint
    var description: String
} 