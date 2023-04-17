import UIKit

class HomeSettingViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var backgroundStackView: UIStackView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        backgroundStackView.layer.cornerRadius = 15.0
        backgroundStackView.layer.borderWidth = 2
        backgroundStackView.layer.borderColor = UIColor.black.cgColor
        backgroundStackView.backgroundColor = .systemGray6
    }
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }
    
    @IBAction func homeSettingButtonAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
