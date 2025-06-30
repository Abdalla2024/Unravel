import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var currentRoomIndex: Int = 0
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var selectedAvatar: Avatar?
    @Published var gameStarted = false
    @Published var nearbyObject: InteractiveObject?

    init() {
        loadRooms()
    }

    var currentRoom: Room {
        rooms[currentRoomIndex]
    }

    var allPuzzlesSolved: Bool {
        currentRoom.puzzles.allSatisfy { $0.isSolved }
    }

    func loadRooms() {
        // Sample data for now. Later, we can load this from a file.
        let puzzle1 = Puzzle(title: "Riddle Me This", question: "I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?", answer: "A map")
        let desk = InteractiveObject(name: "Desk", imageName: "desk_image", position: CGPoint(x: 150, y: 150), description: "A sturdy wooden desk covered in papers.")
        let room1 = Room(name: "The Scholar's Study", description: "A quiet room filled with books and secrets.", backgroundImage: "study", puzzles: [puzzle1], objects: [desk])

        let puzzle2 = Puzzle(title: "Codebreaker", question: "What has to be broken before you can use it?", answer: "An egg")
        let room2 = Room(name: "The Alchemist's Lab", description: "Potions bubble and strange contraptions whir.", backgroundImage: "lab", puzzles: [puzzle2], objects: [])
        
        self.rooms = [room1, room2]
    }
    
    func setNearbyObject(_ object: InteractiveObject?) {
        if self.nearbyObject?.id != object?.id {
            self.nearbyObject = object
        }
    }

    func submitAnswer(for puzzle: Puzzle, answer: String) {
        if let roomIndex = rooms.firstIndex(where: { $0.id == currentRoom.id }),
           let puzzleIndex = rooms[roomIndex].puzzles.firstIndex(where: { $0.id == puzzle.id }) {
            if rooms[roomIndex].puzzles[puzzleIndex].answer.localizedCaseInsensitiveCompare(answer) == .orderedSame {
                rooms[roomIndex].puzzles[puzzleIndex].isSolved = true
                alertMessage = "Correct!"
            } else {
                alertMessage = "Wrong answer. Please try again."
            }
            showAlert = true
        }
    }

    func advanceToNextRoom() {
        if currentRoomIndex < rooms.count - 1 {
            currentRoomIndex += 1
        } else {
            // Handle game completion
            print("Congratulations! You've escaped all the rooms.")
        }
    }
} 
