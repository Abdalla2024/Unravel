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
            ZStack(alignment: .bottomLeading) {
                SpriteView(scene: scene)
                    .edgesIgnoringSafeArea(.all)
                
                AnalogStickView(stickPosition: $stickPosition)
                    .padding(40)
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
