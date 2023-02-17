//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 02.02.2023.
//
import WebKit
import UIKit


fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController{
    
    var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    
    @IBOutlet private var progressView: UIProgressView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webView.removeObserver(self,
                               forKeyPath: #keyPath(WKWebView.estimatedProgress),
                               context: nil)
    }
    
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
    
        if let request = authorizeRequest() {
            webView.load(request)
        }
        
    }
    
    
    @IBAction private func didTapBackButton(_ sender: Any?){
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let code = code(from: navigationAction){
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}


extension WebViewViewController{
    
    func authorizeRequest() -> URLRequest?{
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)
        
        urlComponents?.queryItems = [
           URLQueryItem(name: "client_id", value: accessKey),
           URLQueryItem(name: "redirect_uri", value: redirectURI),
           URLQueryItem(name: "response_type", value: "code"),
           URLQueryItem(name: "scope", value: accessScope)
         ]
        
        if let url = urlComponents?.url {
            return URLRequest(url: url)
        }
        return nil
    }
}

