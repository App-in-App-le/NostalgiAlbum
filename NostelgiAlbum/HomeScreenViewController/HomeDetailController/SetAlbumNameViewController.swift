import UIKit

// - MARK: SetAlbumNameViewController
class SetAlbumNameViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var albumName: UITextField!
    var editVC : HomeEditViewController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        albumName.text = editVC.albumName.text
        albumName.becomeFirstResponder()
    }
    
    // MARK: - Methods
    @IBAction func cancleButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        editVC.albumName.text = self.albumName.text
        dismiss(animated: true)
    }
}

