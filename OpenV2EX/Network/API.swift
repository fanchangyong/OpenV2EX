//
//  API.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import Foundation
import UIKit
import Kingfisher
import SwiftSoup
import SwiftyJSON

class API {
    class func getHotTopics(completion: @escaping ([Topic]) -> Void) {
        let url = "https://www.v2ex.com/api/topics/hot.json"
        HTTPClient.request(url: url, successHandler: {
            (data: Data) in
            do {
                let json = try JSON(data: data)
                var topics: [Topic] = []
                for element in json.arrayValue {
                    let url = element["url"].string ?? ""
                    let title = element["title"].string ?? ""
                    let node = element["node"]["title"].string ?? ""
                    let member = element["member"]["username"].string ?? ""
                    let avatarURL = element["member"]["avatar_normal"].string ?? ""
                    let replyCount = element["replies"].string ?? ""
                    let topic = Topic(url: url, title: title, node: node, member: member, avatarURL: avatarURL, postAt: "", replyCount: replyCount)
                    topics.append(topic)
                }
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
    
    class func parseAttributedString(attrString: NSMutableAttributedString, nodes: [Node]?) throws {
        guard let nodes = nodes else {
           return
        }
        for node in nodes {
            if let element = node as? Element {
                switch element.tagName() {
                case "a":
                    // try parseAttributedString(attrString: attrString, nodes: element.getChildNodes())
                    let text = try element.text()
                    let href = try element.attr("href")
                    var url: String = href
                    if !href.starts(with: "http://") && !href.starts(with: "https://") {
                        url = "https://v2ex.com\(href)"
                    }
                    // let color = UIColor(red: 119/255, green: 128/255, blue: 135/255, alpha: 1)
                    attrString.append(NSAttributedString(string: text, attributes: [.link: url, .font: UIFont.systemFont(ofSize: 14)]))
                    
                    // continue to parse other elements
                    let childElements = element.getChildNodes().filter{ ($0 is Element) }
                    if childElements.count > 0 {
                        try parseAttributedString(attrString: attrString, nodes: childElements)
                    }
                case "br":
                    attrString.append(NSAttributedString(string: "\n"))
                case "img":
                    let url = try element.attr("src")
                    let attachment = AsyncTextAttachment(imageURL: URL(string: url)!)
                    attrString.append(NSAttributedString(attachment: attachment))
                default:
                    print("other element: \(element.tagName())")
                }
            } else if let n = node as? TextNode {
                attrString.append(NSAttributedString(string: n.text(), attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.label]))
            }
        }
    }
    
    class func getTopicDetail(url: String, completion: @escaping (String, [Appendix], [Reply]) -> Void) {
        HTTPClient.request(url: url, successHandler: {(data: Data) in
            let html = String(decoding: data, as: UTF8.self)
            do {
                let doc = try SwiftSoup.parse(html)
                let topicContent = try doc.select("#Main .box .cell .topic_content").first()?.outerHtml() ?? ""
                
                // get subtitles
                let subtitleElements = try doc.select("#Main .box .subtle")
                var appendices: [Appendix] = []
                for (index, element) in subtitleElements.enumerated() {
                    let postAt = try element.select("span.fade span[title]").first()?.text() ?? ""
                    let content = try element.select(".topic_content").first()?.text() ?? ""
                    let appendix = Appendix(index: index, postAt: postAt, content: content)
                    appendices.append(appendix)
                }
                
                // get replys
                let replyElements = try doc.select("#Main .box .cell[id*=r_]")
                var replies: [Reply] = []
                for element in replyElements {
                    // print("reply element: \(element)")
                    let avatarURL = try element.select("td img.avatar").attr("src")
                    let member = try element.select("td strong a[href*=member]").first()?.text() ?? ""
                    let postAt = try element.select("td span.ago[title]").first()?.text() ?? ""
                    let contentNodes = try element.select("td div.reply_content").first()?.getChildNodes()
                    let attrString = NSMutableAttributedString()
                    
                    try parseAttributedString(attrString: attrString, nodes: contentNodes)

                    let heartNode = try element.select("td img[src*=heart][alt=❤️]").first()?.nextSibling()
                    var heartCount: String? = nil
                    if let heartText = ((heartNode as? TextNode)?.getWholeText()) {
                        heartCount = heartText
                    }
                    replies.append(Reply(avatarURL: avatarURL, member: member, postAt: postAt, heartCount: heartCount, content: attrString))
                }

                completion(topicContent, appendices, replies)
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
