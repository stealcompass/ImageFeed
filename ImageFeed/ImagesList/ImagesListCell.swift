//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Veniamin on 04.01.2023.
//

import UIKit


final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
}
