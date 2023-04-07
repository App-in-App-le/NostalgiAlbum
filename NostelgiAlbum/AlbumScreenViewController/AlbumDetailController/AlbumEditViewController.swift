import UIKit

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
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
}
