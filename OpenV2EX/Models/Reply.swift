//
//  Reply.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import Foundation

struct Reply: Equatable {
    let avatarURL: String
    let member: String
    let postAt: String
    var heartCount: String?
    let content: NSMutableAttributedString
}

enum ReplyContentElement {
    case text(str: String)
    case image(url: String)
    case br
    case link(url: String)
}
