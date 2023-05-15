import UIKit
import RealmSwift

class HomeSettingViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var backgroundStackView: UIStackView!
    weak var homeScreenViewController: HomeScreenViewController! = nil
    let realm = try! Realm()
    var homeScreenCollectionView: UICollectionView! = nil
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundStackView.layer.cornerRadius = 5
        backgroundStackView.layer.borderWidth = 2
        backgroundStackView.layer.borderColor = UIColor.black.cgColor
        backgroundStackView.backgroundColor = .systemGray6
    }
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }
    
    
    @IBAction func settingButtonAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func iCloudButtonAction(_ sender: Any) {
        guard let homeSettingVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeiCloudSettingViewController") as? HomeiCloudSettingViewController else { return }
        
        // Present homeSettingVC
        homeSettingVC.modalPresentationStyle = .overCurrentContext
        homeSettingVC.modalTransitionStyle = .crossDissolve
        self.present(homeSettingVC, animated: true)
    }
    
    @IBAction func colorSettingButtonAction(_ sender: Any) {
        let colors = ["파란색": "blue", "갈색": "brown", "녹색" : "green"].sorted(by: <)
        
        let titleText = "테마"
        let messageText = "색상을 선택하세요 🎨"
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.setFont(font: nil, title: titleText, message: messageText)
        
        for color in colors {
            print(color.key)
            let action = UIAlertAction(title: color.key, style: .default) { action in
                let homeSettingInfo = self.realm.objects(HomeSetting.self).first!
                try! self.realm.write {
                    homeSettingInfo.themeColor = color.value
                }
                self.homeScreenViewController.setThemeColor()
                self.homeScreenCollectionView.reloadData()
                
                self.dismiss(animated: false)
            }
            switch color.value {
            case "blue":
                action.setValue(UIColor(red: 0.40, green: 0.40, blue: 0.85, alpha: 1.00), forKey: "titleTextColor")
            case "brown":
                action.setValue(UIColor.systemBrown, forKey: "titleTextColor")
            case "green":
                action.setValue(UIColor(red: 0.33, green: 0.64, blue: 0.55, alpha: 1.00), forKey: "titleTextColor")
            default:
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            alert.addAction(action)
        }
        
        // width constraint
        let constraintWidth = NSLayoutConstraint(
            item: alert.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
        alert.view.addConstraint(constraintWidth)
        
        self.present(alert, animated: true) {
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:))))
        }
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
