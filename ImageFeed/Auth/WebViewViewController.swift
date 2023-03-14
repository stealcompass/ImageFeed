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
    
    private var estimatedProgressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                                                        options: [],
                                                        changeHandler: { [weak self] _, _ in
            guard let self = self else {return}
            self.updateProgress()
        })
        
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

