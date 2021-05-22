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

    class func getTopicsByTab(_ tab: String, completion: @escaping ([Topic], [Tab], [Tab]) -> Void) {
        let url = "https://v2ex.com\(tab)"
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
                
                let tabNodes = try doc.select("#Main .box #Tabs a[href*=tab]")
                var tabs: [Tab] = []
                for tabNode in tabNodes {
                    let name = try tabNode.text()
                    let url = try tabNode.attr("href")
                    let tab = Tab(name: name, url: url)
                    tabs.append(tab)
                }
                
                let secTabNodes = try doc.select("#Main .box #SecondaryTabs a[href*=go]")
                var secTabs: [Tab] = []
                for tabNode in secTabNodes {
                    let name = try tabNode.text()
                    let url = try tabNode.attr("href")
                    let tab = Tab(name: name, url: url)
                    secTabs.append(tab)
                }
                completion(topics, tabs, secTabs)
            } catch {
            }
        }, failHandler: {
            (error: Error) in
            print("get topics by tab error: \(error)")
        })
    }
    
    class func getTopicDetail(url: String, completion: @escaping (String, [Reply]) -> Void) {
        HTTPClient.request(url: url, successHandler: {(data: Data) in
            let html = String(decoding: data, as: UTF8.self)
            do {
                let doc = try SwiftSoup.parse(html)
                let topicContent = try doc.select("#Main .box .cell .topic_content").first()?.outerHtml() ?? ""
                
                // get replys
                let replyElements = try doc.select("#Main .box .cell[id*=r_]")
                var replies: [Reply] = []
                for element in replyElements {
                    // print("reply element: \(element)")
                    let avatarURL = try element.select("td img.avatar").attr("src")
                    let member = try element.select("td strong a[href*=member]").first()?.text() ?? ""
                    let postAt = try element.select("td span.ago[title]").first()?.text() ?? ""
                    let content = try element.select("td div.reply_content").first()?.text() ?? ""
                    let heartCount = try element.select("td img[src*=heart][alt=❤️]").first()?.nextSibling()
                    replies.append(Reply(avatarURL: avatarURL, member: member, postAt: postAt, heartCount: "", content: content))
                }

                completion(topicContent, replies)
            } catch {
                print("catched error of get topic detail: \(error)")
            }

        }, failHandler: { (error: Error) in
            print("get topic detail error: \(error)")
        })
    }
    
    class func getTopicsByNode(_ node: String, completion: @escaping ([Topic]) -> Void) {
        let url = "https://v2ex.com\(node)"
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
