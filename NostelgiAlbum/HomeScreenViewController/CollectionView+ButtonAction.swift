import UIKit

// - MARK: CollectionView + ButtonAction
extension HomeScreenViewController {
    
    // - MARK: custom LongPressGuesture Reconizer :: 인자 전달을 위해 선언
    class customLongPressGesture : UILongPressGestureRecognizer {
        var albumIndex : Int!
        var albumName : String!
    }
    
     // - MARK: didLongPressView gesture :: 꾹 누르는 제스처 동작 설정
    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        
        // [1] Alert 생성
        let longPressAlert = UIAlertController(title: (gesture.albumName), message: .none, preferredStyle: .alert)
        
        // [2] Alert Action 설정 :: "앨범 삭제", "앨범 수정"
        // 앨범 삭제 :: RealmDB & Documents 에서 정보 삭제
        let delete = UIAlertAction(title: "앨범 삭제", style: .default) {
            (action) in self.deleteAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        delete.setValue(UIColor.blue, forKey: "titleTextColor")
        // 앨범 수정 :: RealmDB & Documents 에서 albumCover 관련 정보 변경
        let modify = UIAlertAction(title: "앨범 수정", style: .default) {
            (action) in self.modifyAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        modify.setValue(UIColor.blue, forKey: "titleTextColor")
        
        // [3] Alert Action을 longPressAlert에 추가
        longPressAlert.addAction(delete)
        longPressAlert.addAction(modify)
        
        // [4] Alert을 화면에 표시
        present(longPressAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            longPressAlert.view.superview?.isUserInteractionEnabled = true
            longPressAlert.view.superview?.addGestureRecognizer(tap)
        }
        
    }
    
    // - MARK: deleteAlbumCover :: LongPressAlert Action 중 앨범 삭제 버튼에 대한 Action
    private func deleteAlbumCover(_ albumIndex : Int, _ albumName : String) {
        
        // [1] RealmDB에서 삭제에 필요한 정보 불러옴
        let albumCoverNum = realm.objects(albumCover.self).count
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(albumIndex)")
        let albumData = realm.objects(album.self).filter("index = \(albumIndex)")
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(albumIndex)")
        
        // [2] RealmDB에서 불러온 정보들을 모두 삭제
        do {
            try realm.write{
                realm.delete(albumCoverData)
                realm.delete(albumData)
                realm.delete(albumsInfoData)
            }
        } catch {
            print("RealmDB에서 파일을 삭제하지 못했습니다.")
        }
        
        // [3] Documents에서 관련 정보 및 파일을 삭제
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let albumDirectory = documentDirectory.appendingPathComponent(albumName)
        if FileManager.default.fileExists(atPath: albumDirectory.path) {
            do {
                try FileManager.default.removeItem(at: albumDirectory)
            } catch {
                print("폴더를 삭제하지 못했습니다.")
            }
        }
        
        // [4] Documents 폴더안의 각 Album 폴더의 사진들의 index를 재설정 :: 앞의 사진이 지워진 경우 뒤의 사진들의 index를 다 당겨줘야 함
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
        
        // [5] HomeScreenView의 collectionView의 정보를 reload
        collectionView.reloadData()
        
    }
    
    // - MARK: modifyAlbumCover :: LongPressAlert Action 중 앨범 수정 버튼에 대한 Action
    private func modifyAlbumCover(_ albumIndex : Int, _ albumName : String) {
        
        // [1] 새로운 HomeEditViewController 생성
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as? HomeEditViewController else{ return }
        
        // [2] HomeEditViewController 기본 설정
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.collectionViewInHome = self.collectionView
        editVC.IsModifyingView = true
        editVC.albumNameBeforeModify = albumName
        editVC.coverImageBeforeModify = realm.objects(albumCover.self).filter("id = \(albumIndex)").first!.coverImageName
        editVC.id = albumIndex
        
        // [3] HomeEditViewController Modal로 띄우기
        self.present(editVC, animated: false)
        
    }
    
    // - MARK: didTappedOutside :: Alert 바깥을 Tap 하면 Alert이 사라지도록 함
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
