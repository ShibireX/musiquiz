//
//  Quiz.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import Foundation
import SpotifyWebAPI
import SwiftUI

struct QuizSelector {
    static var quizzes = [Quiz(quizName: .mainstream, quizType: .normal, quizColors: ColorModel.quizColors["mainstream"]!),
                          Quiz(quizName: .hipHop, quizType: .normal, quizColors: ColorModel.quizColors["hipHop"]!),
                          Quiz(quizName: .pop, quizType: .normal, quizColors: ColorModel.quizColors["pop"]!),
                          Quiz(quizName: .edm, quizType: .normal, quizColors: ColorModel.quizColors["edm"]!),
                          Quiz(quizName: .kPop, quizType: .normal, quizColors: ColorModel.quizColors["kPop"]!),
                          Quiz(quizName: .jRock, quizType: .normal, quizColors: ColorModel.quizColors["jRock"]!)]
    
    static var specialQuizzes = [Quiz(quizName: .artistSpecials, quizType: .special, quizColors: ColorModel.quizColors["pop"]!)]
}

struct Quiz: Hashable {
    var quizName: QuizName
    var quizType: QuizType
    var quizColors: [Color]
}

enum QuizName: String {
    case mainstream = "Mainstream"
    case hipHop = "Hip Hop"
    case pop = "Pop"
    case edm = "EDM"
    case kPop = "K-Pop"
    case jRock = "J-Rock"
    case artistSpecials = "Artist Specials"
}

enum QuizType {
    case normal
    case special
}

struct ArtistQuiz {
    var questions: [ArtistQuestion]
}

struct TrackQuiz {
    var questions: [TrackQuestion]
}

struct ArtistQuestion: Hashable {
    let questionType: QuestionType
    var artistAlternatives: [Artist]
    let correctArtist: Artist
}

struct TrackQuestion: Hashable {
    let questionType: QuestionType
    var trackAlternatives: [Track]
    let correctTrack: Track
}

enum QuestionType: String {
    case imageQuestion = "Who is the artist?"
    case trackQuestion = "What song is this?"
}



