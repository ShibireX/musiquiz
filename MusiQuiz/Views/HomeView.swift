//
//  HomeView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-04.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var highScoreManager: HighScoreManager
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.white)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(.black)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.black)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: [GridItem(.fixed(175)), GridItem(.fixed(175))],
                              spacing: 1,
                              content: {
                        Section(header: Text("Artists").font(.title2)) {
                            NavigationLink {
                                ArtistQuizView(artists: parseArtistsFromCSV(file: "top_100"), gradientColors: ColorModel.quizColors["top_100"]!)
                            } label: {
                                QuizItemView(colors: ColorModel.quizColors["top_100"]!, option: "Mainstream", highScore: highScoreManager.highScore)
                            }
                            NavigationLink {
                                //ArtistQuizView(artists: parseArtistsFromCSV(file: "k_pop"), gradientColors: ColorModel.quizColors["top_100"]!)
                            } label: {
                                //QuizItemView(option: "K-Pop", color: .purple)
                            }
                            NavigationLink {
                                //ArtistQuizView(artists: parseArtistsFromCSV(file: "swedish"), gradientColors: ColorModel.quizColors["top_100"]!)
                            } label: {
                                //QuizItemView(option: "Swedish", color: .blue)
                            }
                        }
                        .padding()
                        Section(header: Text("Tracks").font(.title2)) {
                            NavigationLink {
                                //ArtistQuizView(artists: parseArtistsFromCSV(file: "most_popular"), gradientColors: ColorModel.quizColors["top_100"]!)
                            } label: {
                                //QuizItemView(option: "Top 100", color: .orange)
                            }
                            NavigationLink {
                                //ArtistQuizView(artists: parseArtistsFromCSV(file: "most_popular"), gradientColors: ColorModel.quizColors["top_100"]!)
                            } label: {
                                //QuizItemView(option: "K-Pop", color: .purple)
                            }
                        }
                        .padding()
                    })
                    .foregroundColor(.black)
                }
                .padding()
            }
            .navigationTitle("All Quizzes")
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
            Text(option)
                .font(.callout)
                .foregroundColor(.white)
                .bold()
                .padding(EdgeInsets(top: 30, leading: -65, bottom: 0, trailing: 0))
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
