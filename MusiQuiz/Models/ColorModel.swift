//
//  ColorModel.swift
//  Spotimy
//
//  Created by Andreas Garcia on 2023-07-21.
//

import Foundation
import SwiftUI

struct ColorModel {
    static let mainColor = Color(red: 242/255, green: 242/255, blue: 242/255)
    static let accentColor = Color(red: 245/255, green: 161/255, blue: 59/255)
    static let textColor = Color(red: 225/255, green: 227/255, blue: 242/255)
    
    static let quizColors: [String: [Color]] = ["top_100": [Color(red: 45/255, green: 56/255, blue: 138/255), Color(red: 0/255, green: 174/255, blue: 239/255)],
                                                "k_pop": [Color(red: 254/255, green: 141/255, blue: 198/255), Color(red: 254/255, green: 209/255, blue: 199/255)],
                                                "swedish": [Color(red: 245/255, green: 85/255, blue: 85/255), Color(red: 250/255, green: 220/255, blue: 95/255)],
                                                "anime": [Color(red: 108/255, green: 0/255, blue: 205/255), Color(red: 225/255, green: 0/255, blue: 255/255)],
                                                "latino_trap": [Color(red: 233/255, green: 109/255, blue: 113/255), Color(red: 254/255, green: 182/255, blue: 146/255)],
                                                "swedish_hip_hop": [Color(red: 51/255, green: 204/255, blue: 188/255), Color(red: 144/255, green: 247/255, blue: 237/255)]]
}
