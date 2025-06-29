import Foundation

struct Avatar: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
} 