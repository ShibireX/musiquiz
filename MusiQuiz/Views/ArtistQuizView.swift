//
//  ContentView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import SwiftUI
import SpotifyWebAPI
import Combine
import Foundation

struct ArtistQuizView: View {
    @EnvironmentObject var spotify: Spotify
    @State private var testQuiz = ArtistQuiz(questions: [])
    @State private var result = " "
    @State private var questionNumber = 1
    @State private var correctAnswers = 0
    @State private var quizFinished: Bool = false
    @State private var buttonIsEnabled: Bool = true
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
    
    //Progress
    @State private var progressWidth: CGFloat = 0
   
    
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
            if !doneStoringQuestion || testQuiz.questions.isEmpty {
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
                    ForEach(testQuiz.questions, id: \.self) { question in
                        Text(question.questionType.rawValue)
                            .font(.title)
                            .bold()
                            .padding()
                        AsyncImage(url: question.correctArtist.images?.largest?.url) { image in
                            image
                                .resizable()
                                .frame(width: 300, height: 300)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                        } placeholder: {
                            EmptyView()
                                .frame(width: 300, height: 300)
                        }
                        Spacer()
                        Text(result)
                        Spacer()
                        VStack {
                            ForEach(question.artistAlternatives, id: \.self) { alternative in
                                Button() {
                                    buttonIsEnabled = false
                                    if alternative.name == question.correctArtist.name {
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
                                        self.testQuiz.questions = []
                                        if artists.count >= 5 && questionNumber < totalQuestions {
                                            questionNumber += 1
                                            self.buildQuestion()
                                        } else {
                                            self.quizFinished = true
                                            if totalPoints > highScoreManager.getHighScore(for: quizName + "Artists") {
                                                highScoreManager.setHighScore(for: quizName + "Artists", score: totalPoints)
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
                                .disabled(!buttonIsEnabled)
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
                    self.startTime = Date()
                    self.contentOpacity = 0.0
                    self.buttonIsEnabled = true
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
            self.buildQuestion()
        }
    }
    
    func fetchArtists(artists: [SpotifyURIConvertible]) {
        self.didRequestArtists = true
        self.isLoadingArtists = true
        
        self.loadArtistsCancellable = spotify.spotifyAPI
            .artists(artists)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        self.artistsNotLoaded = false
                        self.isLoadingArtists = false
                    case .failure(let error):
                        self.artistsNotLoaded = true
                        print(error)
                }
            }, receiveValue: { fetchedArtists in
                let artists = fetchedArtists.compactMap { $0 }
                    .filter { $0.id != nil }
                var question = ArtistQuestion(questionType: .imageQuestion, artistAlternatives: artists, correctArtist: artists[0])
                question.artistAlternatives.shuffle()
                self.testQuiz.questions.append(question)
            })
    }
    
    func buildQuestion() {
        self.doneStoringQuestion = false
        
        var randomArtists = [SpotifyURIConvertible]()
        var leftOverArtists = [Artistt]()
        for _ in 1...4 {
            let randomInt = Int.random(in: 1...self.artists.count-1)
            leftOverArtists.append(self.artists[randomInt])
            randomArtists.append("spotify:artist:" + self.artists[randomInt].artistId)
            self.artists.remove(at: randomInt)
        }
        
        self.artists.append(contentsOf: leftOverArtists.dropFirst())
        self.fetchArtists(artists: randomArtists)
        self.doneStoringQuestion = true
    }
}

struct ArtistQuizView_Previews: PreviewProvider {
    static var spotify = Spotify()
    @State static var highScore = 0
    
    
    static var previews: some View {
        ArtistQuizView(artists: [Artistt(artistId: "0", popularity: 0)], gradientColors: [.blue], quizName: "Test")
            .environmentObject(spotify)
            .onAppear(perform: onAppear)
    }
    
    static func onAppear() {
        spotify.isAuthorized = true
    }
}
