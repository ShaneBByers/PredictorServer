//
//  TransactionRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/26/22.
//

import Foundation

struct TransactionRequest: Encodable
{
    var queryList: [String] = []
    
    mutating public func insert(_ tableName: String, _ columnNames: ColumnNames, _ columnNameToValueMapList: [ColumnNameToValueMap])
    {
        var query = "INSERT INTO \(tableName) ("
        for columnName in columnNames
        {
            query += "\(columnName), "
        }
        query.removeLast(2)
        query += ") VALUES "
        for columnNameToValueMap in columnNameToValueMapList {
            query += "("
            for columnName in columnNames
            {
                if let encodableValue = columnNameToValueMap[columnName]
                {
                    let databaseString = getDatabaseString(encodableValue)
                    query += "\(databaseString), "
                }
            }
            query.removeLast(2)
            query += "), "
        }
        query.removeLast(2)
        query += ";"
        queryList.append(query)
    }
    
    mutating public func update(_ tableName: String, _ columnNameToValueMap: ColumnNameToValueMap, _ whereClauses: [Where])
    {
        var query = "UPDATE \(tableName) SET "
        for (columnName, value) in columnNameToValueMap
        {
            let databaseString = getDatabaseString(value)
            query += "\(columnName) = \(databaseString), "
        }
        query.removeLast(2)
        query += " "
        query += getWhereString(whereClauses)
        query += ";"
        queryList.append(query)
    }
    
    mutating public func delete(_ tableName: String, _ whereClauses: [Where])
    {
        var query = "DELETE FROM \(tableName) "
        query += getWhereString(whereClauses)
        query += ";"
        queryList.append(query)
    }
    
    private func getWhereString(_ whereClauses: [Where]) -> String
    {
        var whereString = "WHERE "
        for whereClause in whereClauses {
            whereString += "\(whereClause.column) \(whereClause.operation) \(whereClause.value) AND "
        }
        whereString.removeLast(5)
        return whereString
    }
    
    private func getDatabaseString(_ encodable: Encodable?) -> String
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
