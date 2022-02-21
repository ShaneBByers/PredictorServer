//
//  SelectRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

struct SelectRequest<T: DatabaseTable>: Encodable
{
    var databaseLogin = DatabaseLogin()
    var query: String
    
    init(whereClauses: [WhereClause]?, columns: ColumnsMap?)
    {
        query = "SELECT "
        if let columnList = columns
        {
            query += "("
            for (_, dbColumn) in columnList
            {
                query += "\(dbColumn), "
            }
            query.removeLast(2)
            query += ")"
        }
        else
        {
            query += "*"
        }
        query += " FROM \(T.tableName)"
        if let whereClauses = whereClauses {
            query += " WHERE "
            for whereClause in whereClauses {
                let stringValue = dbString(whereClause.value)
                query += "\(whereClause.columnName) \(whereClause.operation.rawValue) \(stringValue) AND "
            }
            query.removeLast(5);
        }
        query += ";"
        print(query)
    }
}
