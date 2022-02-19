//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

func getData(from url: String) -> String?
{
    var returnString: String? = nil
    let url = URL(string: url)
    if let url = url
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "ABC".data(using: .utf8)
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data
            {
                returnString = String(data: data, encoding: .utf8)
            }
            semaphore.signal()
        }
        dataTask.resume()
        semaphore.wait()
    }
    return returnString
}

let returnString = getData(from: "http://www.nhl-predictor.com/test.php")
if let printString = returnString
{
    print(printString)
}
