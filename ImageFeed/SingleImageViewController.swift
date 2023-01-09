//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Veniamin on 08.01.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage!{
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
