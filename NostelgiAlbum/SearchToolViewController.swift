//
//  SearchToolViewController.swift
//  NostelgiAlbum
//
//  Created by 황지웅 on 2022/11/14.
//

import UIKit

protocol DisDelegate{
    func delegateString(text: String)
}

class SearchToolViewController: UIViewController {
    var delegate: DisDelegate?
    
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
