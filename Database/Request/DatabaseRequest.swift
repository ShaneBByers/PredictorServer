//
//  DatabaseRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

protocol DatabaseRequest: Encodable
{
    var databaseLogin: DatabaseLogin { get }
    var queryList: [String] { get }
}

extension DatabaseRequest
{
    static func getWhereString(_ whereClauses: [Where]) -> String
    {
        var whereString = "WHERE "
        for whereClause in whereClauses {
            whereString += "\(whereClause.column) \(whereClause.operation) \(whereClause.value) AND "
        }
        whereString.removeLast(5)
        return whereString
    }
    
    static func getDatabaseString(_ encodable: Encodable?) -> String
    {
        switch encodable
        {
            case let intValue as Int:
                return "\(intValue)"
            case let stringValue as String:
                return "'\(stringValue)'"
            default:
                return "NULL"
        }
    }
}
