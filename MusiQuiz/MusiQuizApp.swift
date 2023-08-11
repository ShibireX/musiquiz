//
//  MusiQuizApp.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import SwiftUI

@main
struct MusiQuizApp: App {
    @StateObject var spotify = Spotify()
    let highScoreManager = HighScoreManager()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(spotify)
                .environmentObject(highScoreManager)
        }
    }
}
