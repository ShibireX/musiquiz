//
//  SpecialQuizView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-11.
//

import SwiftUI
import SpotifyWebAPI
import Combine
import Foundation
import AVFoundation

struct SpecialQuizView: View {
    @EnvironmentObject var spotify: Spotify
    @State private var quiz = TrackQuiz(questions: [])
    @State private var result = " "
    @State private var questionNumber = 1
    @State private var correctAnswers = 0
    @State private var quizFinished: Bool = false
    private let totalQuestions = 20

    @State private var doneStoringQuestion = false
    @State private var didRequestTracks = false
    @State private var isLoadingTracks = false
    @State private var tracksNotLoaded = false
    @State private var loadTracksCancellable: AnyCancellable? = nil
    @State private var loadAlbumTracksCancellable: AnyCancellable? = nil
    @State private var contentOpacity = 0.0
    
    @State var tracks: [Track] = []
    let gradientColors: [Color]
    
    // Information
    let quizName: String
    @State var trackIds: [SpotifyURIConvertible]
    
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
    
    //Progress
    @State private var progressWidth: CGFloat = 0
    
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
                if isLoadingTracks {
                    Spacer()
                    HStack {
                        EmptyView()
                            .padding()
                    }
                    Spacer()
                }
                else if tracksNotLoaded {
                    VStack {
                        Text("Could Not Load Data")
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
                                            self.progressWidth += 19.5

                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.result = " "
                                        self.quiz.questions = []
                                        if tracks.count >= 5 && questionNumber <
                                            totalQuestions {
                                            questionNumber += 1
                                            self.doneStoringQuestion = false
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
            VStack {
                HStack {
                    ProgressBarView(barWidth: progressWidth)
                    Spacer()
                }
                .padding(.bottom, -35)
            }
        }
        .toolbar(.hidden)
        .foregroundColor(.white)
        .onAppear {
            if self.trackIds.count > 50 {
                self.trackIds.shuffle()
                self.trackIds = Array(self.trackIds.prefix(50))
            }
            self.getTracks(tracks: trackIds)
        }
        .onDisappear {
            if self.audioPlayer != nil {
                self.audioPlayer.pause()
                self.audioPlayer = nil
            }
        }
    }
    
    func getTracks(tracks: [SpotifyURIConvertible]) {
        self.didRequestTracks = true
        self.isLoadingTracks = true
        
        self.loadTracksCancellable = spotify.spotifyAPI
            .tracks(tracks, market: "SE")
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        self.isLoadingTracks = false
                        self.tracksNotLoaded = false
                    case .failure(let error):
                        self.tracksNotLoaded = true
                        print(error)
                }
            }, receiveValue: { fetchedTracks in
                let allTracks = fetchedTracks.compactMap { $0 }
                    .filter { $0.previewURL != nil }
                self.tracks.append(contentsOf: allTracks)
                self.buildQuestion()
            })
    }
    
    func buildQuestion() {
        self.doneStoringQuestion = false
        var leftOverTracks = [Track]()
        var randomTracks = [Track]()
        
        for _ in 1...4 {
            let randomInt = Int.random(in: 1...self.tracks.count-1)
            leftOverTracks.append(self.tracks[randomInt])
            randomTracks.append(self.tracks[randomInt])
            self.tracks.remove(at: randomInt)
        }
        
        var question = TrackQuestion(questionType: .trackQuestion, trackAlternatives: randomTracks, correctTrack: randomTracks[0])
        question.trackAlternatives.shuffle()
        self.quiz.questions.append(question)
        
        self.tracks.append(contentsOf: leftOverTracks.dropFirst())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.doneStoringQuestion = true
        }
    }
}

struct SpecialQuizView_Previews: PreviewProvider {
    static var spotify = Spotify()
    @State static var highScore = 0
    
    
    static var previews: some View {
        SpecialQuizView(gradientColors: [.blue], quizName: "Selena Gomez", trackIds: parseTracksFromCSV(file: "selena gomez"))
            .environmentObject(spotify)
            .onAppear(perform: onAppear)
    }
    
    static func onAppear() {
        spotify.isAuthorized = true
    }
}

