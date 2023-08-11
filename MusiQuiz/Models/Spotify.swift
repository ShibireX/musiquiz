//
//  Spotify.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import Foundation
import SpotifyWebAPI
import KeychainAccess
import Combine
import UIKit
import SwiftUI

// Class for handling authorization changes and maintaining them in persistent storage
final class Spotify: ObservableObject {
    
    static let clientID = Environment.value(for: "CLIENT_ID")
    static let clientSecret = Environment.value(for: "CLIENT_SECRET")
    
    // Bool that controls whether or not we can make API requests
    @Published var isAuthorized = false
    // Bool that controls whether or not we are receiving access and refresh tokens
    @Published var isReceivingTokens = false
    
    // API instance
    let spotifyAPI = SpotifyAPI(
        authorizationManager: ClientCredentialsFlowManager(
            clientId: Spotify.clientID,
            clientSecret: Spotify.clientSecret))
    
    // Set for keeping track of cancellable tasks
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.spotifyAPI.apiRequestLogger.logLevel = .trace
        self.spotifyAPI.authorizationManager.authorize()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("application authorized")
                case .failure(let error):
                    print(error)
                }
            })
            .store(in: &cancellables)
        
    }
}
