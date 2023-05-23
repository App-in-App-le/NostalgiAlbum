import UIKit
import RealmSwift

class HomeEditViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var divideLine: UILabel!
    weak var collectionViewInHome: UICollectionView!
    let realm = try! Realm()
    let picker = UIImagePickerController()
    var id: Int = 0
    // 수정 EditView 관련 변수
    var IsModifyingView: Bool = false
    var albumNameBeforeModify: String = ""
    var coverImageBeforeModify: String = ""
    // CustomCoverColor를 구분하기 위해 선언
    var defaultCoverColor: String! = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setSubViews()
        setThemeColor()
    }
    
    // MARK: - Methods
    func setSubViews() {
        // editView
        editView.clipsToBounds = true
        editView.layer.cornerRadius = 15
        // coverImage
        coverImage.image = UIImage(systemName: "photo.on.rectangle.angled")
        coverImage.layer.cornerRadius = 5
        coverImage.tintColor = .darkGray
        coverImage.layer.borderColor = UIColor.systemGray3.cgColor
        coverImage.layer.borderWidth = 0.5
        // selectButton
        selectButton.layer.cornerRadius = 8
        
        // 수정 Edit일 경우, CoverImage를 다시 설정
        if !coverImageBeforeModify.isEmpty {
            let coverImageData = realm.objects(albumCover.self).filter("id = \(id)")
            if coverImageData.first?.isCustomCover == false {
                setCoverImage(color: coverImageBeforeModify)
                defaultCoverColor = coverImageBeforeModify
            } else {
                let customCoverImage = loadImageFromDocumentDirectory(imageName: "\(albumNameBeforeModify)_CoverImage.jpeg", albumTitle: albumNameBeforeModify)
                let resizedImage = customCoverImage?.resize(newWidth: 150, newHeight: 200, byScale: false)
                coverImage.image = resizedImage
            }
            createButton.setTitle("수정", for: .normal)
        }
        // albumName
        albumName.placeholder = "앨범 명을 입력하세요"
        albumName.delegate = self
        if !albumNameBeforeModify.isEmpty {
            albumName.text = albumNameBeforeModify
        }
        // creatButton
        createButton.layer.cornerRadius = 8
        // cancleButton
        cancleButton.layer.cornerRadius = 8
        // editTitle
        if IsModifyingView {
            editTitle.text = "앨범 수정"
        }
    }
    
    // - MARK: touchesBegan :: view를 누를 시 editing이 종료되도록 하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

