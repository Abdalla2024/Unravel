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