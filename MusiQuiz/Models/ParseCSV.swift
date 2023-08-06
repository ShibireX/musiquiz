//
//  ParseCSV.swift
//  MusiQuiz
//
//  Created by Andreas Garcia on 2023-08-03.
//

import Foundation
import SwiftCSV

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
                      //popularity > 90
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
