import Foundation
import CoreGraphics

struct InteractiveObject: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String
    var position: CGPoint
    var description: String
} 