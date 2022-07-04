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
    
    mutating public func insert<TableT: DatabaseTable, EnumT: RawRepresentable>(_ table: TableT.Type, _ columns: [EnumT], _ columnNameToValueMapList: [ColumnNameToValueMap]) where EnumT.RawValue == String
    {
        var query = "INSERT INTO \(table.tableName) ("
        for columnName in columns.map({ $0.rawValue })
        {
            query += "\(columnName), "
        }
        query.removeLast(2)
        query += ") VALUES "
        for columnNameToValueMap in columnNameToValueMapList {
            query += "("
            for columnName in columns.map({ $0.rawValue })
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
    
    mutating public func update<TableT: DatabaseTable>(_ table: TableT.Type, _ columnNameToValueMap: ColumnNameToValueMap, _ whereClauses: [Where])
    {
        var query = "UPDATE \(table.tableName) SET "
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
    
    mutating public func delete<TableT: DatabaseTable>(_ table: TableT.Type, _ whereClauses: [Where])
    {
        var query = "DELETE FROM \(table.tableName) "
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
