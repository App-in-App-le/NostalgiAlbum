import UIKit
import RealmSwift

class AlbumEditViewController: UIViewController {

    @IBOutlet weak var editText: UITextView!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editPicture: UIButton!
    var collectionViewInAlbum : UICollectionView!
    var index : Int!
    var albumCoverName : String!
    let picker = UIImagePickerController()
    var picture: album!
    override func viewDidLoad() {
        super.viewDidLoad()
        if picture != nil
        {
            transPic(picture)
        } else {
            editPicture.setImage(UIImage(systemName: "photo"), for: .normal)
        }
        picker.delegate = self
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
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

    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer){
        if sender.direction == .down{
            self.dismiss(animated: true)
        }
    }
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    func transPic(_ picture : album) {
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex).png"
        editPicture.setImage(loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)?.resize(newWidth: editPicture.frame.size.width, newHeight: editPicture.frame.size.height), for: .normal)
        editPicture.setTitle("", for: .normal)
        editName.text = picture.ImageName
        editText.text = picture.ImageText
    }
    
    func modifyPic() {
        let realm = try! Realm()
        let updPicture = (realm.objects(album.self).filter("index = \(picture.index)"))
        try! realm.write {
            updPicture[picture.perAlbumIndex - 1].ImageName = editName.text!
            updPicture[picture.perAlbumIndex - 1].ImageText = editText.text!
        }
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex).png"
        saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: picture.AlbumTitle)
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
        let totalPath = "\(newPicture.AlbumTitle)_\(newPicture.perAlbumIndex).png"
        saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: albumCoverName)
    }
    @IBAction func savePicture(_ sender: Any) {
        if picture != nil {
            modifyPic()
        } else {
            addPic()
        }
        if editPicture.imageView?.image == UIImage(systemName: "photo"){
            let imageAlert = UIAlertController(title: "빈 이미지", message: "이미지를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
            present(imageAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                imageAlert.view.superview?.isUserInteractionEnabled = true
                imageAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        } else if editName.text == "" {
            let imageAlert = UIAlertController(title: "빈 제목", message: "사진 제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            present(imageAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                imageAlert.view.superview?.isUserInteractionEnabled = true
                imageAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        }
        collectionViewInAlbum.reloadData()
        
        dismiss(animated: false, completion: nil)
    }
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}

extension AlbumEditViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{ editPicture.imageView?.image = image
            editPicture.setTitle("", for: .normal)
            editPicture.setImage(image.resize(newWidth: editPicture.frame.size.width, newHeight: editPicture.frame.size.height), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
