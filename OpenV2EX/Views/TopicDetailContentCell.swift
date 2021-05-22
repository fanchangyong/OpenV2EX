//
//  TopicDetailContentCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/21/21.
//

import UIKit
import WebKit

protocol TopicDetailContentCellDelegate {
    func cellHeightChanged(in cell: UITableViewCell, contentHeight: CGFloat)
}

class TopicDetailContentCell: UITableViewCell {
    var topic: Topic? {
        didSet {
            if let body = topic?.content {
                let baseURL = URL(string: "https://v2ex.com")
                let html = """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0,user-scalable=no">
                        <link rel="stylesheet" type="text/css" media="screen" href="/css/basic.css?v=104143:1426155366:3.9.8.5">
                        <link rel="stylesheet" type="text/css" media="screen" href="/assets/1f5c0436557d2312d1c3c05e1e271a63100b4573-style.css">
                        <link rel="stylesheet" type="text/css" media="screen" href="/assets/d0d4814a37e60888feb1d7bfbea9efe1dadd9478-mobile.css">
                    </head>
                    <body>
                        \(body)
                    </body>
                </html>
                """
                webView.loadHTMLString(html, baseURL: baseURL)
            }
        }
    }
    
    var delegate: TopicDetailContentCellDelegate?
    
    private lazy var webView: WKWebView = {
        let topicContentWebView = WKWebView()
        self.contentView.addSubview(topicContentWebView)
        topicContentWebView.scrollView.isScrollEnabled = false
        topicContentWebView.scrollView.bounces = false
        topicContentWebView.scrollView.bouncesZoom = false
        topicContentWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicContentWebView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            topicContentWebView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topicContentWebView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        topicContentWebView.navigationDelegate = self
        return topicContentWebView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        // self.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        self.contentView.addSubview(webView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopicDetailContentCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState", completionHandler: {(result, error) in
            if let result = result as? String, result == "complete" {
                let newHeight = webView.scrollView.contentSize.height + 20
                webView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                self.delegate?.cellHeightChanged(in: self, contentHeight: newHeight)
            }
        })
    }
}
