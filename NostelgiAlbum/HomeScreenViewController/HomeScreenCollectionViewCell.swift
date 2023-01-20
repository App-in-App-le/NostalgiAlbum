import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {
    
    class var identifier: String{
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    var callback1 : (()->Void)?
    var callback2 : (()->Void)?
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondButtonTitle: UILabel!
    
    @IBAction func makeButton(_ sender: Any) {
        callback2?()
    }
    
    @IBAction func fmakeButton(_ sender: Any) {
        callback1?()
    }
}

extension UICollectionViewCell{
    func setGradient(color1: CGColor, color2: CGColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1, color2]
        gradient.locations = [0.1]
        gradient.startPoint = CGPoint(x: 0.5 , y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = self.bounds
        layer.insertSublayer(gradient, at: 0)
    }
}
