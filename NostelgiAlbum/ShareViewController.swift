import UIKit

class ShareViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var albumShareButton: UIButton!
    var filePath: URL?
    var collectionViewInHome : UICollectionView!
    var existedAlbum : Bool!
    var albumCoverName : String!
    @IBOutlet weak var albumButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCoverName = filePath?.deletingPathExtension().lastPathComponent
        albumButton.setTitle(albumCoverName, for: .normal)
        albumButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        loadingAlbumInfo()
    }
    
    @IBAction func openInButtonTapped(_ sender: Any) {
        //.nost file URL에서 .nost앞 앨범 이름만 따옴
        if(!existedAlbum) {
            unzipAlbumDirectory(AlbumCoverName: albumCoverName, shareFilePath: filePath!)
            //realm에 공유받은 album정보 write
            importAlbumInfo(albumCoverName: albumCoverName)
            //album reload
            collectionViewInHome.reloadData()
            self.navigationController?.popViewController(animated: true)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeAlbumName(_ sender: Any) {
        guard let renameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumRenameViewController") as? AlbumRenameViewController else { return }
        renameVC.albumCoverName = albumCoverName
        renameVC.filePath = filePath
        renameVC.shareVC = self
        renameVC.modalPresentationStyle = .overFullScreen
        self.present(renameVC, animated: true)
    }

    func loadingAlbumInfo() {
        if checkExistedAlbum(albumCoverName: albumCoverName) {
            existedAlbum = true
        } else {
            existedAlbum = false
        }
    }
        
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
