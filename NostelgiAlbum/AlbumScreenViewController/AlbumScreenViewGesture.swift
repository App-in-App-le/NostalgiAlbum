import UIKit
import RealmSwift

extension AlbumScreenViewController {
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            let data = realm.objects(album.self).filter("index = \(coverIndex)")
            if (pageNum >= 0) && (pageNum < (data.count / 2) + 1){
                switch swipeGesture.direction{
                case UISwipeGestureRecognizer.Direction.right :
                    if pageNum != 0 {
                        if albumScreenVC != nil && isFontChanged == true && albumScreenVC?.navigationItem.titleView != nil {
                            // Font를 바꿔주는 부분
                            albumScreenVC!.setFont()
                            albumScreenVC!.collectionView.reloadData()
                            albumScreenVC!.isFontChanged = true
                            isFontChanged = false
                            print("TEST:: Font Change Success!!")
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        break
                    }
                case UISwipeGestureRecognizer.Direction.left :
                    if pageNum < data.count / 2{
                        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
                        pushVC.pageNum = pageNum + 1
                        pushVC.coverIndex = coverIndex
                        pushVC.albumScreenVC = self
                        
                        self.navigationController?.pushViewController(pushVC, animated: true)
                    }
                    else{
                        break
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc func popToHome() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        // editPicAlert
        let editPicAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        // editPicAlert "사진 삭제" action
        let delete = UIAlertAction(title: "사진 삭제", style: .default){(action) in
            self.deletePicture(gesture.picture)
        }
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        editPicAlert.addAction(delete)
        // Present editPicAlert
        self.present(editPicAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            editPicAlert.view.superview?.isUserInteractionEnabled = true
            editPicAlert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    private func deletePicture(_ picture : album) {
        let pictures = realm.objects(album.self).filter("index = \(picture.index)")
        let picturesInfo = realm.objects(albumsInfo.self).filter("id = \(picture.index)")
        let num = picture.perAlbumIndex
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let filePath = "\(picture.AlbumTitle)/\(picture.AlbumTitle)_\(picture.perAlbumIndex).jpeg"
        let pictureDirectory = documentDirectory.appending(path: filePath)
        if FileManager.default.fileExists(atPath: pictureDirectory.path) {
            do {
                try FileManager.default.removeItem(at: pictureDirectory)
            } catch {
                print("사진을 삭제하지 못했습니다.")
            }
        }
        try! realm.write{
            realm.delete(picture)
            if pictures.first != nil {
                picturesInfo.first!.setNumberOfPictures(pictures.first!.index)
            } else {
                picturesInfo.first!.numberOfPictures = 0
            }
        }
        if num <= pictures.count {
            for index in num...pictures.count {
                try! realm.write{
                    pictures[index-1].perAlbumIndex -= 1
                }
                let updatePath = "\(pictures[index-1].AlbumTitle)/\(pictures[index-1].AlbumTitle)_\(index).jpeg"
                let originPath = "\(pictures[index-1].AlbumTitle)/\(pictures[index-1].AlbumTitle)_\(index + 1).jpeg"
                let originDirectory = documentDirectory.appending(path: originPath)
                let updateDirectory = documentDirectory.appending(path: updatePath)
                print("origin",originDirectory.path)
                print("update",updateDirectory.path)
                do {
                    try FileManager.default.moveItem(atPath: originDirectory.path, toPath: updateDirectory.path)
                } catch {
                    print("경로가 없습니다.")
                }
            }
        }
        collectionView.reloadData()
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    class customLongPressGesture : UILongPressGestureRecognizer {
        var picture : album!
    }
}
