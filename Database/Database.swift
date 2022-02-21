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
    private static let baseUrl = "http://www.nhl-predictor.com/"
    private static let transactionPHP = "transaction.php"
    private static let selectPHP = "select.php"
    
    static func insert<T: DatabaseTable>(_ insertables: [T], _ columns: ColumnsMap) -> Int?
    {
        return getResponse(from: transactionPHP, using: InsertRequest(insertables, columns))
    }
    
    static func update<T: DatabaseTable>(_ updatable: T, _ columns: ColumnsMap, _ whereClauses: [WhereClause]) -> Int?
    {
        return getResponse(from: transactionPHP, using: UpdateRequest(updatable, columns, whereClauses))
    }
    
    static func delete(from tableName: String, _ whereClauses: [WhereClause]) -> Int?
    {
        return getResponse(from: transactionPHP, using: DeleteRequest(tableName, whereClauses))
    }
    
    static func select<T: DatabaseTable>(_ whereClauses: [WhereClause]? = nil, _ columns: ColumnsMap? = nil) -> [T]?
    {
        return getResponse(from: selectPHP, using: SelectRequest<T>(whereClauses: whereClauses, columns: columns))
    }
    
    private static func getResponse<Request: DatabaseRequest, Return: Decodable>(from filename: String, using request: Request) -> Return?
    {
        if let url = URL(string: baseUrl + filename)
        {
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(request)
            {
                if let jsonResponse = executeRequest(url, with: body)
                {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(Return.self, from: jsonResponse)
                    {
                        return decoded
                    }
                    print(String(data: jsonResponse, encoding: .utf8)!)
                }
            }
        }
        return nil
    }
    
    private static func executeRequest(_ url: URL, with body: Data) -> Data?
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
