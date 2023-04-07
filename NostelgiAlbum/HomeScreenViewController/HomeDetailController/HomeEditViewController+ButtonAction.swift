import UIKit
import RealmSwift
import Mantis

extension HomeEditViewController {
    @IBAction func addImage(_ sender: Any) {
        // selectCoverTypeAlert
        let selectCoverTypeAlert = UIAlertController(title: "커버 타입", message: .none, preferredStyle: .alert)
        // selectCoverTypeAlert "기본 커버" Action
        selectCoverTypeAlert.addAction(UIAlertAction(title: "기본 커버", style: .default) { action in
            let colors = [ "파란색" : "Blue", "갈색" : "Brown", "녹색" : "Green", "보라색" : "Pupple", "빨간색" : "Red", "청록색" : "Turquoise"]
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
        selectCoverTypeAlert.addAction(UIAlertAction(title: "커버 만들기", style: .default) { action in
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
        
        present(selectCoverTypeAlert, animated: true) {
            selectCoverTypeAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
        }
    }
    
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
    
    @IBAction func saveAlbum(_ sender: Any) {
        // Load realm instance
        let realm = try! Realm()
        // Create new Album
        if !IsModifyingView {
            // Warning Alert
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
            // Make Album Folder in Document
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let dirPath = documentDirectory.appendingPathComponent(albumName.text!)
            if !FileManager.default.fileExists(atPath: dirPath.path){
                do{
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch{
                    NSLog("Couldn't create document directory")
                }
            }
            // Create new albumCover Realm Model Class
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
                // Custom Cover Image
                newAlbumCover.coverImageName = "Custom"
                newAlbumCover.isCustomCover = true
                // Save Custom Image in Album Folder
                let customCoverImagePath = "\(albumName.text!)_CoverImage.jpeg"
                saveImageToDocumentDirectory(imageName: customCoverImagePath, image: coverImage.image!, AlbumCoverName: albumName.text!)
            }
            // Create new Realm albumdsInfo Model Class
            let newAlbumsInfo = albumsInfo()
            newAlbumsInfo.incrementIndex()
            newAlbumsInfo.setDateOfCreation()
            newAlbumsInfo.numberOfPictures = 0
            // Save New Models in Realm
            try! realm.write
            {
                realm.add(newAlbumCover)
                realm.add(newAlbumsInfo)
            }
        }
        // Modify exist Album
        else {
            // Waring Alert
            if albumName.text == "" {
                let textAlert = UIAlertController(title: "빈 제목", message: "제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                present(textAlert, animated: true){
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                    textAlert.view.superview?.isUserInteractionEnabled = true
                    textAlert.view.superview?.addGestureRecognizer(tap)
                }
                return
            }
            // Modify Album Folder's Name
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let albumDirectoryPath = documentDirectory.appendingPathComponent(albumNameBeforeModify)
            let modifyAlbumDirectoryPath = documentDirectory.appendingPathComponent(albumName.text!)
            do{
                try FileManager.default.moveItem(at: albumDirectoryPath, to: modifyAlbumDirectoryPath)
                print("Move succcessful")
            } catch {
                print("Move failed")
            }
            // Find Realm Data that should be modified
            let albumCoverData = realm.objects(albumCover.self).filter("id = \(id)")
            let albumData = realm.objects(album.self).filter("index = \(id)")
            
            // Modify Album Pictures' Name
            // CoverImage
            if albumCoverData.first?.isCustomCover == true {
                let oldPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumCoverData.first!.albumName)_CoverImage.jpeg")
                let newPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumName.text!)_CoverImage.jpeg")
                do {
                    try FileManager.default.moveItem(at: oldPicturePath, to: newPicturePath)
                    print("Move succcessful")
                } catch {
                    print("Move failed")
                }
            }
            // Albume Pictures' Image
            for album in albumData {
                let oldPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(album.AlbumTitle)_\(album.perAlbumIndex).jpeg")
                let newPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumName.text!)_\(album.perAlbumIndex).jpeg")
                do {
                    try FileManager.default.moveItem(at: oldPicturePath, to: newPicturePath)
                    print("Move succcessful")
                } catch {
                    print("Move failed")
                }
            }
            // Modify RealmDB :: album -> [albumTitle], albumCover -> [albumName, CoverImageName]
            try! realm.write{
                // Modify "albumCover" instance in RealmDB
                albumCoverData.first?.albumName = String(albumName.text!)
                if coverImage.image == UIImage(named: "Blue"){
                    albumCoverData.first?.coverImageName = "Blue"
                    if albumCoverData.first?.isCustomCover == true {
                        deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumName.text!)_CoverImage.jpeg")
                    }
                    albumCoverData.first?.isCustomCover = false
                }
                else if coverImage.image == UIImage(named: "Brown"){
                    albumCoverData.first?.coverImageName = "Brown"
                    if albumCoverData.first?.isCustomCover == true {
                        deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumName.text!)_CoverImage.jpeg")
                    }
                    albumCoverData.first?.isCustomCover = false
                }
                else if coverImage.image == UIImage(named: "Green"){
                    albumCoverData.first?.coverImageName = "Green"
                    if albumCoverData.first?.isCustomCover == true {
                        deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumName.text!)_CoverImage.jpeg")
                    }
                    albumCoverData.first?.isCustomCover = false
                }
                else if coverImage.image == UIImage(named: "Pupple"){
                    albumCoverData.first?.coverImageName = "Pupple"
                    if albumCoverData.first?.isCustomCover == true {
                        deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumName.text!)_CoverImage.jpeg")
                    }
                    albumCoverData.first?.isCustomCover = false
                }
                else if coverImage.image == UIImage(named: "Red"){
                    albumCoverData.first?.coverImageName = "Red"
                    if albumCoverData.first?.isCustomCover == true {
                        deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumName.text!)_CoverImage.jpeg")
                    }
                    albumCoverData.first?.isCustomCover = false
                }
                else if coverImage.image == UIImage(named: "Turquoise"){
                    albumCoverData.first?.coverImageName = "Turquoise"
                    if albumCoverData.first?.isCustomCover == true {
                        deleteImageFromDocumentDirectory(imageName: "\(albumName.text!)/\(albumName.text!)_CoverImage.jpeg")
                    }
                    albumCoverData.first?.isCustomCover = false
                }
                else{
                    // Modify to Custom Image
                    albumCoverData.first?.coverImageName = "Custom"
                    albumCoverData.first?.isCustomCover = true
                    // Add custom image in album folder
                    let customCoverImagePath = "\(albumName.text!)_CoverImage.jpeg"
                    saveImageToDocumentDirectory(imageName: customCoverImagePath, image: coverImage.image!, AlbumCoverName: albumName.text!)
                }
                // Modify "album" instance in RealmDB
                for album in albumData { album.setAlbumTitle(albumName.text!) }
            }
        }
        
        // Reload HomeScreenView's collectionView
        collectionViewInHome.reloadData()
        
        // Dismiss EditViewController
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
        editAlbumNameVC.modalPresentationStyle = .currentContext
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
        self.coverImage.image = resizeingImage(image: cropped, width: 120, height: 160)
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
