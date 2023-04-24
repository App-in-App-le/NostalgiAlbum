import UIKit

extension HomeScreenViewController {
    
    class customLongPressGesture : UILongPressGestureRecognizer {
        // MARK: - Properties
        var albumIndex : Int!
        var albumName : String!
    }
    
    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        // Alert
        let longPressAlert = UIAlertController(title: (gesture.albumName), message: .none, preferredStyle: .alert)
        
        // Delete action
        let delete = UIAlertAction(title: "앨범 삭제", style: .default) {
            (action) in self.deleteAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        delete.setValue(UIColor.blue, forKey: "titleTextColor")
        
        // Modify action
        let modify = UIAlertAction(title: "앨범 수정", style: .default) {
            (action) in self.modifyAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        modify.setValue(UIColor.blue, forKey: "titleTextColor")
        
        // Set Action in Alert
        longPressAlert.addAction(delete)
        longPressAlert.addAction(modify)
        
        // Print Alert
        present(longPressAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            longPressAlert.view.superview?.isUserInteractionEnabled = true
            longPressAlert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    private func deleteAlbumCover(_ albumIndex : Int, _ albumName : String) {
        // Realm Data
        let albumCoverNum = realm.objects(albumCover.self).count
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(albumIndex)")
        let albumData = realm.objects(album.self).filter("index = \(albumIndex)")
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(albumIndex)")
        
        // Delete All Data in RealmDB
        do {
            try realm.write{
                realm.delete(albumCoverData)
                realm.delete(albumData)
                realm.delete(albumsInfoData)
            }
        } catch {
            print("RealmDB에서 파일을 삭제하지 못했습니다.")
        }
        
        // Delete All Data in Documents
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let albumDirectory = documentDirectory.appendingPathComponent(albumName)
        if FileManager.default.fileExists(atPath: albumDirectory.path) {
            do {
                try FileManager.default.removeItem(at: albumDirectory)
            } catch {
                print("폴더를 삭제하지 못했습니다.")
            }
        }
        
        // Modify Album pictures' Index
        if albumCoverNum != albumIndex{
            for index in (albumIndex + 1)...albumCoverNum{
                let albumCoverData = realm.objects(albumCover.self).filter("id = \(index)")
                let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(index)")
                let albumData = realm.objects(album.self).filter("index = \(index)")
                try! realm.write{
                    albumCoverData.first!.id -= 1
                    albumsInfoData.first!.id -= 1
                    if albumData.count != 0{
                        for data in albumData{
                            data.index -= 1
                        }
                    }
                    realm.add(albumCoverData)
                    realm.add(albumsInfoData)
                    realm.add(albumData)
                }
            }
        } else {
            print("You delete Last album!")
        }
        
        // Reload CollectionView
        collectionView.reloadData()
    }
    
    private func modifyAlbumCover(_ albumIndex : Int, _ albumName : String) {
        // editVC
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as? HomeEditViewController else{ return }
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.collectionViewInHome = self.collectionView
        editVC.IsModifyingView = true
        editVC.albumNameBeforeModify = albumName
        editVC.coverImageBeforeModify = realm.objects(albumCover.self).filter("id = \(albumIndex)").first!.coverImageName
        editVC.id = albumIndex
        
        // Present editVC
        self.present(editVC, animated: false)
    }
    
    @IBAction func homeSettingButtonAction(_ sender: Any) {
        guard let homeSettingVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeSettingViewController") as? HomeSettingViewController else { return }
        homeSettingVC.collectionView = self.collectionView
        
        // Present homeSettingVC
        homeSettingVC.modalPresentationStyle = .overCurrentContext
        self.present(homeSettingVC, animated: false)
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
