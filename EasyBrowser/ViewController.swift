//
//  ViewController.swift
//  Project4
//
//  Created by  Toropov Oleksandr on 08.11.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "youtube.com","hackingwithswift.com","vk.com","google.com","twitter.com","facebook.com","instagram.com","linkedin.com","pinterest.com","tumblr.com","reddit.com","github.com","stackoverflow.com","medium.com","twitch.tv","telegram.org","whatsapp.com","viber.com","skype.com","slack.com","trello.com","bitbucket.org","dropbox.com","behance.net","dribbble.com","codepen.io","jsfiddle.net",]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let goBackButton = UIBarButtonItem(title: "←", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForwardButton = UIBarButtonItem(title: "→", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton, spacer, goBackButton, goForwardButton, spacer,  refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://www.youtube.com/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
          ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)

    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
       if keyPath == "estimatedProgress" {
           progressView.progress = Float(webView.estimatedProgress)
       }
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "Error", message: "This site is blocked", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
            
            let url = navigationAction.request.url
            
            if let host = url?.host {
                for website in websites {
                    if host.contains(website) {
                        decisionHandler(.allow)
                        return
                    }
                }
            }
            
            decisionHandler(.cancel)
               showAlert()
    }

}

