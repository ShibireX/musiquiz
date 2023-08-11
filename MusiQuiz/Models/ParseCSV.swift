//
//  ParseCSV.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import Foundation
import SwiftCSV
import SpotifyWebAPI

struct Artistt: Hashable {
    let artistId: String
    let popularity: Int
}

func parseArtistsFromCSV(file: String) -> [Artistt] {
    var artists: [Artistt] = []

    if let csvPath = Bundle.main.path(forResource: file, ofType: "csv") {
        do {
            let csv = try CSV<Named>(url: URL(fileURLWithPath: csvPath))

            for row in csv.rows {
                guard let artistId = row["id"],
                      let popularityStr = row["popularity"],
                      let popularity = Int(popularityStr)
                else {
                    continue
                }

                let artist = Artistt(artistId: artistId, popularity: popularity)
                artists.append(artist)
            }
        } catch {
            print("Error parsing CSV: \(error)")
        }
    }

    return artists
}

func parseTracksFromCSV(file: String) -> [SpotifyURIConvertible] {
    var tracks: [SpotifyURIConvertible] = []
    
    if let csvPath = Bundle.main.path(forResource: file, ofType: "csv") {
        do {
            let csv = try CSV<Named>(url: URL(fileURLWithPath: csvPath))
            
            for row in csv.rows {
                guard let trackId = row["id"] else {
                    continue
                }
                let track = "spotify:track:" + trackId
                tracks.append(track)
            }
        }
        catch {
            print("Error parsing CSV: \(error)")
        }
    }
    
    return tracks
}
