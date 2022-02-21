//
//  DeleteRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

struct DeleteRequest: Encodable
{
    var databaseLogin = DatabaseLogin()
    var query: String
    
    init(_ tableName: String, _ whereClauses: [WhereClause])
    {
        query = "DELETE FROM \(tableName) WHERE "
        for whereClause in whereClauses {
            let stringValue = dbString(whereClause.value)
            query += "\(whereClause.columnName) \(whereClause.operation.rawValue) \(stringValue) AND "
        }
        query.removeLast(5);
        query += ";"
        print(query)
    }
}
