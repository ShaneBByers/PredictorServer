//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation

print("START")

func getData(from url: String) -> String?
{
    let url = URL(string: url)
    var returnString: String?
    if let url = url
    {
        let group = DispatchGroup()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "SHANE".data(using: .utf8)
        group.enter()
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data
            {
                returnString = String(data: data, encoding: .utf8)
            }
            group.leave()
        }
        dataTask.resume()
        group.wait()
    }
    return returnString
}

let returnString = getData(from: "http://www.nhl-predictor.com")
if let printString = returnString
{
    print(printString)
}
