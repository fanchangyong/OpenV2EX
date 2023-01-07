//
//  Topic.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import Foundation

struct Appendix: Codable, Equatable {
    let index: Int
    let postAt: String
    let content: String
}

struct Topic: Codable, Equatable {
    let id: Int
    var title: String?
    var node: String?
    var member: String?
    var avatarURL: String?
    var postAt: String?
    var lastReplyAt: String?
    var replyCount: String?
    var content: String?
    var appendices: [Appendix] = []
    var replyTotalPage: Int?
    var read: Bool?
    var ignoreURL: String?
    
    var url: String {
        return "\(BASE_URL)/t/\(id)"
    }
}
