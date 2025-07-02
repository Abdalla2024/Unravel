//
//  ContentView.swift
//  Unravel
//
//  Created by Abdalla Abdelmagid on 6/24/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var stickPosition: CGPoint = .zero
    @State private var showRoomDescription = true

    // Create a scene
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400) // Adjust size as needed
        scene.scaleMode = .fill
        // Pass the view model to the scene
        scene.userData = NSMutableDictionary()
        scene.userData?.setObject(gameViewModel, forKey: "gameViewModel" as NSCopying)
        return scene
    }

    var body: some View {
        if gameViewModel.gameStarted {
            ZStack(alignment: .topTrailing) {
                SpriteView(scene: scene)
                    .edgesIgnoringSafeArea(.all)
                
                // Room description overlay (conditional)
                if showRoomDescription {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(gameViewModel.currentRoom.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .shadow(radius: 2)
                                    
                                    Spacer()
                                    
                                    Button("✕") {
                                        showRoomDescription = false
                                    }
                                    .foregroundColor(.white)
                                    .font(.title2)
                                }
                                
                                Text(gameViewModel.currentRoom.description)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: 250)
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 50)
                }
                
                // Room info button (when description is hidden)
                if !showRoomDescription {
                    VStack {
                        HStack {
                            Button("ℹ️") {
                                showRoomDescription = true
                            }
                            .font(.title2)
                            .padding(12)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                }
                
                // Inventory display
                VStack(alignment: .trailing) {
                    Text("Inventory")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(gameViewModel.inventory) { item in
                        Text(item.name)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(5)
                    }
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    Spacer()
                    
                    HStack {
                        AnalogStickView(stickPosition: $stickPosition)
                            .padding(40)
                        
                        Spacer()
                        
                        // Room navigation buttons
                        VStack {
                            ForEach(gameViewModel.currentRoom.connectedRooms, id: \.self) { roomName in
                                Button("→ \(roomName)") {
                                    gameViewModel.navigateToRoom(named: roomName)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .font(.caption)
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    
                    // Examine button
                    if gameViewModel.nearbyObject != nil {
                        Button("Examine") {
                            if let object = gameViewModel.nearbyObject {
                                // Handle special interactive objects that solve puzzles automatically
                                if object.name == "Keypad" {
                                    gameViewModel.solvePuzzle(answer: "1987")
                                } else if object.name == "Locked Cabinet" {
                                    gameViewModel.solvePuzzle(answer: "1987")
                                } else if object.name == "Exit Door" {
                                    gameViewModel.solvePuzzle(answer: "yes")
                                } else if object.name == "Old Key" {
                                    let keyItem = InventoryItem(name: "Old Key", description: "An old brass key that might unlock something.", imageName: "key_image")
                                    gameViewModel.addToInventory(keyItem)
                                    gameViewModel.alertMessage = "You picked up the \(object.name)!"
                                    gameViewModel.showAlert = true
                                } else if object.name == "Crowbar" {
                                    let crowbarItem = InventoryItem(name: "Crowbar", description: "A heavy iron crowbar useful for prying things open.", imageName: "crowbar_image")
                                    gameViewModel.addToInventory(crowbarItem)
                                    gameViewModel.alertMessage = "You picked up the \(object.name)!"
                                    gameViewModel.showAlert = true
                                } else {
                                    gameViewModel.alertMessage = object.description
                                    gameViewModel.showAlert = true
                                }
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    }
                    
                    // Show exit chamber button when player has the old key
                    if gameViewModel.hasItem(named: "Old Key") && gameViewModel.currentRoom.name == "Dark Hallway" {
                        Button("→ Exit Chamber") {
                            gameViewModel.navigateToRoom(named: "Exit Chamber")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.caption)
                        .padding(.bottom, 20)
                    }
                }
            }
            .alert(isPresented: $gameViewModel.showAlert) {
                Alert(title: Text("Game"), message: Text(gameViewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .onChange(of: stickPosition) {
                (scene as? GameScene)?.updateStickPosition(stickPosition)
            }
        } else {
            AvatarSelectionView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameViewModel())
    }
}
