//
//  HighScoreManager.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-06.
//

import Foundation

class HighScoreManager: ObservableObject {
    @Published var highScores: [String: Int] {
        didSet {
            saveHighScores()
        }
    }
    
    init() {
        self.highScores = [:]
        self.highScores = loadHighScores()
    }
    
    private func loadHighScores() -> [String: Int] {
        if let savedHighScores = UserDefaults.standard.dictionary(forKey: "HighScoresKey") as? [String: Int] {
            return savedHighScores
        } else {
            return [:]
        }
    }
    
    private func saveHighScores() {
        UserDefaults.standard.set(highScores, forKey: "HighScoresKey")
    }
    
    func setHighScore(for quiz: String, score: Int) {
        highScores[quiz] = score
    }
    
    func getHighScore(for quiz: String) -> Int {
        return highScores[quiz] ?? 0
    }
}
