import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondButton: UIButton!
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

// - MARK: Cell UI 설정
extension UICollectionViewCell {
    func setGradient(color1: CGColor, color2: CGColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1, color2]
        gradient.locations = [0.8]
        gradient.startPoint = CGPoint(x: 0.5 , y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = self.bounds
        layer.insertSublayer(gradient, at: 0)
    }
}
