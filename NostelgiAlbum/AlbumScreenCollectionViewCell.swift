//
//  AlbumScreenCollectionViewCell.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/31.
//

import UIKit

class AlbumScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImgButton: UIButton!
    @IBOutlet weak var pictureLabel: UILabel!
    var albumSVC: AlbumScreenViewController!
    var image: UIImage?
    var albumInfo : album!
    var albumCoverInfo : albumCover!
    @IBAction func addPicutre(_ sender: Any) {
        if pictureImgButton.imageView?.image == UIImage(systemName: "plus"){
            guard let editVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
            editVC.index = self.albumSVC.coverIndex
            editVC.albumCoverName = self.albumCoverInfo.albumName
            editVC.collectionViewInAlbum = self.albumSVC.collectionView
            editVC.modalPresentationStyle = .overFullScreen
            editVC.navigationController?.pushViewController(editVC, animated: false)
                        albumSVC.present(editVC, animated: false)
        } else {
            picConfigure(albumInfo)
        }
    }
    func configure(_ albumInfo : album){
        pictureImgButton.setTitle("", for: .normal)
        print("imagename: "+albumInfo.ImageName)
        let totalPath = "\(albumInfo.AlbumTitle)_\(albumInfo.perAlbumIndex)"
        image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: albumInfo.AlbumTitle)
        pictureImgButton.setImage(image!.resize(newWidth: 168), for: .normal)
        pictureLabel.text = albumInfo.ImageText
    }
    func albuminit() {
        pictureImgButton.setImage(UIImage(systemName: "plus"), for: .normal)
        pictureImgButton.setTitle("", for: .normal)
        pictureLabel.text = ""
    }
    func picConfigure(_ albumInfo : album){
        guard let picVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumPicViewController") as? AlbumPicViewController else { return }
        picVC.picture = albumInfo
        picVC.modalPresentationStyle = .overFullScreen
        albumSVC.present(picVC, animated: false)
    }
}
