//
//  Reply.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import Foundation

struct Reply: Codable, Equatable {
    let avatarURL: String
    let member: String
    let postAt: String
    var heartCount: String?
    let content: String
}

enum ReplyContentElement {
    case text(str: String)
    case image(url: String)
    case br
    case link(url: String)
}
