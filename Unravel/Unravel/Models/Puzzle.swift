import Foundation

struct Puzzle: Identifiable {
    let id = UUID()
    var title: String
    var question: String
    var answer: String
    var isSolved: Bool = false
} 