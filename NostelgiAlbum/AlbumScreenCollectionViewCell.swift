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
    
    @IBAction func addPicutre(_ sender: Any) {
        if pictureImgButton.imageView?.image == UIImage(systemName: "plus"){
            guard let editVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
            editVC.index = self.albumSVC.coverIndex
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
        image = loadImageFromDocumentDirectory(imageName: albumInfo.ImageName)
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
//        picVC.picImage.setImage(UIImage(named: albumInfo.ImageName), for: .normal)
//        picVC.picName.text = albumInfo.ImageName
//        picVC.picText.text = albumInfo.ImageText
        picVC.picture = albumInfo
        picVC.modalPresentationStyle = .overFullScreen
        albumSVC.present(picVC, animated: false)
    }
}
