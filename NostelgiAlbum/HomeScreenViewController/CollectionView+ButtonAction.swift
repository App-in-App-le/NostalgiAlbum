import UIKit

// CollectionView + ButtonAction
extension HomeScreenViewController {
    /**
     Custom LongPressGuesture Reconizer
     > @objc func 의 인자로 Recognizer를 사용 시 인자를 전달하기 위해 customizing된 Class
     */
    class customLongPressGesture : UILongPressGestureRecognizer {
        var albumIndex : Int!
        var albumName : String!
    }
    /**
     DidLongPressView
     > HomeScreenViewController의 CollectionView 안에 있는 Cell의 Button을 길게 누르는 Gesture를 실행할 때 발생하는 Action을 정의
     */
    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        
        // Make edit Alert
        let editCoverAlert = UIAlertController(title: (gesture.albumName), message: .none, preferredStyle: .alert)
        
        // Make Alert Action : "앨범 삭제", "앨범 수정"
        // Delete :: Delete album Information in RealmDB & Documents
        let delete = UIAlertAction(title: "앨범 삭제", style: .default) {
            (action) in self.deleteAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        delete.setValue(UIColor.blue, forKey: "titleTextColor")
        
        // Modify :: modifying album cover information in RealmDB & Documents
        let modify = UIAlertAction(title: "앨범 수정", style: .default) {
            (action) in self.modifyAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        modify.setValue(UIColor.blue, forKey: "titleTextColor")
        
        // Add Actions in Alert
        editCoverAlert.addAction(delete)
        editCoverAlert.addAction(modify)
        
        // Present Alert
        present(editCoverAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            editCoverAlert.view.superview?.isUserInteractionEnabled = true
            editCoverAlert.view.superview?.addGestureRecognizer(tap)
        }
        
    }
    /**
     DeleteAlbumCover
     > RealmDB와 Document에서 선택된 앨범에 관련된 정보를 모두 제거하는 함수
     */
    private func deleteAlbumCover(_ albumIndex : Int, _ albumName : String) {
        
        // Load data from RealmDB
        let albumCoverNum = realm.objects(albumCover.self).count
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(albumIndex)")
        let albumData = realm.objects(album.self).filter("index = \(albumIndex)")
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(albumIndex)")
        
        // Delete Data from RealmDB
        do {
            try realm.write{
                realm.delete(albumCoverData)
                realm.delete(albumData)
                realm.delete(albumsInfoData)
            }
        } catch {
            print("RealmDB에서 파일을 삭제하지 못했습니다.")
        }
        
        // Delete Data from Documents
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let albumDirectory = documentDirectory.appendingPathComponent(albumName)
        if FileManager.default.fileExists(atPath: albumDirectory.path) {
            do {
                try FileManager.default.removeItem(at: albumDirectory)
            } catch {
                print("폴더를 삭제하지 못했습니다.")
            }
        }
        
        // Change other albums' index
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
        
        // Reload data of collectionView in HomeScreenView
        collectionView.reloadData()
        
    }
    /**
     ModifyAlbumCover
     > RealmDB와 Document에서 선택된 앨범에 관련된 정보를 수정하는 함수
     */
    private func modifyAlbumCover(_ albumIndex : Int, _ albumName : String) {
        
        // Creat a new HomeEditViewController
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as? HomeEditViewController else{ return }
        
        // Set viewController's style and properties
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.collectionViewInHome = self.collectionView
        // Information to modify
        editVC.IsModifyingView = true
        editVC.albumNameBeforeModify = albumName
        editVC.coverImageBeforeModify = realm.objects(albumCover.self).filter("id = \(albumIndex)").first!.coverImageName
        editVC.id = albumIndex
        
        self.present(editVC, animated: false)
        
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
