//
//  TrackQuizView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-09.
//

import SwiftUI
import SpotifyWebAPI
import Combine
import Foundation
import AVFoundation

struct TrackQuizView: View {
    @EnvironmentObject var spotify: Spotify
    @State private var testArtists: [Artist] = []
    @State private var quiz = TrackQuiz(questions: [])
    @State private var result = " "
    @State private var questionNumber = 1
    @State private var correctAnswers = 0
    @State private var quizFinished: Bool = false
    private let totalQuestions = 20

    @State private var doneStoringQuestion = false
    @State private var didRequestArtists = false
    @State private var isLoadingArtists = false
    @State private var artistsNotLoaded = false
    @State private var loadArtistsCancellable: AnyCancellable? = nil
    @State private var contentOpacity = 0.0
    
    @State var artists: [Artistt]
    let gradientColors: [Color]
    
    // Information
    let quizName: String
    
    // Animations
    @State private var rocketOffset: CGSize = CGSize(width: -150, height: 200)
    @State private var rocketOpacity = 0.0
    @State private var scoreOpacity = 0.0
    
    // Score System
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var timeDifference: TimeInterval = 0
    @State private var totalPoints: Int = 0
    @EnvironmentObject var highScoreManager: HighScoreManager
    
    // Music
    @State private var audioPlayer: AVPlayer!
    
    var body: some View {
        ZStack {
            LinearGradient(colors: gradientColors, startPoint:.top, endPoint: .bottom).ignoresSafeArea()
            NavigationLink {
                HomeView()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    .foregroundColor(.white)
            }
            .offset(CGSize(width: (UIScreen.main.bounds.width/2) - 30, height: (-UIScreen.main.bounds.height/2) + 70))
            if !doneStoringQuestion || quiz.questions.isEmpty {
                if isLoadingArtists {
                    Spacer()
                    HStack {
                        EmptyView()
                            .padding()
                    }
                    Spacer()
                }
                else if artistsNotLoaded {
                    VStack {
                        Text("Could Not Load Question")
                            .font(.title)
                    }
                }
                else if quizFinished {
                    ZStack {
                        Text("🚀")
                            .font(.system(size: 50))
                            .offset(rocketOffset)
                            .opacity(rocketOpacity)
                        VStack {
                            Text(String(totalPoints) + "pts")
                                .font(.largeTitle)
                                .bold()
                                .opacity(scoreOpacity)
                            Text(String(100*correctAnswers/totalQuestions) + "% Accuracy")
                                .font(.callout)
                                .opacity(scoreOpacity)
                        }
                    }
                    .onAppear {
                        if doneStoringQuestion {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                rocketOffset = CGSize(width: 0, height: 85)
                                rocketOpacity = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    scoreOpacity = 1.0
                                }
                            }
                        }
                    }

                }
            }
            else {
                VStack {
                    ForEach(quiz.questions, id: \.self) { question in
                        Text(question.questionType.rawValue)
                            .font(.title)
                            .bold()
                            .padding()
                        Image(systemName: "music.note.list")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        Text(result)
                        Spacer()
                        VStack {
                            ForEach(question.trackAlternatives, id: \.self) { alternative in
                                Button() {
                                    self.audioPlayer.pause()
                                    self.audioPlayer = nil
                                    if alternative.name == question.correctTrack.name {
                                        result = "✅"
                                        self.correctAnswers += 1
                                        self.endTime = Date()
                                        self.timeDifference = endTime.timeIntervalSince(startTime)
                                        self.totalPoints += 100 + Int(100/self.timeDifference)
                                    } else {
                                        result = "❌"
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        withAnimation(.easeOut(duration: 0.25)) {
                                            self.contentOpacity = 0.0
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.result = " "
                                        self.quiz.questions = []
                                        if artists.count >= 5 && questionNumber < totalQuestions {
                                            questionNumber += 1
                                            self.buildQuestion()
                                        } else {
                                            self.quizFinished = true
                                            if totalPoints > highScoreManager.getHighScore(for: quizName) {
                                                highScoreManager.setHighScore(for: quizName, score: totalPoints)
                                            }
                                        }
                                    }
                                } label: {
                                    Text(alternative.name)
                                        .padding()
                                        .bold()
                                        .font(.callout)
                                        .frame(width: 300, height: 40)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.white, lineWidth: 0.3)
                                                .shadow(radius: 2, x: 2, y:2)
                                        )
                                }
                                .padding(5)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .padding(.top, 20)
                .opacity(contentOpacity)
                .onAppear {
                    if let previewURL = quiz.questions[0].correctTrack.previewURL {
                        self.audioPlayer = AVPlayer(url: previewURL)
                        self.audioPlayer.play()
                    }
                    self.startTime = Date()
                    self.contentOpacity = 0.0
                    if doneStoringQuestion {
                        withAnimation(.easeIn(duration: 1.5)) {
                            self.contentOpacity = 1.0
                        }
                    }
                }
            }
        }
        .toolbar(.hidden)
        .foregroundColor(.white)
        .onAppear {
            self.buildQuestion()
        }
        .onDisappear {
            if self.audioPlayer != nil {
                self.audioPlayer.pause()
                self.audioPlayer = nil
            }
        }
    }
    
    func fetchSongs(artist: SpotifyURIConvertible) {
        self.didRequestArtists = true
        self.isLoadingArtists = true
        
        self.loadArtistsCancellable = spotify.spotifyAPI
            .artistTopTracks(artist, country: "SE")
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        self.artistsNotLoaded = false
                        self.isLoadingArtists = false
                    case .failure(let error):
                        self.artistsNotLoaded = true
                        print(error)
                }
            }, receiveValue: { fetchedTracks in
                var tracks = fetchedTracks.compactMap { $0 }
                    .filter { $0.previewURL != nil }
                if tracks.count >= 4 {
                    tracks.shuffle()
                    var question = TrackQuestion(questionType: .trackQuestion, trackAlternatives: Array(tracks.prefix(4)), correctTrack: tracks[0])
                    question.trackAlternatives.shuffle()
                    self.quiz.questions.append(question)
                } else {
                    self.buildQuestion()
                }
                
            })
    }
    
    func buildQuestion() {
        self.doneStoringQuestion = false
        var randomArtist: SpotifyURIConvertible = ""
  
        let randomInt = Int.random(in: 1...self.artists.count-1)
        randomArtist = "spotify:artist:" + self.artists[randomInt].artistId
        self.artists.remove(at: randomInt)
 
        self.fetchSongs(artist: randomArtist)
        self.doneStoringQuestion = true
    }
}

struct TrackQuizView_Previews: PreviewProvider {
    static var spotify = Spotify()
    @State static var highScore = 0
    
    
    static var previews: some View {
        TrackQuizView(artists: [Artistt(artistId: "0", popularity: 0)], gradientColors: [.blue], quizName: "Test")
            .environmentObject(spotify)
            .onAppear(perform: onAppear)
    }
    
    static func onAppear() {
        spotify.isAuthorized = true
    }
}

