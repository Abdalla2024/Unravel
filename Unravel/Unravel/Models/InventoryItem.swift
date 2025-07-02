import Foundation

struct InventoryItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var description: String
    var imageName: String
} 