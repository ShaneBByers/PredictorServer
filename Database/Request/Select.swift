//
//  Select.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

struct Select: DatabaseRequest
{
    var databaseLogin = DatabaseLogin()
    var queryList: [String] = []
    
    init<TableT: DatabaseTable>(_ table: TableT.Type, where whereClause: Where? = nil)
    {
        if let whereClause = whereClause {
            self.init(table, where: [whereClause])
        }
        else
        {
            self.init(table)
        }
    }
    
    init<TableT: DatabaseTable>(_ table: TableT.Type, including cols: [TableT.ColumnType]? = nil, where whereClauses: [Where]? = nil)
    {
        var query = "SELECT "
        if let cols = cols
        {
            query += "("
            for col in cols
            {
                query += "\(col), "
            }
            query.removeLast(2)
            query += ")"
        }
        else
        {
            query += "*"
        }
        query += " FROM \(table.tableName)"
        if let whereClauses = whereClauses
        {
            query += Select.getWhereString(whereClauses)
        }
        query += ";"
    }
}
