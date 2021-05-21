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
                    let row = try item.select("table tbody tr")
                    let title = try row.select(".item_title a").first()?.text() ?? ""
                    let url = try row.select(".item_title a").first()?.attr("href") ?? ""
                    let node = try row.select(".topic_info .node").first()?.text() ?? ""
                    let member = try row.select(".topic_info strong a[href*=\"member\"]").first()?.text() ?? ""
                    let postAt = try row.select(".topic_info > span").first()?.text() ?? ""
                    let replyCount = try row.select(".count_livid").first()?.text() ?? ""
                    let avatarURL = try row.select("img.avatar").first()?.attr("src") ?? ""

                    let completeURL = "https://v2ex.com\(url)"
                    
                    let topic = Topic(url: completeURL, title: title, node: node, member: member, avatarURL: avatarURL, postAt: postAt, replyCount: replyCount)
                    topics.append(topic)
                }
                completion(topics)
            } catch {
            }
        }, failHandler: {
            (error: Error) in
            print("get topics by tab error: \(error)")
        })
    }
    
    class func getTopicDetail(url: String, completion: @escaping (String) -> Void) {
        HTTPClient.request(url: url, successHandler: {(data: Data) in
            let html = String(decoding: data, as: UTF8.self)
            print("html: \(html)")
            do {
                let doc = try SwiftSoup.parse(html)
                /*
                let headerNode = try doc.select("#Main .box .header")
                let title = try headerNode.select("h1").first()?.text() ?? ""
                let node = try headerNode.select(".chevron+a").first()?.text() ?? ""
                let memberNode = try headerNode.select(".votes+small.gray a[href*=member]").first()
                let member = try memberNode?.text() ?? ""
                let avatarURL = try headerNode.select(".fr a img.avatar").first()?.attr("src") ?? ""
                let postAt = try memberNode?.select("+span").first()?.text()
                print("post at: \(postAt)")
                */
                let topicContent = try doc.select("#Main .box .cell .topic_content").first()?.outerHtml() ?? ""
                print("topic content: \(topicContent)")
                completion(topicContent)
                /*
                let topicDetail = TopicDetail(content: topicContent)
                completion(topicDetail)
                print("topic content: \(topicContent)")
                */
            } catch {
                print("catched error of get topic detail: \(error)")
            }

        }, failHandler: { (error: Error) in
            print("get topic detail error: \(error)")
        })
    }
    
    class func getTopicsByNode(_ node: String, completion: @escaping ([Topic]) -> Void) {
        let url = "https://v2ex.com/go/\(node)"
        HTTPClient.request(url: url, successHandler: { (data: Data) in
            do {
                var topics: [Topic] = [];
                
                let html = String(decoding: data, as: UTF8.self)
                let doc = try SwiftSoup.parse(html)
                let items = try doc.select("#TopicsNode .cell")
                for item in items {
                    let row = try item.select("table tbody tr")
                    let title = try row.select(".item_title a").first()?.text() ?? ""
                    let url = try row.select(".item_title a").first()?.attr("href") ?? ""
                    let member = try row.select(".topic_info strong a[href*=\"member\"]").first()?.text() ?? ""
                    let postAt = try row.select(".topic_info > span").first()?.text() ?? ""
                    let replyCount = try row.select(".count_livid").first()?.text() ?? ""
                    let avatarURL = try row.select("img.avatar").first()?.attr("src") ?? ""

                    let completeURL = "https://v2ex.com\(url)"
                    
                    let topic = Topic(url: completeURL, title: title, node: nil, member: member, avatarURL: avatarURL, postAt: postAt, replyCount: replyCount)
                    topics.append(topic)
                }
                completion(topics)
            } catch {
            }
        }, failHandler: {
            (error: Error) in
            print("get topics by tab error: \(error)")
        })
    }
}
