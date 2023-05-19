import UIKit
import RealmSwift
import Mantis

extension HomeEditViewController {
    @IBAction func addImage(_ sender: Any) {
        // selectCoverTypeAlert
        let selectCoverTypeAlert = UIAlertController(title: "커버 타입", message: .none, preferredStyle: .alert)
        selectCoverTypeAlert.setFont(font: nil, title: "커버 타입", message: nil)
        
        // selectCoverTypeAlert "기본 커버" Action
        selectCoverTypeAlert.addAction(UIAlertAction(title: "기본", style: .default) { action in
            let colors = [ "파란색" : "Blue", "갈색" : "Brown", "녹색" : "Green", "보라색" : "Pupple", "빨간색" : "Red", "청록색" : "Turquoise"].sorted(by: <)
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            colors.forEach { color in
                alert.addAction(UIAlertAction(title: color.key, style: .default) { action in
                    self.setCoverImage(color: color.value)
                })
            }
            self.present(alert, animated: true) {
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
            }
        })
        
        // selectCoverTypeAlert "커버 만들기" Action
        selectCoverTypeAlert.addAction(UIAlertAction(title: "사진", style: .default) { action in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let library = UIAlertAction(title: "사진 앨범", style: .default){(action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: false, completion: nil)
            }
            let camera = UIAlertAction(title: "카메라", style: .default){(action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: false, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        })
        
        // 해당 Alert Present
        present(selectCoverTypeAlert, animated: true) {
            selectCoverTypeAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
        }
    }
    
    func setCoverImage(color: String) {
        switch color {
        case "Blue" :
            coverImage.image = UIImage(named: "Blue")?.resize(newWidth: 150, newHeight: 200, byScale: false)
        case "Brown" :
            coverImage.image = UIImage(named: "Brown")?.resize(newWidth: 150, newHeight: 200, byScale: false)
        case "Green":
            coverImage.image = UIImage(named: "Green")?.resize(newWidth: 150, newHeight: 200, byScale: false)
        case "Pupple":
            coverImage.image = UIImage(named: "Pupple")?.resize(newWidth: 150, newHeight: 200, byScale: false)
        case "Red":
            coverImage.image = UIImage(named: "Red")?.resize(newWidth: 150, newHeight: 200, byScale: false)
        case "Turquoise":
            coverImage.image = UIImage(named: "Turquoise")?.resize(newWidth: 150, newHeight: 200, byScale: false)
        default:
            coverImage.image = nil
        }
        defaultCoverColor = color
    }
    
    @IBAction func saveAlbum(_ sender: Any) {
        // RealmDB 백업본 생성
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentDirectory.appendingPathComponent("RealmDB_backup").appendingPathComponent("default.realm")
        
        do{
            if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("RealmDB_backup").path) {
                try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("RealmDB_backup"))
            }
            try FileManager.default.createDirectory(atPath: documentDirectory.appendingPathComponent("RealmDB_backup").path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.copyItem(at: documentDirectory.appendingPathComponent("default.realm"), to: destinationURL)
        } catch let error {
            print("RealmDB BackUP in HomeEditViewController's saveAlbum Func :: \(error)")
            NSErrorHandling_Alert(error: error, vc: self)
            return
        }
        
        // 빈 제목 경고 처리
        if albumName.text == "" {
            let textAlert = UIAlertController(title: "빈 제목", message: "제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            present(textAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                textAlert.view.superview?.isUserInteractionEnabled = true
                textAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        }
        
        // 중복 제목 경고 처리
        if checkExistedAlbum(albumCoverName: albumName.text!) == true && albumNameBeforeModify != albumName.text {
            let duplicateNameAlert = UIAlertController(title: "중복 제목", message: "동일한 제목의 앨범이 존재합니다.", preferredStyle: UIAlertController.Style.alert)
            present(duplicateNameAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                duplicateNameAlert.view.superview?.isUserInteractionEnabled = true
                duplicateNameAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        }
        
        // RealmDB 객체 생성
        let realm = try! Realm()
        
        // 새로운 앨범을 생성하는 경우
        if !IsModifyingView {
            // 빈 이미지 경고 처리
            if coverImage.image == UIImage(systemName: "photo.on.rectangle.angled"){
                let imageAlert = UIAlertController(title: "빈 이미지", message: "이미지를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
                present(imageAlert, animated: true){
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                    imageAlert.view.superview?.isUserInteractionEnabled = true
                    imageAlert.view.superview?.addGestureRecognizer(tap)
                }
                return
            }
            // Document에 새로운 앨범 폴더 생성
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let dirPath = documentDirectory.appendingPathComponent(albumName.text!)
            if !FileManager.default.fileExists(atPath: dirPath.path){
                do{
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch let error {
                    NSLog("Couldn't create document directory")
                    deleteTmpFiles()
                    collectionViewInHome.reloadData()
                    dismiss(animated: false) {
                        NSErrorHandling_Alert(error: error, vc: self)
                    }
                    return
                }
            }
            // RealmDB에 새로운 앨범 관련 정보 추가
            let newAlbumCover = albumCover()
            newAlbumCover.incrementIndex()
            newAlbumCover.albumName = albumName.text!
            if defaultCoverColor == "Blue" {
                newAlbumCover.coverImageName = "Blue"
            }
            else if defaultCoverColor == "Brown" {
                newAlbumCover.coverImageName = "Brown"
            }
            else if defaultCoverColor == "Green" {
                newAlbumCover.coverImageName = "Green"
            }
            else if defaultCoverColor == "Pupple" {
                newAlbumCover.coverImageName = "Pupple"
            }
            else if defaultCoverColor == "Red" {
                newAlbumCover.coverImageName = "Red"
            }
            else if defaultCoverColor == "Turquoise" {
                newAlbumCover.coverImageName = "Turquoise"
            }
            else{
                // Custom Cover
                newAlbumCover.coverImageName = "Custom"
                newAlbumCover.isCustomCover = true
                // Document의 앨범 폴더에 Cover Image 저장
                let customCoverImagePath = "\(albumName.text!)_CoverImage.jpeg"
                let height = collectionViewInHome.bounds.height / 3 / 5 * 4
                let width = height / 4 * 3
                do {
                    try saveImageToDocumentDirectory(imageName: customCoverImagePath, image: (coverImage.image?.resize(newWidth: width, newHeight: height, byScale: false))!, AlbumCoverName: albumName.text!)
                } catch let error {
                    print("save Album Error :: \(error.localizedDescription)")
                    do{
                        try FileManager.default.removeItem(atPath: dirPath.path)
                    } catch let error {
                        print("Couldn't create document directory \(error)")
                        deleteTmpFiles()
                        collectionViewInHome.reloadData()
                        dismiss(animated: false) {
                            NSErrorHandling_Alert(error: error, vc: self)
                        }
                        return
                    }
                    deleteTmpFiles()
                    collectionViewInHome.reloadData()
                    dismiss(animated: false) {
                        NSErrorHandling_Alert(error: error, vc: self)
                    }
                    return
                }
            }
            // 새로운 RealmDB albumdsInfo 객체 생성
            let newAlbumsInfo = albumsInfo()
            newAlbumsInfo.incrementIndex()
            newAlbumsInfo.setDateOfCreation()
            newAlbumsInfo.numberOfPictures = 0
            do {
                try realm.write {
                    realm.add(newAlbumCover)
                    realm.add(newAlbumsInfo)
                }
            } catch let error {
                // 새로 생긴 앨범 Directory 삭제
                if FileManager.default.fileExists(atPath: dirPath.path) {
                    do{
                        try FileManager.default.removeItem(atPath: dirPath.path)
                    } catch let error {
                        print("Couldn't create document directory \(error)")
                        deleteTmpFiles()
                        collectionViewInHome.reloadData()
                        dismiss(animated: false) {
                            NSErrorHandling_Alert(error: error, vc: self)
                        }
                        return
                    }
                }
                print("RealmDB Write Error Occur : \(error)")
                deleteTmpFiles()
                collectionViewInHome.reloadData()
                dismiss(animated: false) {
                    NSErrorHandling_Alert(error: error, vc: self)
                }
                return
            }
        }
        
        // 앨범을 수정하는 경우
        else {
            // RealmDB 정보
            let albumCoverData = realm.objects(albumCover.self).filter("id = \(id)")
            let albumData = realm.objects(album.self).filter("index = \(id)")
            let coverStateBeforeModify = albumCoverData.first!.isCustomCover
            let albumNameBeforeModify = albumCoverData.first!.albumName
            
            // Document 정보
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let albumDirectoryPath = documentDirectory.appendingPathComponent(albumNameBeforeModify)
            let modifyAlbumDirectoryPath = documentDirectory.appendingPathComponent(albumName.text!)
            
            // realmDB 정보 수정
            do {
                try realm.write{
                    // Modify "albumCover" instance in RealmDB
                    albumCoverData.first?.albumName = albumName.text!.precomposedStringWithCanonicalMapping
                    if defaultCoverColor == "Blue" {
                        albumCoverData.first?.coverImageName = "Blue"
                        albumCoverData.first?.isCustomCover = false
                    }
                    else if defaultCoverColor == "Brown" {
                        albumCoverData.first?.coverImageName = "Brown"
                        albumCoverData.first?.isCustomCover = false
                    }
                    else if defaultCoverColor == "Green" {
                        albumCoverData.first?.coverImageName = "Green"
                        albumCoverData.first?.isCustomCover = false
                    }
                    else if defaultCoverColor == "Pupple" {
                        albumCoverData.first?.coverImageName = "Pupple"
                        albumCoverData.first?.isCustomCover = false
                    }
                    else if defaultCoverColor == "Red" {
                        albumCoverData.first?.coverImageName = "Red"
                        albumCoverData.first?.isCustomCover = false
                    }
                    else if defaultCoverColor == "Turquoise" {
                        albumCoverData.first?.coverImageName = "Turquoise"
                        albumCoverData.first?.isCustomCover = false
                    } else {
                        // Modify to Custom Image
                        albumCoverData.first?.coverImageName = "Custom"
                        albumCoverData.first?.isCustomCover = true
                    }
                    // Modify "album" instance in RealmDB
                    for album in albumData { album.setAlbumTitle(albumName.text!) }
                }
            } catch let error {
                // RealmDB는 트렌잭션 안에서 오류나면 자동 RollBack 됨
                print("Realm write error : \(error.localizedDescription)")
                
                dismiss(animated: false) {
                    NSErrorHandling_Alert(error: error, vc: self)
                }
                return
            }
            
            // Document 정보 수정
            // 앨범 폴더 명 변경
            do{
                try FileManager.default.moveItem(at: albumDirectoryPath, to: modifyAlbumDirectoryPath)
            } catch let error {
                print("FileManager Error Occur :: \(error)")
                // RealmDB 백업본 다시 돌려놓기
                do {
                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("default.realm"))
                    try FileManager.default.moveItem(at: destinationURL, to: documentDirectory.appendingPathComponent("default.realm"))
                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("RealmDB_backup"))
                } catch let error {
                    print("realmDB Backup 파일 복원 실패 :: \(error)")
                }
                
                deleteTmpFiles()
                collectionViewInHome.reloadData()
                dismiss(animated: false) {
                    NSErrorHandling_Alert(error: error, vc: self)
                }
                return
            }
            
            // 앨범 커스텀 커버 이미지
            if coverStateBeforeModify {
                do {
                    try deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumNameBeforeModify)_CoverImage.jpeg")
                } catch let error {
                    // MARK: - 여기
                    // RealmDB 백업본 다시 돌려놓기
                    do {
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("default.realm"))
                        try FileManager.default.moveItem(at: destinationURL, to: documentDirectory.appendingPathComponent("default.realm"))
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("RealmDB_backup"))
                    } catch let error {
                        print("realmDB Backup 파일 복원 실패 :: \(error)")
                    }
                    
                    // 폴더 명 돌려놓기
                    do {
                        try FileManager.default.moveItem(at: modifyAlbumDirectoryPath, to: albumDirectoryPath)
                    } catch let error {
                        print("폴더 명 복구 실패 :: \(error)")
                    }
                    
                    deleteTmpFiles()
                    collectionViewInHome.reloadData()
                    dismiss(animated: false) {
                        NSErrorHandling_Alert(error: error, vc: self)
                    }
                    return
                }
            }
            
            if albumCoverData.first!.isCustomCover {
                let customCoverImagePath = "\(albumName.text!)_CoverImage.jpeg"
                let height = collectionViewInHome.bounds.height / 3 / 5 * 4
                let width = height / 4 * 3
                do {
                    try saveImageToDocumentDirectory(imageName: customCoverImagePath, image: (coverImage.image?.resize(newWidth: width, newHeight: height, byScale: false))!, AlbumCoverName: albumName.text!)
                } catch let error {
                    print("save Album Error :: \(error.localizedDescription)")
                    // RealmDB 백업본 다시 돌려놓기
                    do {
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("default.realm"))
                        try FileManager.default.moveItem(at: destinationURL, to: documentDirectory.appendingPathComponent("default.realm"))
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("RealmDB_backup"))
                    } catch let error {
                        print("realmDB Backup 파일 복원 실패 :: \(error)")
                    }
                    
                    // 폴더 명 돌려놓기
                    do {
                        try FileManager.default.moveItem(at: modifyAlbumDirectoryPath, to: albumDirectoryPath)
                    } catch let error {
                        print("폴더 명 복구 실패 :: \(error)")
                    }
                    
                    // CustomCover image가 없는 상태이기 때문에 realmDB의 isCustomCover == true 일 때, 사진이 없는 경우 특정 이미지 혹은 사진이 들어가도록 설정
                    // extension HomeScreenViewController: UICollectionViewDataSource 에서 CollectionViewCell 만들 때 해결
                    // isCustomCover == true 인데 이미지를 불러왔을 때 nil인 경우 이미지를 blue로 만들고 RealmDB에 커버 관련 변수 값들을 변경
                    
                    deleteTmpFiles()
                    collectionViewInHome.reloadData()
                    dismiss(animated: false) {
                        NSErrorHandling_Alert(error: error, vc: self)
                    }
                    return
                }
            }
            
            // Album Pictures' Image
            for album in albumData {
                let oldPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumNameBeforeModify)_\(album.perAlbumIndex).jpeg")
                let newPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumName.text!)_\(album.perAlbumIndex).jpeg")
                do {
                    try FileManager.default.moveItem(at: oldPicturePath, to: newPicturePath)
                } catch let error {
                    print("FileManager Error Occur :: \(error)")
                    // Cell을 눌렀을 경우 무조건 한번씩 검사해서 (앨범 폴더명)_(숫자)가 안바뀐 사진을 찾아 변경
                    // Cell을 누르고 Push를 하기 이전에 extension HomeScreenViewController: UICollectionViewDataSource 에서 검사 (reviewPicturesInAlbum 함수로 처리)
                }
            }
        }
        
        // realmDB 수정본 삭제
        do {
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("RealmDB_backup"))
        } catch let error {
            // 작동을 멈추지는 않고 앱 시작 시, 백업본이 있으면 삭제하는 방향으로 구현
            // Alert도 굳이 띄우지는 않도록 하기
            print("Error occur when delete RealmDB backup file in HomeEditViewController's saveAlbum Func :: \(error)")
        }
        
        deleteTmpFiles()
        collectionViewInHome.reloadData()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        // Dismiss EditView
        dismiss(animated: false, completion: nil)
    }
    
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // editAlbumNameViewController
        guard let editAlbumNameVC = self.storyboard?.instantiateViewController(withIdentifier: "SetAlbumNameViewController") as? SetAlbumNameViewController else{ return }
        editAlbumNameVC.editVC = self
        editAlbumNameVC.modalPresentationStyle = .overCurrentContext
        editAlbumNameVC.modalTransitionStyle = .crossDissolve
        // Present modal
        self.present(editAlbumNameVC, animated: true)
    }
}

extension HomeEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.openCropVC(image: image)
            }
        }
    }
}

extension HomeEditViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        self.coverImage.image = cropped.resize(newWidth: 150, newHeight: 200, byScale: false)
        defaultCoverColor = "Custom"
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    private func openCropVC(image: UIImage) {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 3.0 / 4.0)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        
        self.present(cropViewController, animated: true)
    }
}
