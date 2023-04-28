import UIKit
import RealmSwift

class HomeEditViewController: UIViewController {
    // MARK: - Properties
    // UIView
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var divideLine: UILabel!
    let realm = try! Realm()
    var collectionViewInHome : UICollectionView!
    // Modifying
    var IsModifyingView : Bool = false
    var albumNameBeforeModify : String = ""
    var coverImageBeforeModify : String = ""
    var id : Int = 0
    
    // MARK: - View Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setSubViews()
        setThemeColor()
    }
    
    // MARK: - Methods
    func setSubViews() {
        // editView
        editView.layer.cornerRadius = 15
        // coverImage
        coverImage.image = UIImage(systemName: "photo")
        coverImage.layer.cornerRadius = 5
        // selectButton
        selectButton.layer.cornerRadius = 10
        
        if !coverImageBeforeModify.isEmpty {
            let coverImageData = realm.objects(albumCover.self).filter("id = \(id)")
            if coverImageData.first?.isCustomCover == false {
                setCoverImage(color: coverImageBeforeModify)
            } else {
                let customCoverImage = loadImageFromDocumentDirectory(imageName: "\(albumNameBeforeModify)_CoverImage.jpeg", albumTitle: albumNameBeforeModify)
                coverImage.image = customCoverImage
            }
        }
        // albumName
        albumName.placeholder = "앨범 명을 입력하세요"
        albumName.delegate = self
        if !albumNameBeforeModify.isEmpty {
            albumName.text = albumNameBeforeModify
        }
        // creatButton
        createButton.layer.cornerRadius = 10
        // cancleButton
        cancleButton.layer.cornerRadius = 10
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

