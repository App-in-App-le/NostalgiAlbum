import UIKit
import RealmSwift

class HomeScreenCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstButtonShadowView: UIView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondButtonShadowView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    var callBack1 : (()->Void)!
    var callBack2 : (()->Void)!
    
    // MARK: - Methods
    @IBAction func fmakeButton(_ sender: Any) {
        callBack1()
    }
    
    @IBAction func makeButton(_ sender: Any) {
        callBack2()
    }
    
    func setFirstButton(height: CGFloat) {
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        firstButton.widthAnchor.constraint(equalToConstant: height / 4 * 3).isActive = true
    }
    
    func setSecondButton(height: CGFloat) {
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        secondButton.widthAnchor.constraint(equalToConstant: height / 4 * 3).isActive = true
    }
}
