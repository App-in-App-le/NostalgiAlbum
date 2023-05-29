import UIKit

extension HomeScreenViewController {
    
    class customLongPressGesture : UILongPressGestureRecognizer {
        // MARK: - Properties
        var albumIndex : Int!
        var albumName : String!
    }
    
    // MARK: - Methods
    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        // LongPressGuesture 시, present 되는 Alert
        let longPressAlert = UIAlertController(title: gesture.albumName!, message: .none, preferredStyle: .alert)
        longPressAlert.setFont(font: nil, title: gesture.albumName!, message: nil)
        
        // 앨범 정보 삭제
        let delete = UIAlertAction(title: "앨범 삭제", style: .default) { [weak self] action in
            let reconfirmAlert = UIAlertController(title: "앨범 삭제", message: "정말 앨범을 삭제하시겠습니까?", preferredStyle: .alert)
            reconfirmAlert.setFont(font: nil, title: "앨범 삭제", message: "정말 앨범을 삭제하시겠습니까?")
            
            let confirm = UIAlertAction(title: "예", style: .default) { [weak self] action in
                self?.deleteAlbumCover(gesture.albumIndex, gesture.albumName)
            }
            confirm.setValue(UIColor(red: 0.89, green: 0.25, blue: 0.21, alpha: 0.90), forKey: "titleTextColor")
            let cancle = UIAlertAction(title: "아니오", style: .default) { [weak self] action in
                self?.dismiss(animated: true)
            }
            reconfirmAlert.addAction(confirm)
            reconfirmAlert.addAction(cancle)
            self?.present(reconfirmAlert, animated: true)
        }
        delete.setValue(UIColor(red: 0.89, green: 0.25, blue: 0.21, alpha: 0.90), forKey: "titleTextColor")
        
        // 앨범 정보 수정
        let modify = UIAlertAction(title: "앨범 수정", style: .default) {
            (action) in self.modifyAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        
        // Alert에 동작 추가
        longPressAlert.addAction(modify)
        longPressAlert.addAction(delete)
        
        // Alert Present
        present(longPressAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            longPressAlert.view.superview?.isUserInteractionEnabled = true
            longPressAlert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    private func deleteAlbumCover(_ albumIndex : Int, _ albumName : String) {
        // 삭제할 앨범의 RealmDB 정보 불러오기
        let albumCoverNum = realm.objects(albumCover.self).count
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(albumIndex)")
        let albumData = realm.objects(album.self).filter("index = \(albumIndex)")
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(albumIndex)")
        
        let copyCoverData = albumCover()
        copyCoverData.albumName = albumCoverData.first!.albumName
        copyCoverData.coverImageName = albumCoverData.first!.coverImageName
        copyCoverData.isCustomCover = albumCoverData.first!.isCustomCover
        copyCoverData.id = albumCoverData.first!.id
        var copyAlbumData = [album]()
        for picture in albumData {
            let newAlbum = album()
            newAlbum.AlbumTitle = picture.AlbumTitle
            newAlbum.ImageName = picture.ImageName
            newAlbum.ImageText = picture.ImageText
            newAlbum.index = picture.index
            newAlbum.perAlbumIndex = picture.perAlbumIndex
            copyAlbumData.append(newAlbum)
        }
        let copyAlbumsInfoData = albumsInfo()
        copyAlbumsInfoData.id = albumsInfoData.first!.id
        copyAlbumsInfoData.firstPageSetting = albumsInfoData.first!.firstPageSetting
        copyAlbumsInfoData.lastViewingPage = albumsInfoData.first!.lastViewingPage
        copyAlbumsInfoData.numberOfPictures = albumsInfoData.first!.numberOfPictures
        copyAlbumsInfoData.dateOfCreation = albumsInfoData.first!.dateOfCreation
        copyAlbumsInfoData.font = albumsInfoData.first!.font
        
        
        
        // 앨범의 RealmDB 정보 삭제
        do {
            try realm.write{
                realm.delete(albumCoverData)
                realm.delete(albumData)
                realm.delete(albumsInfoData)
            }
        } catch let error {
            print("RealmDB 파일 삭제 오류 발생 : \(error).")
            collectionView.reloadData()
            NSErrorHandling_Alert(error: HomeScreenViewErrorMessage.deleteAlbumError, vc: self)
            return
        }
        
        
        // 삭제된 앨범 뒤의 앨범들과 관련된 Index 변경
        if albumCoverNum != albumIndex{
            do {
                for index in (albumIndex + 1)...albumCoverNum{
                    let albumCoverData = realm.objects(albumCover.self).filter("id = \(index)")
                    let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(index)")
                    let albumData = realm.objects(album.self).filter("index = \(index)")
                    try realm.write{
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
            } catch let error {
                do {
                    try realm.write{
                        realm.add(copyCoverData)
                        realm.add(copyAlbumsInfoData)
                        for albumData in copyAlbumData {
                            realm.add(albumData)
                        }
                    }
                } catch let error {
                    print("Realm write error (critical) : \(error.localizedDescription)")
                    collectionView.reloadData()
                    NSErrorHandling_Alert(error: HomeScreenViewErrorMessage.deleteAlbumError, vc: self)
                    return
                }
                print("Realm write error : \(error.localizedDescription)")
                collectionView.reloadData()
                NSErrorHandling_Alert(error: error, vc: self)
                return
            }
        }
        
        // Document 파일 안에 해당 앨범 폴더 삭제
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let albumDirectory = documentDirectory.appendingPathComponent(albumName)
        if FileManager.default.fileExists(atPath: albumDirectory.path) {
            do {
                try FileManager.default.removeItem(at: albumDirectory)
            } catch let error {
                // 앱 시작 시 RealmDB를 돌아 앨범 폴더 이름과 비교해서 없는 폴더가 있으면 삭제시키도록 함
                print("deleteAlbumCover func cannot delete Album Folder : \(error)")
            }
        }
        
        // 앨범 정보가 삭제되었기 때문에 CollectionView Reload
        collectionView.reloadData()
    }
    
    private func modifyAlbumCover(_ albumIndex : Int, _ albumName : String) {
        // 수정 관련 HomeEditVC 불러오기
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as? HomeEditViewController else{ return }
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.modalTransitionStyle = .crossDissolve
        editVC.collectionViewInHome = self.collectionView
        editVC.IsModifyingView = true
        editVC.albumNameBeforeModify = albumName
        editVC.coverImageBeforeModify = realm.objects(albumCover.self).filter("id = \(albumIndex)").first!.coverImageName
        editVC.id = albumIndex
        
        // 해당 HomeEditVC Present
        self.present(editVC, animated: true)
    }
    
    @IBAction func homeSettingButtonAction(_ sender: Any) {
        // 글꼴 설정 및 iCloud - 백업, 복원 가능한 SettingVC
        guard let homeSettingVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeSettingViewController") as? HomeSettingViewController else { return }
        homeSettingVC.homeScreenViewController = self
        homeSettingVC.homeScreenCollectionView = collectionView
        
        // 해당 SettingVC Present
        homeSettingVC.modalPresentationStyle = .overCurrentContext
        homeSettingVC.modalTransitionStyle = .crossDissolve
        self.present(homeSettingVC, animated: true)
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
