import UIKit

// - MARK: HomeEditViewController
class HomeEditViewController: UIViewController {
    
    // - MARK: subView 관련 변수 선언
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    var collectionViewInHome : UICollectionView!

    // - MARK: modifying view에 필요한 변수 선언
    var IsModifyingView : Bool = false
    var albumNameBeforeModify : String = ""
    var coverImageBeforeModify : String = ""
    var id : Int = 0
    
    // - MARK: viewDidLoad :: view가 Load될 때
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // [1] 초기 subview 설정 :: 새로 앨범을 만드는 경우
        coverImage.image = UIImage(systemName: "photo")
        
        // [2] 초기 subview 설정 :: 기존의 앨범을 수정하는 경우
        if IsModifyingView {
            editTitle.text = "앨범 수정"
        }
        if !albumNameBeforeModify.isEmpty {
            albumName.text = albumNameBeforeModify
        }
        if !coverImageBeforeModify.isEmpty {
            setCoverImage(color: coverImageBeforeModify)
        }
    }
    
    // - MARK: touchesBegan :: view를 누를 시 editing이 종료되도록 하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

