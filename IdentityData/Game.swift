//
//  Game.swift
//  Predictor
//
//  Created by Shane Byers on 12/25/21.
//

import Foundation

struct Game
{
    var id: Int
    var teams: [(Team, Venue)]
    var dateTime: Date
    var season: Season
}
