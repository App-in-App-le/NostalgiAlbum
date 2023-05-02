import UIKit
import RealmSwift

extension AlbumEditViewController {
    @IBAction func addAlbumPicture(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 앨범", style: .default){(action) in self.openLibrary()}
        let camera = UIAlertAction(title: "카메라", style: .default){(action) in self.openCamera()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    @IBAction func savePicture(_ sender: Any) {
        if picture != nil {
            modifyPic()
        } else {
            addPic()
        }
        if editPicture.imageView?.image == UIImage(systemName: "plus"){
            let imageAlert = UIAlertController(title: "빈 이미지", message: "이미지를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
            present(imageAlert, animated: true){
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
        deleteTmpPicture()
        collectionViewInAlbum.reloadData()
        
        dismiss(animated: false) {
            self.picVC?.dismiss(animated: false)
        }
    }
    
    func modifyPic() {
        let realm = try! Realm()
        let updPicture = (realm.objects(album.self).filter("index = \(picture!.index)"))
        try! realm.write {
            updPicture[picture!.perAlbumIndex - 1].ImageName = editName.text!
            updPicture[picture!.perAlbumIndex - 1].ImageText = editText.text!
        }
        let totalPath = "\(picture!.AlbumTitle)_\(picture!.perAlbumIndex).jpeg"
        saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: picture!.AlbumTitle)
    }
    
    func addPic() {
        let realm = try! Realm()
        let newPicture = album()
        let data = (realm.objects(albumsInfo.self).filter("id = \(index!)"))
        newPicture.ImageName = editName.text!
        newPicture.ImageText = editText.text!
        newPicture.index = index
        newPicture.AlbumTitle = albumCoverName
        newPicture.perAlbumIndex = data.first!.numberOfPictures + 1
        try! realm.write {
            realm.add(newPicture)
            data.first!.setNumberOfPictures(index)
        }
        let totalPath = "\(newPicture.AlbumTitle)_\(newPicture.perAlbumIndex).jpeg"
        saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: albumCoverName)
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
