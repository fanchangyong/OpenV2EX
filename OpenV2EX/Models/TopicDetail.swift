//
//  TopicDetail.swift
//  OpenV2EX
//
//  Created by fancy on 5/14/21.
//

import Foundation

struct TopicDetail: Codable, Equatable {
    let url: String
    let title: String
    let node: String?
    let member: String
    let avatarURL: String
    let postAt: String
    let replyCount: String
    let content: String
    
    init(topic: Topic, content: String) {
        self.url = topic.url
        self.title = topic.title
        self.node = topic.node
        self.member = topic.member
        self.avatarURL = topic.avatarURL
        self.postAt = topic.postAt
        self.replyCount = topic.replyCount
        self.content = content
    }
}
