//
//  UnravelApp.swift
//  Unravel
//
//  Created by Abdalla Abdelmagid on 6/24/25.
//

import SwiftUI

@main
struct UnravelApp: App {
    @StateObject private var gameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameViewModel)
        }
    }
}
