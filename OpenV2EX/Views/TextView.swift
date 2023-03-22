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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let layoutManager = self.layoutManager
        var location = sender.location(in: self)
        location.x -= self.textContainerInset.left
        location.y -= self.textContainerInset.top

        let characterIndex = layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if characterIndex < self.textStorage.length {
            let attributes = self.textStorage.attributes(at: characterIndex, effectiveRange: nil)
            if let attachment = attributes[NSAttributedString.Key.attachment] as? AsyncTextAttachment {
                 let fullscreenVC = FullscreenViewController()
                 fullscreenVC.image = attachment.image
                fullscreenVC.modalPresentationStyle = .overFullScreen
                self.window?.rootViewController?.present(fullscreenVC, animated: true, completion: nil)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if tryOpenV2EXTopicURL(url: URL, in: self.window) {
            return false
        }

        let vc = SFSafariViewController(url: URL)
        self.window?.rootViewController?.present(vc, animated: true)
        return false
    }
}
