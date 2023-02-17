//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 15.02.2023.
//

import UIKit


final class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthView"
    
    private let oauth2Service = OAuth2Service()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {

        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    } 
    
    
}


extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        oauth2Service.fetchAuthToken(code) {[weak self] result in
            guard let self=self else {return}
            
            switch result {
            case .success(let authToken):
                OAuth2TokenStorage().token = authToken
                print("CODE: \(authToken)")
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
            }
        }
    }
}


