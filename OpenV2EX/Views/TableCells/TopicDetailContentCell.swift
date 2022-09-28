//
//  TopicDetailContentCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/21/21.
//

import UIKit
import WebKit
import SafariServices

protocol TopicDetailContentCellDelegate {
    func cellHeightChanged(in cell: UITableViewCell, contentHeight: CGFloat)
}

class TopicDetailContentCell: BaseCell {
    var topic: Topic? {
        didSet {
            if let body = topic?.content {
                var nightCSSLink: String = ""
                var nightCSS: String = ""
                if self.traitCollection.userInterfaceStyle == .dark {
                    nightCSSLink = "/assets/daa79692e29bd25db4725e53ce26d7d5c022e0df-night.css"
                    nightCSS = """
                        body {
                            background-color: black;
                        }
                    """
                }
                let baseURL = URL(string: "https://v2ex.com")
                let html = """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0,user-scalable=no">
                        <script src="/assets/a7060c8411316361cea866bff9b318aec0be371d-combo.js" type="text/javascript" defer></script>
                        <link rel="stylesheet" type="text/css" media="screen" href="/assets/cc82c1e8a17aed16ce8ed2bac2afe681e4bd400e-style.css">
                        <link rel="stylesheet" type="text/css" media="screen" href="/assets/a968a3703d50353bf2d707239299e7fc7f4b802b-mobile.css">
                        <link rel="stylesheet" type="text/css" media="screen" href="\(nightCSSLink)">
                        <style>
                            \(nightCSS)
                        </style>
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
            topicContentWebView.topAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.topAnchor),
            topicContentWebView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            topicContentWebView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
        ])
        topicContentWebView.navigationDelegate = self
        return topicContentWebView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
                let newHeight = webView.scrollView.contentSize.height
                webView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                self.delegate?.cellHeightChanged(in: self, contentHeight: newHeight + self.padding * 2)
            }
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            // first try open natively
            if tryOpenV2EXTopicURL(url: url, in: self.window) {
                return
            }
            let vc = SFSafariViewController(url: url)
            self.window?.rootViewController?.present(vc, animated: true)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
