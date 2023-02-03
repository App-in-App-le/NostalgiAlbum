import UIKit
import RealmSwift

extension HomeEditViewController {
    
    @IBAction func saveAlbum(_ sender: Any) {
        
        let realm = try! Realm()
        
        // Save new albumCoverData
        if !IsModifyingView {
            // Declare New Album Cover
            let newAlbumCover = albumCover()
            newAlbumCover.incrementIndex()
            newAlbumCover.albumName = albumName.text!
            
            // Empty title or coverImage Alert
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
            
            // Set New Album Cover's coverImageName
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
            
            // Declare New Album's Info
            let newAlbumsInfo = albumsInfo()
            newAlbumsInfo.incrementIndex()
            newAlbumsInfo.setDateOfCreation()
            newAlbumsInfo.numberOfPictures = 0
            
            // Write new information in RealmDB
            try! realm.write
            {
                realm.add(newAlbumCover)
                realm.add(newAlbumsInfo)
            }
            
            // Make new Directory about new Album in Document Directory
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            // Directory Name is Set by "albumName"
            let dirPath = documentDirectory.appendingPathComponent(albumName.text!)
            if !FileManager.default.fileExists(atPath: dirPath.path){
                do{
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch{
                    NSLog("Couldn't create document directory")
                }
            }
        }
        
        // Modify albumCoverData
        else {
            // Empty title Alert
            if albumName.text == "" {
                let textAlert = UIAlertController(title: "빈 제목", message: "제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
                present(textAlert, animated: true){
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                    textAlert.view.superview?.isUserInteractionEnabled = true
                    textAlert.view.superview?.addGestureRecognizer(tap)
                }
                return
            }
            
            // Change Album directory Name in Document Directory.
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let albumDirectoryPath = documentDirectory.appendingPathComponent(albumNameBeforeModify)
            let modifyAlbumDirectoryPath = documentDirectory.appendingPathComponent(albumName.text!)
            do{
                try FileManager.default.moveItem(at: albumDirectoryPath, to: modifyAlbumDirectoryPath)
                print("Move succcessful")
            } catch {
                print("Move failed")
            }
            
            // Find previous data in RealmDB about modifying album.
            let albumCoverData = realm.objects(albumCover.self).filter("id = \(id)")
            let albumData = realm.objects(album.self).filter("index = \(id)")
            
            // Change Pictures' name in Album Directory.
            for album in albumData {
                let OldPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(album.AlbumTitle)_\(album.perAlbumIndex).png")
                let NewPicturePath = documentDirectory.appendingPathComponent(albumName.text!).appendingPathComponent("\(albumName.text!)_\(album.perAlbumIndex).png")
                do {
                    try FileManager.default.moveItem(at: OldPicturePath, to: NewPicturePath)
                    print("Move succcessful")
                } catch {
                    print("Move failed")
                }
            }
            
            // Change Data in RealmDB
            // (album -> [albumTitle], albumCover -> [albumName, CoverImageName])
            try! realm.write{
                // "albumCover" in RealmDB
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
                // "album" in RealmDB
                for album in albumData { album.setAlbumTitle(albumName.text!) }
            }
        }
        
        // Reload Collection View's Data in HomeScreenView
        collectionViewInHome.reloadData()
        
        // Dismiss HomeEditView Modal
        dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        // Set Colors
        let colors = [ "파란색" : "Blue", "갈색" : "Brown", "녹색" : "Green", "보라색" : "Pupple", "빨간색" : "Red", "청록색" : "Turquoise"]
        
        // Set alert and alert action
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        colors.forEach { color in
            alert.addAction(UIAlertAction(title: color.key, style: .default) { action in
                self.setCoverImage(color: color.value)
            })
        }
        
        // Present alert
        present(alert, animated: true) {
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
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
    
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
