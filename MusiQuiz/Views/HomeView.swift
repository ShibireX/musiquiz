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
                            ForEach(QuizSelector.quizzes, id:\.self) { quiz in
                                NavigationLink {
                                    NormalQuizSelectionView(quizColors: quiz.quizColors, quizName: quiz.quizName.rawValue, tracksHighScore: highScoreManager.getHighScore(for: quiz.quizName.rawValue.lowercased() + "Tracks"), artistsHighScore: highScoreManager.getHighScore(for: quiz.quizName.rawValue.lowercased() + "Artists"))
                                } label: {
                                    QuizItemView(colors: quiz.quizColors, option: quiz.quizName.rawValue)
                                }
                                .padding(.top, 7)
                            }
                            ForEach(QuizSelector.specialQuizzes, id:\.self) { quiz in
                                NavigationLink {
                                    SpecialQuizSelectionView(colorGradient: quiz.quizColors)
                                } label: {
                                    QuizItemView(colors: quiz.quizColors, option: quiz.quizName.rawValue)
                                }
                                .padding(.top, 7)
                            }
                        })
                        .foregroundColor(.black)
                    }
                }
            }
            .toolbar(.hidden)
        }
    }
}

struct QuizItemView: View {
    var colors: [Color]
    let option: String
    
    init(colors: [Color], option: String) {
        self.colors = colors
        self.option = option
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
                    .padding(.top, 55)
                    .padding(.leading, 10)
                Spacer()
            }
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
