//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 02.02.2023.
//

import UIKit


protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {

    weak var delegate: AuthViewControllerDelegate?
    
    private let idWebView = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == idWebView {
            
            guard let webViewController = segue.destination as? WebViewViewController
            else{
                fatalError("Failed to prepare for \(idWebView)")
            }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController {
    
    func authTokenRequest(code: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String){
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}


extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = defaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
