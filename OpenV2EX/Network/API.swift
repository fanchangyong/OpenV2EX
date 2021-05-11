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
    
    class func getTopicsByTab(_ tab: String, completion: @escaping ([Topic]) -> Void) {
        let url = "https://v2ex.com/?tab=\(tab)"
        HTTPClient.request(url: url, successHandler: { (data: Data) in
            do {
                var topics: [Topic] = [];
                
                let html = String(decoding: data, as: UTF8.self)
                let doc = try SwiftSoup.parse(html)
                let items = try doc.select("#Main .box .cell.item")
                for item in items {
                    let title = try item.select("table tbody tr .item_title a").first()?.text() ?? ""
                    print("title: \(title)")
                    let topic = Topic(id: 1, url: title, title: title)
                    topics.append(topic)
                }
                completion(topics)
                print("items: \(items.count)")
            } catch {
            }
        }, failHandler: {
            (error: Error) in
            print("get topics by tab error: \(error)")
        })
    }
}
