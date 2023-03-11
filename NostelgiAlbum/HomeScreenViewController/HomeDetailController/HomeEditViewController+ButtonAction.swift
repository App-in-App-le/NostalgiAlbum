import UIKit
import RealmSwift

// - MARK: HomeEditViewController + ButtonAction
extension HomeEditViewController {
    
    // - MARK: "save" 버튼 Action
    @IBAction func saveAlbum(_ sender: Any) {
        
        // realm 객체 생성
        let realm = try! Realm()
        
        // 새로운 앨범을 생성하는 경우
        if !IsModifyingView {
            
            // 앨범의 제목이나 이미지를 설정하지 않은 경우 Alert을 띄움
            if albumName.text == "" {
                let textAlert = UIAlertController(title: "빈 제목", message: "제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                present(textAlert, animated: true){
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                    textAlert.view.superview?.isUserInteractionEnabled = true
                    textAlert.view.superview?.addGestureRecognizer(tap)
                }
                return
            }
            if coverImage.image == UIImage(systemName: "photo"){
                let imageAlert = UIAlertController(title: "빈 이미지", message: "이미지를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
                present(imageAlert, animated: true){
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                    imageAlert.view.superview?.isUserInteractionEnabled = true
                    imageAlert.view.superview?.addGestureRecognizer(tap)
                }
                return
            }
            
            // 새로운 albumCover realm 객체를 생성
            let newAlbumCover = albumCover()
            newAlbumCover.incrementIndex()
            newAlbumCover.albumName = albumName.text!
            if coverImage.image == UIImage(named: "Blue"){
                newAlbumCover.coverImageName = "Blue"
            }
            else if coverImage.image == UIImage(named: "Brown"){
                newAlbumCover.coverImageName = "Brown"
            }
            else if coverImage.image == UIImage(named: "Green"){
                newAlbumCover.coverImageName = "Green"
            }
            else if coverImage.image == UIImage(named: "Pupple"){
                newAlbumCover.coverImageName = "Pupple"
            }
            else if coverImage.image == UIImage(named: "Red"){
                newAlbumCover.coverImageName = "Red"
            }
            else if coverImage.image == UIImage(named: "Turquoise"){
                newAlbumCover.coverImageName = "Turquoise"
            }
            else{
                print("error!")
                return
            }
            
            // 새로운 albumsInfo realm 객체를 생성
            let newAlbumsInfo = albumsInfo()
            newAlbumsInfo.incrementIndex()
            newAlbumsInfo.setDateOfCreation()
            newAlbumsInfo.numberOfPictures = 0
            
            // 위의 새로운 정보들을 realm 객체에 저장
            try! realm.write
            {
                realm.add(newAlbumCover)
                realm.add(newAlbumsInfo)
            }
            
            // 새로운 앨범에 대한 폴더를 document 파일에 생성 :: 폴더 이름 == "albumName.text"
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            
            let dirPath = documentDirectory.appendingPathComponent(albumName.text!)
            if !FileManager.default.fileExists(atPath: dirPath.path){
                do{
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch{
                    NSLog("Couldn't create document directory")
                }
            }
        }
        
        // 기존의 앨범을 수정하는 경우
        else {
            // 앨범의 제목을 설정하지 않은 경우 Alert을 띄움
            if albumName.text == "" {
                let textAlert = UIAlertController(title: "빈 제목", message: "제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                present(textAlert, animated: true){
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                    textAlert.view.superview?.isUserInteractionEnabled = true
                    textAlert.view.superview?.addGestureRecognizer(tap)
                }
                return
            }
            
            // Document 폴더에서 수정된 앨범의 앨범 폴더 이름을 변경
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let albumDirectoryPath = documentDirectory.appendingPathComponent(albumNameBeforeModify)
            let modifyAlbumDirectoryPath = documentDirectory.appendingPathComponent(albumName.text!)
            do{
                try FileManager.default.moveItem(at: albumDirectoryPath, to: modifyAlbumDirectoryPath)
                print("Move succcessful")
            } catch {
                print("Move failed")
            }
            
            // RealmDB에서 해당 앨범에 관련된 albumCover, album 객체를 찾음
            let albumCoverData = realm.objects(albumCover.self).filter("id = \(id)")
            let albumData = realm.objects(album.self).filter("index = \(id)")
            
            // 앨범 폴더 내의 사진 이름을 모두 변경
            for album in albumData {
                let OldPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(album.AlbumTitle)_\(album.perAlbumIndex).jpeg")
                let NewPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumName.text!)_\(album.perAlbumIndex).jpeg")
                do {
                    try FileManager.default.moveItem(at: OldPicturePath, to: NewPicturePath)
                    print("Move succcessful")
                } catch {
                    print("Move failed")
                }
            }
            
            // RealmDB의 객체 정보들을 수정 :: album -> [albumTitle], albumCover -> [albumName, CoverImageName]
            try! realm.write{
                // Modify "albumCover" instance in RealmDB
                albumCoverData.first?.albumName = String(albumName.text!)
                if coverImage.image == UIImage(named: "Blue"){
                    albumCoverData.first?.coverImageName = "Blue"
                }
                else if coverImage.image == UIImage(named: "Brown"){
                    albumCoverData.first?.coverImageName = "Brown"
                }
                else if coverImage.image == UIImage(named: "Green"){
                    albumCoverData.first?.coverImageName = "Green"
                }
                else if coverImage.image == UIImage(named: "Pupple"){
                    albumCoverData.first?.coverImageName = "Pupple"
                }
                else if coverImage.image == UIImage(named: "Red"){
                    albumCoverData.first?.coverImageName = "Red"
                }
                else if coverImage.image == UIImage(named: "Turquoise"){
                    albumCoverData.first?.coverImageName = "Turquoise"
                }
                else{
                    print("error!")
                    return
                }
                // Modify "album" instance in RealmDB
                for album in albumData { album.setAlbumTitle(albumName.text!) }
            }
        }
        
        // HomeScreenView의 collectionView를 reload
        collectionViewInHome.reloadData()
        
        // EditViewController modal을 dismiss
        dismiss(animated: false, completion: nil)
        
    }
    
    // - MARK: "close" 버튼 Action
    @IBAction func closeButton(_ sender: Any) {
        
        // EditView를 dismiss 하도록 함
        dismiss(animated: false, completion: nil)
        
    }
    
    // - MARK: "Image" 버튼 Action
    @IBAction func addImage(_ sender: Any) {
        // 기본 커버 or 커스텀 커버 중 택하는 Alert 생성
        let selectCoverTypeAlert = UIAlertController(title: "커버 타입", message: .none, preferredStyle: .alert)
        
        // 해당 Alert의 Action을 설정
        selectCoverTypeAlert.addAction(UIAlertAction(title: "기본 커버", style: .default) { action in
            // 색을 지정
            let colors = [ "파란색" : "Blue", "갈색" : "Brown", "녹색" : "Green", "보라색" : "Pupple", "빨간색" : "Red", "청록색" : "Turquoise"]
            
            // Alert을 생성하고 Action을 지정
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            
            // 색 별로 Action을 Alert에 등록
            colors.forEach { color in
                alert.addAction(UIAlertAction(title: color.key, style: .default) { action in
                    self.setCoverImage(color: color.value)
                })
            }
            
            // Alert을 띄움
            self.present(alert, animated: true) {
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
            }
        })
        
        selectCoverTypeAlert.addAction(UIAlertAction(title: "커버 만들기", style: .default) { action in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let library = UIAlertAction(title: "사진 앨범", style: .default){(action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                self.present(picker, animated: false, completion: nil)
            }
            let camera = UIAlertAction(title: "카메라", style: .default){(action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .camera
                self.present(picker, animated: false, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        })
        
        present(selectCoverTypeAlert, animated: true) {
            selectCoverTypeAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
        }
        
    }
    
    // - MARK: "setCoverImage" 함수
    func setCoverImage(color: String) {
        
        switch color {
        case "Blue" :
            coverImage.image = UIImage(named: "Blue")
        case "Brown" :
            coverImage.image = UIImage(named: "Brown")
        case "Green":
            coverImage.image = UIImage(named: "Green")
        case "Pupple":
            coverImage.image = UIImage(named: "Pupple")
        case "Red":
            coverImage.image = UIImage(named: "Red")
        case "Turquoise":
            coverImage.image = UIImage(named: "Turquoise")
        default:
            coverImage.image = nil
        }
        
    }
    
    // - MARK: 해당 view 바깥을 tap하면 dismiss 되도록하는 함수
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

// - MARK: HomeEditViewController + pickerControllerDelegate
extension HomeEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            coverImage.image = image.resize(newWidth: coverImage.frame.size.width, newHeight: coverImage.frame.size.height)
            dismiss(animated: true, completion: nil)
        }
    }
}

// - MARK: HomeEditViewController + UITextFieldDelegate
extension HomeEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 새로운 HomeEditViewController 생성
        guard let editAlbumNameVC = self.storyboard?.instantiateViewController(withIdentifier: "SetAlbumNameViewController") as? SetAlbumNameViewController else{ return }
        // 이런 부분들 전부 동기적 or 비동기적 처리(Combine or Rxswift)로 바꿔야 될 것 같음 -> 공부 + 논의 필요
        // 1. 모달로 뜬 부분에 입력을 받음
        // 2. 모달의 확인 버튼을 누르거나 취소 버튼을 누를 때 까지 동작 정지
        // 3. 모달의 확인 버튼을 누르거나 취소 버튼을 누르면 동작이 다시 시작되도록 함.
        editAlbumNameVC.editVC = self
        editAlbumNameVC.modalPresentationStyle = .currentContext
        editAlbumNameVC.modalTransitionStyle = .crossDissolve
        self.present(editAlbumNameVC, animated: true)
    }
}
