import UIKit

// - MARK: HomeEditViewController
class HomeEditViewController: UIViewController {
    
    // - MARK: subView 관련 변수 선언
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var collectionViewInHome : UICollectionView!

    // - MARK: modifying view에 필요한 변수 선언
    var IsModifyingView : Bool = false
    var albumNameBeforeModify : String = ""
    var coverImageBeforeModify : String = ""
    var id : Int = 0
    
    // - MARK: viewDidLoad :: view가 Load될 때
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // 초기 subview 설정 :: 새로 앨범을 만드는 경우
        coverImage.image = UIImage(systemName: "photo")
        albumName.placeholder = " 앨범 명을 입력하세요"
        albumName.delegate = self
        coverImage.layer.cornerRadius = 10
        createButton.layer.cornerRadius = 10
        cancleButton.layer.cornerRadius = 10
        backButton.layer.cornerRadius = 16
        
        // 초기 subview 설정 :: 기존의 앨범을 수정하는 경우
        if IsModifyingView {
            editTitle.text = "앨범 수정"
        }
        if !albumNameBeforeModify.isEmpty {
            albumName.text = albumNameBeforeModify
        }
        if !coverImageBeforeModify.isEmpty {
            setCoverImage(color: coverImageBeforeModify)
        }
        
        // EditView 기본 설정
        editView.layer.cornerRadius = 20
    }
    
    // - MARK: touchesBegan :: view를 누를 시 editing이 종료되도록 하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

