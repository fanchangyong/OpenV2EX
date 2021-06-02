//
//  SafariActivity.swift
//  OpenV2EX
//
//  Created by fancy on 6/2/21.
//

import UIKit

class SafariActivity: UIActivity {
    public var URL: URL?

    public override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType(rawValue: "SafariActivity")
    }

    public override var activityTitle: String? {
        return "Open in Safari"
    }

    public override var activityImage: UIImage? {
        return UIImage(systemName: "safari", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .light))
    }

    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        var canPerform = false
        
        for activityItem in activityItems {
            if let URL = activityItem as? URL {
                if UIApplication.shared.canOpenURL(URL) {
                    canPerform = true
                    break
                }
            }
        }
        
        return canPerform
    }

    public override func prepare(withActivityItems activityItems: [Any]) {
        for activityItem in activityItems {
            if let URL = activityItem as? URL {
                self.URL = URL
                break
            }
        }
    }

    public override func perform() {
        if let URL = URL {
            UIApplication.shared.open(URL, options: [:], completionHandler: {(success) in
                self.activityDidFinish(success)
            })
        }
        
    }
}
