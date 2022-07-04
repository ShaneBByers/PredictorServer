//
//  TransactionRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/26/22.
//

import Foundation

struct Transaction: Encodable
{
    var queryList: [String] = []
    
    mutating public func insert<TableT: DatabaseTable>(_ rows: [TableT])
    {        
        if !rows.isEmpty
        {
            let cols = TableT.editableColumns()
            
            var query = "INSERT INTO \(TableT.tableName) ("
            for col in cols
            {
                query += "\(col.rawValue), "
            }
            query.removeLast(2)
            query += ") VALUES "
            for row in rows
            {
                query += "("
                let valueDict = row.values()
                for col in cols
                {
                    if let encodableValue = valueDict[col]
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
    }
    
    mutating public func update<TableT: DatabaseTable>(_ row: TableT, columns cols: [TableT.ColumnType], where whereClauses: [Where])
    {
        var query = "UPDATE \(TableT.tableName) SET "
        let valueDict = row.values()
        for col in cols
        {
            if let encodableValue = valueDict[col]
            {
                let databaseString = getDatabaseString(encodableValue)
                query += "\(col.rawValue) = \(databaseString)"
            }
            query.removeLast(2)
            query += " "
            query += getWhereString(whereClauses)
            query += ";"
            queryList.append(query)
        }
    }
    
    mutating public func delete<TableT: DatabaseTable>(_ table: TableT.Type, where whereClauses: [Where])
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
