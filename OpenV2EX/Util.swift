//
//  Util.swift
//  OpenV2EX
//
//  Created by fancy on 6/6/21.
//

import Foundation

func getTopicIdFromRelativeURL(url: String) -> Int {
    // url is like: /t/780185#reply8
    let startInex = url.index(url.startIndex, offsetBy: 3)
    let endIndex = url.firstIndex(of: "#") ?? url.endIndex
    let id = Int(url[startInex..<endIndex])!
    return id
}
