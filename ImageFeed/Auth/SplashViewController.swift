//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 15.02.2023.
//

import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthView"
    private let profileData = ProfileService.shared
    private let oauth2Service = OAuth2Service()
    
    override func viewDidAppear(_ animated: Bool) {
        print("SplashViewController viewDidAppear")
        super.viewDidAppear(animated)
        
        
        if UserDefaults.standard.string(forKey:"tokenFlag") == nil {
            KeychainWrapper.standard.removeObject(forKey: "Auth token")
        }
        
        
        if let token = OAuth2TokenStorage().token {
            fetchProfileSplash(token: token)
        } else {
            
            guard let viewController = getViewController(with: "AuthViewController") as? AuthViewController
            else {
                fatalError()
            }
            viewController.modalPresentationStyle = .fullScreen
            viewController.delegate = self
            present(viewController, animated: true)
        }
    }
    
    //MARK: Отрисовка
    override func viewDidLoad() {
        print("SplashViewController viewDidLoad")
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "backGroundCol")
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    
    private func switchToTabBarController() {

        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
    
    private func getViewController(with id: String) -> UIViewController {
         
         let storyboard = UIStoryboard(name: "Main", bundle: .main)
         let viewController = storyboard.instantiateViewController(withIdentifier: id)
         return viewController
     }
  
}




extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code) {[weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let authToken):
                print("TOKEN: \(authToken)")
                self.fetchProfileSplash(token: authToken)
                
            case .failure(let error):
                
                UIBlockingProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Что-то пошло не так(",
                                  message: "Не удалось войти в систему",
                                  preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(action)
                vc.present(self, animated: true)
                
                print(error)
            }
        }
    }
    
    
    private func fetchProfileSplash(token: String){
        
        profileData.fetchProfile(token) { [weak self] profileInfo  in
                
                guard let self = self else {return}
                
                switch profileInfo{
                case .success(let profile):
                    
                    ProfileImageService.shared.fetchProfileImageURL(username: profile.username) {urlResult in
                        switch urlResult {
                        case .success(let url):
                            return
                        case .failure(let error):
                            return
                        }
                    }
                    
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    print(error)
                }
        }
        
    }
}


