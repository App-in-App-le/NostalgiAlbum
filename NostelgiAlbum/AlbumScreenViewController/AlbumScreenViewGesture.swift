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
                        if let albumScreenVC = albumScreenVC, isFontChanged == true && albumScreenVC.navigationItem.titleView != nil {
                            // Font를 바꿔주는 부분
                            albumScreenVC.setFont()
                            albumScreenVC.collectionView.reloadData()
                            albumScreenVC.isFontChanged = true
                            isFontChanged = false
                        }
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        break
                    }
                case UISwipeGestureRecognizer.Direction.left :
                    if pageNum < data.count / 2 {
                        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
                        pushVC.pageNum = pageNum + 1
                        pushVC.coverIndex = coverIndex
                        pushVC.albumScreenVC = self
                        self.navigationController?.pushViewController(pushVC, animated: true)
                    } else {
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
        // editPicAlert "사진 삭제" action(삭제를 선택한 경우)
        let delete = UIAlertAction(title: "사진 삭제", style: .default){(action) in
            self.deletePicture(gesture.picture)
        }
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        editPicAlert.addAction(delete)
        // Present editPicAlert(수정을 선택한 경우)
        self.present(editPicAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            editPicAlert.view.superview?.isUserInteractionEnabled = true
            editPicAlert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    private func deletePicture(_ picture : album) {
        let album = realm.objects(album.self).filter("index = \(picture.index)")
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(picture.index)")
        var checkComplete: Bool = true
        let num = picture.perAlbumIndex
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let filePath = "\(picture.AlbumTitle)/\(picture.AlbumTitle)_\(picture.perAlbumIndex).jpeg"
        let pictureDirectory = documentDirectory.appending(path: filePath)
        let albumTitle = picture.AlbumTitle
        let index = picture.index
        var fileMangerError: Error! = nil
        do {
            try realm.write{
                realm.delete(picture)
                if let albumInfo = albumInfo.first {
                    if album.first != nil {
                        albumInfo.setNumberOfPictures(album.first!.index)
                    } else {
                        albumInfo.numberOfPictures = 0
                    }
                }
            }
        } catch let error {
            print("error: \(error.localizedDescription)")
            NSErrorHandling_Alert(error: error, vc: self)
            return
        }
        if FileManager.default.fileExists(atPath: pictureDirectory.path) {
            do {
                try FileManager.default.removeItem(at: pictureDirectory)
            } catch let error {
                print("사진을 삭제하지 못했습니다.")
                do {
                    try realm.write {
                        // realm 복구
                        realm.add(picture)
                        if let albumInfo = albumInfo.first {
                            albumInfo.setNumberOfPictures(album.first!.index)
                        }
                    }
                } catch {
                    print("realm write 실패")
                }
                NSErrorHandling_Alert(error: error, vc: self)
                return
            }
        }
        if num <= album.count {
            do {
                try realm.write {
                    for index in num...album.count {
                        album[index-1].perAlbumIndex -= 1
                        let updatePath = "\(album[index-1].AlbumTitle)/\(album[index-1].AlbumTitle)_\(index).jpeg"
                        let originPath = "\(album[index-1].AlbumTitle)/\(album[index-1].AlbumTitle)_\(index + 1).jpeg"
                        let originDirectory = documentDirectory.appending(path: originPath)
                        let updateDirectory = documentDirectory.appending(path: updatePath)
                        do {
                            try FileManager.default.moveItem(atPath: originDirectory.path, toPath: updateDirectory.path)
                        } catch let error {
                            // moveItem에 대한 실패 경우
                            print("경로가 없습니다.")
                            checkComplete = false
                            fileMangerError = error
                        }
                    }
                }
            } catch let error {
                print("error : \(error.localizedDescription)")
                // realm write에 대한 실패 경우
                // check && 복구함수
                recoverAlbumState(albumTitle, index)
                NSErrorHandling_Alert(error: error, vc: self)
                collectionView.reloadData()
                return
            }
        }
        // check && 복구함수
        if !checkComplete {
            recoverAlbumState(albumTitle, index)
            NSErrorHandling_Alert(error: fileMangerError, vc: self)
        }
        collectionView.reloadData()
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    class customLongPressGesture : UILongPressGestureRecognizer {
        var picture : album!
    }
    
    func recoverAlbumState(_ albumTitle: String, _ index: Int) {
        let album = realm.objects(album.self).filter("index = \(index)")
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index)")
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let albumDir = documentDirectory.appendingPathComponent(albumTitle)
        let files : [String]
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: albumDir.path).sorted()
        } catch {
            print("Recover Error")
            return
        }
        var count = 1
        var checkCustom = false
        for file in files {
            if file == "\(albumTitle)_CoverImage" {
                checkCustom = true
                continue
            }
            let change = "\(albumTitle)_\(count).jpeg"
            let changeURL = albumDir.appendingPathComponent(change)
            do {
                try FileManager.default.moveItem(atPath: file, toPath: changeURL.path)
            } catch {
                print("Recover MoveItem Error")
                return
            }
            count += 1
        }
        do {
            try realm.write {
                if !checkCustom {
                    for i in 1...files.count {
                        album[i].perAlbumIndex = i
                    }
                    albumInfo.first?.setNumberOfPictures(files.count)
                } else {
                    for i in 1...files.count - 1 {
                        album[i].perAlbumIndex = i
                    }
                    albumInfo.first?.setNumberOfPictures(files.count - 1)
                }
            }
        } catch {
            print("Recover Realm write error")
            return
        }
    }
}
