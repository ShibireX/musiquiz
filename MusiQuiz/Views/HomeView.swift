//
//  HomeView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-04.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var highScoreManager: HighScoreManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorModel.mainColor.ignoresSafeArea()
                VStack {
                    Text("MusiQuiz")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.fixed(175)), GridItem(.fixed(175))],
                                  spacing: 1,
                                  content: {
                            Section(header: Text("Artist Quizzes").font(.title2).opacity(0.7)) {
                                NavigationLink {
                                    ArtistQuizView(artists: parseArtistsFromCSV(file: "top_100"), gradientColors: ColorModel.quizColors["top_100"]!, quizName: "top_100")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["top_100"]!, option: "Mainstream", highScore: highScoreManager.getHighScore(for: "top_100"))
                                }
                                NavigationLink {
                                    ArtistQuizView(artists: parseArtistsFromCSV(file: "k_pop"), gradientColors: ColorModel.quizColors["k_pop"]!, quizName: "k_pop")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["k_pop"]!, option: "K-Pop", highScore: highScoreManager.getHighScore(for: "k_pop"))
                                }
                                NavigationLink {
                                    ArtistQuizView(artists: parseArtistsFromCSV(file: "swedish"), gradientColors: ColorModel.quizColors["swedish"]!, quizName: "swedish")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["swedish"]!, option: "Sweden", highScore: highScoreManager.getHighScore(for: "swedish"))
                                }
                                .padding(.top, -25)
                                NavigationLink {
                                    ArtistQuizView(artists: parseArtistsFromCSV(file: "anime"), gradientColors: ColorModel.quizColors["anime"]!, quizName: "anime")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["anime"]!, option: "Anime", highScore: highScoreManager.getHighScore(for: "anime"))
                                }
                                .padding(.top, -25)
                                NavigationLink {
                                    ArtistQuizView(artists: parseArtistsFromCSV(file: "latino_trap"), gradientColors: ColorModel.quizColors["latino_trap"]!, quizName: "latino_trap")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["latino_trap"]!, option: "Latino Trap", highScore: highScoreManager.getHighScore(for: "latino_trap"))
                                }
                                .padding(.top, -25)
                                NavigationLink {
                                    ArtistQuizView(artists: parseArtistsFromCSV(file: "swedish_hip_hop"), gradientColors: ColorModel.quizColors["swedish_hip_hop"]!, quizName: "swedish_hip_hop")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["swedish_hip_hop"]!, option: "Swedish Hip Hop", highScore: highScoreManager.getHighScore(for: "swedish_hip_hop"))
                                }
                                .padding(.top, -25)
                            }
                            .padding()
                            Section(header: Text("Song Quizzes").font(.title2).opacity(0.7)) {
                                NavigationLink {
                                    TrackQuizView(artists: parseArtistsFromCSV(file: "top_100"), gradientColors: ColorModel.quizColors["top_100"]!, quizName: "top_100_tracks")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["top_100"]!, option: "Mainstream", highScore: highScoreManager.getHighScore(for: "top_100_tracks"))
                                }
                                NavigationLink {
                                    TrackQuizView(artists: parseArtistsFromCSV(file: "k_pop"), gradientColors: ColorModel.quizColors["k_pop"]!, quizName: "k_pop_tracks")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["k_pop"]!, option: "K-Pop", highScore: highScoreManager.getHighScore(for: "k_pop_tracks"))
                                }
                                NavigationLink {
                                    TrackQuizView(artists: parseArtistsFromCSV(file: "swedish"), gradientColors: ColorModel.quizColors["swedish"]!, quizName: "swedish_tracks")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["swedish"]!, option: "Sweden", highScore: highScoreManager.getHighScore(for: "swedish_tracks"))
                                }
                                .padding(.top, -25)
                                NavigationLink {
                                    TrackQuizView(artists: parseArtistsFromCSV(file: "anime"), gradientColors: ColorModel.quizColors["anime"]!, quizName: "anime_tracks")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["anime"]!, option: "Anime", highScore: highScoreManager.getHighScore(for: "anime_tracks"))
                                }
                                .padding(.top, -25)
                                NavigationLink {
                                    TrackQuizView(artists: parseArtistsFromCSV(file: "latino_trap"), gradientColors: ColorModel.quizColors["latino_trap"]!, quizName: "latino_trap_tracks")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["latino_trap"]!, option: "Latino Trap", highScore: highScoreManager.getHighScore(for: "latino_trap_tracks"))
                                }
                                .padding(.top, -25)
                                NavigationLink {
                                    TrackQuizView(artists: parseArtistsFromCSV(file: "swedish_hip_hop"), gradientColors: ColorModel.quizColors["swedish_hip_hop"]!, quizName: "swedish_hip_hop_tracks")
                                } label: {
                                    QuizItemView(colors: ColorModel.quizColors["swedish_hip_hop"]!, option: "Swedish Hip Hop", highScore: highScoreManager.getHighScore(for: "swedish_hip_hop_tracks"))
                                }
                                .padding(.top, -25)
                            }
                            .padding()
                        })
                        .foregroundColor(.black)
                    }
                    .padding()
                }
            }
            .toolbar(.hidden)
        }
    }
}

struct QuizItemView: View {
    var colors: [Color]
    let option: String
    let highScore: Int
    
    init(colors: [Color], option: String, highScore: Int) {
        self.colors = colors
        self.option = option
        self.highScore = highScore
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom))
                .frame(width: 175, height: 100)
            HStack {
                Text(option)
                    .font(.callout)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 25)
                    .padding(.leading, 10)
                Spacer()
            }
            HStack {
                Image(systemName: "crown.fill")
                    .frame(width: 10)
                    .scaleEffect(x: 0.85, y:0.85, anchor: .center)
                Text(String(highScore))
            }
            .font(.body)
            .foregroundColor(.white).opacity(0.8)
            .padding(EdgeInsets(top: 69, leading: -72, bottom: 0, trailing: 0))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var highScoreManager = HighScoreManager()
    
    static var previews: some View {
        HomeView()
            .environmentObject(highScoreManager)
    }
}
