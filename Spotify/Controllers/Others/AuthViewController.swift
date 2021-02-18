//
//  AuthViewController.swift
//  Spotify
//
//  Created by admin on 2/16/21.
//

import UIKit
import WebKit


class AuthViewController: UIViewController , WKNavigationDelegate {

    private let webView: WKWebView = {
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        

        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        print("Code: \(code)" )
        
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToker(code: code, completion: { [weak self] success in
            
            DispatchQueue.main.async{
            self?.navigationController?.popToRootViewController(animated: true)
            
            self?.completionHandler?(success)
            
            }
            
        })
    }

}
