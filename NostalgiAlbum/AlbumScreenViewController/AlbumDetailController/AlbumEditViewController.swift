import UIKit
import RealmSwift

class AlbumEditViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editPicture: UIButton!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editText: UITextView!
    @IBOutlet weak var dismissButton: UIButton!
    weak var picVC : AlbumPicViewController? = nil
    weak var picture: album?
    let realm = try! Realm()
    let picker = UIImagePickerController()
    var collectionViewInAlbum : UICollectionView!
    var index : Int!
    var albumCoverName : String!
    var width: CGFloat! = nil
    var height: CGFloat! = nil
    var isHeightLonger: Bool = true
    var consArray: [NSLayoutConstraint]! = nil
    var newConsArray: [NSLayoutConstraint]! = nil
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        editName.delegate = self
        editText.delegate = self
        picker.delegate = self
        setSubViews()
        
        if let picture = picture {
            transPic(picture)
        } else {
            editPicture.setImage(UIImage(systemName: "plus"), for: .normal)
            editPicture.setTitle("", for: .normal)
        }
        
        if editText.text.isEmpty {
            editText.text = "설명을 입력해주세요"
            editText.textColor = .systemGray3
        }
        setThemeColor()
        setFont()
    }
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setSubViews() {
        // saveButton
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 10.0
        saveButton.titleLabel?.numberOfLines = 1
        
        // dismissButton
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        // editPicture
        editPicture.translatesAutoresizingMaskIntoConstraints = false
        editPicture.backgroundColor = .systemGray6
        editPicture.clipsToBounds = true
        editPicture.layer.cornerRadius = 10.0
        width = UIScreen.main.bounds.width / 4 * 3
        
        let remainder = Int(width) % 3
        if remainder != 0 {
            width = width - CGFloat(remainder)
        }
        height = width / 3 * 4
        
        // editName
        editName.translatesAutoresizingMaskIntoConstraints = false
        editName.textAlignment = .center
        
        // editText
        editText.translatesAutoresizingMaskIntoConstraints = false
        editText.layer.cornerRadius = 10
        
        // set Layout
        consArray = [
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            editPicture.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            editPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editPicture.widthAnchor.constraint(equalToConstant: width!),
            editPicture.heightAnchor.constraint(equalToConstant: height!),
            
            editName.topAnchor.constraint(equalTo: editPicture.bottomAnchor, constant: 10),
            editName.heightAnchor.constraint(equalToConstant: 34),
            editName.centerXAnchor.constraint(equalTo: editPicture.centerXAnchor),
            editName.widthAnchor.constraint(equalToConstant: width!),
            
            editText.topAnchor.constraint(equalTo: editName.bottomAnchor, constant: 10),
            editText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            editText.centerXAnchor.constraint(equalTo: editPicture.centerXAnchor),
            editText.widthAnchor.constraint(equalToConstant: width!)
        ]
        NSLayoutConstraint.activate(consArray)
    }
    
    func transPic(_ picture : album) {
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex).jpeg"
        if let image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle) {
            if image.size.height > image.size.width {
                width = UIScreen.main.bounds.width / 4 * 3
                let remainder = Int(width) % 3
                if remainder != 0 {
                    width = width - CGFloat(remainder)
                }
                height = width! / 3 * 4
            } else {
                width = UIScreen.main.bounds.width / 8 * 7
                let remainder = Int(width) % 4
                if remainder != 0 {
                    width = width - CGFloat(remainder)
                }
                height = width / 4 * 3
            }
            editPicture.setImage(loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)?.resize(newWidth: width, newHeight: height, byScale: false), for: .normal)
        }
        
        if height < width {
            NSLayoutConstraint.deactivate(consArray)
            newConsArray = [
                saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                saveButton.heightAnchor.constraint(equalToConstant: 30),
                saveButton.widthAnchor.constraint(equalToConstant: 50),
                
                dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
                dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                
                editPicture.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 50),
                editPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                editPicture.widthAnchor.constraint(equalToConstant: width),
                editPicture.heightAnchor.constraint(equalToConstant: height),
                
                editName.topAnchor.constraint(equalTo: editPicture.bottomAnchor, constant: 10),
                editName.heightAnchor.constraint(equalToConstant: 34),
                editName.centerXAnchor.constraint(equalTo: editPicture.centerXAnchor),
                editName.widthAnchor.constraint(equalToConstant: width),
                
                editText.topAnchor.constraint(equalTo: editName.bottomAnchor, constant: 10),
                editText.heightAnchor.constraint(equalToConstant: height),
                editText.centerXAnchor.constraint(equalTo: editPicture.centerXAnchor),
                editText.widthAnchor.constraint(equalToConstant: width)
            ]
            NSLayoutConstraint.activate(newConsArray)
            isHeightLonger = false
        }
        editPicture.setTitle("", for: .normal)
        editName.text = picture.ImageName
        editText.text = picture.ImageText
    }
}

extension AlbumEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // editPictureNameVC
        guard let editPictureNameVC = self.storyboard?.instantiateViewController(withIdentifier: "SetPictureNameViewController") as? SetPictureNameViewController else { return }
        editPictureNameVC.editVC = self
        editPictureNameVC.modalPresentationStyle = .overCurrentContext
        editPictureNameVC.modalTransitionStyle = .crossDissolve
        // Present modal
        self.present(editPictureNameVC, animated: true)
    }
}

extension AlbumEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "설명을 입력해주세요" {
            textView.text = nil
        }
        // editPictureDescriptionVC
        guard let editPictureDescriptionVC = self.storyboard?.instantiateViewController(withIdentifier: "SetPictureDescriptionViewController") as? SetPictureDescriptionViewController else { return }
        editPictureDescriptionVC.editVC = self
        editPictureDescriptionVC.modalPresentationStyle = .overCurrentContext
        editPictureDescriptionVC.modalTransitionStyle = .crossDissolve
        // Present modal
        textView.endEditing(true)
        self.present(editPictureDescriptionVC, animated: true)
    }
}
