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
    let heartCount: String
    let content: String
}
