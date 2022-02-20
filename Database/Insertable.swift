//
//  Insert.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/20/22.
//

import Foundation

protocol Insertable: Encodable
{
    var tableName: String { get }
    init()
    func allColumns() -> [String]
}
