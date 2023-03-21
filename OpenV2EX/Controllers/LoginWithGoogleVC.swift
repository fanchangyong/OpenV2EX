//
//  WebViewVC.swift
//  OpenV2EX
//
//  Created by Changyong Fan on 2023/1/1.
//

import UIKit
import WebKit
import Alamofire

class LoginWithGoogleVC: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1"
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://v2ex.com/signin")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}

extension LoginWithGoogleVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("redirecting...: \(webView.url)")
        if (webView.url?.absoluteString == "https://www.v2ex.com/#") {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                if let cookie = cookies.first { $0.name == "A2" } {
                    print("setting cookie A2")
                    AF.session.configuration.httpCookieStorage?.setCookie(cookie)
                }
                
                // AF.session.configuration.httpCookieStorage?.setCookies(cookies, for: URL(string: ".v2ex.com"), mainDocumentURL: nil)
                
                //HTTPCookieStorage.shared.setCookies(cookies, for: URL(string: "https://www.v2ex.com"), mainDocumentURL: nil)
//                for cookie in cookies {
//                    print("cookie [\(cookie.name)]: [\(cookie.value)]")
//                }
            }
            self.dismiss(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start provisional navigation: \(webView.url)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish: \(webView.url)")
    }
}
