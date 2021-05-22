//
//  Topic.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import Foundation

struct Topic: Codable, Equatable {
    let url: String
    let title: String
    let node: String?
    let member: String
    let avatarURL: String
    let postAt: String
    let replyCount: String
    var content: String?
}
