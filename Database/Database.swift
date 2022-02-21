//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

typealias ColumnsMap = [(name: String, rawValue: String)]

typealias WhereClause = (columnName: String, operation: WhereOperation, value: Any?)

enum WhereOperation: String
{
    case lt = "<"
    case lte = "<="
    case gt = ">"
    case gte = ">="
    case eq = "="
    case neq = "!="
}

struct Database
{
    static let baseUrl = "http://www.nhl-predictor.com/"
    
    static func insert<T: Insertable>(_ insertables: [T], columns: ColumnsMap) -> Int?
    {
        if let url = URL(string: baseUrl + "transaction.php")
        {
            let insertRequest = InsertRequest(insertables, columns: columns)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(insertRequest)
            {
                if let jsonResponse = request(url, with: body)
                {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(Int.self, from: jsonResponse)
                    {
                        return decoded
                    }
                    print(String(data: jsonResponse, encoding: .utf8)!)
                }
            }
        }
        return nil
    }
    
    static func update<T: Updatable>(_ updatable: T, _ columns: ColumnsMap, _ whereClauses: [WhereClause]) -> Int?
    {
        if let url = URL(string: baseUrl + "transaction.php")
        {
            let updateRequest = UpdateRequest(updatable, columns: columns, whereClauses: whereClauses)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(updateRequest)
            {
                if let jsonResponse = request(url, with: body)
                {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(Int.self, from: jsonResponse)
                    {
                        return decoded
                    }
                    print(String(data: jsonResponse, encoding: .utf8)!)
                }
            }
        }
        return nil
    }
    
    static func select<T: Selectable>(_ whereClauses: [WhereClause]? = nil, _ columns: ColumnsMap? = nil) -> [T]?
    {
        if let url = URL(string: baseUrl + "select.php")
        {
            let selectRequest = SelectRequest<T>(whereClauses: whereClauses, columns: columns)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(selectRequest)
            {
                if let jsonResponse = request(url, with: body)
                {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode([T].self, from: jsonResponse)
                    {
                        return decoded
                    }
                    print(String(data: jsonResponse, encoding: .utf8)!)
                }
            }
        }
        return nil
    }
    
    private static func request(_ url: URL, with body: Data) -> Data?
    {
        var jsonResponse: Data? = nil
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request)
        { data, response, error in
            jsonResponse = data
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return jsonResponse
    }
    
    private static func dbString(_ value: Any?) -> String
    {
        switch value
        {
            case let intValue as Int:
                return "\(intValue)"
            case let stringValue as String:
                return "'\(stringValue)'"
            default:
                return "NULL"
        }
    }
    
    private struct InsertRequest<T: Insertable>: Encodable
    {
        var databaseLogin = DatabaseLogin()
        var query: String
        
        init(_ insertables: [T], columns: ColumnsMap)
        {
            let emptyT = T()
            query = "INSERT INTO " + emptyT.tableName + " ("
            for (_, rawValue) in columns
            {
                query += "\(rawValue), "
            }
            query.removeLast(2)
            query += ") VALUES "
            for insertable in insertables {
                query += "("
                for dbValue in getStringValues(insertable, forNames: columns.map { $0.name })
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
        
        private func getStringValues(_ insertable: T, forNames enumNames: [String]) -> [String]
        {
            var returnList: [String] = []
            let mirror = Mirror(reflecting: insertable.self)
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
    
    private struct UpdateRequest<T: Updatable>: Encodable
    {
        var databaseLogin = DatabaseLogin()
        var query: String
        
        init(_ updatable: T, columns: ColumnsMap, whereClauses: [WhereClause])
        {
            query = "UPDATE \(updatable.tableName) SET "
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
        
        private func getStringValue<T: Updatable>(_ updatable: T, forName enumName: String) -> String
        {
            let mirror = Mirror(reflecting: updatable.self)
            if let property = mirror.children.first(where: { $0.label == enumName })
            {
                return dbString(property.value)
            }
            return "NULL"
        }
    }
    
    private struct SelectRequest<T: Selectable>: Encodable
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
            query += " FROM \(T().tableName)"
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
    
    private struct DatabaseLogin : Encodable
    {
        let serverName = ConstantStrings.DB_SERVER_NAME.rawValue
        let username = ConstantStrings.DB_USERNAME.rawValue
        let password = ConstantStrings.DB_PASSWORD.rawValue
        let databaseName = ConstantStrings.DB_DATABASE_NAME.rawValue
    }
}
