//
//  Quiz.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import Foundation
import SpotifyWebAPI
import SwiftUI

struct Quiz {
    var questions: [ArtistQuestion]
    
    func checkAnswer(answer: String, correct: String) -> Bool {
        if answer != correct {
            return false
        } else {
            return true
        }
    }

}

struct ArtistQuestion: Hashable {
    let questionType: QuestionType
    var artistAlternatives: [Artist]
    let correctArtist: Artist
}

enum QuestionType: String {
    case imageQuestion = "Who is the artist?"
    case trackQuestion = "What artist made this track?"
}


