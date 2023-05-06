import UIKit

class SetPictureDescriptionViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var pictureDescription: UITextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    var editVC: AlbumEditViewController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        pictureDescription.text = editVC.editText.text
        wordCountLabel.text = "\(pictureDescription.text.count) / 50"
        
        pictureDescription.layer.cornerRadius = 7
        pictureDescription.becomeFirstResponder()
        pictureDescription.delegate = self
    }
    
    // MARK: - Methods
    @IBAction func cancleButtonAction(_ sender: Any) {
        if editVC.editText.textColor == .systemGray3 {
            editVC.editText.text = "설명을 입력해주세요"
        }
        dismiss(animated: true)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        editVC.editText.text = pictureDescription.text
        if pictureDescription.text == "" {
            editVC.editText.text = "설명을 입력해주세요"
            editVC.editText.textColor = .systemGray3
        } else {
            editVC.editText.textColor = .black
        }
        dismiss(animated: true)
    }
}

extension SetPictureDescriptionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if changedText.count <= 50 {
            self.wordCountLabel.text = "\(changedText.count) / 50"
            self.wordCountLabel.textColor = .white
        } else {
            self.wordCountLabel.textColor = .red
        }
        
        
        return changedText.count <= 50
    }
}
