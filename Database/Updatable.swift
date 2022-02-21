//
//  Update.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/20/22.
//

import Foundation

protocol Updatable: Encodable
{
    var tableName: String { get }
}
