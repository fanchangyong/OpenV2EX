//
//  Util.swift
//  OpenV2EX
//
//  Created by fancy on 6/6/21.
//

import Foundation
import UIKit

func getTopicIdFromRelativeURL(url: String) -> Int {
    // url is like: /t/780185#reply8
    let startInex = url.index(url.startIndex, offsetBy: 3)
    let endIndex = url.firstIndex(of: "#") ?? url.endIndex
    let id = Int(url[startInex..<endIndex])!
    return id
}

func tryOpenV2EXTopicURL(url: URL, in window: UIWindow?) -> Bool {
    let host = url.host
    let path = url.path
    if (host == "v2ex.com" || host == "www.v2ex.com") && path.starts(with: "/t/") {
        let id = getTopicIdFromRelativeURL(url: path)
        let topic = Topic(id: id)
        let vc = TopicDetailVC(topic: topic)
        if let navVC = window?.rootViewController as? UINavigationController {
            navVC.pushViewController(vc, animated: true)
            return true
        }
    }
    return false
}

func getTopicReadStateKey(topicId: Int) -> String {
    return "keyTopicReadState-\(topicId)"
}
