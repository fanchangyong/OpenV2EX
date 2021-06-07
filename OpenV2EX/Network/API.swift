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

let BASE_URL = "https://v2ex.com"

class API {
    class func getHotTopics(completion: @escaping ([Topic]) -> Void) {
        let url = "\(BASE_URL)/api/topics/hot.json"
        HTTPClient.request(url: url, successHandler: {
            (data: Data) in
            do {
                let json = try JSON(data: data)
                var topics: [Topic] = []
                for element in json.arrayValue {
                    let id = element["id"].intValue
                    let title = element["title"].string ?? ""
                    let node = element["node"]["title"].string ?? ""
                    let member = element["member"]["username"].string ?? ""
                    let avatarURL = element["member"]["avatar_normal"].string ?? ""
                    let replyCount = element["replies"].string ?? ""
                    let topic = Topic(id: id, title: title, node: node, member: member, avatarURL: avatarURL, postAt: "", replyCount: replyCount)
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
        let url = "\(BASE_URL)\(tab)"
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
                    let id = getTopicIdFromRelativeURL(url: url)
                    let node = try row.select(".topic_info .node").first()?.text() ?? ""
                    let member = try row.select(".topic_info strong a[href*=\"member\"]").first()?.text() ?? ""
                    let lastReplyAt = try row.select(".topic_info > span").first()?.text() ?? ""
                    let replyCount = try row.select(".count_livid").first()?.text() ?? ""
                    let avatarURL = try row.select("img.avatar").first()?.attr("src") ?? ""

                    let topic = Topic(id: id, title: title, node: node, member: member, avatarURL: avatarURL, lastReplyAt: lastReplyAt, replyCount: replyCount)
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
                    let text = try element.text()
                    let href = try element.attr("href")
                    var url: String = href
                    if !href.starts(with: "http://") && !href.starts(with: "https://") {
                        url = "https://v2ex.com\(href)"
                    }
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
                let font = UIFont.systemFont(ofSize: 14)
                let color = UIColor.label
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = font.lineHeight * 0.4
                attrString.append(NSAttributedString(string: n.text(), attributes: [.font: font,.foregroundColor: color, .paragraphStyle: paragraphStyle]))
            }
        }
    }
    
    class func getTopicDetail(topicId: Int, page: Int, completion: @escaping (Topic, [Reply]) -> Void) {
        let url = "\(BASE_URL)/t/\(topicId)?p=\(page)"
        HTTPClient.request(url: url, successHandler: {(data: Data) in
            let html = String(decoding: data, as: UTF8.self)
            do {
                let doc = try SwiftSoup.parse(html)
                
                let header = try doc.select("#Main .box .header")
                let title = try header.select("h1").first()?.text() ?? ""
                let node = try header.select("a[href*=/go/]").first()?.text() ?? ""
                let member = try header.select("small.gray a[href*=/member/]").first()?.text() ?? ""
                let avatarURL = try header.select(".fr a[href*=/member/] img").first()?.attr("src") ?? ""
                let postAt = try header.select("small.gray span[title]:nth-child(2)").first()?.text() ?? ""
                let topicContent = try doc.select("#Main .box .cell .topic_content").first()?.outerHtml() ?? ""
                
                let lastPage = try doc.select("#Main .box .cell table tbody tr td a.page_current,#Main .box .cell table tbody tr td a.page_normal").last()?.text() ?? ""
                
                // get subtitles
                let subtitleElements = try doc.select("#Main .box .subtle")
                var appendices: [Appendix] = []
                for (index, element) in subtitleElements.enumerated() {
                    let postAt = try element.select("span.fade span[title]").first()?.text() ?? ""
                    let content = try element.select(".topic_content").first()?.text() ?? ""
                    let appendix = Appendix(index: index, postAt: postAt, content: content)
                    appendices.append(appendix)
                }
                
                let topic = Topic(id: topicId, title: title, node: node, member: member, avatarURL: avatarURL, postAt: postAt, replyCount: "", content: topicContent, appendices: appendices, replyTotalPage: Int(lastPage))
                
                // get replys
                let replyElements = try doc.select("#Main .box .cell[id*=r_]")
                var replies: [Reply] = []
                for element in replyElements {
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

                completion(topic, replies)
            } catch {
                print("catched error of get topic detail: \(error)")
            }

        }, failHandler: { (error: Error) in
            print("get topic detail error: \(error)")
        })
    }
    
    class func getTopicsByNode(_ node: String, page: Int, completion: @escaping ([Topic], Int) -> Void) {
        let url = "\(BASE_URL)\(node)?p=\(page)"
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
                    let id = getTopicIdFromRelativeURL(url: url)
                    let member = try row.select(".topic_info strong a[href*=\"member\"]").first()?.text() ?? ""
                    let postAt = try row.select(".topic_info > span").first()?.text() ?? ""
                    let replyCount = try row.select(".count_livid").first()?.text() ?? ""
                    let avatarURL = try row.select("img.avatar").first()?.attr("src") ?? ""
                    
                    let topic = Topic(id: id, title: title, node: nil, member: member, avatarURL: avatarURL, postAt: postAt, replyCount: replyCount)
                    topics.append(topic)
                }
                
                let pages = try doc.select(".cell table tbody tr td a.page_normal, .cell table tbody tr td a.page_current")
                let lastPage = try pages.last()?.text() ?? ""
                completion(topics, Int(lastPage) ?? 1)
            } catch {
            }
        }, failHandler: {
            (error: Error) in
            print("get topics by tab error: \(error)")
        })
    }
}
