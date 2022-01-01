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
//        request.httpMethod = "POST"
//        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//        request.cachePolicy = .reloadRevalidatingCacheData
//        request.cachePolicy = .returnCacheDataElseLoad
//        request.httpMethod = "POST"
//        request.httpBody = "ABC".data(using: .utf8)
//        if let _ = URLCache.shared.cachedResponse(for: request)
//        {
//            print("CACHED")
//        }
//        group.enter()
        group.enter()
        let session = URLSession(configuration: .default)
        let socketTask = session.webSocketTask(with: request)
        socketTask.sendPing { error in
            print("PONG")
            group.leave()
        }
        
        socketTask.resume()
//        let dataTask = session.dataTask(with: request) { data, response, error in
//            if let data = data
//            {
//                returnString = String(data: data, encoding: .utf8)
//            }
//
//            group.leave()
//        }
//
//        dataTask.resume()
//        request.networkServiceType = .responsiveData
//        let cache = URLCache.shared.cachedResponse(for: request)
//        URLCache.shared.removeAllCachedResponses()

        group.wait()

    }
//    sleep(10000)
//    print("DONE WITH METHOD")
    return returnString
}

let returnString = getData(from: "http://www.nhl-predictor.com")
if let _ = returnString
{
    print("DONE")
}

//let testing = getData(from: "http://www.toonhq.com")
//print("SUPER DONE")
