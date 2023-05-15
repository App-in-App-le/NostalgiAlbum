import UIKit

class SetPictureNameViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var pictureName: UITextField!
    @IBOutlet weak var wordCountLabel: UILabel!
    weak var editVC: AlbumEditViewController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureName.text = editVC.editName.text
        wordCountLabel.text = "\(pictureName.text!.count) / 10"
        pictureName.becomeFirstResponder()
        pictureName.delegate = self
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

extension SetPictureNameViewController: UITextFieldDelegate {
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
