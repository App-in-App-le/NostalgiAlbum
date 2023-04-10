import UIKit

class SetPictureDescriptionViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var pictureDescription: UITextView!
    var editVC: AlbumEditViewController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        pictureDescription.text = editVC.editText.text
        pictureDescription.becomeFirstResponder()
    }
    
    // MARK: - Methods
    @IBAction func cancleButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        editVC.editText.text = pictureDescription.text
        dismiss(animated: true)
    }
}
