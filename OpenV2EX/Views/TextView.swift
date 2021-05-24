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
        let vc = SFSafariViewController(url: URL)
        self.window?.rootViewController?.present(vc, animated: true)
        return false
    }
}
