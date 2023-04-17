import UIKit

protocol SearchDelegate{
    func delegateString(text: String)
    func pushPage(currentPageNum: Int, targetPageNum: Int)
    func popPage(difBetCurTar: Int)
}

class SearchToolViewController: UIViewController {
    var delegate: SearchDelegate?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var searchText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 6
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        dismiss(animated: false){
            self.delegate?.delegateString(text: String(self.searchText.text ?? "empty"))
        }
    }
}
