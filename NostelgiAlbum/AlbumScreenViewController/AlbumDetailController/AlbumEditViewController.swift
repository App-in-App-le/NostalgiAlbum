import UIKit
import RealmSwift
import Mantis

class AlbumEditViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editPicture: UIButton!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editText: UITextView!
    
    var collectionViewInAlbum : UICollectionView!
    var picVC : AlbumPicViewController?
    var index : Int!
    var albumCoverName : String!
    var picture: album? = nil
    
    var width: CGFloat?
    var height: CGFloat?
    
    var isHeightLonger: Bool = true
    var consArray: [NSLayoutConstraint]?
    var newConsArray: [NSLayoutConstraint]?
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
        setSubViews()
        if picture != nil
        {
            transPic(picture!)
        } else {
            editPicture.setImage(UIImage(systemName: "plus.square"), for: .normal)
            editPicture.setTitle("", for: .normal)
        }
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    // - MARK: 키보드가 올라가고 내려가는데에 observer를 생성하여 action을 설정
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer){
        if sender.direction == .down{
            self.dismiss(animated: true)
        }
    }
    
    func setSubViews() {
        // saveButton
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10.0
        
        // editPicture
        editPicture.translatesAutoresizingMaskIntoConstraints = false
        editPicture.backgroundColor = .systemGray6
        editPicture.layer.cornerRadius = 10.0
        width = UIScreen.main.bounds.width - 30
        let remainder = Int(width!) % 3
        if remainder != 0 {
            width = width! - CGFloat(remainder)
        }
        height = width! / 3 * 4
        
        // editName
        editName.translatesAutoresizingMaskIntoConstraints = false
        editName.textAlignment = .center
        
        // editText
        editText.translatesAutoresizingMaskIntoConstraints = false
        editText.textAlignment = .center
        editText.layer.cornerRadius = 5
        
        // set Layout
        consArray = [
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            
            editPicture.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            editPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editPicture.widthAnchor.constraint(equalToConstant: width!),
            editPicture.heightAnchor.constraint(equalToConstant: height!),
            
            editName.topAnchor.constraint(equalTo: editPicture.bottomAnchor, constant: 10),
            editName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editName.heightAnchor.constraint(equalToConstant: 35),
            
            editText.topAnchor.constraint(equalTo: editName.bottomAnchor, constant: 10),
            editText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(consArray!)
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
    
    func transPic(_ picture : album) {
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex).jpeg"
        
        if let image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle) {
            if image.size.height > image.size.width {
                width = UIScreen.main.bounds.width - 30
                let remainder = Int(width!) % 3
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 3 * 4
            } else {
                width = UIScreen.main.bounds.width - 40
                let remainder = Int(width!) % 4
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 4 * 3
            }
            editPicture.setImage(resizeingImage(image: loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)!, width: Int(width!), height: Int(height!)), for: .normal)
        }
        
        if height! < width! {
            NSLayoutConstraint.deactivate(consArray!)
            newConsArray = [
                saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                saveButton.heightAnchor.constraint(equalToConstant: 30),
                saveButton.widthAnchor.constraint(equalToConstant: 50),
                
                editPicture.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 50),
                editPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                editPicture.widthAnchor.constraint(equalToConstant: width!),
                editPicture.heightAnchor.constraint(equalToConstant: height!),
                
                editName.topAnchor.constraint(equalTo: editPicture.bottomAnchor, constant: 10),
                editName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                editName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                editName.heightAnchor.constraint(equalToConstant: 35),
                
                editText.topAnchor.constraint(equalTo: editName.bottomAnchor, constant: 10),
                editText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                editText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                editText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
            ]
            NSLayoutConstraint.activate(newConsArray!)
            isHeightLonger = false
        }
        editPicture.setTitle("", for: .normal)
        editName.text = picture.ImageName
        editText.text = picture.ImageText
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
        deleteTmpPicture()
        collectionViewInAlbum.reloadData()
        
        dismiss(animated: false) {
            self.picVC?.dismiss(animated: false)
        }
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}

extension AlbumEditViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.openCropVC(image: image)
            }
        }
    }
}

extension AlbumEditViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        if cropInfo.cropSize.width > cropInfo.cropSize.height {
            print("가로")
            if isHeightLonger == true {
                width = UIScreen.main.bounds.width - 40
                let remainder = Int(width!) % 4
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 4 * 3
                NSLayoutConstraint.deactivate(consArray!)
                newConsArray = [
                    saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                    saveButton.heightAnchor.constraint(equalToConstant: 30),
                    saveButton.widthAnchor.constraint(equalToConstant: 50),
                    
                    editPicture.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 50),
                    editPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    editPicture.widthAnchor.constraint(equalToConstant: width!),
                    editPicture.heightAnchor.constraint(equalToConstant: height!),
                    
                    editName.topAnchor.constraint(equalTo: editPicture.bottomAnchor, constant: 10),
                    editName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    editName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    editName.heightAnchor.constraint(equalToConstant: 35),
                    
                    editText.topAnchor.constraint(equalTo: editName.bottomAnchor, constant: 10),
                    editText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    editText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    editText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
                ]
                NSLayoutConstraint.activate(newConsArray!)
                isHeightLonger = false
            }
        } else {
            print("세로")
            if isHeightLonger == false {
                width = UIScreen.main.bounds.width - 30
                let remainder = Int(width!) % 3
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 3 * 4
                NSLayoutConstraint.deactivate(newConsArray!)
                NSLayoutConstraint.activate(consArray!)
                isHeightLonger = true
            }
        }
        
        self.editPicture.setImage(resizeingImage(image: cropped, width: Int(width!) - 25, height: Int(height!) - 25), for: .normal)
        self.editPicture.setTitle("", for: .normal)
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    private func openCropVC(image: UIImage) {
        var config = Mantis.Config()
        config.ratioOptions = [.custom]
        config.addCustomRatio(byVerticalWidth: 3, andVerticalHeight: 4)
        config.addCustomRatio(byVerticalWidth: 4, andVerticalHeight: 3)
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        //        cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 3.0 / 4.0)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        self.present(cropViewController, animated: true)
    }
}
