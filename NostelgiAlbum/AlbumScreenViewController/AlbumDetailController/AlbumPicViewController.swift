import UIKit
import RealmSwift

class AlbumPicViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var picName: UILabel!
    @IBOutlet weak var picText: UITextView!
    @IBOutlet weak var picImage: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    let realm = try! Realm()
    var picture: album!
    var collectionViewInAlbum : UICollectionView!
    
    var width: CGFloat?
    var height: CGFloat?
    
    var consArray: [NSLayoutConstraint]?
    var newConsArray: [NSLayoutConstraint]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setThemeColor()
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    func setupSubviews() {
        // set settingBtn
        settingBtn.translatesAutoresizingMaskIntoConstraints = false
        settingBtn.setTitle("", for: .normal)
        settingBtn.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        
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
            picImage.setImage(resizeingImage(image: loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)!, width: Int(width!), height: Int(height!)), for: .normal)
        }
//        picImage.setImage(loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)?.resize(newWidth: picImage.frame.width, newHeight: (picImage.frame.height)), for: .normal)
        
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
            
            picImage.topAnchor.constraint(equalTo: settingBtn.bottomAnchor, constant: 10),
            picImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picImage.widthAnchor.constraint(equalToConstant: width!),
            picImage.heightAnchor.constraint(equalToConstant: height!),
            
            picName.topAnchor.constraint(equalTo: picImage.bottomAnchor, constant: 10),
            picName.heightAnchor.constraint(equalToConstant: 34),
            picName.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picName.widthAnchor.constraint(equalToConstant: width!),
            
            picText.topAnchor.constraint(equalTo: picName.bottomAnchor, constant: 10),
            picText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            picText.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picText.widthAnchor.constraint(equalToConstant: width!)
        ]
        newConsArray = [
            settingBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            settingBtn.heightAnchor.constraint(equalToConstant: 30),
            settingBtn.widthAnchor.constraint(equalToConstant: 50),
            
            picImage.topAnchor.constraint(equalTo: settingBtn.bottomAnchor, constant: 50),
            picImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picImage.widthAnchor.constraint(equalToConstant: width!),
            picImage.heightAnchor.constraint(equalToConstant: height!),
            
            picName.topAnchor.constraint(equalTo: picImage.bottomAnchor, constant: 10),
            picName.heightAnchor.constraint(equalToConstant: 34),
            picName.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picName.widthAnchor.constraint(equalToConstant: width!),
            
            picText.topAnchor.constraint(equalTo: picName.bottomAnchor, constant: 10),
            picText.heightAnchor.constraint(equalToConstant: height!),
            picText.centerXAnchor.constraint(equalTo: picImage.centerXAnchor),
            picText.widthAnchor.constraint(equalToConstant: width!)
        ]
        
        if height! > width! {
            NSLayoutConstraint.activate(consArray!)
        } else {
            NSLayoutConstraint.activate(newConsArray!)
        }
        
    }
    
    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer){
        if sender.direction == .down{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func settingPicture(_ sender: Any) {
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
//        guard let picVC = self.presentingViewController else { return }
        editVC.picture = picture
        editVC.collectionViewInAlbum = collectionViewInAlbum
        editVC.picVC = self
        editVC.modalPresentationStyle = .overFullScreen
        self.present(editVC, animated: false)
//        self.dismiss(animated: false) {
//            picVC.present(editVC, animated: false)
//        }
    }
    
    @IBAction func zoomImage(_ sender: Any) {
        guard let zoomVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else { return }
        let totalPath = "\(self.picture.AlbumTitle)_\(self.picture.perAlbumIndex).jpeg"
        zoomVC.imageName = totalPath
        zoomVC.albumTitle = self.picture.AlbumTitle
        zoomVC.modalPresentationStyle = .overFullScreen
        self.present(zoomVC, animated: false)
    }
}
