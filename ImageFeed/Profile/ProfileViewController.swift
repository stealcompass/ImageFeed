//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 06.01.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared

    private var nameLabel: String?
    private var loginNameLabel: String?
    private var descriptionLabel: String?
    
    private var imageView = UIImageView()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "backGroundCol")
    
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else {return}
                
                self.updateAvatar()
            })
        
        updateAvatar()
        
        guard let profile = profileService.profile else {return}
        
        updateProfileDetails(profile: profile)
        
        guard
            let imageButton = UIImage(named: "quit")
        else {return}
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        
        let buttonQuit = UIButton()
        buttonQuit.translatesAutoresizingMaskIntoConstraints = false
        buttonQuit.setImage(imageButton, for: .normal)
        view.addSubview(buttonQuit)
    
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = self.nameLabel ?? "" //"Екатерина Новикова"
        nameLabel.font = UIFont(name: "SFProText-Bold", size: CGFloat(23))
        nameLabel.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        view.addSubview(nameLabel)

        
        let accountLabel = UILabel()
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.text = self.loginNameLabel ?? "" //"@ekaterina_nov"
        accountLabel.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        accountLabel.textColor = UIColor(red: CGFloat(0.68), green: CGFloat(0.69), blue: CGFloat(0.71), alpha: CGFloat(1))
        view.addSubview(accountLabel)
        
        
        let mesLabel = UILabel()
        mesLabel.translatesAutoresizingMaskIntoConstraints = false
        mesLabel.text = self.descriptionLabel ?? "" //"Hello, world!"
        mesLabel.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        mesLabel.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        view.addSubview(mesLabel)
        
        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            buttonQuit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            buttonQuit.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            accountLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            accountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            mesLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            mesLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8)
            ])
        
    }
    
    
    private func updateProfileDetails(profile: Profile){
        
        self.loginNameLabel = profile.loginName
        self.descriptionLabel = profile.bio
        self.nameLabel = profile.name
        
    }
    
    private func updateAvatar(){
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {return}
        
        //..Update avatar
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        self.imageView.kf.setImage(with: url,
                                   placeholder: UIImage(named: "person_placeholder.png"),
                                   options: [.processor(processor)])
        
    }
    
}
