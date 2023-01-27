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
        
        guard let imageAvatar = UIImage(named: "avatar") else {return}
        guard let imageButton = UIImage(named: "quit") else {return}
        
        let imageView = UIImageView(image: imageAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageButton, for: .normal)
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        
        
        let labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.text = "Екатерина Новикова"
        labelName.font = UIFont(name: "SFProText-Bold", size: CGFloat(23))
        labelName.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        view.addSubview(labelName)
        
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true

        
        let labelAccount = UILabel()
        labelAccount.translatesAutoresizingMaskIntoConstraints = false
        labelAccount.text = "@ekaterina_nov"
        labelAccount.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        labelAccount.textColor = UIColor(red: CGFloat(0.68), green: CGFloat(0.69), blue: CGFloat(0.71), alpha: CGFloat(1))
        view.addSubview(labelAccount)
        
        labelAccount.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelAccount.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        
        
        
        let labelMes = UILabel()
        labelMes.translatesAutoresizingMaskIntoConstraints = false
        labelMes.text = "Hello, world!"
        labelMes.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        labelMes.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        view.addSubview(labelMes)
        
        labelMes.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelMes.topAnchor.constraint(equalTo: labelAccount.bottomAnchor, constant: 8).isActive = true
       
        
    }
    
}
