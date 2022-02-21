//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

typealias ColumnsMap = [(name: String, rawValue: String)]

typealias WhereClause = (columnName: String, operation: WhereOperation, value: Any?)

struct Database
{
    static let baseUrl = "http://www.nhl-predictor.com/"
    
    static func insert<T: DatabaseTable>(_ insertables: [T], columns: ColumnsMap) -> Int?
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
    
    static func update<T: DatabaseTable>(_ updatable: T, _ columns: ColumnsMap, _ whereClauses: [WhereClause]) -> Int?
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
    
    static func delete(from tableName: String, _ whereClauses: [WhereClause]) -> Int?
    {
        if let url = URL(string: baseUrl + "transaction.php")
        {
            let deleteRequest = DeleteRequest(tableName, whereClauses)
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(deleteRequest)
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
    
    static func select<T: DatabaseTable>(_ whereClauses: [WhereClause]? = nil, _ columns: ColumnsMap? = nil) -> [T]?
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
}
