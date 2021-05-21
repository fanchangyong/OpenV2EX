//
//  TopicDetailVC.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import UIKit
import WebKit

class TopicDetailVC: UIViewController {
    let topicURL: String
    var topicContent: String? {
        didSet {
            if let body = topicContent {
                let baseURL = URL(string: "https://v2ex.com")
                print("topic content\(body)")
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
                print("html: \(html)")
                topicContentWebView.loadHTMLString(html, baseURL: baseURL)
            }
        }
    }
    
    private lazy var topicContentWebView: WKWebView = {
        let topicContentWebView = WKWebView()
        self.view.addSubview(topicContentWebView)
        topicContentWebView.scrollView.isScrollEnabled = true
        topicContentWebView.scrollView.bounces = false
        topicContentWebView.scrollView.bouncesZoom = false
        topicContentWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicContentWebView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
            topicContentWebView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor),
            topicContentWebView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topicContentWebView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        topicContentWebView.navigationDelegate = self
        return topicContentWebView
    }()
    
    private lazy var block: UIView = {
        let block = UIView()
        self.view.addSubview(block)
        block.translatesAutoresizingMaskIntoConstraints = false
        block.backgroundColor = .green
        NSLayoutConstraint.activate([
            block.topAnchor.constraint(equalTo: topicContentWebView.bottomAnchor, constant: 20),
            block.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor),
            block.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor),
            block.heightAnchor.constraint(equalToConstant: 20),
        ])
        return block
    }()
    
    init(topicURL: String) {
        self.topicURL = topicURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        // self.edgesForExtendedLayout = UIRectEdge()
        // self.extendedLayoutIncludesOpaqueBars = false
        // self.topicContentWebView.scrollView.contentInsetAdjustmentBehavior = .never
        self.view.backgroundColor = .white
        self.view.addSubview(self.block)
        API.getTopicDetail(url: topicURL) { (topicContent) in
            self.topicContent = topicContent
        }
        
        print("frame: \(topicContentWebView.frame.minX), y: \(topicContentWebView.frame.minY)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TopicDetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /*
        if webView.isLoading == false {
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self] (result, error) in
              if let height = result as? CGFloat {
                self?.topicContentWebView.heightAnchor.constraint(equalToConstant: height).isActive = true
                  // webView.frame.size.height += height
              }
          })
        }
 */

        webView.evaluateJavaScript("document.readyState", completionHandler: {(result, error) in
            if let result = result as? String, result == "complete" {
                let newHeight = webView.scrollView.contentSize.height
                print("new height is: \(newHeight)")
                // webView.frame.size.height = newHeight
                webView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                let frame = self.topicContentWebView.frame
                print("wkwebview frame: \(frame.minX), y: \(frame.minY), width: \(frame.width), height: \(frame.height)")
                let screenRect = UIAccessibility.convertToScreenCoordinates(frame, in: self.topicContentWebView)
                
                print("screen rect: \(screenRect)")
                print("content size: \(self.topicContentWebView.scrollView.contentSize)")
                // self.topicContentWebView.frame.size.height = webView.scrollView.contentSize.height
            }
        })
    }
}
