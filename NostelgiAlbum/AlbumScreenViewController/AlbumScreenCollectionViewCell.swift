import UIKit
import RealmSwift

class AlbumScreenCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    // Cell 하위에 들어가는 하위 뷰 객체들
    var pictureImgButton = UIButton()
    var pictureLabel = UILabel()
    // AlbumScreenViewController에서 받아온 정보들을 담을 객체
    var albumName: String!
    weak var albumSVC: AlbumScreenViewController!
    weak var albumInfo : album!
        
    // - MARK: Set PictureImgButton
    func setButton() {
        pictureImgButton.translatesAutoresizingMaskIntoConstraints = false
        pictureImgButton.setImage(UIImage(systemName: "plus"), for: .normal)
        pictureImgButton.layer.cornerRadius = 10
        pictureImgButton.imageView!.layer.cornerRadius = 10
        pictureImgButton.setTitle("", for: .normal)
        pictureImgButton.isHidden = false
        pictureImgButton.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        self.addSubview(pictureImgButton)
    }
    
    // - MARK: Set PictureLabel
    func setLabel(){
        pictureLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureLabel.text = ""
        pictureLabel.textAlignment = .center
        pictureLabel.numberOfLines = 0
        self.addSubview(pictureLabel)
    }
    
    // - MARK: Set Layout
    func setLayout(HeightIsLonger scale: Bool){
        // When height is longer than width
        if scale == true {
            NSLayoutConstraint.activate([
                pictureImgButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                pictureImgButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                pictureImgButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                pictureImgButton.widthAnchor.constraint(equalToConstant: (self.bounds.height - 40) / 4 * 3),
                pictureLabel.leadingAnchor.constraint(equalTo: pictureImgButton.trailingAnchor , constant: 10),
                pictureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                pictureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                pictureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)

            ])
            var frame = CGRect(x: 0, y: 0, width: 240, height: self.frame.height)
            pictureImgButton.frame = frame
            frame = CGRect(x: 240, y: 0, width: self.frame.width - 240, height: self.frame.height)
            pictureLabel.frame = frame
            // when width is longer than height
        } else {
            NSLayoutConstraint.activate([
                pictureImgButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                pictureImgButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                pictureImgButton.widthAnchor.constraint(equalToConstant: self.bounds.width / 4 * 3),
                pictureImgButton.heightAnchor.constraint(equalToConstant: self.bounds.width / 16 * 9),
                pictureLabel.topAnchor.constraint(equalTo: pictureImgButton.bottomAnchor),
                pictureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                pictureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                pictureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)

            ])
            var frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 280)
            pictureImgButton.frame = frame
            frame = CGRect(x: 0, y: 280, width: self.frame.width, height: self.frame.height - 280)
            pictureLabel.frame = frame
        }
    }
    
    // - MARK: 사진 데이터가 없을 경우 albumInit 함수이 호출됨.
    func albumInit() {
        reset()
        setButton()
        setLabel()
        setLayout(HeightIsLonger: false)
    }
    
    // - MARK: 사진 데이터를 호출했을 경우, configure func 호출
    func configure(_ albumInfo : album) -> Bool {
        let totalPath = "\(albumInfo.AlbumTitle)_\(albumInfo.perAlbumIndex).jpeg"
        guard let image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: albumInfo.AlbumTitle) else { return false }
        // albumScreenViewController안의 collectionView의 데이터를 리로드 할때 cell을 reset시킴.
        reset()
        setButton()
        setLabel()
        
        // image의 가로 세로 길이를 확인해서 비율에 맞춰 "Dynamic-Layout"을 설계함.
        if image.size.width < image.size.height {
            setLayout(HeightIsLonger: true)
            pictureImgButton.setImage(image.resize(newWidth: (self.bounds.height - 40) / 4 * 3, newHeight: self.bounds.height - 40, byScale: false), for: .normal)
        } else {
            setLayout(HeightIsLonger: false)
            pictureImgButton.setImage(image.resize(newWidth: self.bounds.width / 4 * 3, newHeight: self.bounds.width / 16 * 9, byScale: false), for: .normal)
        }
        // 사진 제목 set
        pictureLabel.text = albumInfo.ImageName
        
        return true
    }
    
    // - MARK: The target action of pictureImgButton.
    @objc func addPicture() {
        // When the pictureImageButton doesn't have a picture, go to the view where you can add the picture.
        // pictureImageButton이 사진이 없을 때, 
        if pictureImgButton.imageView?.image == UIImage(systemName: "plus") {
            guard let editVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
            editVC.index = self.albumSVC.coverIndex
            editVC.albumCoverName = self.albumName
            editVC.collectionViewInAlbum = self.albumSVC.collectionView
            editVC.modalPresentationStyle = .overFullScreen
            // editVC.navigationController?.pushViewController(editVC, animated: false)
            albumSVC.present(editVC, animated: false)
            // When the pictureImageButton has a picture, go to the albumPicView.
        } else {
            guard let picVC = self.albumSVC.storyboard?.instantiateViewController(withIdentifier: "AlbumPicViewController") as? AlbumPicViewController else { return }
            picVC.picture = albumInfo
            picVC.collectionViewInAlbum = albumSVC.collectionView
            picVC.index = albumSVC.coverIndex
            picVC.modalPresentationStyle = .overFullScreen
            albumSVC.present(picVC, animated: false)
        }
    }
    
    // - MARK: Reset the properties of the subviews in cell and subviews.
    func reset() {
        // Reset PictureImgButton
        pictureImgButton.removeTarget(self, action: nil, for: .touchUpInside)
        pictureImgButton.setImage(nil, for: .normal)
        pictureImgButton.backgroundColor = nil
        pictureImgButton.layer.borderWidth = 0
        pictureImgButton = UIButton()
        // Reset Picture Label
        pictureLabel.text = nil
        pictureLabel = UILabel()
    }
}

