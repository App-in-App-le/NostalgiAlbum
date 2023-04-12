import UIKit

class SetPictureNameViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var pictureName: UITextField!
    var editVC: AlbumEditViewController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        pictureName.text = editVC.editName.text
        pictureName.becomeFirstResponder()
    }
    
    // MARK: - Methods
    @IBAction func cancleButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        editVC.editName.text = pictureName.text
        dismiss(animated: true)
    }
}
