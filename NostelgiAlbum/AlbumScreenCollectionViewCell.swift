//
//  AlbumScreenCollectionViewCell.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/31.
//

import UIKit

class AlbumScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var pictureLabel: UILabel!
    
    
    func configure(_ albumInfo : album){
        pictureImage.image = UIImage(named: albumInfo.ImageName)
        pictureLabel.text = albumInfo.ImageText
    }
}
