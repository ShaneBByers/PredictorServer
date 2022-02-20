//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation

struct WebServerConnector
{
    let baseUrl = "http://www.nhl-predictor.com/"
    
    func getData<T: Encodable>(from filename: String, with jsonObject: T) -> String?
    {
        var returnString : String? = nil
        if let url = URL(string: baseUrl + filename)
        {
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(jsonObject)
            {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = body
                let semaphore = DispatchSemaphore(value: 0)
                URLSession.shared.dataTask(with: request)
                { data, response, error in
                    if let data = data
                    {
                        returnString = String(data: data, encoding: .utf8)
                    }
                    semaphore.signal()
                }.resume()
                semaphore.wait()
            }
        }
        return returnString
    }
}
