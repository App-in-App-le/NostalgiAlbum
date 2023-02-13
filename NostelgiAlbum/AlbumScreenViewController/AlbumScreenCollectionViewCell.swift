import UIKit

class AlbumScreenCollectionViewCell: UICollectionViewCell {
    
    var pictureImgButton : UIButton?
    var pictureLabel: UILabel?
    
    var albumSVC: AlbumScreenViewController!
    var albumInfo : album!
    var albumCoverInfo : albumCover!
    
    func setButton(){
        pictureImgButton!.translatesAutoresizingMaskIntoConstraints = false
        pictureImgButton!.setImage(UIImage(systemName: "plus"), for: .normal)
        pictureImgButton!.setTitle("", for: .normal)
        pictureImgButton!.isHidden = false
        pictureImgButton!.addTarget(self, action: #selector(addPicutre), for: .touchUpInside)
        self.addSubview(pictureImgButton!)
    }
    
    func setLabel(){
        pictureLabel!.translatesAutoresizingMaskIntoConstraints = false
        pictureLabel!.text = ""
        pictureLabel!.textAlignment = .center
        self.addSubview(pictureLabel!)
    }
    
    func setLayout(HeightIsLongger scale: Bool){
        if scale == true {
            NSLayoutConstraint.activate([
                pictureImgButton!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                pictureImgButton!.topAnchor.constraint(equalTo: self.topAnchor),
                pictureImgButton!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                pictureImgButton!.widthAnchor.constraint(equalToConstant: 240),
                pictureLabel!.leadingAnchor.constraint(equalTo: pictureImgButton!.trailingAnchor),
                pictureLabel!.topAnchor.constraint(equalTo: self.topAnchor),
                pictureLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                pictureLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
            var frame = CGRect(x: 0, y: 0, width: 240, height: self.frame.height)
            pictureImgButton!.frame = frame
            frame = CGRect(x: 240, y: 0, width: self.frame.width - 240, height: self.frame.height)
            pictureLabel!.frame = frame
            
        } else {
            NSLayoutConstraint.activate([
                pictureImgButton!.topAnchor.constraint(equalTo: self.topAnchor),
                pictureImgButton!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                pictureImgButton!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                pictureImgButton!.heightAnchor.constraint(equalToConstant: 280),
                pictureLabel!.topAnchor.constraint(equalTo: pictureImgButton!.bottomAnchor),
                pictureLabel!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                pictureLabel!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                pictureLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
            var frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 280)
            pictureImgButton!.frame = frame
            frame = CGRect(x: 0, y: 280, width: self.frame.width, height: self.frame.height - 280)
            pictureLabel!.frame = frame
        }
    }
    
    func albumInit() {
        reset()
        setButton()
        setLabel()
        setLayout(HeightIsLongger: true)
    }
    
    func configure(_ albumInfo : album){
        reset()
        let totalPath = "\(albumInfo.AlbumTitle)_\(albumInfo.perAlbumIndex).png"
        let image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: albumInfo.AlbumTitle)
        
        setButton()
        setLabel()
        if image!.size.width < image!.size.height {
            setLayout(HeightIsLongger: true)
        } else {
            setLayout(HeightIsLongger: false)
        }
        
        pictureImgButton!.setImage(image!.resize(newWidth: pictureImgButton!.frame.width, newHeight: pictureImgButton!.frame.height), for: .normal)
        
        pictureLabel!.text = albumInfo.ImageText
    }
    
    func picConfigure(_ albumInfo : album){
        guard let picVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumPicViewController") as? AlbumPicViewController else { return }
        picVC.picture = albumInfo
        picVC.collectionViewInAlbum = albumSVC.collectionView
        picVC.modalPresentationStyle = .overFullScreen
        albumSVC.present(picVC, animated: false)
    }
    
    @objc func addPicutre() {
        if pictureImgButton!.imageView?.image == UIImage(systemName: "plus"){
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
    
    func reset() {
        pictureImgButton?.removeTarget(self, action: nil, for: .touchUpInside)
        pictureImgButton?.setImage(nil, for: .normal)
        pictureImgButton = nil
        pictureImgButton = UIButton()
        
        pictureLabel?.text = nil
        pictureLabel = nil
        pictureLabel = UILabel()
    }
}

extension UIButton {
}
