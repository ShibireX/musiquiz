//
//  NormalQuizSelectionView.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-10.
//

import SwiftUI

struct NormalQuizSelectionView: View {
    var quizColors: [Color]
    var quizName: String
    var tracksHighScore: Int
    var artistsHighScore: Int
    
    var body: some View {
        ZStack {
            LinearGradient(colors: quizColors, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text(quizName)
                    .font(.largeTitle)
                    .bold()
                Text("Select Quiz Type")
                    .padding(.top, -15)
                    .padding(.bottom, 50)
                    .font(.callout)
                Spacer()
                NavigationLink {
                    ArtistQuizView(artists: parseArtistsFromCSV(file: quizName.lowercased()), gradientColors: quizColors, quizName: quizName.lowercased())
                } label: {
                    VStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Text("Artists")
                            .bold()
                        HStack {
                            Image(systemName: "crown.fill")
                            Text(String(artistsHighScore))
                                .padding(.leading, -5)
                        }
                        .padding(.top, -5)
                    }
                }
                Spacer()
                NavigationLink {
                    TrackQuizView(artists: parseArtistsFromCSV(file: quizName.lowercased()), gradientColors: quizColors, quizName: quizName.lowercased())
                } label: {
                    VStack {
                        Image(systemName: "music.mic.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Text("Songs")
                            .bold()
                        HStack {
                            Image(systemName: "crown.fill")
                            Text(String(tracksHighScore))
                                .padding(.leading, -5)
                        }
                        .padding(.top, -5)
                    }
                }
                Spacer()
            }
        }
        .foregroundColor(.white)
    }
}

struct NormalQuizSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NormalQuizSelectionView(quizColors: ColorModel.quizColors["mainstream"]!, quizName: "Mainstream", tracksHighScore: 0, artistsHighScore: 0)
    }
}
