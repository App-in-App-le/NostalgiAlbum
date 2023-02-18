import UIKit

class AlbumScreenCollectionViewCell: UICollectionViewCell {
    
    // - MARK: Declare Class' Properties
    // Cell 하위에 들어가는 하위 뷰 객체들
    var pictureImgButton : UIButton?
    var pictureLabel: UILabel?
    // AlbumScreenViewController에서 받아온 정보들을 담을 객체
    var albumSVC: AlbumScreenViewController!
    var albumInfo : album!
    var albumCoverInfo : albumCover!
    
    // - MARK: Set PictureImgButton
    func setButton(){
        pictureImgButton!.translatesAutoresizingMaskIntoConstraints = false
        pictureImgButton!.setImage(UIImage(systemName: "plus"), for: .normal)
        pictureImgButton!.setTitle("", for: .normal)
        pictureImgButton!.isHidden = false
        pictureImgButton!.addTarget(self, action: #selector(addPicutre), for: .touchUpInside)
        self.addSubview(pictureImgButton!)
    }
    
    // - MARK: Set PictureLabel
    func setLabel(){
        pictureLabel!.translatesAutoresizingMaskIntoConstraints = false
        pictureLabel!.text = ""
        pictureLabel!.textAlignment = .center
        self.addSubview(pictureLabel!)
    }
    
    // - MARK: Set Layout
    func setLayout(HeightIsLonger scale: Bool){
        // When height is longer than width
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
            // when width is longer than height
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
    
    // - MARK: When the cell don't have picture Data, albumInit func is called.
    func albumInit() {
        reset()
        setButton()
        setLabel()
        setLayout(HeightIsLonger: true)
    }
    
    // - MARK: When the cell has picture data, configure func is called.
    func configure(_ albumInfo : album){
        let totalPath = "\(albumInfo.AlbumTitle)_\(albumInfo.perAlbumIndex).png"
        let image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: albumInfo.AlbumTitle)
        // Reset cell's subview to reload the data of collection view in albumScreenViewController.
        reset()
        setButton()
        setLabel()
        // Construct "Dynamic-Layout" by comparing the width and height of the image.
        if image!.size.width < image!.size.height {
            setLayout(HeightIsLonger: true)
        } else {
            setLayout(HeightIsLonger: false)
        }
        // Set image and text.
        pictureImgButton!.setImage(image!.resize(newWidth: pictureImgButton!.frame.width, newHeight: pictureImgButton!.frame.height), for: .normal)
        pictureLabel!.text = albumInfo.ImageText
    }
    
    // - MARK: The target action of pictureImgButton.
    @objc func addPicutre() {
        // When the pictureImageButton doesn't have a picture, go to the view where you can add the picture.
        if pictureImgButton!.imageView?.image == UIImage(systemName: "plus"){
            guard let editVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
            editVC.index = self.albumSVC.coverIndex
            editVC.albumCoverName = self.albumCoverInfo.albumName
            editVC.collectionViewInAlbum = self.albumSVC.collectionView
            editVC.modalPresentationStyle = .overFullScreen
            // editVC.navigationController?.pushViewController(editVC, animated: false)
            albumSVC.present(editVC, animated: false)
            // When the pictureImageButton has a picture, go to the albumPicView.
        } else {
            picConfigure(albumInfo)
        }
    }
    
    // - MARK: When you touch a picture, go to the view where you can see the picture in detail.
    func picConfigure(_ albumInfo : album){
        guard let picVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumPicViewController") as? AlbumPicViewController else { return }
        picVC.picture = albumInfo
        picVC.collectionViewInAlbum = albumSVC.collectionView
        picVC.modalPresentationStyle = .overFullScreen
        albumSVC.present(picVC, animated: false)
    }
    
    // - MARK: Reset the properties of the subviews in cell and subviews.
    func reset() {
        // Reset PictureImgButton
        pictureImgButton?.removeTarget(self, action: nil, for: .touchUpInside)
        pictureImgButton?.setImage(nil, for: .normal)
        pictureImgButton = nil
        pictureImgButton = UIButton()
        // Reset Picture Label
        pictureLabel?.text = nil
        pictureLabel = nil
        pictureLabel = UILabel()
    }
}

