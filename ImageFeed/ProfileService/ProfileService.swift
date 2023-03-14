//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Veniamin on 21.02.2023.
//  Сервис для получения базовой информации профиля - запускается в splashscreen

import UIKit



final class ProfileService{
    
    static let shared = ProfileService()

    private (set) var profile: Profile?
    private var lastToken: String?
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        print("TOKEN2: ", token)
        
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = getRequest(token: token)
        task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in 
            
            switch result {
            case .success(let data):
                
                //let profileResult = try? JSONDecoder().decode(ProfileResult.self , from: data)
                    
                self.profile = Profile(username: data.username,
                                     name: (data.firstName) + " " + (data.lastName) ,
                                     loginName: "@" + (data.username),
                                     bio: data.bio)
                
                guard let profile = self.profile else {return}
                
                DispatchQueue.main.async {
                    completion(.success(profile))
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


func getRequest(token: String) -> URLRequest{
    var request = URLRequest.makeHTTPRequest(path: "/me",
                               httpMethod: "GET",
                               baseURL: defaultBaseURL)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}



struct ProfileResult: Codable{
    var username: String
    var firstName: String
    var lastName: String
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}


struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
}
