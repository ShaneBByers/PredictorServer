//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation
import OSLog

let logger = Logger(subsystem: Logger.id, category: Logger.Category.testing.rawValue)

let setup = Setup()

setup.setupPlayerStatsAndPlayers()

let delete = Delete()

//delete.deletePlayerStatsAndPlayers()
