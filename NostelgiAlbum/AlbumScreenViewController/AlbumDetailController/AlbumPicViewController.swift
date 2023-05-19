import UIKit
import RealmSwift

class AlbumPicViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var picName: UILabel!
    @IBOutlet weak var picNameShadowView: UIView!
    @IBOutlet weak var picText: UITextView!
    @IBOutlet weak var picTextShadowView: UIView!
    @IBOutlet weak var picImage: UIButton!
    @IBOutlet weak var picImageShadowView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    weak var picture: album!
    weak var collectionViewInAlbum : UICollectionView!
    let realm = try! Realm()
    var index: Int!
    var width: CGFloat! = nil
    var height: CGFloat! = nil
    var consArray: [NSLayoutConstraint]! = nil
    var newConsArray: [NSLayoutConstraint]! = nil
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        setupSubviews()
        setThemeColor()
        setFont()
//        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
//        swipeRecognizer.direction = .down
//        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    // MARK: - Methods
    func setupSubviews() {
        // set settingBtn
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.setTitle("", for: .normal)
        settingBtn.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        
        // set dismissButton
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        // set picImage
        picImage.translatesAutoresizingMaskIntoConstraints = false
        picImage.setTitle("", for: .normal)
        picImage.backgroundColor = .systemGray6
        picImage.clipsToBounds = true
        picImage.layer.cornerRadius = 10.0
        
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex).jpeg"
        
        if let image = loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle) {
            if image.size.height > image.size.width {
                width = UIScreen.main.bounds.width / 4 * 3
                let remainder = Int(width!) % 3
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 3 * 4
            } else {
                width = UIScreen.main.bounds.width / 8 * 7
                let remainder = Int(width!) % 4
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 4 * 3
            }
            picImage.setImage(loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)?.resize(newWidth: width, newHeight: height, byScale: false), for: .normal)
        }
        // set picName
        picName.translatesAutoresizingMaskIntoConstraints = false
        picName.text = picture.ImageName
        picName.clipsToBounds = true
        picName.layer.cornerRadius = 5.0
        
        // set picText
        picText.translatesAutoresizingMaskIntoConstraints = false
        picText.text = picture.ImageText
        picText.layer.cornerRadius = 10.0
        
        consArray = [
            settingBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            settingBtn.heightAnchor.constraint(equalToConstant: 30),
            settingBtn.widthAnchor.constraint(equalToConstant: 50),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            picImageShadowView.topAnchor.constraint(equalTo: settingBtn.bottomAnchor, constant: 10),
            picImageShadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picImageShadowView.widthAnchor.constraint(equalToConstant: width!),
            picImageShadowView.heightAnchor.constraint(equalToConstant: height!),
            
            picImage.topAnchor.constraint(equalTo: picImageShadowView.topAnchor),
            picImage.bottomAnchor.constraint(equalTo: picImageShadowView.bottomAnchor),
            picImage.leadingAnchor.constraint(equalTo: picImageShadowView.leadingAnchor),
            picImage.trailingAnchor.constraint(equalTo: picImageShadowView.trailingAnchor),
            
            picNameShadowView.topAnchor.constraint(equalTo: picImage.bottomAnchor, constant: 10),
            picNameShadowView.heightAnchor.constraint(equalToConstant: 34),
            picNameShadowView.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picNameShadowView.widthAnchor.constraint(equalToConstant: width!),
            
            picName.topAnchor.constraint(equalTo: picNameShadowView.topAnchor),
            picName.bottomAnchor.constraint(equalTo: picNameShadowView.bottomAnchor),
            picName.leadingAnchor.constraint(equalTo: picNameShadowView.leadingAnchor),
            picName.trailingAnchor.constraint(equalTo: picNameShadowView.trailingAnchor),
            
            picTextShadowView.topAnchor.constraint(equalTo: picName.bottomAnchor, constant: 10),
            picTextShadowView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            picTextShadowView.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picTextShadowView.widthAnchor.constraint(equalToConstant: width!),
            
            picText.topAnchor.constraint(equalTo: picTextShadowView.topAnchor),
            picText.bottomAnchor.constraint(equalTo: picTextShadowView.bottomAnchor),
            picText.leadingAnchor.constraint(equalTo: picTextShadowView.leadingAnchor),
            picText.trailingAnchor.constraint(equalTo: picTextShadowView.trailingAnchor)
        ]
        newConsArray = [
            settingBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            settingBtn.heightAnchor.constraint(equalToConstant: 30),
            settingBtn.widthAnchor.constraint(equalToConstant: 50),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            picImageShadowView.topAnchor.constraint(equalTo: settingBtn.bottomAnchor, constant: 50),
            picImageShadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picImageShadowView.widthAnchor.constraint(equalToConstant: width!),
            picImageShadowView.heightAnchor.constraint(equalToConstant: height!),
            
            picImage.topAnchor.constraint(equalTo: picImageShadowView.topAnchor),
            picImage.bottomAnchor.constraint(equalTo: picImageShadowView.bottomAnchor),
            picImage.leadingAnchor.constraint(equalTo: picImageShadowView.leadingAnchor),
            picImage.trailingAnchor.constraint(equalTo: picImageShadowView.trailingAnchor),
            
            picNameShadowView.topAnchor.constraint(equalTo: picImage.bottomAnchor, constant: 10),
            picNameShadowView.heightAnchor.constraint(equalToConstant: 34),
            picNameShadowView.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picNameShadowView.widthAnchor.constraint(equalToConstant: width!),
            
            picName.topAnchor.constraint(equalTo: picNameShadowView.topAnchor),
            picName.bottomAnchor.constraint(equalTo: picNameShadowView.bottomAnchor),
            picName.leadingAnchor.constraint(equalTo: picNameShadowView.leadingAnchor),
            picName.trailingAnchor.constraint(equalTo: picNameShadowView.trailingAnchor),
            
            picTextShadowView.topAnchor.constraint(equalTo: picName.bottomAnchor, constant: 10),
            picTextShadowView.heightAnchor.constraint(equalToConstant: height!),
            picTextShadowView.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picTextShadowView.widthAnchor.constraint(equalToConstant: width!),
            
            picText.topAnchor.constraint(equalTo: picTextShadowView.topAnchor),
            picText.bottomAnchor.constraint(equalTo: picTextShadowView.bottomAnchor),
            picText.leadingAnchor.constraint(equalTo: picTextShadowView.leadingAnchor),
            picText.trailingAnchor.constraint(equalTo: picTextShadowView.trailingAnchor)
        ]
        
        if height > width {
            NSLayoutConstraint.activate(consArray)
        } else {
            NSLayoutConstraint.activate(newConsArray)
        }
        
    }
    
//    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer){
//        if sender.direction == .down{
//            self.dismiss(animated: true)
//        }
//    }
    
    @IBAction func dismissPicture(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func settingPicture(_ sender: Any) {
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
        
        editVC.picture = picture
        editVC.collectionViewInAlbum = collectionViewInAlbum
        editVC.picVC = self
        editVC.index = index
        editVC.modalPresentationStyle = .overFullScreen
        self.present(editVC, animated: false)
        
    }
    
    @IBAction func zoomImage(_ sender: Any) {
        guard let zoomVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else { return }
        let totalPath = "\(self.picture.AlbumTitle)_\(self.picture.perAlbumIndex).jpeg"
        zoomVC.imageName = totalPath
        zoomVC.albumTitle = self.picture.AlbumTitle
        zoomVC.modalPresentationStyle = .overFullScreen
        zoomVC.modalTransitionStyle = .crossDissolve
        self.present(zoomVC, animated: true)
    }
}
