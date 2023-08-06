//
//  HighScoreManager.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-06.
//

import Foundation

class HighScoreManager: ObservableObject {
    @Published var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "HighScoreKey")
        }
    }
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "HighScoreKey")
    }
}
