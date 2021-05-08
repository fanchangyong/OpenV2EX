//
//  HTTPClient.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import Foundation

enum HTTPError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
    case encodingError
}

class HTTPClient {
    class func request(url: String, successHandler: @escaping (Data) -> (Void), failHandler: @escaping (Error) -> (Void)) {
        print("### http client request: \(url)")
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                DispatchQueue.main.async {
                    failHandler(err)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    failHandler(HTTPError.badResponse)
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    failHandler(HTTPError.badStatusCode(httpResponse.statusCode))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    failHandler(HTTPError.badData)
                }
                return
            }

            DispatchQueue.main.async {
                successHandler(data);
                return
            }
        }
        task.resume()
    }
}