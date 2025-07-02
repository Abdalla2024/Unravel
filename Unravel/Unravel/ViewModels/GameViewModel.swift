//
//  GameViewModel.swift
//  Unravel
//
//  Created by Abdalla Abdelmagid on 6/29/25.
//

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
    @Published var inventory: [InventoryItem] = []

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
        // Create a mysterious building with interconnected rooms
        let puzzle1 = Puzzle(title: "Strange Note", question: "A note on the desk reads: 'The key to freedom lies where knowledge sleeps.' What could this mean?", answer: "library")
        let desk = InteractiveObject(name: "Desk", imageName: "desk_image", position: CGPoint(x: 150, y: 150), description: "A dusty mahogany desk with papers scattered about. Among the clutter, you find a cryptic note: 'The key to freedom lies where knowledge sleeps.' This must be a clue about where to go next.")
        let room1 = Room(name: "Mysterious Office", description: "You slowly regain consciousness in a dimly lit office. Dust motes dance in the pale light filtering through grimy windows. The heavy wooden door behind you is firmly locked - there's no going back. You must find another way out.", backgroundImage: "study", puzzles: [puzzle1], objects: [desk], connectedRooms: ["Dark Hallway"])

        let puzzle2 = Puzzle(title: "Keypad Lock", question: "A digital keypad blocks your path forward. The display shows: '_ _ _ _'. Four digits are needed. You notice scratches around certain numbers: 1, 9, 8, 7. What year might be significant here?", answer: "1987")
        let keypad = InteractiveObject(name: "Keypad", imageName: "keypad_image", position: CGPoint(x: 150, y: 200), description: "A digital keypad with worn numbers. You notice deep scratches around 1, 9, 8, 7. These numbers seem significant... maybe they form a year? You try entering 1987.")
        let room2 = Room(name: "Dark Hallway", description: "A narrow, windowless hallway stretches before you. Fluorescent lights flicker overhead, casting eerie shadows on the peeling wallpaper. Multiple doors line the corridor, but most are sealed shut. Only one path leads forward, blocked by an electronic keypad.", backgroundImage: "lab", puzzles: [puzzle2], objects: [keypad], connectedRooms: ["Mysterious Office", "Library", "Storage Room"])
        
        let libraryKey = InteractiveObject(name: "Old Key", imageName: "key_image", position: CGPoint(x: 200, y: 100), description: "An ornate brass key hidden behind a row of dusty tomes. Its weight feels significant in your hand - this must unlock something important.")
        let room3 = Room(name: "Library", description: "Towering bookshelves stretch to the ceiling, filled with ancient volumes and forgotten knowledge. The air smells of old paper and secrets. Somewhere in this maze of books lies the key to your escape.", backgroundImage: "study", puzzles: [], objects: [libraryKey], isLocked: true, requiredKey: "Solved Keypad", connectedRooms: ["Dark Hallway"])
        
        let puzzle3 = Puzzle(title: "Combination Lock", question: "A combination lock secures a metal cabinet. The hint reads: 'The year this building was constructed.' You notice a faded plaque on the wall showing '1987'.", answer: "1987")
        let cabinet = InteractiveObject(name: "Locked Cabinet", imageName: "cabinet_image", position: CGPoint(x: 120, y: 180), description: "A metal cabinet secured with a combination lock. There's a faded plaque on the wall that reads 'Established 1987'. You try the combination 1987 and it clicks open!")
        let crowbar = InteractiveObject(name: "Crowbar", imageName: "crowbar_image", position: CGPoint(x: 100, y: 200), description: "A heavy iron crowbar. This could be useful for prying open locked doors.")
        let room4 = Room(name: "Storage Room", description: "A cluttered storage room filled with old furniture and maintenance equipment. The air is stale and heavy with dust. A locked metal cabinet sits in the corner.", backgroundImage: "lab", puzzles: [puzzle3], objects: [cabinet, crowbar], connectedRooms: ["Dark Hallway"])
        
        let puzzle4 = Puzzle(title: "Final Door", question: "The exit door has a complex lock mechanism. You need both the Old Key and the Crowbar to escape. Do you have both items?", answer: "yes")
        let exitDoor = InteractiveObject(name: "Exit Door", imageName: "door_image", position: CGPoint(x: 150, y: 100), description: "The final door to freedom. The lock mechanism is complex - you use the Old Key to unlock the main mechanism and the Crowbar to pry open the heavy security bolts. The door swings open and you step into freedom!")
        let room5 = Room(name: "Exit Chamber", description: "You stand before the final door - your path to freedom. The lock mechanism is complex, requiring both finesse and force. The Old Key fits one part, but you'll need something to pry open the heavy bolts.", backgroundImage: "study", puzzles: [puzzle4], objects: [exitDoor], isLocked: true, requiredKey: "Old Key", connectedRooms: [])
        
        self.rooms = [room1, room2, room3, room4, room5]
    }
    
    func addToInventory(_ item: InventoryItem) {
        if !inventory.contains(item) {
            inventory.append(item)
        }
    }
    
    func hasItem(named name: String) -> Bool {
        return inventory.contains { $0.name == name }
    }
    
    func navigateToRoom(named roomName: String) {
        if let roomIndex = rooms.firstIndex(where: { $0.name == roomName }) {
            let targetRoom = rooms[roomIndex]
            
            // Check if room is locked
            if targetRoom.isLocked {
                if let requiredKey = targetRoom.requiredKey, hasItem(named: requiredKey) {
                    // Unlock the room
                    rooms[roomIndex].isLocked = false
                    currentRoomIndex = roomIndex
                    alertMessage = "You unlocked the \(roomName) with your \(requiredKey)!"
                    showAlert = true
                } else {
                    alertMessage = "The \(roomName) is locked. You need: \(targetRoom.requiredKey ?? "a key")"
                    showAlert = true
                }
            } else {
                currentRoomIndex = roomIndex
            }
        }
    }

    func setNearbyObject(_ object: InteractiveObject?) {
        if self.nearbyObject?.id != object?.id {
            self.nearbyObject = object
        }
    }

    func solvePuzzle(answer: String) {
        for i in 0..<rooms[currentRoomIndex].puzzles.count {
            if !rooms[currentRoomIndex].puzzles[i].isSolved &&
               rooms[currentRoomIndex].puzzles[i].answer.lowercased() == answer.lowercased() {
                rooms[currentRoomIndex].puzzles[i].isSolved = true
                
                // Handle special puzzle effects
                let puzzle = rooms[currentRoomIndex].puzzles[i]
                
                if puzzle.title == "Keypad Lock" {
                    // Solving the keypad gives you access to the library
                    let keypadAccess = InventoryItem(name: "Solved Keypad", description: "You've solved the keypad lock.", imageName: "keypad_solved")
                    addToInventory(keypadAccess)
                    alertMessage = "The keypad beeps and turns green. You hear doors unlocking throughout the building..."
                    showAlert = true
                } else if puzzle.title == "Combination Lock" {
                    alertMessage = "The combination lock clicks open! You can now access the cabinet contents."
                    showAlert = true
                } else if puzzle.title == "Final Door" {
                    // Check if player has both required items
                    if hasItem(named: "Old Key") && hasItem(named: "Crowbar") {
                        alertMessage = "Congratulations! You use the Old Key to unlock the mechanism and the Crowbar to pry open the heavy bolts. The door swings open and you step into freedom! You have successfully escaped!"
                        showAlert = true
                    } else {
                        rooms[currentRoomIndex].puzzles[i].isSolved = false // Reset if they don't have items
                        var missingItems: [String] = []
                        if !hasItem(named: "Old Key") { missingItems.append("Old Key") }
                        if !hasItem(named: "Crowbar") { missingItems.append("Crowbar") }
                        alertMessage = "You need both items to escape. Missing: \(missingItems.joined(separator: ", "))"
                        showAlert = true
                    }
                } else {
                    alertMessage = "Correct! You solved the puzzle."
                    showAlert = true
                }
                
                return
            }
        }
        alertMessage = "That's not the right answer. Try again!"
        showAlert = true
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
