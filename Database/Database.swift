//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

struct Database
{
    static let baseUrl = "http://www.nhl-predictor.com/"
    
    static func insert<T: Insertable>(_ insertables: [T], columns: ColumnsMap) -> Int?
    {
        if let url = URL(string: baseUrl + "insert.php")
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
    
    static func select<T: Selectable>(onlyColumns columns: [String]? = nil) -> [T]?
    {
        if let url = URL(string: baseUrl + "select.php")
        {
            let selectRequest = SelectRequest<T>(usingColumns: columns)
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
            query += " VALUES ("
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
            query += ");"
            
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
        
        private func dbString(_ value: Any) -> String
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
    }
    
    private struct SelectRequest<T: Selectable>: Encodable
    {
        var databaseLogin = DatabaseLogin()
        var query: String
        
        init(usingColumns columns: [String]? = nil)
        {
            query = "SELECT "
            if let columnList = columns
            {
                query += " ("
                for column in columnList
                {
                    query += "\(column), "
                }
                query.removeLast(2)
            }
            else
            {
                query += "*"
            }
            query += " FROM \(T().tableName);"
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
