//
//  UpdateRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

struct UpdateRequest<T: DatabaseTable>: Encodable
{
    var databaseLogin = DatabaseLogin()
    var query: String
    
    init(_ updatable: T, columns: ColumnsMap, whereClauses: [WhereClause])
    {
        query = "UPDATE \(T.tableName) SET "
        for (enumName, dbName) in columns
        {
            query += "\(dbName) = \(getStringValue(updatable, forName: enumName)), "
        }
        query.removeLast(2)
        query += " WHERE "
        for whereClause in whereClauses {
            let stringValue = dbString(whereClause.value)
            query += "\(whereClause.columnName) \(whereClause.operation.rawValue) \(stringValue) AND "
        }
        query.removeLast(5);
        query += ";"
        print(query)
    }
    
    private func getStringValue<T: DatabaseTable>(_ updatable: T, forName enumName: String) -> String
    {
        let mirror = Mirror(reflecting: updatable.self)
        if let property = mirror.children.first(where: { $0.label == enumName })
        {
            return dbString(property.value)
        }
        return "NULL"
    }
}
