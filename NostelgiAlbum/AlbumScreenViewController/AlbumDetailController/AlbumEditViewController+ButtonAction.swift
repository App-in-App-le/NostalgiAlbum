import UIKit
import RealmSwift

extension AlbumEditViewController {
    @IBAction func dismissEditView(_ sender: Any) {
        var titleText = "수정 취소"
        var messageText = "수정을 취소하시겠습니까?"
        if picVC == nil {
            titleText = "생성 취소"
            messageText = "사진 추가를 취소하시겠습니까?"
        }
        
        let dismissAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        dismissAlert.setFont(font: nil, title: titleText, message: messageText)
        
        let confirmAction = UIAlertAction(title: "예", style: .default) { action in
            self.dismiss(animated: true)
        }
        
        let cancleAction = UIAlertAction(title: "아니오", style: .default) { action in
            dismissAlert.dismiss(animated: true)
        }
        
        dismissAlert.addAction(confirmAction)
        dismissAlert.addAction(cancleAction)
        
        self.present(dismissAlert, animated: true)
    }
    
    // 사진을 어디서 가져올지 Alert
    @IBAction func addAlbumPicture(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 앨범", style: .default){(action) in self.loadLibrary()}
        let camera = UIAlertAction(title: "카메라", style: .default){(action) in self.loadCamera()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func loadLibrary() {
        self.albumAuth()
    }
    
    func loadCamera() {
        if self.cameraAuth() {
            self.openCamera()
        } else {
            self.showAlertAuth("카메라")
        }
    }
    
    // 사진 저장
    @IBAction func savePicture(_ sender: Any) {
        if editPicture.imageView?.image == UIImage(systemName: "plus") {
            let imageAlert = UIAlertController(title: "빈 이미지", message: "이미지를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
            present(imageAlert, animated: true) {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                imageAlert.view.superview?.isUserInteractionEnabled = true
                imageAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        } else if editName.text == "" {
            let editNameAlert = UIAlertController(title: "빈 제목", message: "사진 제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            present(editNameAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                editNameAlert.view.superview?.isUserInteractionEnabled = true
                editNameAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        }
        
        var titleText = "수정 완료"
        var messageText = "변경 내용을 저장하시겠습니까?"
        if picVC == nil {
            titleText = "생성 완료"
            messageText = "새로운 사진을 추가하시겠습니까?"
        }
        let saveAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        saveAlert.setFont(font: nil, title: titleText, message: messageText)
        
        let confirmAction = UIAlertAction(title: "예", style: .default) { action in
            if self.editText.text == "설명을 입력해주세요" && self.editText.textColor == .systemGray3 {
                self.editText.text = nil
            }
            
            if self.picture != nil {
                self.modifyPic()
            } else {
                self.addPic()
            }
            deleteTmpFiles()
            self.collectionViewInAlbum.reloadData()
            
            self.dismiss(animated: false) {
                self.picVC?.dismiss(animated: false)
            }
        }
        
        let cancleAction = UIAlertAction(title: "아니오", style: .default) { action in
            saveAlert.dismiss(animated: true)
        }
        
        saveAlert.addAction(confirmAction)
        saveAlert.addAction(cancleAction)
        
        self.present(saveAlert, animated: true)
    }
    // 사진을 변경
    func modifyPic() {
        let realm = try! Realm()
        let updPicture = (realm.objects(album.self).filter("index = \(picture!.index)"))
        do {
            try realm.write {
                updPicture[picture!.perAlbumIndex - 1].ImageName = editName.text!
                updPicture[picture!.perAlbumIndex - 1].ImageText = editText.text!
            }
        } catch let error {
            print("Realm Write Error :: \(error.localizedDescription)")
            NSErrorHandling_Alert(error: error, vc: self)
        }
        let totalPath = "\(picture!.AlbumTitle)_\(picture!.perAlbumIndex).jpeg"
        do {
            try saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: picture!.AlbumTitle)
        } catch let error {
            print("Modifying Picture Error :: \(error.localizedDescription)")
            NSErrorHandling_Alert(error: error, vc: self)
        }
    }
    // 사진을 추가
    func addPic() {
        let realm = try! Realm()
        let newPicture = album()
        let data = (realm.objects(albumsInfo.self).filter("id = \(index!)"))
        newPicture.ImageName = editName.text!
        newPicture.ImageText = editText.text!
        newPicture.index = index
        newPicture.AlbumTitle = albumCoverName
        newPicture.perAlbumIndex = data.first!.numberOfPictures + 1
        do {
            try realm.write {
                realm.add(newPicture)
                data.first!.setNumberOfPictures(index)
            }
        } catch let error {
            print("Realm Write Error :: \(error.localizedDescription)")
            NSErrorHandling_Alert(error: error, vc: self)
        }
        let totalPath = "\(newPicture.AlbumTitle)_\(newPicture.perAlbumIndex).jpeg"
        do {
            try saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: albumCoverName)
        } catch let error {
            print("Add Picture Error :: \(error.localizedDescription)")
            NSErrorHandling_Alert(error: error, vc: self)
        }
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
