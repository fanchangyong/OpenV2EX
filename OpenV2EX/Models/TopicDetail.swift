//
//  TopicDetail.swift
//  OpenV2EX
//
//  Created by fancy on 5/14/21.
//

import Foundation

struct TopicDetail: Codable {
    let url: String
    let title: String
    let node: String?
    let member: String
    let avatarURL: String
    let postAt: String
    let replyCount: String
    let content: String
}
