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
    }

    @IBAction func checkButton(_ sender: Any) {
        if albumTextField.text == "" {
            print("비어있습니다.")
        } else {
            //guard let shareVC = storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController else { return }
            shareVC.albumCoverName = albumTextField.text
            shareVC.loadingAlbumInfo()
            self.dismiss(animated: true)
        }
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
}

