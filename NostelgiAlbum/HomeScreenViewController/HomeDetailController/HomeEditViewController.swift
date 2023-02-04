import UIKit

class HomeEditViewController: UIViewController {
    
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    var collectionViewInHome : UICollectionView!
    var IsModifyingView : Bool = false
    var albumNameBeforeModify : String = ""
    var coverImageBeforeModify : String = ""
    var id : Int = 0
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        // Set first image
        coverImage.image = UIImage(systemName: "photo")
        
        // Default: Edit New albumCover
        // Set editTitle, albumName, CoverImage When Modifying
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // To end Editing on iphone's touch keyboard when user touch outside of keyboard.
        self.view.endEditing(true)
    }
    
}

