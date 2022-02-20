//
//  Selectable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

protocol Selectable : Codable
{
    var tableName: String { get }
}
