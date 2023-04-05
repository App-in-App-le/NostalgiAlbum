import UIKit

// - MARK: HomeScreenCollectionViewCell
class HomeScreenCollectionViewCell: UICollectionViewCell {
    
    // - MARK: Cell의 Subviews 관련 변수 설정
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var secondButtonTitle: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // - MARK: 각 버튼에 대한 Callback 함수 설정
    var callback1 : (()->Void)?
    var callback2 : (()->Void)?
    
    // - MARK: 각 버튼에 대한 Action 설정
    @IBAction func fmakeButton(_ sender: Any) {
        callback1?()
    }
    @IBAction func makeButton(_ sender: Any) {
        callback2?()
    }
}

// - MARK: UICollectionViewCell의 UI 설정에 관련된 extension
extension UICollectionViewCell {
    // - MARK: 그라데이션을 설정하는 함수
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
