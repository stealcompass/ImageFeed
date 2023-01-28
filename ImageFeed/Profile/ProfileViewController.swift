//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 06.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let imageAvatar = UIImage(named: "avatar"),
            let imageButton = UIImage(named: "quit")
        else {return}
        
        let imageView = UIImageView(image: imageAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        
        let buttonQuit = UIButton()
        buttonQuit.translatesAutoresizingMaskIntoConstraints = false
        buttonQuit.setImage(imageButton, for: .normal)
        view.addSubview(buttonQuit)
    
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "SFProText-Bold", size: CGFloat(23))
        nameLabel.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        view.addSubview(nameLabel)

        
        let accountLabel = UILabel()
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.text = "@ekaterina_nov"
        accountLabel.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        accountLabel.textColor = UIColor(red: CGFloat(0.68), green: CGFloat(0.69), blue: CGFloat(0.71), alpha: CGFloat(1))
        view.addSubview(accountLabel)
        
        
        let mesLabel = UILabel()
        mesLabel.translatesAutoresizingMaskIntoConstraints = false
        mesLabel.text = "Hello, world!"
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
    
}
