//
//  Insert.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/20/22.
//

import Foundation

typealias ColumnsMap = [(name: String, rawValue: String)]

protocol Insertable: Encodable
{
    var tableName: String { get }
    init()
}
