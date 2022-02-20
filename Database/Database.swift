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
    
    static func insert<T: Insertable>(_ insertables: [T], onlyColumns columns: [String]? = nil) -> Int?
    {
        if let url = URL(string: baseUrl + "insert.php")
        {
            let insertRequest = InsertRequest(insertables, usingColumns: columns)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(insertRequest)
            {
                if let jsonResponse = request(url, with: body)
                {
                    let decoder = JSONDecoder()
                    return try? decoder.decode(Int.self, from: jsonResponse)
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
        var tableName: String
        var columns: [String]
        var values: [T]
        
        init(_ insertables: [T], usingColumns cols: [String]? = nil)
        {
            let emptyT = T()
            tableName = emptyT.tableName
            values = insertables
            if let colArgs = cols
            {
                columns = colArgs
            }
            else
            {
                columns = emptyT.allColumns()
            }
        }
    }
    
    private struct SelectRequest<T: Selectable>: Encodable
    {
        var databaseLogin = DatabaseLogin()
        var tableName: String
        var columns: [String]?
        
        init(usingColumns cols: [String]? = nil)
        {
            tableName = T().tableName
            columns = cols
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
