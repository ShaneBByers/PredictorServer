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
    
    static func insert<T: Insertable>(values insertables: [T]) -> InsertResponse?
    {
        var insertResponse: InsertResponse? = nil
        if let url = URL(string: baseUrl + "insert.php")
        {
            if let insertRequest = InsertRequest(insertables: insertables)
            {
                let encoder = JSONEncoder()
                if let body = try? encoder.encode(insertRequest)
                {
                    if let jsonResponse = request(url, with: body)
                    {
                        let decoder = JSONDecoder()
                        insertResponse = try? decoder.decode(InsertResponse.self, from: jsonResponse)
                    }
                }
            }
        }
        return insertResponse
    }
    
    static func select<T: Selectable>(from selectable: T) -> SelectResponse<T>?
    {
        var selectResponse: SelectResponse<T>? = nil
        if let url = URL(string: baseUrl + "select.php")
        {
            let selectRequest = SelectRequest(selectable: selectable)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(selectRequest)
            {
                if let jsonResponse = request(url, with: body)
                {
                    let decoder = JSONDecoder()
                    selectResponse = try? decoder.decode(SelectResponse<T>.self, from: jsonResponse)
                }
            }
        }
        return selectResponse
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
        var values: [T]
        
        init?(insertables: [T])
        {
            if let firstInsertable = insertables.first
            {
                tableName = firstInsertable.tableName
            }
            else
            {
                return nil
            }
            values = insertables
        }
    }
    
    private struct SelectRequest: Encodable
    {
        var databaseLogin = DatabaseLogin()
        var tableName: String
        
        init(selectable: Selectable)
        {
            tableName = selectable.tableName
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
