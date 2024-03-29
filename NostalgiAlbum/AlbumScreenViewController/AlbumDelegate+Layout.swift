import UIKit

// DataSource, Delegate에 대한 extension을 정의
extension AlbumScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = realm.objects(album.self).filter("index = \(coverIndex)")
        let coverData = realm.objects(albumCover.self).filter("id = \(coverIndex)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumScreenCollectionViewCell", for: indexPath) as! AlbumScreenCollectionViewCell
        var picture: album
        
        cell.albumSVC = self
        cell.albumName = coverData.first?.albumName
        
        if (indexPath.item + pageNum * 2) < data.count {
            picture = data[indexPath.item + pageNum * 2]
            if cell.configure(picture) {
                cell.albumInfo = picture
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.picture = picture
                cell.pictureImgButton.addGestureRecognizer(LongPressGestureRecognizer)
                cell.pictureImgButton.isEnabled = true
            } else {
                cell.albumInit()
                cell.pictureImgButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
                cell.pictureLabel.text = "이미지 오류"
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.picture = picture
                cell.pictureImgButton.addGestureRecognizer(LongPressGestureRecognizer)
                cell.pictureImgButton.isEnabled = false
            }
        } else {
            if indexPath.item + pageNum * 2 == data.count {
                cell.albumInit()
            }
            if (indexPath.item + pageNum * 2) > data.count {
                cell.reset()
            }
        }
        
        cell.setFont()
        cell.setThemeColor()
        return cell
    }
}

// layout에 관한 extension을 정의
extension AlbumScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
