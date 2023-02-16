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

    private let idWebView = "ShowWebView"
    private var oAuth2Service =  OAuth2Service()
    
    weak var delegate: AuthViewControllerDelegate?
    
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
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String){
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        
        oAuth2Service.fetchAuthToken(code) { result in
            
            switch result {
            case .success(let authToken):
                OAuth2TokenStorage().token = authToken
                print("CODE: \(authToken)")
                //var token = authToken
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}


extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = DefaultBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
