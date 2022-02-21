//
//  InsertRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

struct InsertRequest<T: DatabaseTable>: DatabaseRequest
{
    let databaseLogin = DatabaseLogin()
    var query: String
    
    init(_ rows: [T], _ columns: ColumnsMap)
    {
        query = "INSERT INTO " + T.tableName + " ("
        for (_, rawValue) in columns
        {
            query += "\(rawValue), "
        }
        query.removeLast(2)
        query += ") VALUES "
        for row in rows {
            query += "("
            for dbValue in getStringValues(row, forNames: columns.map { $0.name })
            {
                query += "\(dbValue), "
            }
            query.removeLast(2)
            query += "), "
        }
        query.removeLast(2)
        query += ";"
        
        print(query)
    }
    
    private func getStringValues(_ row: T, forNames enumNames: [String]) -> [String]
    {
        var returnList: [String] = []
        let mirror = Mirror(reflecting: row.self)
        for enumName in enumNames
        {
            if let property = mirror.children.first(where: { $0.label == enumName })
            {
                returnList.append(dbString(property.value))
            }
        }
        return returnList
    }
}
