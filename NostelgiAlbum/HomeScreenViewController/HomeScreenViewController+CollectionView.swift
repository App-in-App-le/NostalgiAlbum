import UIKit
import RealmSwift

enum HomeScreenViewErrorMessage: String, Error {
    case reviewAlbumError = "앨범 폴더 사진에 오류가 발생하였습니다." // Critial
    case deleteAlbumError = "앨범 삭제 중 오류가 발생하였습니다." // Not Critial
}

extension HomeScreenViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 재사용 셀 생성
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        // Properties 초기화
        let cellHeight = collectionView.bounds.height / 3 / 5 * 4
        let cellWidth = cellHeight / 4 * 3
        // 버튼 Width, Height 설정
        cell.setFirstButton(height: cellHeight)
        cell.setSecondButton(height: cellHeight)
        // 기본 이미지 설정
        cell.firstButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.secondButton.setImage(UIImage(systemName: "plus"), for: .normal)
        // LongPressGesture를 위해 초기화
        cell.firstButton.gestureRecognizers = nil
        cell.secondButton.gestureRecognizers = nil
        // CornerRadius 설정
        cell.firstButton.layer.masksToBounds = true
        cell.secondButton.layer.masksToBounds = true
        cell.firstButton.layer.cornerRadius = 10
        cell.secondButton.layer.cornerRadius = 10
        // 하단 줄 색상 설정
        cell.bottomLabel.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
        // 셀 전체 테마 색 적용
        cell.setThemeColor()
        // 버튼 뒤, 그림자 설정
        cell.setShadow()
        
        // CollectionView에 표현되어야 하는 Cell 개수 (data.count + 1[Empty Space])
        let cover_num = realm.objects(albumCover.self).count + 1
        
        // MARK: RealmDB에 있는 정보 중, 각 Cell의 버튼들에 해당하는 정보들을 입력
        // FIRST CASE :: Cell의 First & Second Button이 모두 정보가 존재하는 경우
        if (indexPath.row + 1) * 2 <= cover_num {
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            
            if let firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first {
                if firstbuttonInfo.isCustomCover == false {
                    cell.firstButton.setImage(UIImage(named: firstbuttonInfo.coverImageName)?.resize(newWidth: cellWidth, newHeight: cellHeight, byScale: false), for: .normal)
                } else {
                    let customCoverImage = loadImageFromDocumentDirectory(imageName: "\(firstbuttonInfo.albumName)_CoverImage.jpeg", albumTitle: firstbuttonInfo.albumName)
                    if customCoverImage == nil {
                        cell.firstButton.setImage(UIImage(named: "Blue"), for: .normal)
                        do {
                            try realm.write {
                                firstbuttonInfo.coverImageName = "Blue"
                                firstbuttonInfo.isCustomCover = false
                            }
                        } catch let error {
                            print("extension HomeScreenViewController: UICollectionViewDataSource - customCover Error : \(error)")
                        }
                    } else {
                        cell.firstButton.setImage(customCoverImage?.resize(newWidth: cellWidth, newHeight: cellHeight, byScale: false), for: .normal)
                    }
                }
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 1
                LongPressGestureRecognizer.albumName = firstbuttonInfo.albumName
                cell.firstButton.addGestureRecognizer(LongPressGestureRecognizer)
            } else {
                print("RealmDB Error occur!")
            }
            
            if let secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first {
                if secondbuttonInfo.isCustomCover == false {
                    cell.secondButton.setImage(UIImage(named: secondbuttonInfo.coverImageName)?.resize(newWidth: cellWidth, newHeight: cellHeight, byScale: false), for: .normal)
                } else {
                    let customCoverImage = loadImageFromDocumentDirectory(imageName: "\(secondbuttonInfo.albumName)_CoverImage.jpeg", albumTitle: secondbuttonInfo.albumName)
                    if customCoverImage == nil {
                        cell.secondButton.setImage(UIImage(named: "Blue"), for: .normal)
                        do {
                            try realm.write {
                                secondbuttonInfo.coverImageName = "Blue"
                                secondbuttonInfo.isCustomCover = false
                            }
                        } catch let error {
                            print("extension HomeScreenViewController: UICollectionViewDataSource - customCover Error : \(error)")
                        }
                    } else {
                        cell.secondButton.setImage(customCoverImage?.resize(newWidth: cellWidth, newHeight: cellHeight, byScale: false), for: .normal)
                    }
                }
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 2
                LongPressGestureRecognizer.albumName = secondbuttonInfo.albumName
                cell.secondButton.addGestureRecognizer(LongPressGestureRecognizer)
            }
        }
        // SECOND CASE :: cover_num이 홀수 개인 경우, 마지막 빈 버튼에 대한 처리
        else if (indexPath.row + 1) * 2 - 1 == cover_num{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = true
        }
        // THIRD CASE :: 정보가 없는 Button들에 대한 처리
        else{
            cell.firstButton.isHidden = true
            cell.secondButton.isHidden = true
        }
        
        // MARK: 각 버튼들이 눌렸을 때의 동작(Call Back)을 정의
        cell.callBack1 = {
            if cell.firstButton.imageView?.image == UIImage(systemName: "plus"){
                // 새로운 앨범을 만드는 Edit modal present
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as! HomeEditViewController
                editVC.collectionViewInHome = self.collectionView
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.modalTransitionStyle = .crossDissolve
                self.present(editVC, animated: true)
            } else {
                // pushVC 생성 이전 앨범 폴더에 사진이 정상적으로 들어가 있는지 확인
                let albumName = self.realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first!.albumName
                if self.reviewPicturesInAlbum(albumName: albumName) {
                    // pushVC 생성
                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as! AlbumScreenViewController
                    pushVC.coverIndex = indexPath.row * 2 + 1
                    pushVC.pageNum = 0
                    self.navigationController?.pushViewController(pushVC, animated: false)
                    // 앨범 진입 방식에 따라 시작 페이지 설정하는 부분
                    let albumInfo = self.realm.objects(albumsInfo.self).filter("id = \(indexPath.row * 2 + 1)").first!
                    let firstPageSetting = albumInfo.firstPageSetting
                    switch firstPageSetting {
                    case 0:
                        print("pass")
                    case 1:
                        if albumInfo.numberOfPictures / 2 > 0 {
                            pushVC.pushPage(currentPageNum: 1, targetPageNum: albumInfo.numberOfPictures / 2)
                        }
                    case 2:
                        if albumInfo.lastViewingPage - 1 > 0 {
                            pushVC.pushPage(currentPageNum: 1, targetPageNum: albumInfo.lastViewingPage - 1)
                        }
                    default:
                        return
                    }
                } else {
                    NSErrorHandling_Alert(error: HomeScreenViewErrorMessage.reviewAlbumError, vc: self)
                }
            }
        }
        cell.callBack2 = {
            if cell.secondButton.imageView?.image == UIImage(systemName: "plus"){
                // 새로운 앨범을 만드는 Edit modal present
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as! HomeEditViewController
                editVC.collectionViewInHome = self.collectionView
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.modalTransitionStyle = .crossDissolve
                self.present(editVC, animated: true)
            } else {
                // pushVC 생성 이전 앨범 폴더에 사진이 정상적으로 들어가 있는지 확인
                let albumName = self.realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first!.albumName
                if self.reviewPicturesInAlbum(albumName: albumName) {
                    // AlbumScreenVC push
                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as! AlbumScreenViewController
                    pushVC.coverIndex = indexPath.row * 2 + 2
                    pushVC.pageNum = 0
                    self.navigationController?.pushViewController(pushVC, animated: false)
                    // 앨범 진입 방식에 따라 시작 페이지 설정하는 부분
                    let albumInfo = self.realm.objects(albumsInfo.self).filter("id = \(indexPath.row * 2 + 2)").first!
                    let firstPageSetting = albumInfo.firstPageSetting
                    switch firstPageSetting {
                    case 0:
                        print("pass")
                    case 1:
                        if albumInfo.numberOfPictures / 2 > 0 {
                            pushVC.pushPage(currentPageNum: 1, targetPageNum: albumInfo.numberOfPictures / 2)
                        }
                    case 2:
                        if albumInfo.lastViewingPage - 1 > 0 {
                            pushVC.pushPage(currentPageNum: 1, targetPageNum: albumInfo.lastViewingPage - 1)
                        }
                    default:
                        return
                    }
                } else {
                    NSErrorHandling_Alert(error: HomeScreenViewErrorMessage.reviewAlbumError, vc: self)
                }
            }
        }
        return cell
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeScreenViewController {
    func reviewPicturesInAlbum(albumName: String) -> Bool {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document load error in extension HomeScreenViewController: UICollectionViewDataSource :: func reviewPicturesInAlbum(albumName: String)")
            return false
        }
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.appendingPathComponent(albumName).path)
            for content in contents {
                if !content.hasPrefix(albumName) {
                    var splitResult = content.split(separator: "_")
                    splitResult[0] = Substring(stringLiteral: albumName)
                    let modifiedContent = splitResult.joined(separator: "_")
                    
                    let originalName = documentDirectory.appendingPathComponent(albumName).appendingPathComponent(content)
                    let modifiedName = documentDirectory.appendingPathComponent(albumName).appendingPathComponent(modifiedContent)
                    
                    try FileManager.default.moveItem(at: originalName, to: modifiedName)
                }
            }
        } catch let error {
            print("Rename picture error in extension HomeScreenViewController: UICollectionViewDataSource :: reviewPicturesInAlbum func : \(error)")
            return false
        }
        
        return true
    }
}

func deleteRestDirectoryInDocument() {
    let realm = try! Realm()
    let albumCoverData = realm.objects(albumCover.self)
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }
    do {
        let albumFolders = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
        for albumFolder in albumFolders {
            if !albumFolder.hasPrefix("default") && !albumFolder.hasPrefix("Inbox") {
                var check = false
                for coverData in albumCoverData {
                    if coverData.albumName == albumFolder {
                        check = true
                    }
                }
                if !check {
                    do {
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(albumFolder))
                    } catch {
                        print("FileManagerError in DeleteRestAlbumDirectory-1")
                        return
                    }
                }
            }
        }
    } catch {
        print("FileManagerError in DeleteRestAlbumDirectory-2")
        return
    }
}
