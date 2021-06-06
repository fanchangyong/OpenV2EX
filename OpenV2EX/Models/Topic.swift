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
    let title: String
    let node: String?
    let member: String
    let avatarURL: String
    let postAt: String
    let replyCount: String
    var content: String?
    var appendices: [Appendix] = []
    var replyTotalPage: Int?
    
    var url: String {
        return "\(BASE_URL)/t/\(id)"
    }
}
