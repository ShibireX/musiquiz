//
//  SpecialQuizSelectionView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-11.
//

import SwiftUI

struct SpecialQuizSelectionView: View {
    @EnvironmentObject var highScoreManager: HighScoreManager
    var colorGradient: [Color]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: colorGradient, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text("Artist Specials")
                    .font(.largeTitle)
                    .bold()
                Text("Select Artist Quiz")
                    .padding(.top, -15)
                    .padding(.bottom, 10)
                    .font(.callout)
                Spacer()
                ScrollView {
                    LazyVGrid(columns: [GridItem(.fixed(150)), GridItem(.fixed(150))],
                              spacing: 1,
                              content: {
                        ForEach(ArtistSpecials.artists, id:\.self) { artist in
                            VStack {
                                NavigationLink {
                                    SpecialQuizView(gradientColors: colorGradient, quizName: artist, trackIds: parseTracksFromCSV(file: artist.lowercased()))
                                } label: {
                                    Image(artist)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Rectangle())
                                        .cornerRadius(10)
                                        .shadow(radius: 4)
                                }
                                Text(artist)
                                    .font(.title3)
                                HStack {
                                    Image(systemName: "crown.fill")
                                    Text(String(highScoreManager.getHighScore(for: artist)))
                                        .padding(.leading, -5)
                                }
                                .padding(.top, -5)
                            }
                            .padding(.top, 30)
                        }
                    })
                }
            }
                
        }
        .foregroundColor(.white)
    }
}

struct SpecialQuizSelectionView_Previews: PreviewProvider {
    static var highScoreManager = HighScoreManager()
    
    static var previews: some View {
        SpecialQuizSelectionView(colorGradient: ColorModel.quizColors["pop"]!)
            .environmentObject(highScoreManager)
    }
}
