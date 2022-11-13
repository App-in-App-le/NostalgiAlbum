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
    
    
    func configure(_ album : AlbumModel){
        pictureImage.image = UIImage(named: album.pictureName)
        pictureLabel.text = album.pictureLabel
    }
}
