import UIKit
import RealmSwift
import Zip

class ShareViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var divideLine: UILabel!
    weak var collectionViewInHome : UICollectionView!
    let realm = try! Realm()
    var filePath: URL?
    var existedAlbum : Bool!
    var albumCoverName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCoverName = filePath?.deletingPathExtension().lastPathComponent
        albumName.text = albumCoverName
        albumName.delegate = self //textfield 클릭 시 다른 뷰로 전환되는 delegate 추가
        loadingAlbumInfo()
        setSubViews()
        setThemeColor()
    }
    
    func setSubViews() {
        // editView
        editView.clipsToBounds = true
        editView.layer.cornerRadius = 15
        // createButton
        createButton.layer.cornerRadius = 8
        // cancleButton
        cancleButton.layer.cornerRadius = 8
    }
    
    @IBAction func openInButtonTapped(_ sender: Any) {
        //.nost file URL에서 .nost앞 앨범 이름만 따옴
        if(!existedAlbum) {
            do {
                try unzipAlbumDirectory(AlbumCoverName: albumCoverName, shareFilePath: filePath!)
            } catch let error {
                NSErrorHandling_Alert(error: error, vc: self)
                // MARK: - 해당 unzip되던 앨범 디렉토리가 있는지 확인하고 삭제해줘야 함
                
                return
            }
            do {
                //realm에 공유받은 album정보 write
                try importAlbumInfo(albumCoverName: albumCoverName, useForShare: true)
            } catch let error {
                NSErrorHandling_Alert(error: error, vc: self)
                // MARK: - 받다만 정보들을 처리해줘야 함
                
                return
            }
            //album reload
            collectionViewInHome.reloadData()
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false)
        } else {
            let textAlert = UIAlertController(title: "중복된 이름", message: "이미 존재하는 앨범입니다. 이름을 바꿔주세요.", preferredStyle: UIAlertController.Style.alert)
            present(textAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                textAlert.view.superview?.isUserInteractionEnabled = true
                textAlert.view.superview?.addGestureRecognizer(tap)
            }
        }
    }
    
    @IBAction func closeInButtonTapped(_ sender: Any) {
        do{
            try FileManager.default.removeItem(at: filePath!)
        } catch let error {
            print("NSError Occur :: \(error)")
        }
        
        self.dismiss(animated: false)
    }

    func loadingAlbumInfo() {
        if checkExistedAlbum(albumCoverName: albumCoverName) {
            existedAlbum = true
        } else {
            existedAlbum = false
        }
    }
        
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
}
// -MARK: shareView에서 textfield 클릭 시 앨범 이름을 변경하는 AlbumRenameViewController를 present
extension ShareViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let renameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumRenameViewController") as? AlbumRenameViewController else { return }
        renameVC.albumCoverName = albumCoverName
        renameVC.filePath = filePath
        renameVC.shareVC = self
//        renameVC.modalPresentationStyle = .overFullScreen
        renameVC.modalPresentationStyle = .currentContext
        renameVC.modalTransitionStyle = .crossDissolve
        self.present(renameVC, animated: true)
    }
}
