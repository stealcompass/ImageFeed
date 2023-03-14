//
//  OAuthService.swift
//  ImageFeed
//
//  Created by Veniamin on 15.02.2023.
//

import UIKit


final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get { return OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(_ code: String, completion: @escaping (Swift.Result<String, Error>) -> Void){
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                
                DispatchQueue.main.async {
                    completion(.success(authToken))
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
            
        //self.task = task
        task?.resume()
    }
    
}


extension OAuth2Service {
    
    private func object(for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        return urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            completion(result)
        }
    }
    
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int

        enum CodingKeys: String, CodingKey{
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }

    func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
