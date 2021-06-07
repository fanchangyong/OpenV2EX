//
//  TextView.swift
//  OpenV2EX
//
//  Created by fancy on 5/24/21.
//

import UIKit
import SafariServices

class TextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let host = URL.host
        let path = URL.path
        if (host == "v2ex.com" || host == "www.v2ex.com") && path.starts(with: "/t/") {
            let id = getTopicIdFromRelativeURL(url: path)
            let topic = Topic(id: id)
            let vc = TopicDetailVC(topic: topic)
            if let navVC = self.window?.rootViewController as? UINavigationController {
                navVC.pushViewController(vc, animated: true)
                return false
            }
        }

        let vc = SFSafariViewController(url: URL)
        self.window?.rootViewController?.present(vc, animated: true)
        return false
    }
}
