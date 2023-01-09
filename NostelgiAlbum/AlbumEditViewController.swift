import UIKit
import RealmSwift

class AlbumEditViewController: UIViewController {

    @IBOutlet weak var editText: UITextView!
    @IBOutlet weak var editTitle: UITextField!
    @IBOutlet weak var editPicture: UIButton!
    var collectionViewInAlbum : UICollectionView!
    var index : Int!
    var albumCoverName : String!
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        editPicture.setImage(UIImage(systemName: "photo"), for: .normal)
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
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
    
    @IBAction func savePicture(_ sender: Any) {
        let realm = try! Realm()
        let newPicture = album()
        print("#####\(String(index))")
        let data = (realm.objects(albumsInfo.self).filter("id = \(index + 0)"))
        print("#####\(data.first!)")
        newPicture.ImageName = editTitle.text!
        newPicture.ImageText = editText.text!
        newPicture.index = index
        newPicture.AlbumTitle = albumCoverName
        newPicture.perAlbumIndex = data.first!.numberOfPictures + 1
        try! realm.write {
            realm.add(newPicture)
            data.first!.setNumberOfPictures(index)
        }
        let totalPath = "\(newPicture.AlbumTitle)_\(newPicture.perAlbumIndex)"
        print(totalPath)
        saveImageToDocumentDirectory(imageName: totalPath, image: (editPicture.imageView?.image!)!, AlbumCoverName: albumCoverName)
        
        collectionViewInAlbum.reloadData()
        
        dismiss(animated: false, completion: nil)
    }
}

extension AlbumEditViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{ editPicture.imageView?.image = image
            editPicture.setTitle("", for: .normal)
            editPicture.setImage(image.resize(newWidth: 312), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
