import UIKit

class AlbumRenameViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var albumTextField: UITextField!

    var albumCoverName: String!
    var filePath: URL!
    var shareVC: ShareViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        albumTextField.text = albumCoverName
        albumTextField.becomeFirstResponder()
    }

    @IBAction func checkButton(_ sender: Any) {
        if albumTextField.text == "" {
            print("비어있습니다.")
        } else {
            shareVC.albumCoverName = albumTextField.text
            shareVC.albumCoverText.text = albumTextField.text
            shareVC.loadingAlbumInfo()
            self.dismiss(animated: true)
        }
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

