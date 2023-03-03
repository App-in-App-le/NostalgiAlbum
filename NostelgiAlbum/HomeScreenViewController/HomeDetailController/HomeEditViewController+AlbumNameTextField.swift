import UIKit

// - MARK: SetAlbumNameViewController
class SetAlbumNameViewController: UIViewController {
    
    @IBOutlet weak var albumName: UITextField!
    var editVC : HomeEditViewController!
    
    override func viewDidLoad() {
        albumName.text = editVC.albumName.text
        albumName.becomeFirstResponder()
    }
    
    @IBAction func cancleButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        editVC.albumName.text = self.albumName.text
        dismiss(animated: true)
    }
    
    
}

