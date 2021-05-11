//
//  API.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import Foundation
import SwiftSoup

class API {
    class func getHotTopics(completion: @escaping ([Topic]) -> Void) {
        let url = "https://www.v2ex.com/api/topics/hot.json"
        HTTPClient.request(url: url, successHandler: {
            (data: Data) in
            do {
                let topics = try JSONDecoder().decode([Topic].self, from: data)
                completion(topics)
            } catch {
                print("json decode error: \(error)")
            }
        }, failHandler: {
            (error: Error) in
            print("error: \(error)")
        })
    }
}
