import UIKit

// - MARK: SetAlbumNameViewController
class SetAlbumNameViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var wordCountLabel: UILabel!
    var editVC : HomeEditViewController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        albumName.text = editVC.albumName.text
        wordCountLabel.text = "\(albumName.text!.count) / 10"
        albumName.becomeFirstResponder()
        albumName.delegate = self
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

extension SetAlbumNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if changedText.count <= 10 {
            self.wordCountLabel.text = "\(changedText.count) / 10"
            self.wordCountLabel.textColor = .white
        } else {
            self.wordCountLabel.textColor = .red
        }
        
        return changedText.count <= 10
    }
}
