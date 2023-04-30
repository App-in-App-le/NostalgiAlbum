import UIKit
import RealmSwift

class HomeScreenCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstButtonShadowView: UIView!
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondButtonShadowView: UIView!
    @IBOutlet weak var secondButtonTitle: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    var callback1 : (()->Void)?
    var callback2 : (()->Void)?
    
    // MARK: - Methods
    @IBAction func fmakeButton(_ sender: Any) {
        callback1?()
    }
    
    @IBAction func makeButton(_ sender: Any) {
        callback2?()
    }
}
