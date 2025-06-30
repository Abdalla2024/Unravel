import Foundation

struct Room: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var backgroundImage: String
    var puzzles: [Puzzle]
    var objects: [InteractiveObject]
} 