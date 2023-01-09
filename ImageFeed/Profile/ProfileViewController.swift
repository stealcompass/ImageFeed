//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 06.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var buttonQuit: UIButton!
    
    @IBOutlet weak var labelMes: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAccount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageAvatar = UIImage(named: "avatar") else {return}
        guard let imageButton = UIImage(named: "quit") else {return}
        
        self.avatar.image = imageAvatar
        
        self.buttonQuit.setImage(imageButton, for: .normal)
        
        self.labelMes.text = "Hello, world!"
        self.labelName.text = "Екатерина Новикова"
        self.labelAccount.text = "@ekaterina_nov"
        
        self.labelName.font = UIFont(name: "SFProText-Bold", size: CGFloat(23))
        self.labelMes.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        self.labelAccount.font = UIFont(name: "SFProText-Regular", size: CGFloat(13))
        
        self.labelMes.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        self.labelName.textColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
        self.labelAccount.textColor = UIColor(red: CGFloat(0.68), green: CGFloat(0.69), blue: CGFloat(0.71), alpha: CGFloat(1))
        
    }
    
    
    @IBAction func quitPush(_ sender: Any) {
    }
    
}
